import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants/app_colors.dart';
import 'app_text.dart';

class ProfileMenuCard extends StatelessWidget {
  final String icon;
  final String title;
  final int? count;
  final VoidCallback? onTap;

  const ProfileMenuCard(
      {super.key,
      required this.icon,
      required this.title,
      this.onTap,
      this.count});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Stack(
        children: [
          Container(
            height: 130.h,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadowColor,
                  blurRadius: 4.r,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 47.w,
                  height: 47.h,
                  child: SvgPicture.asset(
                    icon,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 3.h),
                SizedBox(
                  width: 90.w,
                  height: 32.h,
                  child: appText(
                    title,
                    fontSize: 12.sp,
                    color: AppColors.textBlack,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          if (count != null && count! > 0)
            Positioned(
              right: 32.w,
              top: 5.h,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.red,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "$count",
                  style: TextStyle(color: AppColors.white, fontSize: 10),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
