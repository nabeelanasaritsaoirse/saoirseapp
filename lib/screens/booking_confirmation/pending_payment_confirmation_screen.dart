import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:saoirse_app/constants/app_constant.dart';
import 'package:saoirse_app/main.dart';
import 'package:saoirse_app/screens/notification/notification_controller.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_gradient.dart';
import '../../widgets/app_text.dart';
import '/screens/dashboard/dashboard_controller.dart';
import '/screens/dashboard/dashboard_screen.dart';

class PendingPaymentConfirmationScreen extends StatelessWidget {
  const PendingPaymentConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Circle with icon (same design)
              Container(
                width: 110.w,
                height: 110.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.green, // keeping same color as requested
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

              // ✅ Title
              appText(
                "One Step Closer!",
                color: AppColors.black,
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
              ),

              SizedBox(height: 10.h),

              // ✅ Description
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.w),
                child: appText(
                  "Your payment has been received and your installment is updated. "
                  "You are getting closer to your product delivery! "
                  "Your product will be shipped once the full amount is paid.",
                  color: AppColors.black87,
                  fontSize: 14.sp,
                  textAlign: TextAlign.center,
                  height: 1.4,
                ),
              ),

              SizedBox(height: 30.h),

              // Thank You Button (unchanged)
              InkWell(
                onTap: () async {
                  final username = storage.read(AppConst.USER_NAME) ?? "User";
                  final notif = Get.find<NotificationController>();
                  await notif.sendPendingPaymentConfirmation(username);

                  final dashboardController = Get.find<DashboardController>();
                  dashboardController.selectedIndex.value = 0;

                  Get.offAll(() => DashboardScreen());
                },
                child: Container(
                  width: 180.w,
                  height: 45.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    gradient: AppGradients.primaryGradient,
                  ),
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
