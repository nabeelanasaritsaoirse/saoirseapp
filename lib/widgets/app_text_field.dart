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




