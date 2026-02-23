// ignore_for_file: deprecated_member_use, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../constants/app_assets.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_constant.dart';
import '../../main.dart';
import '../../services/deep_link_navigation_service.dart';
import '../dashboard/dashboard_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  //navigation
  Future<void> _splashScreen() async {
    bool cacheCleanUp = storage.read(AppConst.CACHE_CLEANUP) ?? false;
    if (!cacheCleanUp) {
      await storage.erase();
      await storage.write(AppConst.CACHE_CLEANUP, true);
    }

    print("✔ SAVED userId: ${storage.read(AppConst.USER_ID)}");
    print("✔ SAVED accessToken: ${storage.read(AppConst.ACCESS_TOKEN)}");
    print("✔ SAVED refreshToken: ${storage.read(AppConst.REFRESH_TOKEN)}");
    print("✔ SAVED referralCode: ${storage.read(AppConst.REFERRAL_CODE)}");

    Future.delayed(const Duration(seconds: 2), () async {
      Get.offAll(() => DashboardScreen());

      WidgetsBinding.instance.addPostFrameCallback((_) {
        DeepLinkNavigationService.handleProductNavigation();
      });
    });
  }

  @override
  void initState() {
    super.initState();

    _splashScreen();
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
