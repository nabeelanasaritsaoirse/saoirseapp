import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/app_colors.dart';

Widget appText(
  String text, {
  TextOverflow? overflow,
  TextAlign? textAlign,
  TextDecoration? decoration,
  int? maxLines,
  double? height,
  double? fontSize,
  FontWeight? fontWeight,
  Color? color,
}) {
  return Text(
    text,
    overflow: overflow,
    softWrap: true,
    maxLines: maxLines,
    textAlign: textAlign ?? TextAlign.center,
    style: GoogleFonts.plusJakartaSans(
      textStyle: TextStyle(
        decoration: decoration,
        height: height,
        fontSize: fontSize ?? 12.sp,
        fontWeight: fontWeight,
        color: color ?? AppColors.white,
      ),
    ),
  );
}
