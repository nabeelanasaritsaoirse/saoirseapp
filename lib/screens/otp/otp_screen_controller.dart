// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saoirse_app/screens/notification/notification_controller.dart';

import '../../constants/app_constant.dart';
import '../../constants/app_urls.dart';
import '../../main.dart';
import '../../services/api_service.dart';
import '../../services/auth_service.dart';
import '../../widgets/app_toast.dart';
import '../dashboard/dashboard_screen.dart';
import '../login/login_controller.dart';
import '../refferal/referral_controller.dart';

class VerifyOtpController extends GetxController {
  VerifyOtpController({
    required this.phoneNumber,
    required this.referral,
    required this.username,
  });
  final List<TextEditingController> otpControllers =
      List.generate(6, (index) => TextEditingController());
  final List<FocusNode> focusNodes =
      List.generate(6, (index) => FocusNode()); //new

  var isLoading = false.obs;
  final String phoneNumber;
  final String username;
  final String referral;

  RxInt secondsRemaining = 60.obs;
  RxBool canResend = false.obs;
  Timer? timer;
  @override
  void onInit() {
    super.onInit();
    startTimer();
  }

  void startTimer() {
    canResend(false);
    secondsRemaining.value = 60;

    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining.value > 0) {
        secondsRemaining.value--;
      } else {
        canResend(true);
        timer.cancel();
      }
    });
  }

  void stopTimer() {
    timer?.cancel();
  }

  /// STEP 1 — Verify OTP (Firebase)
  Future<void> verifyOtp() async {
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
    storage.write(AppConst.USER_NAME, data.name);

    print("✔ SAVED userId: ${storage.read(AppConst.USER_ID)}");
    print("✔ SAVED accessToken: ${storage.read(AppConst.ACCESS_TOKEN)}");
    print("✔ SAVED refreshToken: ${storage.read(AppConst.REFRESH_TOKEN)}");
    print("Backend Login Successful → userId: ${data.userId}");
    print("✔ SAVED referralCode: ${storage.read(AppConst.REFERRAL_CODE)}");

    /// STEP 3 — Update profile (deviceToken, referral, username, phone)
    final notif = Get.find<NotificationController>();
    notif.updateToken(data.accessToken!); // update token in controller
    notif.service.updateToken(data.accessToken!);

    bool updated = await updateUser(
      userId: data.userId!,
      name: username,
      phoneNumber: phoneNumber,
    );

    if (!updated) {
      isLoading.value = false;
      return;
    }
    if (referral.isNotEmpty) {
      print("\n========== APPLY REFERRAL DURING OTP LOGIN ==========");
      bool applied = await Get.find<LoginController>().applyReferral(referral);

      print(applied
          ? "🎉 Referral Applied Successfully"
          : "⚠ Referral Failed or Invalid");

      final referralCtrl = Get.isRegistered<ReferralController>()
          ? Get.find<ReferralController>()
          : Get.put(ReferralController());
      await referralCtrl.fetchReferrerInfo();
      // <-- required
      print("🔍 Referrer Info Retrieved After OTP Login");
      print("=====================================================\n");
    }
    notif.updateToken(data.accessToken!);
    await notif.sendWelcomeNotification(username);
    await notif.refreshNotifications();
    await notif.fetchUnreadCount();
    print("🔍 Referral Check Complete After OTP Login");
    final fcmToken = await getDeviceToken();
    if (fcmToken != null) {
      log("Assign FCM token to the registerFCM function : $fcmToken");
      Get.find<NotificationController>().registerFCM(fcmToken);
    }

    /// ✅ STEP 5 — TOKEN REFRESH LISTENER (Only after login)
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      log("🔄 New FCM token generated: $newToken");

      final accessToken = storage.read(AppConst.ACCESS_TOKEN);
      if (accessToken != null) {
        Get.find<NotificationController>().registerFCM(newToken);
      } else {
        log("⚠ User logged out — skipping FCM refresh update");
      }
    });

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
        "phoneNumber": phoneNumber,
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
      log("FCM Token: $token");
      return token;
    } catch (e) {
      log("FCM TOKEN ERROR: $e");
      return null;
    }
  }

  /// --- Resend OTP (Local mock) ---
  Future<void> resendOtp() async {
    appToast(
        content: "Resending OTP...A new OTP has been sent to your number.");
  }

//------------------new-----------------------------
  @override
  void onClose() {
    for (var node in focusNodes) {
      node.dispose();
    }
    for (var controller in otpControllers) {
      controller.dispose();
    }
    timer?.cancel();
    super.onClose();
  }
}
