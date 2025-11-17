import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:saoirse_app/constants/app_colors.dart';
import 'package:saoirse_app/widgets/app_text.dart';

class ProfileMenuCard extends StatelessWidget {
  final String icon;
  final String title;

  const ProfileMenuCard({
    super.key,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140.h,
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
          // ICON CIRCLE
          SizedBox(
            width: 55.w,
            height: 55.h, // <-- same ratio!
            child: Image.asset(
              icon,
              fit: BoxFit.contain,
            ),
          ),

          SizedBox(height: 4.h),

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
    );
  }
}
