import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../constants/app_colors.dart';

class CategoryScreenShimmer extends StatelessWidget {
  const CategoryScreenShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        /// -------- LEFT SIDEBAR SHIMMER --------
        Container(
          width: 85.h,
          color: AppColors.white,
          child: ListView.builder(
            itemCount: 8,
            itemBuilder: (_, __) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 8.w),
                child: Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Column(
                    children: [
                      Container(
                        height: 45.h,
                        width: 45.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Container(
                        height: 8.h,
                        width: 45.w,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        /// -------- RIGHT GRID SHIMMER --------
        Expanded(
          child: GridView.builder(
            padding: EdgeInsets.all(12.w),
            itemCount: 6,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12.h,
              crossAxisSpacing: 12.w,
              childAspectRatio: .72,
            ),
            itemBuilder: (_, __) {
              return Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Column(
                  children: [
                    Container(
                      height: 95.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      height: 10.h,
                      width: double.infinity,
                      color: Colors.white,
                    ),
                    SizedBox(height: 4.h),
                    Container(
                      height: 10.h,
                      width: 60.w,
                      color: Colors.white,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
