// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/app_assets.dart';
import '../../constants/app_colors.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text.dart';

class OnBoardScreen extends StatefulWidget {
  const OnBoardScreen({super.key});

  @override
  State<OnBoardScreen> createState() => OnBoardScreenState();
}

class OnBoardScreenState extends State<OnBoardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppAssets.onBoard_img),
                fit: BoxFit.cover,
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.h, vertical: 40.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      SizedBox(height: 120.h),
                      Image.asset(AppAssets.app_logo, height: 180.h),
                      SizedBox(height: 18.h),
                      appText(
                        "INVEST SMALL, DREAM BIG,\nOWN IT",
                        color: AppColors.white,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                        // need to add font style
                      ),
                    ],
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      appButton(
                        onTap: () {
                          // LOGIN BUTTON
                        },
                        height: 40.h,
                        width: 100.w,
                        buttonText: "Login",
                        textColor: AppColors.white,
                        buttonColor: AppColors.primaryColor,
                      ),

                      SizedBox(height: 10.h),
                      appButton(
                        onTap: () {
                          //SIGNUP BuTTON
                        },
                        height: 40.h,
                        width: 100.w,
                        buttonText: "signup",
                        textColor: AppColors.white,
                        buttonColor: AppColors.primaryColor,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
