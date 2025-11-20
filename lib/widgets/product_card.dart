import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../constants/app_colors.dart';
import '../models/product_model.dart';
import '../screens/product_details/product_details_screen.dart';
import 'app_text.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product, this.margin});

  final Product product;
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.to(ProductDetailsScreen()),
      child: Container(
        width: 150.w,
        margin: margin ?? EdgeInsets.only(right: 10.w),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowColor,
              blurRadius: 6.r,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section
            Stack(
              children: [
                Container(
                  height: 120.h,
                  margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
                  decoration: BoxDecoration(
                    color: AppColors.lightGrey,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: product.image.startsWith('http')
                        ? Image.network(
                            product.image,
                            width: 80.w,
                            height: 80.h,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.broken_image,
                                size: 40.sp,
                                color: AppColors.grey,
                              );
                            },
                          )
                        : Image.asset(
                            product.image,
                            width: 80.w,
                            height: 80.h,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                Positioned(
                  top: 8.h,
                  right: 8.w,
                  child: Container(
                    width: 28.w,
                    height: 28.h,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      product.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      size: 16.sp,
                      color:
                          product.isFavorite ? AppColors.red : AppColors.grey,
                    ),
                  ),
                ),
              ],
            ),

            // Text Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title Row (Fix overflow)
                  appText(
                    product.name,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textBlack,
                    textAlign: TextAlign.left,
                    maxLines: 2, 
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: 2.h),

                  // subtitle
                  appText(
                    product.brand,
                    fontFamily: 'inter',
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w400,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: 2.h),

                  // price
                  appText(
                    '₹ ${product.price.toStringAsFixed(0)}',
                    fontFamily: 'inter',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}










