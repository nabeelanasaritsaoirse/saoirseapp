import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../constants/app_colors.dart';

class ProductGridShimmer extends StatelessWidget {
  const ProductGridShimmer({super.key, this.itemCount = 6});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(12.w),
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10.h,
        crossAxisSpacing: 10.w,
        childAspectRatio: 0.70,
      ),
      itemCount: itemCount,
      itemBuilder: (_, __) {
        return Shimmer.fromColors(
          baseColor: AppColors.lightGrey,
          highlightColor: Colors.grey.shade200,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // IMAGE
                Container(
                  height: 120.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                SizedBox(height: 8.h),

                // TITLE
                Container(
                  height: 14.h,
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 8.w),
                  color: Colors.white,
                ),

                SizedBox(height: 6.h),

                // BRAND
                Container(
                  height: 12.h,
                  width: 80.w,
                  margin: EdgeInsets.symmetric(horizontal: 8.w),
                  color: Colors.white,
                ),

                SizedBox(height: 10.h),

                // PRICE
                Container(
                  height: 14.h,
                  width: 60.w,
                  margin: EdgeInsets.symmetric(horizontal: 8.w),
                  color: Colors.white,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
