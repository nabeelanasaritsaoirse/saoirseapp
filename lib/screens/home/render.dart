import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../constants/app_assets.dart';
import '../../constants/app_colors.dart';
import '../../models/product_model.dart';
import '../../widgets/app_text.dart';
import '../../widgets/product_card.dart';
import '../productListing/product_listing.dart';
import '../product_details/product_details_binding.dart';
import '../product_details/product_details_screen.dart';

class FeatureListRenderer extends StatelessWidget {
  final FeaturedList feature;

  const FeatureListRenderer({super.key, required this.feature});

  @override
  Widget build(BuildContext context) {
    switch (feature.design) {
      case 1:
        return Design1BigList(list: feature);

      case 2:
        return Design2CompactList(list: feature);

      case 3:
        return Design3Widget(feature: feature);

      case 4:
        return Column(
          children: [
            Design4Widget(feature: feature),
            SizedBox(height: 10.h),
            const StaticPromoBanner(),
          ],
        );

      case 5:
        return Design5Widget(feature: feature);

      default:
        return const SizedBox.shrink();
    }
  }
}

class StaticPromoBanner extends StatelessWidget {
  const StaticPromoBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
      ),
      child: Container(
        width: double.infinity,
        height: 100.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          image: DecorationImage(
            image: AssetImage(AppAssets.banner_refer),
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}

class Design1BigList extends StatelessWidget {
  final FeaturedList list;

  const Design1BigList({super.key, required this.list});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 205.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
        itemCount: list.products.length,
        itemBuilder: (context, index) {
          final product = list.products[index];

          return ProductCard(
            productId: product.productId,
            id: product.productMongoId,
            name: product.name,
            image: product.image,
            brand: product.brand ?? "",
            price: product.finalPrice.toStringAsFixed(0),
            isFavorite: product.isFavorite,
            showFavorite: false,
            margin: EdgeInsets.only(right: 12.w),
          );
        },
      ),
    );
  }
}

class Design2CompactList extends StatelessWidget {
  final FeaturedList list;

  const Design2CompactList({super.key, required this.list});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 85.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: list.products.length,
        itemBuilder: (context, index) {
          final product = list.products[index];

          return Padding(
            padding: EdgeInsets.all(8.0.w),
            child: InkWell(
              onTap: () => Get.to(
                () => ProductDetailsScreen(
                  productId: product.productId,
                  id: product.productMongoId,
                ),
                binding: ProductDetailsBinding(
                  productId: product.productId,
                  id: product.productMongoId,
                ),
              ),
              child: Container(
                width: 220.w,
                padding: EdgeInsets.all(6.sp),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12.sp),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadowColor,
                      blurRadius: 6.r,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: Image.network(
                        product.image,
                        width: 70.w,
                        height: 70.w,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.broken_image, color: Colors.grey),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          appText(product.name,
                              fontSize: 13.sp,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.w600,
                              textAlign: TextAlign.left),
                          SizedBox(height: 4.h),
                          appText(
                            "₹ ${product.finalPrice.toStringAsFixed(0)}",
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w800,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class Design3Widget extends StatelessWidget {
  final FeaturedList feature;

  const Design3Widget({
    super.key,
    required this.feature,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 210.h,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        scrollDirection: Axis.horizontal,
        itemCount: feature.products.length,
        separatorBuilder: (_, __) => SizedBox(width: 14.w),
        itemBuilder: (context, index) {
          final product = feature.products[index];

          return InkWell(
            onTap: () => Get.to(
              () => ProductDetailsScreen(
                productId: product.productId,
                id: product.productMongoId,
              ),
              binding: ProductDetailsBinding(
                productId: product.productId,
                id: product.productMongoId,
              ),
            ),
            child: SizedBox(
              width: 140.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// IMAGE
                  Container(
                    width: 140.w,
                    height: 170.h,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(20.r),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors
                              .shadowColor, // same shadow you use elsewhere
                          blurRadius: 8.r,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.r),
                      child: Image.network(
                        product.image,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.broken_image,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 5.h),

                  /// BRAND / PRODUCT NAME
                  SizedBox(
                    width: double.infinity,
                    child: appText(
                      product.brand ?? product.name,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),

                  /// PRICE
                  SizedBox(
                    width: double.infinity,
                    child: appText(
                      "₹ ${product.finalPrice.toStringAsFixed(0)}",
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.black,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class Design4Widget extends StatelessWidget {
  final FeaturedList feature;

  const Design4Widget({super.key, required this.feature});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 360.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: (feature.products.length / 2).ceil(),
        itemBuilder: (context, index) {
          final first = index * 2;
          final second = first + 1;

          return Padding(
            padding: EdgeInsets.only(right: 12.w),
            child: Column(
              children: [
                _productCard(feature.products[first]),
                SizedBox(height: 12.h),
                if (second < feature.products.length)
                  _productCard(feature.products[second]),
              ],
            ),
          );
        },
      ),
    );
  }
}

Widget _productCard(FeaturedProduct p) {
  return SizedBox(
    width: 150.w,
    height: 170.h,
    child: InkWell(
      onTap: () => Get.to(
        () => ProductDetailsScreen(
          productId: p.productId,
          id: p.productMongoId,
        ),
        binding: ProductDetailsBinding(
          productId: p.productId,
          id: p.productMongoId,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// IMAGE
          Container(
            height: 130.h,
            width: 150.w,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadowColor,
                  blurRadius: 8.r,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.r),
              child: Image.network(
                p.image,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.broken_image, color: Colors.grey),
              ),
            ),
          ),

          SizedBox(height: 6.h),

          /// NAME
          appText(
            p.brand ?? p.name,
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          SizedBox(height: 2.h),

          /// PRICE
          Row(
            children: [
              if (p.price > p.finalPrice)
                appText(
                  "₹${p.price.toStringAsFixed(0)}",
                  fontSize: 11.sp,
                  color: AppColors.grey,
                  decoration: TextDecoration.lineThrough,
                ),
              SizedBox(width: 6.w),
              appText(
                "₹${p.finalPrice.toStringAsFixed(0)}",
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

class Design5Widget extends StatelessWidget {
  final FeaturedList feature;

  const Design5Widget({super.key, required this.feature});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: const Color(0xFFB9B3FF), // violet background
        borderRadius: BorderRadius.circular(22.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔹 HEADER (INSIDE VIOLET)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              appText(
                feature.listName, // Best quality
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.black,
              ),
              InkWell(
                onTap: () {
                  Get.to(
                    () => const ProductListing(),
                    arguments: {
                      'slug': feature.slug,
                      'listId': feature.listId,
                      'title': feature.listName,
                    },
                  );
                },
                child: appText(
                  "View all",
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ),
            ],
          ),

          SizedBox(height: 12.h),

          /// ⬜ WHITE CONTAINER (ONLY PRODUCTS)
          /// ⬜ WHITE CONTAINER (ONLY PRODUCTS)
          SizedBox(
            height: 350.h,
            child: Container(
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: GridView.builder(
                scrollDirection: Axis.horizontal, // ✅ horizontal scroll
                itemCount: feature.products.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 rows
                  mainAxisSpacing: 10.h, // vertical spacing
                  crossAxisSpacing: 10.w, // horizontal spacing
                  mainAxisExtent: 130.w, // ✅ FIXED CARD WIDTH
                ),

                itemBuilder: (_, index) {
                  final p = feature.products[index];
                  return _design5ProductCard(p);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _design5ProductCard(FeaturedProduct p) {
  return InkWell(
    onTap: () => Get.to(
      () => ProductDetailsScreen(
        productId: p.productId,
        id: p.productMongoId,
      ),
      binding: ProductDetailsBinding(
        productId: p.productId,
        id: p.productMongoId,
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// IMAGE
        SizedBox(
          height: 120.h,
          width: 130.w,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadowColor,
                  blurRadius: 6.r,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: Image.network(
                p.image,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.broken_image, color: Colors.grey),
              ),
            ),
          ),
        ),

        SizedBox(height: 8.h),

        /// PRODUCT NAME
        appText(
          p.brand ?? p.name,
          fontSize: 13.sp,
          fontWeight: FontWeight.w600,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    ),
  );
}
