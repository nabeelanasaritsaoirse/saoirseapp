import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_text.dart';

Widget appButton({
  required Function() onTap,
  double? height,
  double? width,
  EdgeInsets? padding,
  BorderRadiusGeometry? borderRadius,
  double? borderWidth,
  Color? borderColor,
  Color? buttonColor,
  Gradient? gradient,
  Color? textColor,
  String? buttonText,
  double? fontSize,
  FontWeight? fontWeight,
  Widget? child,
}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: buttonColor,
        gradient: gradient,
        borderRadius: borderRadius ?? BorderRadius.circular(15.r),
        border: borderColor != null
            ? Border.all(width: borderWidth!, color: borderColor)
            : const Border(),
      ),
      child: Center(
        child:
            child ??
            appText(
              buttonText!,
              color: textColor,
              fontSize: fontSize ?? 16.sp,
              fontWeight: fontWeight ?? FontWeight.w600,
            ),
      ),
    ),
  );
}
