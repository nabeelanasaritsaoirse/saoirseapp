import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../constants/app_strings.dart';
import '../../constants/app_colors.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text.dart';


class WarningDialog {
  static void show({
    required String title,
    required String message,
    String buttonText = "OK",
    VoidCallback? onConfirm,
  }) {
    Get.dialog(
      Dialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// ICON
              Container(
                width: 52.w,
                height: 52.h,
                decoration: BoxDecoration(
                  color: AppColors.lightAmber.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.warning_amber_rounded,
                    color: AppColors.mediumAmber,
                    size: 26.sp,
                  ),
                ),
              ),

              SizedBox(height: 15.h),

              /// TITLE
              appText(
                title,
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textBlack,
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 10.h),

              /// MESSAGE
              appText(
                message,
                fontSize: 13.sp,
                color: AppColors.grey,
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 20.h),

              /// OK BUTTON

              appButton(
                  onTap: () => Get.back(),
                  width: double.infinity,
                  height: 40.h,
                  buttonColor: AppColors.lightGrey,
                  borderRadius: BorderRadius.circular(8.r),
                  borderColor: AppColors.shadowColor,
                  child: Center(
                    child: appText(AppStrings.ok,
                        color: AppColors.textBlack,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600),
                  ))
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }
}
