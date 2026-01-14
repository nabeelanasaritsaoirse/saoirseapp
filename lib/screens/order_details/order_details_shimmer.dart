import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../constants/app_colors.dart';

class OrderDetailsShimmer extends StatelessWidget {
  const OrderDetailsShimmer({super.key});

  Widget _box({
    double? width,
    required double height,
    BorderRadius? radius,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: radius ?? BorderRadius.circular(8.r),
      ),
    );
  }

  Widget _section({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 6.r,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        spacing: 10.h,
        children: [
          /// ---------------- ADDRESS SECTION SHIMMER ----------------
          _section(
            child: Column(
              spacing: 5.h,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Address label + Name row
                Row(
                  spacing: 15.w,
                  children: [
                    _box(width: 80.w, height: 20.h),
                    _box(width: 100.w, height: 12.h),
                  ],
                ),
                // Address details and Change button row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 2.h,
                        children: [
                          _box(width: double.infinity, height: 10.h),
                          _box(width: 150.w, height: 10.h),
                          _box(width: 120.w, height: 10.h),
                          _box(width: 140.w, height: 10.h),
                        ],
                      ),
                    ),
                    _box(width: 75.w, height: 27.h),
                  ],
                ),
              ],
            ),
          ),

          /// ---------------- PRODUCT DETAILS SECTION SHIMMER ----------------
          _section(
            child: Column(
              spacing: 6.h,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // "Item" label
                _box(width: 60.w, height: 13.h),

                // Product container
                Container(
                  width: double.infinity,
                  padding:
                      EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
                  constraints: BoxConstraints(minHeight: 80.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: AppColors.grey),
                  ),
                  child: Row(
                    spacing: 15.w,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product image
                      _box(
                        width: 55.w,
                        height: 55.h,
                        radius: BorderRadius.circular(8.r),
                      ),

                      // Product details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Product name
                            _box(width: double.infinity, height: 12.h),
                            SizedBox(height: 4.h),
                            // Variant
                            _box(width: 120.w, height: 10.h),
                            SizedBox(height: 4.h),
                            // Price
                            _box(width: 80.w, height: 10.h),
                            SizedBox(height: 4.h),
                            // Plan
                            _box(width: 160.w, height: 10.h),
                            SizedBox(height: 6.h),
                            // Quantity selector
                            Align(
                              alignment: Alignment.centerRight,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                spacing: 10.w,
                                children: [
                                  _box(
                                      width: 22.w,
                                      height: 22.w,
                                      radius: BorderRadius.circular(6.r)),
                                  _box(
                                      width: 30.w,
                                      height: 22.w,
                                      radius: BorderRadius.circular(6.r)),
                                  _box(
                                      width: 22.w,
                                      height: 22.w,
                                      radius: BorderRadius.circular(6.r)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          /// ---------------- COUPON SECTION SHIMMER ----------------
          Column(
            spacing: 10.h,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // "Apply Coupon" label
              _box(width: 100.w, height: 13.h),

              _section(
                child: Column(
                  spacing: 10.h,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Coupon input + Apply button row
                    Row(
                      spacing: 10.w,
                      children: [
                        _box(
                            width: 180.w,
                            height: 35.h,
                            radius: BorderRadius.circular(15.w)),
                        _box(width: 90.w, height: 35.h),
                      ],
                    ),
                    // Available coupons shimmer
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 8.h,
                      children: [
                        _box(width: 130.w, height: 12.h),
                        Row(
                          spacing: 12.w,
                          children: [
                            _box(
                                width: 100.w,
                                height: 50.h,
                                radius: BorderRadius.circular(5.r)),
                            _box(
                                width: 100.w,
                                height: 50.h,
                                radius: BorderRadius.circular(5.r)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          /// ---------------- PRICE DETAILS SECTION SHIMMER ----------------
          _section(
            child: Column(
              spacing: 5.h,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // "Price Details" label
                _box(width: 100.w, height: 12.h),
                SizedBox(height: 5.h),

                // Price rows
                _buildPriceRow(),
                _buildPriceRow(),
                _buildPriceRow(),

                // Divider
                Container(
                  height: 1.h,
                  color: AppColors.grey,
                  margin: EdgeInsets.symmetric(vertical: 5.h),
                ),

                // Total amount
                _buildPriceRow(),

                // Plan details
                _buildPriceRow(),

                // Pay now
                _buildPriceRow(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _box(width: 120.w, height: 10.h),
        _box(width: 60.w, height: 10.h),
      ],
    );
  }
}
