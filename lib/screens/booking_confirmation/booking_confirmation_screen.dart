import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:saoirse_app/constants/app_colors.dart';
import 'package:saoirse_app/constants/app_gradient.dart';
import 'package:saoirse_app/constants/app_strings.dart';
import 'package:saoirse_app/screens/dashboard/dashboard_controller.dart';
import 'package:saoirse_app/screens/dashboard/dashboard_screen.dart';

import 'package:saoirse_app/widgets/app_text.dart';

class BookingConfirmationScreen extends StatelessWidget {
  const BookingConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Green circle with tick
              Container(
                width: 110.w,
                height: 110.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.green,
                ),
                child: Center(
                  child: Icon(
                    Icons.check,
                    size: 55.sp,
                    color: AppColors.white,
                  ),
                ),
              ),

              SizedBox(height: 20.h),

              // Title
              appText(
                AppStrings.confirm_title,
                color: AppColors.black,
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
              ),

              SizedBox(height: 10.h),

              // Subtitle
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.w),
                child: appText(
                  AppStrings.confirm_content,
                  color: AppColors.black87,
                  fontSize: 14.sp,
                  textAlign: TextAlign.center,
                  height: 1.4,
                ),
              ),

              SizedBox(height: 30.h),

              // Thank You Button
              InkWell(
                onTap: () {
                  final dashboardController = Get.find<DashboardController>();
                  dashboardController.selectedIndex.value = 0;

                  Get.offAll(() => DashboardScreen());
                },
                child: Container(
                  width: 180.w,
                  height: 45.h,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      gradient: AppGradients.primaryGradient),
                  child: Center(
                    child: appText(
                      "Thank You",
                      color: AppColors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
