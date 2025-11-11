import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saoirse_app/screens/home/home_screen.dart';
import 'package:saoirse_app/widgets/app_toast.dart';

class VerifyOtpController extends GetxController {
  final List<TextEditingController> otpControllers =
      List.generate(4, (_) => TextEditingController());

  var isLoading = false.obs;
  late String phoneNumber;

  /// --- Verify OTP (Local Validation Only) for temp ---
  Future<void> verifyOtp() async {
    final otp = otpControllers.map((c) => c.text).join();

    //Validation
    if (otp.isEmpty) {
      appToast(message: "Please enter the OTP code.", error: true);

      return;
    }

    if (otp.length != 4) {
      appToast(message: "Please enter all 4 digits of the OTP.", error: true);

      return;
    }

    // Success Message + Navigate
    appToast(message: "OTP Verified Successfully!");

    // Small delay just for UX
    await Future.delayed(const Duration(seconds: 1));

    //Temporary navigation to HomeScreen
    Get.offAll(() => const HomeScreen());
  }

  /// --- Resend OTP (Local mock) ---
  Future<void> resendOtp() async {
    appToast(
        message: "Resending OTP...A new OTP has been sent to your number.");
  }
}
