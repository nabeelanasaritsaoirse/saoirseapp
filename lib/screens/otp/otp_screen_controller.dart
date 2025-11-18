// ignore_for_file: avoid_print

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/app_urls.dart';
import '../../main.dart';
import '../../services/api_service.dart';
import '../../services/auth_service.dart';
import '../../widgets/app_snackbar.dart';
import '../../widgets/app_toast.dart';
import '../dashboard/dashboard_screen.dart';

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
    print("Phone: $phoneNumber, Username: $username, Referral: $referral");

    String? idToken = await AuthService.verifyOTP(otp);

    if (idToken == null) {
      isLoading.value = false;
      return;
    }

    print("Firebase ID Token Received!");

    /// STEP 2 — Login via Backend API
    final res = await AuthService.loginWithIdToken(idToken);

    if (res == null || res.success != true) {
      appSnackbar(content: "Login failed", error: true);
      return;
    }

    final data = res.data!;
    storage.write("userId", data.userId);
    storage.write("accessToken", data.accessToken);
    storage.write("refreshToken", data.refreshToken);

    print("✔ SAVED userId: ${storage.read("userId")}");
    print("✔ SAVED accessToken: ${storage.read("accessToken")}");
    print("✔ SAVED refreshToken: ${storage.read("refreshToken")}");
    print("Backend Login Successful → userId: ${data.userId}");

    /// STEP 3 — Update profile (deviceToken, referral, username, phone)
    bool updated = await updateUser(
      userId: data.userId!,
      referralCode: referral,
      username: username,
      phone: phoneNumber,
    );

    if (!updated) {
      isLoading.value = false;
      return;
    }

    print("User Updated Successfully!");

    /// STEP 4 — Navigate to Home
    Get.offAll(() => DashboardScreen());
    appSnackbar(content: "Login Successful!");

    isLoading.value = false;
  }

  /// UPDATE USER API
  Future<bool> updateUser({
    required String userId,
    required String? referralCode,
    required String username,
    required String phone,
  }) async {
    try {
      String? deviceToken = await getDeviceToken();
      deviceToken ??= "";

      print(" Updating User with:");
      print("   Username: $username");
      print("   Phone: $phone");
      print("   Referral: $referralCode");
      print("   DeviceToken: $deviceToken");
      Map<String, dynamic> body = {
        "deviceToken": deviceToken,
        "username": username,
      };

      // add referral only when user entered it
      if (referralCode != null && referralCode.isNotEmpty) {
        body["referral"] = referralCode;
      }
      final result = await APIService.putRequest(
        url: AppURLs.USER_UPDATE_API + userId,
        body: body,
        headers: {
          "Authorization": "Bearer ${storage.read("accessToken")}",
          "Content-Type": "application/json"
        },
        onSuccess: (json) => json,
      );

      print("Update User Response: $result");

      if (result == null) return false;

      if (result["success"] == true) {
        return true;
      }

      appSnackbar(content: result["message"], error: true);
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
        message: "Resending OTP...A new OTP has been sent to your number.");
  }
}
