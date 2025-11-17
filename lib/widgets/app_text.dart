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
  double? letterSpacing, 
  FontWeight? fontWeight,
  FontStyle? fontStyle,
  Color? color,
  String fontFamily = 'poppins',
}) {
  TextStyle fontStyleSelected;

  final baseStyle = TextStyle(
    decoration: decoration,
    height: height,
    fontSize: fontSize ?? 12.sp,
    fontWeight: fontWeight,
    letterSpacing: letterSpacing, 
    fontStyle: fontStyle, 
    color: color ?? AppColors.textBlack,
  );

  switch (fontFamily.toLowerCase()) {
    case 'montserrat':
      fontStyleSelected = GoogleFonts.montserrat(textStyle: baseStyle);
      break;

    case 'jakarta':
      fontStyleSelected = GoogleFonts.plusJakartaSans(textStyle: baseStyle);
      break;

    case 'poppins':
      fontStyleSelected = GoogleFonts.poppins(textStyle: baseStyle);
      break;
    case 'inter':
      fontStyleSelected = GoogleFonts.inter(textStyle: baseStyle);
      break;
    default:
      fontStyleSelected = baseStyle.copyWith(fontFamily: fontFamily);
  }

  return Text(
    text,
    overflow: overflow,
    softWrap: true,
    maxLines: maxLines,
    textAlign: textAlign ?? TextAlign.center,
    style: fontStyleSelected,
  );
}
