import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import '../../constants/app_colors.dart';
import '../../models/coupon_model.dart';
import '../../widgets/custom_appbar.dart';

import 'package:get/get.dart';
import 'coupon_controller.dart';

class CouponScreen extends StatelessWidget {
  const CouponScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CouponController());

    return Scaffold(
      backgroundColor: AppColors.paperColor,
      appBar: const CustomAppBar(
        title: "Coupons",
        showBack: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const CouponShimmer();
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(child: Text(controller.errorMessage.value));
        }

        if (controller.coupons.isEmpty) {
          return const Center(child: Text("No coupons available"));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.coupons.length,
          itemBuilder: (context, index) {
            final coupon = controller.coupons[index];
            return CouponCard(
              coupon: coupon,
              onApply: () {
                /// later: call validateCoupon API here
                Get.back(result: coupon);
              },
            );
          },
        );
      }),
    );
  }
}

class CouponCard extends StatelessWidget {
  final Coupon coupon;
  final VoidCallback? onApply;

  const CouponCard({
    super.key,
    required this.coupon,
    this.onApply,
  });

  String get discountLabel {
    if (coupon.discountType == "percentage") {
      return "${coupon.discountValue.toInt()}%\nOFF";
    }
    return "₹${coupon.discountValue.toInt()}\nOFF";
  }

  String get expiryLabel {
    if (coupon.expiryDate == null) return "--";
    final d = coupon.expiryDate!;
    const months = [
      "",
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];
    return "${d.day}\n${months[d.month]}";
  }

  String get discountText {
    if (coupon.discountType == "percentage") {
      return "${coupon.discountValue.toInt()}% off your order";
    }
    return "₹${coupon.discountValue.toInt()} off your order";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          /// LEFT DISCOUNT
          Container(
            width: 78.w,
            height: 90.h,
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.12),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(14.r),
                bottomLeft: Radius.circular(14.r),
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              discountLabel,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),

          /// CENTER DETAILS
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// TITLE
                Text(
                  coupon.couponCode, // or replace with title if backend adds it
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textBlack,
                  ),
                ),

                SizedBox(height: 4.h),

                /// DISCOUNT LINE
                Text(
                  discountText,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: AppColors.grey,
                  ),
                ),

                SizedBox(height: 2.h),

                /// MIN ORDER
                Text(
                  "Minimum order value ₹${coupon.minOrderValue.toInt()}",
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.grey,
                  ),
                ),

                SizedBox(height: 6.h),

                /// CODE
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Code: ",
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: AppColors.textBlack,
                        ),
                      ),
                      TextSpan(
                        text: coupon.couponCode.toLowerCase(),
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textBlack,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          /// RIGHT EXPIRY
          Container(
            width: 55.w,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Exp.",
                  style: TextStyle(fontSize: 10.sp, color: Colors.grey),
                ),
                SizedBox(height: 4.h),
                Text(
                  expiryLabel,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CouponShimmer extends StatelessWidget {
  const CouponShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 3, // number of shimmer cards
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(bottom: 12.h),
          height: 90.h,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Row(
              children: [
                /// LEFT DISCOUNT BLOCK
                Container(
                  width: 78.w,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(14.r),
                      bottomLeft: Radius.circular(14.r),
                    ),
                  ),
                ),

                SizedBox(width: 12.w),

                /// CENTER LINES
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _line(width: 120.w, height: 14.h),
                      SizedBox(height: 8.h),
                      _line(width: 160.w, height: 12.h),
                      SizedBox(height: 6.h),
                      _line(width: 140.w, height: 12.h),
                      SizedBox(height: 8.h),
                      _line(width: 90.w, height: 12.h),
                    ],
                  ),
                ),

                /// RIGHT EXPIRY
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _line(width: 30.w, height: 10.h),
                      SizedBox(height: 6.h),
                      _line(width: 28.w, height: 16.h),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _line({required double width, required double height}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(6.r),
      ),
    );
  }
}
