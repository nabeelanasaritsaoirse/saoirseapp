import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../constants/app_colors.dart';
import '../screens/product_details/product_details_screen.dart';
import 'app_text.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.productId,
    required this.name,
    required this.brand,
    required this.image,
    required this.price,
    required this.isFavorite,
    this.id,
    this.onFavoriteTap,
    this.margin,
  });

  final String productId;
  final String? id;
  final String name;
  final String brand;
  final String image;
  final String price;
  final bool isFavorite;
  final VoidCallback? onFavoriteTap;
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () =>
          Get.to(() => ProductDetailsScreen(productId: productId, id: id)),
      child: Container(
        width: 160.w,
        margin: margin ?? EdgeInsets.only(right: 10.w),
        decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowColor,
                blurRadius: 6.r,
                offset: const Offset(0, 2),
              ),
            ]),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ------------------ PRODUCT IMAGE + HEART ------------------
                Stack(
                  children: [
                    // Product Image
                    Container(
                      height: 120.h,
                      margin:
                          EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
                      decoration: BoxDecoration(
                        color: AppColors.lightGrey,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Center(
                        child: image.startsWith('http')
                            ? Image.network(
                                image,
                                width: 80.w,
                                height: 80.h,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Icon(
                                  Icons.broken_image,
                                  size: 40.sp,
                                  color: AppColors.grey,
                                ),
                              )
                            : Image.asset(
                                image,
                                width: 80.w,
                                height: 80.h,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),

                    // ------------------ HEART ICON BUTTON ------------------
                    Positioned(
                      top: 8.h,
                      right: 8.w,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: onFavoriteTap,
                        child: Container(
                          width: 28.w,
                          height: 28.h,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            size: 16.sp,
                            color: isFavorite ? AppColors.red : AppColors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // ------------------ TEXT INFO ------------------
                Expanded(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        appText(
                          name,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textBlack,
                          textAlign: TextAlign.left,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 2.h),
                        appText(
                          brand,
                          fontSize: 10.sp,
                          color: AppColors.grey,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 2.h),
                        appText(
                          "₹ $price",
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
