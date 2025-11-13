import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_colors.dart';
import 'app_text.dart';

Widget appButton({
  required VoidCallback onTap,
  double? height,
  double? width,
  EdgeInsets? padding,
  BorderRadius? borderRadius,
  double? borderWidth,
  Color? borderColor,
  Color? buttonColor,
  Gradient? gradient,
  Color? textColor,
  String? buttonText,
  double? fontSize,
  FontWeight? fontWeight,
  String fontFamily = 'poppins',
  Widget? child,
}) {
  return InkWell(
    onTap: onTap,
    borderRadius: borderRadius ?? BorderRadius.circular(15.r),
    child: Container(
      width: width ?? double.infinity,
      height: height ?? 48.h,
      padding: padding ?? EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(
        color: buttonColor,
        gradient: gradient,
        borderRadius: borderRadius ?? BorderRadius.circular(15.r),
        border: borderColor != null
            ? Border.all(width: borderWidth ?? 1, color: borderColor)
            : null,
      ),
      child: Center(
        child: child ??
            (buttonText != null
                ? appText(
                    buttonText,
                    color: textColor ?? AppColors.white,
                    fontFamily: fontFamily,
                    fontSize: fontSize ?? 16.sp,
                    fontWeight: fontWeight ?? FontWeight.w600,
                  )
                : const SizedBox()),
      ),
    ),
  );
}
