import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/app_colors.dart';
import 'app_button.dart';
import 'app_text.dart';

appDialogBox({
  required String title,
  required String content,
  required String confirmText,
  required String cancelText,
  required Function()? confirm,
  required Color confirmBtnColor,
  Color? textColor,
  Color? borderColor,
  double? width,
  EdgeInsets? contentPadding,
  bool? showShadow,
}) {
  Get.defaultDialog(
    radius: 10.r,
    backgroundColor: AppColors.scaffoldColor,
    barrierDismissible: false,
    contentPadding: contentPadding ?? EdgeInsets.symmetric(horizontal: 20.w),
    titlePadding: EdgeInsets.symmetric(vertical: 10.h),
    title: title,
    titleStyle: GoogleFonts.plusJakartaSans(
      textStyle: TextStyle(
        color: AppColors.white,
        fontSize: 18.sp,
        fontWeight: FontWeight.w700,
      ),
    ),
    content: WillPopScope(
      onWillPop: () async => false,
      child: Padding(
        padding: EdgeInsets.only(bottom: 10.h),
        child: appText(
          content,
          color: AppColors.white,
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
    actions: [
      Padding(
        padding: EdgeInsets.only(bottom: 15.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            appButton(
              onTap: () {
                Get.back();
              },
              height: 33.h,
              width: width ?? 115.w,
              borderRadius: BorderRadius.circular(10.r),
              borderWidth: 1.w,
              borderColor: AppColors.white,
              buttonColor: AppColors.scaffoldColor,
              textColor: AppColors.white,
              buttonText: cancelText,
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
            ),
            SizedBox(width: 10.w),
            InkWell(
              onTap: confirm,
              child: Container(
                height: 33.h,
                width: width ?? 115.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: confirmBtnColor,
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: borderColor ?? Colors.transparent),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.white.withOpacity(0.15),
                      blurRadius: 20.r,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
                child: appText(
                  confirmText,
                  color: textColor ?? AppColors.scaffoldColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
