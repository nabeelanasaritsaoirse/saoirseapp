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
  //navigation
  _splashScreen() {
    bool isLogin = !(storage.read(AppConst.USER_ID) == null);

    Future.delayed(const Duration(seconds: 2), () async {
      if (isLogin) {
        Get.offAll(() => DashboardScreen());
      } else {
        Get.offAll(() => const OnBoardScreen());
      }
    });
  }

  @override
  void initState() {
    super.initState();

    _splashScreen();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.primaryColor,
        body: Center(
          child: Image.asset(
            AppAssets.app_logo,
            height: 250.h,
            width: Get.width,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
