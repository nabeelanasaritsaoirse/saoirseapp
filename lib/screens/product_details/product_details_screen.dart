// ignore_for_file: unused_local_variable, body_might_complete_normally_nullable, deprecated_member_use

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../models/product_details_model.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_loader.dart';
import '../../widgets/warning_dialog.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../widgets/app_text.dart';
import '../cart/cart_controller.dart';
import '../select_address/select_address.dart';
import 'product_details_controller.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String productId;
  final String? id;

  const ProductDetailsScreen({
    super.key,
    required this.productId,
    this.id,
  });

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late ProductDetailsController controller;
  final CartController cartController = Get.find<CartController>();

  @override
  void initState() {
    controller = Get.put(
      ProductDetailsController(
        productId: widget.productId,
        id: widget.id,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      body: SafeArea(
        child: Obx(() {
          /// LOADING
          if (controller.isLoading.value) {
            return Center(child: appLoader());
          }

          /// NO PRODUCT
          if (controller.product.value == null) {
            return Center(child: Text("Product not found"));
          }

          return buildBody(controller.product.value!);
        }),
      ),

      /// Bottom Bar Stays Same
      bottomNavigationBar: buildBottomBar(),
    );
  }

  // ----------------- MAIN BODY -----------------
  Widget buildBody(ProductDetailsData product) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// IMAGE SLIDER
          buildImageSection(product),

          /// PRODUCT DETAILS TEXT
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// BRAND + FREE SHIPPING
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    appText(
                      product.brand,
                      fontSize: 14.sp,
                      color: AppColors.textBlack,
                      fontWeight: FontWeight.w500,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.lightGreen,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: appText(
                        AppStrings.freeShiping,
                        fontSize: 10.sp,
                        color: AppColors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 4.h),

                /// PRODUCT NAME
                appText(
                  product.name,
                  fontSize: 24.sp,
                  textAlign: TextAlign.left,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textBlack,
                ),

                SizedBox(height: 8.h),

                /// PRICE
                Row(
                  children: [
                    appText(
                      "₹${product.pricing.finalPrice}",
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textBlack,
                    ),
                    SizedBox(width: 8.w),
                    if (product.pricing.finalPrice !=
                        product.pricing.regularPrice)
                      appText(
                        "₹${product.pricing.regularPrice}",
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.grey,
                        decoration: TextDecoration.lineThrough,
                      ),
                  ],
                ),

                SizedBox(height: 10),

                /// VARIANTS
                if (product.hasVariants) buildVariantOptions(product),
              ],
            ),
          ),

          /// DESCRIPTION
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                appText(
                  AppStrings.description,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textBlack,
                ),
                SizedBox(height: 8.h),
                appText(
                  product.description.long,
                  textAlign: TextAlign.left,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.grey,
                  height: 1.5.h,
                ),
              ],
            ),
          ),

          SizedBox(height: 50),
        ],
      ),
    );
  }

  // ----------------- IMAGE SECTION -----------------
  Widget buildImageSection(ProductDetailsData product) {
    return Column(
      children: [
        Stack(
          children: [
            buildCarousel(product),

            /// PAGE INDICATOR
            Positioned(
              bottom: 10.h,
              left: 0,
              right: 0,
              child: Obx(() {
                final index = controller.currentImageIndex.value;

                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: product.images.asMap().entries.map((entry) {
                    final i = entry.key;
                    return AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      width: index == i ? 18.w : 8.w,
                      height: 6.h,
                      margin: EdgeInsets.symmetric(horizontal: 2.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.r),
                        color:
                            index == i ? AppColors.black : AppColors.textBlack,
                      ),
                    );
                  }).toList(),
                );
              }),
            ),

            /// BACK + FAVORITE BUTTON
            Positioned(
              top: 20.h,
              left: 15.w,
              right: 15.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// BACK BUTTON
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      width: 40.w,
                      height: 40.h,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        size: 18.sp,
                        color: AppColors.black,
                      ),
                    ),
                  ),

                  /// FAVORITE BUTTON
                  Obx(() {
                    return GestureDetector(
                      onTap: controller.toggleFavorite,
                      child: Container(
                        width: 40.w,
                        height: 40.h,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                            controller.isFavorite.value
                                ? Icons.favorite
                                : Icons.favorite_border,
                            size: 22,
                            color: controller.isFavorite.value
                                ? AppColors.red
                                : AppColors.black),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ----------------- VARIANT OPTIONS -----------------
  Widget buildVariantOptions(ProductDetailsData product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        appText(
          AppStrings.ColorAvailable,
          fontWeight: FontWeight.w600,
          fontSize: 14.sp,
          color: AppColors.textBlack,
        ),
        SizedBox(height: 12.h),
        Obx(() {
          final selected = controller.selectedVariantId.value;

          return SizedBox(
            height: 45.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: product.variants.length,
              itemBuilder: (context, index) {
                final variant = product.variants[index];
                final isSelected = selected == variant.variantId;

                return GestureDetector(
                  onTap: () => controller.selectVariantById(variant.variantId),
                  child: Container(
                    margin: EdgeInsets.only(right: 10.w),
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primaryColor.withOpacity(0.15)
                          : AppColors.white,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primaryColor
                            : AppColors.lightGrey,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Center(
                      child: appText(
                        variant.attributes.color,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? AppColors.primaryColor
                            : AppColors.textBlack,
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }),
        SizedBox(height: 20.h),
      ],
    );
  }

  // ----------------- BOTTOM BAR -----------------
  Widget buildBottomBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15.r),
          topRight: Radius.circular(15.r),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 8.r,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          /// Add to Cart
          appButton(
            onTap: () {
              bool hasPlan = controller.selectedPlanIndex.value != -1 ||
                  (controller.customDays.value > 0 &&
                      controller.customAmount.value > 0);

              if (!hasPlan) {
                WarningDialog.show(
                  title: AppStrings.warning_label,
                  message: AppStrings.warning_body,
                );
                return;
              }

              cartController.addProductToCart(controller.product.value!.id);
            },
            width: 50.w,
            height: 35.h,
            padding: EdgeInsets.all(0),
            borderRadius: BorderRadius.circular(10.r),
            borderColor: AppColors.shadowColor,
            child: Center(
              child: Icon(
                Icons.shopping_cart_checkout,
                color: AppColors.textBlack,
              ),
            ),
          ),

          SizedBox(width: 8.w),

          /// Select Plan Button
          Expanded(
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: AppColors.white,
                side: BorderSide(color: AppColors.shadowColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                padding: EdgeInsets.symmetric(vertical: 10.h),
              ),
              onPressed: controller.openSelectPlanSheet,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(() => appText(
                        controller.selectedPlanButtonText,
                        color: AppColors.textBlack,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                      )),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: AppColors.textBlack,
                    size: 20.sp,
                  ),
                ],
              ),
            ),
          ),

          SizedBox(width: 5.w),

          /// Checkout Button
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.gradientDarkBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                padding: EdgeInsets.symmetric(vertical: 10.h),
              ),
              onPressed: () {
                bool hasPlan = controller.selectedPlanIndex.value != -1 ||
                    (controller.customDays.value > 0 &&
                        controller.customAmount.value > 0);

                if (!hasPlan) {
                  WarningDialog.show(
                    title: AppStrings.warning_label,
                    message: AppStrings.checkout_warning_body,
                  );
                  return;
                }

                Get.to(
                  SelectAddress(
                    product: controller.product.value!,
                    selectVarientId: controller.selectedVariantId.value,
                  ),
                );
              },
              child: Text(
                AppStrings.checkout,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ----------------- CAROUSEL -----------------
  Widget buildCarousel(ProductDetailsData product) {
    if (product.images.isEmpty) {
      return Container(
        color: AppColors.lightGrey,
        height: 280.h,
        alignment: Alignment.center,
        child: Icon(
          Icons.broken_image,
          size: 36.sp,
          color: AppColors.grey,
        ),
      );
    }

    return CarouselSlider(
      options: CarouselOptions(
        height: 280.h,
        viewportFraction: 1.0,
        enableInfiniteScroll: false,
        onPageChanged: (index, reason) {
          controller.currentImageIndex.value = index;
        },
      ),
      items: product.images.map((img) {
        return Container(
          alignment: Alignment.center,
          color: AppColors.lightGrey,
          child: Padding(
            padding: EdgeInsets.all(15.0.w),
            child: Image.network(
              img.url,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Icon(
                Icons.broken_image_outlined,
                size: 36.sp,
                color: Colors.grey,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
