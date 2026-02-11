import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../constants/app_colors.dart';

/// ------------------ BANNER SHIMMER ------------------
class HomeBannerShimmer extends StatelessWidget {
  const HomeBannerShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.lightGrey,
      highlightColor: Colors.grey.shade200,
      child: Container(
        height: 140.h,
        margin: EdgeInsets.symmetric(horizontal: 8.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    );
  }
}

/// ------------------ CATEGORY CHIP SHIMMER ------------------
class CategoryChipShimmer extends StatelessWidget {
  const CategoryChipShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: 6,
        itemBuilder: (_, __) {
          return Shimmer.fromColors(
            baseColor: AppColors.lightGrey,
            highlightColor: Colors.grey.shade200,
            child: Container(
              margin: EdgeInsets.only(right: 8.w),
              width: 50.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// ------------------ FEATURED PRODUCT SHIMMER ------------------
class FeaturedProductShimmer extends StatelessWidget {
  final bool isBig;

  const FeaturedProductShimmer({super.key, required this.isBig});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: isBig ? 205.h : 85.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: 5,
        itemBuilder: (_, __) {
          return Shimmer.fromColors(
            baseColor: AppColors.lightGrey,
            highlightColor: Colors.grey.shade200,
            child: Container(
              margin: EdgeInsets.only(right: 12.w),
              width: isBig ? 150.w : 220.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          );
        },
      ),
    );
  }
}
