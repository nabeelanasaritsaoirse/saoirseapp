import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/app_assets.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_constant.dart';
import '../../main.dart';
import '../dashboard/dashboard_screen.dart';
import '../onboard/onboard_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    log("🟢 SplashScreen init");

    _navigate();
  }

  Future<void> _navigate() async {
    bool isLogin = false;

    try {
      final userId = storage.read(AppConst.USER_ID);
      isLogin = userId != null;
      log("🟢 User login state: $isLogin");
    } catch (e) {
      log("⚠️ Storage read failed: $e");
    }

    // HARD safety timeout (never hang)
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    if (isLogin) {
      Get.offAll(() => DashboardScreen());
    } else {
      Get.offAll(() => const OnBoardScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: SafeArea(
        child: Center(
          child: Image.asset(
            AppAssets.app_logo,
            width: 200, // ❌ no ScreenUtil here
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) =>
                const CircularProgressIndicator(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
