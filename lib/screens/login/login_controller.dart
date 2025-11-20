// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../constants/app_constant.dart';
import '../../constants/app_urls.dart';
import '../../main.dart';
import '../../services/api_service.dart';
import '../../services/auth_service.dart';
import '../../widgets/app_snackbar.dart';
import '../dashboard/dashboard_screen.dart';

import 'package:http/http.dart' as http;

class LoginController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController referrelController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  RxBool loading = false.obs;
  Rx<Country?> country = Rx<Country?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchCountryCode();
  }

  Future<void> fetchCountryCode() async {
    try {
      final response = await http
          .get(Uri.parse("http://ip-api.com/json"))
          .timeout(Duration(seconds: 3));

      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        print("Response body: $body");
        final countryCode = body["countryCode"];
        country.value = CountryParser.tryParseCountryCode(countryCode);
      }
    } catch (e) {
      print("Error fetching country code: $e");
    }
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
      appSnackbar(content: "Login failed", error: true);
      return;
    }

    final data = res.data!;
    storage.write(AppConst.USER_ID, data.userId);
    storage.write(AppConst.ACCESS_TOKEN, data.accessToken);
    storage.write(AppConst.REFRESH_TOKEN, data.refreshToken);

    print("✔ SAVED userId: ${storage.read(AppConst.USER_ID)}");
    print("✔ SAVED accessToken: ${storage.read(AppConst.ACCESS_TOKEN)}");
    print("✔ SAVED refreshToken: ${storage.read(AppConst.REFRESH_TOKEN)}");

    // Step 3: Update user with FCM + referral
    bool updated = await updateUser(
      data.userId!,
      referrelController.text.isNotEmpty ? referrelController.text.trim() : "",
    );

    if (updated) {
      // Step 4: Navigate to Home
      Get.offAll(() => DashboardScreen());
      appSnackbar(content: "Login Successful!");
    }

    loading.value = false;
  }

  bool validateInputs() {
    String username = emailController.text.trim();
    String phone = phoneController.text.trim();

    if (username.isEmpty) {
      appSnackbar(content: "Username is required", error: true);
      return false;
    }

    if (phone.isEmpty) {
      appSnackbar(content: "Phone number is required", error: true);
      return false;
    }

    if (phone.length < 7 || phone.length > 15) {
      appSnackbar(content: "Enter a valid phone number", error: true);
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

  Future<bool> updateUser(String userId, String? referralCode) async {
    try {
      final deviceToken = await getDeviceToken();

      final result = await APIService.putRequest(
        url: AppURLs.USER_UPDATE_API + userId,
        body: {
          "referral": referralCode ?? "",
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

      appSnackbar(content: result["message"], error: true);
      return false;
    } catch (e) {
      print("UPDATE ERROR::: $e");
      return false;
    }
  }
}
