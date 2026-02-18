import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_colors.dart';
import 'app_text.dart';

class ExpandableSectionHeader extends StatelessWidget {
  final String title;
  final bool isExpanded;
  final VoidCallback onTap;
  final EdgeInsetsGeometry? padding;
  final bool showDivider;

  const ExpandableSectionHeader({
    super.key,
    required this.title,
    required this.isExpanded,
    required this.onTap,
    this.padding,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: padding ?? EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          // color: AppColors.lightGreen,
          border: showDivider
              ? Border(
                  bottom: BorderSide(
                    color: AppColors.lightGrey,
                  ),
                )
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            appText(
              title,
              fontWeight: FontWeight.w600,
              fontSize: 14.sp,
              color: AppColors.textBlack,
            ),
            AnimatedRotation(
              turns: isExpanded ? 0.5 : 0,
              duration: const Duration(milliseconds: 200),
              child: Icon(
                Icons.keyboard_arrow_down,
                color: AppColors.textBlack,
                size: 22.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
