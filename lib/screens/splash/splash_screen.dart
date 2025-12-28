// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

    /// ✅ Delay until FIRST FRAME is rendered (CRITICAL)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navigate();
    });
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 2));

    final userId = storage.read(AppConst.USER_ID);

    if (userId != null) {
      Get.offAll(() => DashboardScreen());
    } else {
      Get.offAll(() => const OnBoardScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Center(
        child: Image.asset(
          AppAssets.app_logo,
          height: 250.h,
          width: Get.width,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
