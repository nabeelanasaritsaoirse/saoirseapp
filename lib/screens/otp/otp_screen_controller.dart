// ignore_for_file: avoid_print

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/app_constant.dart';
import '../../constants/app_urls.dart';
import '../../main.dart';
import '../../services/api_service.dart';
import '../../services/auth_service.dart';
import '../../widgets/app_toast.dart';
import '../dashboard/dashboard_screen.dart';
import '../login/login_controller.dart';

class VerifyOtpController extends GetxController {
  VerifyOtpController({
    required this.phoneNumber,
    required this.referral,
    required this.username,
  });
  final List<TextEditingController> otpControllers =
      List.generate(6, (_) => TextEditingController());

  var isLoading = false.obs;
  final String phoneNumber;
  final String username;
  final String referral;

  /// STEP 1 — Verify OTP (Firebase)
  verifyOtp() async {
    isLoading.value = true;

    String otp = otpControllers.map((c) => c.text).join();

    print("OTP ENTERED: $otp");
    print("PhoneNumber: $phoneNumber, name: $username, Referral: $referral");

    String? idToken = await AuthService.verifyOTP(otp);

    if (idToken == null) {
      isLoading.value = false;
      return;
    }

    print("Firebase ID Token Received!");

    /// STEP 2 — Login via Backend API
    final res = await AuthService.loginWithIdToken(idToken);

    if (res == null || res.success != true) {
      appToast(content: "Login failed", error: true);
      return;
    }
    print("✔ SUCCESS FLAG: ${res.success}");
    print("✔ LOGIN MESSAGE: ${res.message}");
    final data = res.data!;
    storage.write(AppConst.USER_ID, data.userId);
    storage.write(AppConst.ACCESS_TOKEN, data.accessToken);
    storage.write(AppConst.REFRESH_TOKEN, data.refreshToken);
    storage.write(AppConst.REFERRAL_CODE, data.referralCode);

    print("✔ SAVED userId: ${storage.read(AppConst.USER_ID)}");
    print("✔ SAVED accessToken: ${storage.read(AppConst.ACCESS_TOKEN)}");
    print("✔ SAVED refreshToken: ${storage.read(AppConst.REFRESH_TOKEN)}");
    print("Backend Login Successful → userId: ${data.userId}");
    print("✔ SAVED referralCode: ${storage.read(AppConst.REFERRAL_CODE)}");

    /// STEP 3 — Update profile (deviceToken, referral, username, phone)
    if (referral.isNotEmpty) {
      await Get.find<LoginController>().applyReferralCode(referral);
    }

    bool updated = await updateUser(
      userId: data.userId!,
      name: username,
      phoneNumber: phoneNumber,
    );

    if (!updated) {
      isLoading.value = false;
      return;
    }

    print("User Updated Successfully!");

    /// STEP 4 — Navigate to Home
    Get.offAll(() => DashboardScreen());
    appToast(content: "Login Successful!");

    isLoading.value = false;
  }

  /// UPDATE USER API
  Future<bool> updateUser({
    required String userId,
    required String name,
    required String phoneNumber,
  }) async {
    try {
      String? deviceToken = await getDeviceToken();
      deviceToken ??= "";

      print(" Updating User with:");
      print("   name: $username");
      print("   phoneNumber: $phoneNumber");
      print("   DeviceToken: $deviceToken");
      Map<String, dynamic> body = {
        "deviceToken": deviceToken,
        "name": username,
      };

      final result = await APIService.putRequest(
        url: AppURLs.USER_UPDATE_API + userId,
        body: body,
        headers: {
          "Authorization": "Bearer ${storage.read(AppConst.ACCESS_TOKEN)}",
          "Content-Type": "application/json"
        },
        onSuccess: (json) => json,
      );

      print("Update User Response: $result");

      if (result == null) return false;

      if (result["success"] == true) {
        return true;
      }

      appToast(content: result["message"], error: true);
      return false;
    } catch (e) {
      print("UPDATE ERROR: $e");
      return false;
    }
  }

  /// GET FCM TOKEN
  Future<String?> getDeviceToken() async {
    try {
      final token = await FirebaseMessaging.instance.getToken();
      print("FCM Token: $token");
      return token;
    } catch (e) {
      print("FCM TOKEN ERROR: $e");
      return null;
    }
  }

  /// --- Resend OTP (Local mock) ---
  Future<void> resendOtp() async {
    appToast(
        content: "Resending OTP...A new OTP has been sent to your number.");
  }
}
