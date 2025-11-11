import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/app_colors.dart';

class AppTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final Function(String)? onFieldSubmitted; // ✅ NEW

  final int? maxLength;
  final int? maxLines;
  final int? minLines;

  final double? textSize;
  final double? hintSize;
  final FontWeight? textWeight;
  final FontWeight? hintWeight;

  final Color? textColor;
  final Color? hintColor;
  final Color? fillColor;

  final TextInputAction? textInputAction;
  final TextInputType? textInputType;

  final BorderRadius? borderRadius;
  final BorderSide? borderSide;
  final EdgeInsets? contentPadding;

  final double? prefixWidth;
  final double? suffixWidth;

  final Widget? prefixWidget;
  final Widget? suffixWidget;

  final bool suffix;
  final bool obsecure;
  final bool readOnly;

  const AppTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted, // ✅ NEW
    this.maxLength,
    this.maxLines = 1,
    this.minLines,
    this.textSize,
    this.hintSize,
    this.textWeight,
    this.hintWeight,
    this.textColor,
    this.hintColor,
    this.fillColor,
    this.textInputAction,
    this.textInputType,
    this.borderRadius,
    this.borderSide,
    this.contentPadding,
    this.prefixWidth,
    this.suffixWidth,
    this.prefixWidget,
    this.suffixWidget,
    this.suffix = false,
    this.obsecure = false,
    this.readOnly = false,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _isObscured;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.obsecure;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      cursorColor: AppColors.white,
      readOnly: widget.readOnly,
      obscureText: _isObscured,
      obscuringCharacter: '*',
      textInputAction: widget.textInputAction ?? TextInputAction.done,
      keyboardType: widget.textInputType, // ✅ Keyboard type support
      onFieldSubmitted: widget.onFieldSubmitted, // ✅ Submit callback
      minLines: widget.minLines,
      maxLines: widget.maxLines,
      onChanged: widget.onChanged,
      validator: widget.validator,
      inputFormatters: [
        if (widget.maxLength != null)
          LengthLimitingTextInputFormatter(widget.maxLength),
      ],
      style: GoogleFonts.plusJakartaSans(
        textStyle: TextStyle(
          fontSize: widget.textSize ?? 16.sp,
          fontWeight: widget.textWeight ?? FontWeight.w500,
          color: widget.textColor ?? AppColors.white,
        ),
      ),
      decoration: InputDecoration(
        // 🧩 Field Padding & Background
        contentPadding: widget.contentPadding ??
            EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
        filled: widget.fillColor != null,
        fillColor: widget.fillColor,

        // 🧩 Hint Styling
        hintText: widget.hintText,
        hintStyle: GoogleFonts.plusJakartaSans(
          textStyle: TextStyle(
            fontSize: widget.hintSize ?? 16.sp,
            fontWeight: widget.hintWeight ?? FontWeight.w400,
            color: widget.hintColor ?? AppColors.white.withOpacity(0.3),
          ),
        ),
        errorStyle: const TextStyle(height: 0),

        // 🧩 Prefix Widget
        prefixIconConstraints: widget.prefixWidget != null
            ? BoxConstraints(
                maxHeight: 40.h,
                maxWidth: widget.prefixWidth ?? 60.w,
              )
            : const BoxConstraints(),
        prefixIcon: widget.prefixWidget != null
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: widget.prefixWidget,
              )
            : null,

        // 🧩 Suffix Widget or Password Toggle
        suffixIconConstraints: widget.suffix
            ? BoxConstraints(maxWidth: widget.suffixWidth ?? 60.w)
            : const BoxConstraints(),
        suffixIcon: widget.suffix
            ? widget.suffixWidget ??
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _isObscured = !_isObscured;
                      });
                    },
                    child: Icon(
                      _isObscured
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 22.sp,
                      color: AppColors.white,
                    ),
                  ),
                )
            : null,

        // 🧩 Borders
        enabledBorder: OutlineInputBorder(
          borderRadius: widget.borderRadius ?? BorderRadius.circular(8.r),
          borderSide:
              widget.borderSide ?? BorderSide(color: AppColors.grey, width: 1.w),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: widget.borderRadius ?? BorderRadius.circular(8.r),
          borderSide:
              widget.borderSide ?? BorderSide(color: AppColors.grey, width: 1.w),
        ),
        border: OutlineInputBorder(
          borderRadius: widget.borderRadius ?? BorderRadius.circular(8.r),
          borderSide:
              widget.borderSide ?? BorderSide(color: AppColors.grey, width: 1.w),
        ),
      ),
    );
  }
}








// // ignore_for_file: camel_case_types, must_be_immutable, deprecated_member_use

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:google_fonts/google_fonts.dart';

// import '../constants/app_colors.dart';

// class appTextField extends StatefulWidget {
//   TextEditingController controller;
//   String? Function(String?)? validator;
//   Function(String)? onChanged;
//   int? maxLength;
//   int? maxLines;
//   String hintText;
//   int? minLines;
//   double? textSize;
//   double? hintSize;
//   FontWeight? textWeight;
//   FontWeight? hintWeight;
//   Color? textColor;
//   Color? hintColor;
//   String? prefixImg;
//   TextInputAction? textInputAction;
//   TextInputType? textInputType;
//   BorderRadius? borderRadius;
//   BorderSide? borderSide;
//   EdgeInsets? contentPadding;
//   double? prefixWidth;
//   double? suffixWidth;
//   Color? fillColor;
//   Widget? suffixWidget;
//   bool suffix;
//   bool obsecure;
//   bool readOnly;

//   appTextField({
//     super.key,
//     required this.controller,
//     required this.hintText,
//     required this.validator,
//     this.maxLength,
//     this.onChanged,
//     this.prefixImg,
//     this.textInputAction,
//     this.textInputType,
//     this.borderRadius,
//     this.borderSide,
//     this.contentPadding,
//     this.prefixWidth,
//     this.suffixWidth,
//     this.fillColor,
//     this.textColor,
//     this.textSize,
//     this.textWeight,
//     this.hintColor,
//     this.hintSize,
//     this.hintWeight,
//     this.minLines,
//     this.suffixWidget,
//     this.maxLines = 1,
//     this.suffix = false,
//     this.obsecure = false,
//     this.readOnly = false,
//   });

//   @override
//   State<appTextField> createState() => _appTextFieldState();
// }

// class _appTextFieldState extends State<appTextField> {
//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       controller: widget.controller,
//       cursorColor: AppColors.white,
//       textInputAction: widget.textInputAction ?? TextInputAction.done,
//       obscuringCharacter: '*',
//       obscureText: widget.obsecure,
//       keyboardType: widget.textInputType,
//       minLines: widget.minLines,
//       maxLines: widget.maxLines,
//       inputFormatters: [LengthLimitingTextInputFormatter(widget.maxLength)],
//       readOnly: widget.readOnly,
//       onChanged: widget.onChanged,
//       validator: widget.validator,
//       style: GoogleFonts.plusJakartaSans(
//         textStyle: TextStyle(
//           fontSize: widget.textSize ?? 16.sp,
//           fontWeight: widget.textWeight ?? FontWeight.w500,
//           color: widget.textColor ?? AppColors.white,
//         ),
//       ),
//       decoration: InputDecoration(
//         contentPadding:
//             widget.contentPadding ??
//             EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
//         filled: widget.fillColor != null,
//         fillColor: widget.fillColor,
//         errorStyle: const TextStyle(height: 0),
//         hintText: widget.hintText,
//         hintStyle: GoogleFonts.plusJakartaSans(
//           textStyle: TextStyle(
//             fontSize: widget.hintSize ?? 16.sp,
//             fontWeight: widget.hintWeight ?? FontWeight.w400,
//             color: widget.hintColor ?? AppColors.white.withOpacity(0.3),
//           ),
//         ),
//         prefixIconConstraints: widget.prefixImg == null
//             ? BoxConstraints(maxHeight: 0, maxWidth: widget.prefixWidth ?? 0)
//             : BoxConstraints(maxHeight: 25.h, maxWidth: 60.w),
//         prefixIcon: widget.prefixImg == null
//             ? Container()
//             : Container(
//                 padding: EdgeInsets.symmetric(horizontal: 15.w),
//                 child: SvgPicture.asset(
//                   widget.prefixImg!,
//                   height: 17.h,
//                   fit: BoxFit.contain,
//                 ),
//               ),
//         suffixIconConstraints: widget.suffix
//             ? BoxConstraints(maxWidth: widget.suffixWidth ?? 60.w)
//             : BoxConstraints(
//                 maxHeight: 0,
//                 maxWidth: widget.suffixWidth ?? 20.w,
//               ),
//         suffixIcon: widget.suffix
//             ? widget.suffixWidget ??
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 15.w),
//                     child: InkWell(
//                       onTap: () {
//                         widget.obsecure = !widget.obsecure;
//                         setState(() {});
//                       },
//                       child: Icon(
//                         widget.obsecure
//                             ? Icons.visibility_off_outlined
//                             : Icons.visibility_outlined,
//                         size: 25.sp,
//                         color: AppColors.white,
//                       ),
//                     ),
//                   )
//             : Container(),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: widget.borderRadius ?? BorderRadius.circular(8.r),
//           borderSide:
//               widget.borderSide ??
//               BorderSide(color: AppColors.grey, width: 1.w),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: widget.borderRadius ?? BorderRadius.circular(8.r),
//           borderSide:
//               widget.borderSide ??
//               BorderSide(color: AppColors.grey, width: 1.w),
//         ),
//         border: OutlineInputBorder(
//           borderRadius: widget.borderRadius ?? BorderRadius.circular(8.r),
//           borderSide:
//               widget.borderSide ??
//               BorderSide(color: AppColors.grey, width: 1.w),
//         ),
//       ),
//     );
//   }
// }
