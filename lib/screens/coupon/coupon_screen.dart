// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../constants/app_colors.dart';
import '../../models/coupon_model.dart';
import '../../widgets/custom_appbar.dart';
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
      return "${coupon.discountValue.toInt()}%";
    }
    return "₹${coupon.discountValue.toInt()}";
  }

  String get expiryDay {
    if (coupon.expiryDate == null) return "--";
    return coupon.expiryDate!.day.toString();
  }

  String get expiryMonth {
    if (coupon.expiryDate == null) return "--";
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
    return months[coupon.expiryDate!.month];
  }

  String get discountText {
    if (coupon.discountType == "percentage") {
      return "${coupon.discountValue.toInt()}% off your order";
    }
    return "₹${coupon.discountValue.toInt()} off your order";
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Container(
        height: 120.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 24,
              offset: const Offset(0, 2),
              spreadRadius: 1,
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 24,
              offset: const Offset(0, 1),
              spreadRadius: 0,
            ),
          ],
        ),
        child: ClipPath(
          clipper: CouponClipper(),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Stack(
              children: [
                Row(
                  children: [
                    /// LEFT DISCOUNT BADGE
                    Container(
                      width: 120.w,
                      padding: EdgeInsets.all(16.w),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Center(
                          child: Text(
                            discountLabel,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 26.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),

                    /// CENTER DETAILS
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            coupon.couponCode,
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textBlack,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            discountText,
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: AppColors.textGray,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            "Minimum order value ₹${coupon.minOrderValue.toInt()}",
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColors.textGray,
                            ),
                          ),
                          SizedBox(height: 5.h),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Code: ",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textBlack,
                                  ),
                                ),
                                TextSpan(
                                  text: coupon.couponCode.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
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
                      width: 80.w,
                      padding: EdgeInsets.symmetric(vertical: 18.h),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Exp.",
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.textGray,
                            ),
                          ),
                          SizedBox(height: 9.h),
                          Text(
                            expiryDay,
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF2C3E50),
                            ),
                          ),
                          Text(
                            expiryMonth,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF2C3E50),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                /// DOTTED DIVIDER
                Positioned(
                  right: 80.w,
                  top: 0,
                  bottom: 0,
                  child: CustomPaint(
                    painter: DottedLinePainter(),
                    size: Size(1.w, double.infinity),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CouponClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    double radius = 12;
    double notchRadius = 10;
    double notchPosition = size.width - 90;

    // Start from top-left with radius
    path.moveTo(radius, 0);

    // Top edge to first notch
    path.lineTo(notchPosition - notchRadius, 0);

    // Top notch (curved cut)
    path.arcToPoint(
      Offset(notchPosition + notchRadius, 0),
      radius: Radius.circular(notchRadius),
      clockwise: false,
    );

    // Continue to top-right
    path.lineTo(size.width - radius, 0);
    path.arcToPoint(
      Offset(size.width, radius),
      radius: Radius.circular(radius),
    );

    // Right edge
    path.lineTo(size.width, size.height - radius);
    path.arcToPoint(
      Offset(size.width - radius, size.height),
      radius: Radius.circular(radius),
    );

    // Bottom edge to second notch
    path.lineTo(notchPosition + notchRadius, size.height);

    // Bottom notch (curved cut)
    path.arcToPoint(
      Offset(notchPosition - notchRadius, size.height),
      radius: Radius.circular(notchRadius),
      clockwise: false,
    );

    // Continue to bottom-left
    path.lineTo(radius, size.height);
    path.arcToPoint(
      Offset(0, size.height - radius),
      radius: Radius.circular(radius),
    );

    // Left edge with notches
    double leftNotch1 = size.height * 0.35;
    double leftNotch2 = size.height * 0.65;
    double leftNotchRadius = 10;

    path.lineTo(0, leftNotch2 + leftNotchRadius);

    // Left bottom notch
    path.arcToPoint(
      Offset(0, leftNotch2 - leftNotchRadius),
      radius: Radius.circular(leftNotchRadius),
      clockwise: false,
    );

    path.lineTo(0, leftNotch1 + leftNotchRadius);

    // Left top notch
    path.arcToPoint(
      Offset(0, leftNotch1 - leftNotchRadius),
      radius: Radius.circular(leftNotchRadius),
      clockwise: false,
    );

    path.lineTo(0, radius);
    path.arcToPoint(
      Offset(radius, 0),
      radius: Radius.circular(radius),
    );

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class DottedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey[300]!
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    const dashHeight = 4.0;
    const dashSpace = 4.0;
    double startY = 0;

    while (startY < size.height) {
      canvas.drawLine(
        Offset(0, startY),
        Offset(0, startY + dashHeight),
        paint,
      );
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
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
