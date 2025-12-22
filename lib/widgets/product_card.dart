import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../constants/app_colors.dart';
import '../screens/product_details/product_details_screen.dart';
import 'app_text.dart';

class ProductCard extends StatefulWidget {
  const ProductCard({
    super.key,
    required this.productId,
    required this.name,
    required this.brand,
    required this.image,
    required this.price,
    required this.isFavorite,
    this.id,
    this.showFavorite = false,
    this.onFavoriteTap,
    this.margin,
  });

  final String productId;
  final String? id;
  final String name;
  final String brand;
  final String image;
  final String price;
  final bool showFavorite;
  final bool isFavorite;
  final VoidCallback? onFavoriteTap;
  final EdgeInsets? margin;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _isImageLoading = true;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.to(
        () => ProductDetailsScreen(productId: widget.productId, id: widget.id),
      ),
      child: Container(
        width: 150.w,
        height: 230.h, // 🔥 FIXED, RESPONSIVE SAFE HEIGHT
        margin: widget.margin ?? EdgeInsets.only(right: 10.w),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowColor,
              blurRadius: 6.r,
              offset: const Offset(0, 2),
            ),
          ],
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ---------------- IMAGE AREA ----------------

            SizedBox(
              height: 110.h,
              child: Stack(
                children: [
                  Container(
                    margin: EdgeInsets.all(6.w),
                    decoration: BoxDecoration(
                      color: AppColors.lightGrey,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.r),
                      child: widget.image.startsWith('http')
                          ? Image.network(
                              widget.image,
                              fit: BoxFit.contain,
                              width: double.infinity,
                              height: double.infinity,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;

                                return Center(
                                  child: CupertinoActivityIndicator(
                                    radius: 10.0,
                                    color: AppColors.textGray,
                                  ),
                                );
                              },
                              errorBuilder: (_, __, ___) => Center(
                                child: Icon(
                                  Icons.broken_image,
                                  size: 40.sp,
                                  color: AppColors.grey,
                                ),
                              ),
                            )
                          : Image.asset(
                              widget.image,
                              fit: BoxFit.contain,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                    ),
                  ),
                  if (widget.showFavorite)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: widget.onFavoriteTap,
                        child: Container(
                          width: 26.w,
                          height: 26.w,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            widget.isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            size: 14.sp,
                            color: widget.isFavorite ? Colors.red : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            /// ---------------- TEXT AREA ----------------
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 4.h),
                  appText(
                    widget.name,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    textAlign: TextAlign.left,
                    height: 1.2,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2.h),
                  appText(
                    widget.brand,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    fontSize: 10.sp,
                    color: AppColors.grey,
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: 4.h),
                  appText(
                    "₹ ${widget.price}",
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textBlack,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
