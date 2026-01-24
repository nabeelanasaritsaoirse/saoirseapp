import 'dart:convert';

import 'package:country_picker/country_picker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../constants/app_constant.dart';
import '../../constants/app_urls.dart';
import '../../main.dart';
import '../../services/api_service.dart';
import '../../services/appsflyer_service.dart';
import '../../services/auth_service.dart';
import '../../services/refferal_service.dart';
import '../../widgets/app_toast.dart';
import '../dashboard/dashboard_screen.dart';
import '../home/home_controller.dart';
import '../notification/notification_controller.dart';
import '../refferal/referral_controller.dart';

import 'package:http/http.dart' as http;

class LoginController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController referreltextController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  RxBool loading = false.obs;
  Rx<Country?> country = Rx<Country?>(null);
  RxBool fetchFailed = false.obs;
  RxBool referralApplied = false.obs;
  final ReferralService referralService = ReferralService();
  final formKey = GlobalKey<FormState>();
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
      referreltextController.text = referralCode;
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
  Future<void> googleLogin() async {
    loading.value = true;

    try {
      await AuthService.signOut();

      String? idToken = await AuthService.googleLogin();

      if (idToken == null) {
        loading.value = false;
        return;
      }

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
      storage.write(AppConst.USER_NAME, data.name);
      storage.write(AppConst.CACHE_CLEANUP, true);
      if (Get.isRegistered<HomeController>()) {
        Get.find<HomeController>().loadUserName();
      }
      final notif = Get.find<NotificationController>();
      notif.updateToken(data.accessToken!);

      final String displayName =
          (data.name != null && data.name!.isNotEmpty) ? data.name! : "User";

      await notif.sendWelcomeNotification(displayName);

      final fcmToken = await getDeviceToken();
      if (fcmToken != null) {
        notif.registerFCM(fcmToken);
      }

      bool updated = await updateUser(data.userId!);

      final referralText = referreltextController.text.trim();
      if (referralText.isNotEmpty) {
        await applyReferral(referralText);
      }

      final referralCtrl = Get.isRegistered<ReferralController>()
          ? Get.find<ReferralController>()
          : Get.put(ReferralController());

      await referralCtrl.fetchReferrerInfo();

      if (updated) {
        Get.offAll(() => DashboardScreen());
        appToast(content: "Login Successful!");
      }
    } catch (e) {
      appToast(content: "Something went wrong", error: true);
    } finally {
      loading.value = false;
    }
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
      fcmtoken = await FirebaseMessaging.instance.getToken();
      return fcmtoken;
    } catch (e) {
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
      return false;
    }
  }

  // ================= APPLY REFERRAL CODE API =================
  Future<bool> applyReferral(String code) async {
    if (code.isEmpty) {
      return true;
    }

    final result = await referralService.applyReferralCode(code);

    if (result == null) {
      appToast(error: true, content: "Something went wrong");
      return false;
    }

    if (result.success == true) {
      storage.write("referral_applied", true);
      referralApplied.value = true;

      appToast(title: "Success", content: result.message);
      final referralController = Get.find<ReferralController>();
      referralController.fetchReferralData();

      referralController.fetchReferrerInfo();

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
