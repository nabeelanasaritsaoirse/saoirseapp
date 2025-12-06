// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:saoirse_app/screens/refferal/referral_controller.dart';

import '../../constants/app_constant.dart';
import '../../constants/app_urls.dart';
import '../../main.dart';
import '../../services/api_service.dart';
import '../../services/appsflyer_service.dart';
import '../../services/auth_service.dart';
import '../../services/refferal_service.dart';
import '../../widgets/app_toast.dart';
import '../dashboard/dashboard_screen.dart';

import 'package:http/http.dart' as http;

class LoginController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController referrelController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  RxBool loading = false.obs;
  Rx<Country?> country = Rx<Country?>(null);
  RxBool fetchFailed = false.obs;
  RxBool referralApplied = false.obs;
  final ReferralService referralService = ReferralService();
  @override
  void onInit() {
    super.onInit();
    fetchCountryCode();
    loadReferralCode();
    loadReferralFlag();
  }

  void loadReferralFlag() {
    referralApplied.value = storage.read("referral_applied") ?? false;
  }

  void loadReferralCode() {
    final referralFromDeepLink = AppsFlyerService.instance.referralFromDeepLink;
    final storedReferral = storage.read('pending_referral_code');
    final referralCode = referralFromDeepLink ?? storedReferral;

    if (referralCode != null && referralCode.isNotEmpty) {
      referrelController.text = referralCode;
    }
  }

  Future<void> fetchCountryCode() async {
    loading.value = true;

    try {
      final response = await http
          .get(Uri.parse("http://ip-api.com/json"))
          .timeout(Duration(seconds: 5));

      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        final countryCode = body["countryCode"];
        country.value = CountryParser.tryParseCountryCode(countryCode);

        // In case API returns garbage
        country.value ??= CountryParser.tryParseCountryCode("IN");
        fetchFailed.value = false;
      } else {
        fallbackToManual();
      }
    } catch (e) {
      print("Error fetching country code: $e");
      fallbackToManual();
    }

    loading.value = false;
  }

  void fallbackToManual() {
    country.value = CountryParser.tryParseCountryCode("IN");
    fetchFailed.value = true;
  }

  void updateCountry(Country selectedCountry) {
    country.value = selectedCountry;
  }

  String get fullPhoneNumber {
    final c = country.value;
    if (c == null) return '';
    return '+${c.phoneCode}${phoneController.text}';
  }

  @override
  void onClose() {
    phoneController.dispose();
    super.onClose();
  }

  //google login
  googleLogin() async {
    loading.value = true;

    // Clear previous session
    await AuthService.signOut();

    // Step 1: Google Login & ID token
    String? idToken = await AuthService.googleLogin();

    if (idToken == null) {
      loading.value = false;
      return;
    }

    // Step 2: Backend login → get userId
    final res = await AuthService.loginWithIdToken(idToken);

    if (res == null || res.success != true) {
      appToast(content: "Login failed", error: true);
      loading.value = false;
      return;
    }

    final data = res.data!;
    storage.write(AppConst.USER_ID, data.userId);
    storage.write(AppConst.ACCESS_TOKEN, data.accessToken);
    storage.write(AppConst.REFRESH_TOKEN, data.refreshToken);
    storage.write(AppConst.REFERRAL_CODE, data.referralCode);

    print("✔ SAVED userId: ${storage.read(AppConst.USER_ID)}");
    print("✔ SAVED accessToken: ${storage.read(AppConst.ACCESS_TOKEN)}");
    print("✔ SAVED refreshToken: ${storage.read(AppConst.REFRESH_TOKEN)}");
    print("✔ SAVED referralCode: ${storage.read(AppConst.REFERRAL_CODE)}");

    // Step 3: Update user with FCM + referral

    final referralText = referrelController.text.trim();
    if (referralText.isNotEmpty) {
      await applyReferral(referralText);
    }

    bool updated = await updateUser(data.userId!);

    if (updated) {
      print("✔ Login + Profile Update SUCCESS");
      print("🔁 Checking if referral exists...");

      final referralController = Get.put(ReferralController());
      await referralController.fetchReferrerInfo();

      print("🔄 Referral Info Loaded -> Navigating Home");
      Get.offAll(() => DashboardScreen());
    }

    loading.value = false;
  }

  bool validateInputs() {
    String username = emailController.text.trim();
    String phone = phoneController.text.trim();

    if (username.isEmpty) {
      appToast(content: "Username is required", error: true);
      return false;
    }

    if (phone.isEmpty) {
      appToast(content: "Phone number is required", error: true);
      return false;
    }

    // remove non-digit characters before checking length
    final digitsOnly = phone.replaceAll(RegExp(r'\D'), '');
    if (digitsOnly.length < 7 || digitsOnly.length > 15) {
      appToast(content: "Enter a valid phone number", error: true);
      return false;
    }

    return true; // validation passed
  }

  Future<String?> getDeviceToken() async {
    try {
      String? fcmtoken;
      if (Platform.isAndroid) {
        fcmtoken = await FirebaseMessaging.instance.getToken();
      } else {
        fcmtoken = await FirebaseMessaging.instance.getAPNSToken();
      }
      return fcmtoken;
    } catch (e) {
      print("FCM TOKEN ERROR: $e");
      return null;
    }
  }

  Future<bool> updateUser(String userId) async {
    try {
      final deviceToken = await getDeviceToken();

      final result = await APIService.putRequest(
        url: AppURLs.USER_UPDATE_API + userId,
        body: {
          "deviceToken": deviceToken ?? "",
        },
        headers: {
          "Authorization": "Bearer ${storage.read(AppConst.ACCESS_TOKEN)}",
          "Content-Type": "application/json"
        },
        onSuccess: (json) => json,
      );

      if (result == null) return false;

      if (result["success"] == true) {
        return true;
      }

      appToast(content: result["message"], error: true);
      return false;
    } catch (e) {
      print("UPDATE ERROR::: $e");
      return false;
    }
  }

  // ================= APPLY REFERRAL CODE API =================
  Future<bool> applyReferral(String code) async {
    print("\n========= APPLYING REFERRAL =========");
    print("Entered Code: $code");
    if (code.isEmpty) {
      print("⚠ Referral Empty → Skipping");
      return true;
    }

    final result = await referralService.applyReferralCode(code);

    if (result == null) {
      print("❌ API Returned NULL → Something failed");
      appToast(error: true, content: "Something went wrong");
      return false;
    }

    if (result.success == true) {
      print("🎉 Referral Applied Successfully!");
      print("Message: ${result.message}");
      storage.write("referral_applied", true);
      referralApplied.value = true;

      appToast(title: "Success", content: result.message);
      final referralController = Get.find<ReferralController>();
      referralController.fetchReferralData();
      print("🔁 Fetching new referral info to update UI...");
      referralController.fetchReferrerInfo();
      print("🔄 UI updated with referrer info");
      return true;
    }

    // Handle backend error codes
    switch (result.code) {
      case "REFERRAL_ALREADY_APPLIED":
      case "INVALID_REFERRAL_CODE":
      case "SELF_REFERRAL":
      case "REFERRAL_LIMIT_EXCEEDED":
        appToast(error: true, content: result.message);
        break;
      default:
        appToast(error: true, content: result.message);
    }

    return false;
  }
}
