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
  double? letterSpacing, // ➕ added
  FontWeight? fontWeight,
  FontStyle? fontStyle, // ➕ added
  Color? color,
  String fontFamily = 'poppins',
}) {
  TextStyle fontStyleSelected;

  final baseStyle = TextStyle(
    decoration: decoration,
    height: height,
    fontSize: fontSize ?? 12.sp,
    fontWeight: fontWeight,
    letterSpacing: letterSpacing, // ➕ added
    fontStyle: fontStyle, // ➕ added
    color: color ?? AppColors.text_black,
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
    default:
      fontStyleSelected = GoogleFonts.poppins(textStyle: baseStyle);
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

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';

// import '../constants/app_colors.dart';

// Widget appText(
//   String text, {
//   TextOverflow? overflow,
//   TextAlign? textAlign,
//   TextDecoration? decoration,
//   int? maxLines,
//   double? height,
//   double? fontSize,
//   FontWeight? fontWeight,
//   Color? color,
// }) {
//   return Text(
//     text,
//     overflow: overflow,
//     softWrap: true,
//     maxLines: maxLines,
//     textAlign: textAlign ?? TextAlign.center,
//     style: GoogleFonts.plusJakartaSans(
//       textStyle: TextStyle(
//         decoration: decoration,
//         height: height,
//         fontSize: fontSize ?? 12.sp,
//         fontWeight: fontWeight,
//         color: color ?? AppColors.white,
//       ),
//     ),
//   );
// }
