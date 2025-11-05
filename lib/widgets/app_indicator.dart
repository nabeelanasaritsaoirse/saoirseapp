import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_colors.dart';

Widget appIndicator({required int length, required int current}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: List.generate(
      length,
      (index) => Padding(
        padding: EdgeInsets.only(right: 5.w),
        child: AnimatedContainer(
          height: 12.h,
          width: index == current ? 40.w : 12.w,
          duration: const Duration(microseconds: 1000),
          decoration: BoxDecoration(
            borderRadius: index == current ? BorderRadius.circular(20.r) : null,
            shape: index == current ? BoxShape.rectangle : BoxShape.circle,
            color: index == current
                ? AppColors.white
                : AppColors.white.withOpacity(0.5),
          ),
        ),
      ),
    ),
  );
}
