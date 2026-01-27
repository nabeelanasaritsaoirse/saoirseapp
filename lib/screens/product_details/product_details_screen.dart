// ignore_for_file: deprecated_member_use, curly_braces_in_flow_control_structures

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../models/product_details_model.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_loader.dart';
import '../../widgets/product_card.dart';
import '../../widgets/warning_dialog.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../widgets/app_text.dart';
import '../cart/cart_controller.dart';
import '../productListing/product_listing.dart';
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
    super.initState();
    controller = Get.find<ProductDetailsController>(tag: widget.productId);
    controller.checkIfInWishlist(widget.productId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      body: SafeArea(
        child: Obx(() {
          /// LOADING
          if (controller.isProductLoading.value) {
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
          SizedBox(
            height: 20.h,
          ),
          buildSimilarProductsSection(),
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

            /// PAGE INDICATOR (ALWAYS USE mergedImages)
            Positioned(
              bottom: 10.h,
              left: 0,
              right: 0,
              child: Obx(() {
                final index = controller.currentImageIndex.value;
                final images = controller.mergedImages;

                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(images.length, (i) {
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
                  }),
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
                      onTap: () => controller.toggleFavorite(product.id),
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
                              : AppColors.black,
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),

            /// SHARE BUTTON (BOTTOM RIGHT)
            Positioned(
              top: 70.h,
              right: 15.w,
              child: GestureDetector(
                onTap: () async {
                  await controller.productSharing(product.id);
                },
                child: Container(
                  width: 40.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.share,
                    size: 20.sp,
                    color: AppColors.black,
                  ),
                ),
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
          Obx(() => appButton(
                onTap: () {
                  if (cartController.isAddToCartLoading.value)
                    return; // ⛔ block tap

                  final selectedVariantId =
                      controller.selectedVariantId.value.isEmpty
                          ? null
                          : controller.selectedVariantId.value;

                  cartController.addProductToCart(
                    productId: controller.product.value!.id,
                    variantId: selectedVariantId,
                  );
                },
                width: 50.w,
                height: 35.h,
                padding: EdgeInsets.all(0),
                borderRadius: BorderRadius.circular(10.r),
                borderColor: AppColors.shadowColor,
                child: Center(
                  child: cartController.isAddToCartLoading.value
                      ? SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Icon(
                          Icons.shopping_cart_checkout,
                          color: AppColors.textBlack,
                        ),
                ),
              )),

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

                // COMPUTE FINAL SELECTED VALUES
                int selectedDays;
                double selectedAmount;

                if (controller.selectedPlanIndex.value != -1) {
                  final plan =
                      controller.plans[controller.selectedPlanIndex.value];
                  selectedDays = plan.days;
                  selectedAmount = plan.perDayAmount;
                } else {
                  selectedDays = controller.customDays.value;
                  selectedAmount = controller.customAmount.value;
                }

                // GO TO SELECT ADDRESS
                Get.to(
                  () => SelectAddress(
                    product: controller.product.value!,
                    selectVarientId: controller.selectedVariantId.value,
                    selectedDays: selectedDays,
                    selectedAmount: selectedAmount,
                    checkoutSource: CheckoutSource.product,
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
    return Obx(() {
      final images = controller.mergedImages;

      if (images.isEmpty) {
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

      return SizedBox(
        height: 280.h,
        child: Stack(
          children: [
            /// PAGEVIEW USING mergedImages
            PageView.builder(
              controller: controller.pageController,
              itemCount: images.length,
              onPageChanged: (i) => controller.currentImageIndex.value = i,
              itemBuilder: (_, i) {
                final img = images[i];
                return Container(
                  alignment: Alignment.center,
                  color: AppColors.lightGrey,
                  child: Padding(
                    padding: EdgeInsets.all(15.w),
                    child: Image.network(
                      img.url,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        }
                        return Center(
                          child: CupertinoActivityIndicator(
                            radius: 10.0,
                            color: AppColors.textGray,
                          ),
                        );
                      },
                      errorBuilder: (_, __, ___) {
                        return Container(
                          width: double.infinity,
                          height: double.infinity,
                          color: Colors.grey.shade200,
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.broken_image,
                            size: 32.sp,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),

            /// DOT INDICATOR USING mergedImages
            Positioned(
              bottom: 10.h,
              left: 0,
              right: 0,
              child: Obx(() {
                final index = controller.currentImageIndex.value;

                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(images.length, (i) {
                    return AnimatedContainer(
                      duration: Duration(milliseconds: 250),
                      width: index == i ? 18.w : 8.w,
                      height: 6.h,
                      margin: EdgeInsets.symmetric(horizontal: 2.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.r),
                        color:
                            index == i ? AppColors.black : AppColors.textBlack,
                      ),
                    );
                  }),
                );
              }),
            ),
          ],
        ),
      );
    });
  }

  Widget buildSimilarProductsSection() {
    return Obx(() {
      /// ---------------- LOADING STATE ----------------
      if (controller.isSimilarLoading.value) {
        return appLoader();
      }

      /// ---------------- EMPTY STATE ----------------
      if (controller.similarProducts.isEmpty) {
        return const SizedBox.shrink();
      }

      /// ---------------- DATA STATE ----------------
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TITLE ROW (same as Home)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                appText(
                  "Similar Products",
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                ),
                InkWell(
                  onTap: () {
                    final product = controller.product.value;
                    if (product == null) return;

                    Get.to(
                      () => const ProductListing(),
                      arguments: {
                        'categoryId': product.category.mainCategoryId,
                        'title': product.category.mainCategoryName,
                      },
                    );
                  },
                  child: appText(
                    AppStrings.see_all,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 8.h),

          /// HORIZONTAL LIST (KEY PART)
          SizedBox(
            height: 200.h, // 👈 must be fixed height
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              scrollDirection: Axis.horizontal,
              itemCount: controller.similarProducts.length,
              separatorBuilder: (_, __) => SizedBox(width: 2.w),
              itemBuilder: (context, index) {
                final product = controller.similarProducts[index];

                return SizedBox(
                  width: 160.w,
                  child: GestureDetector(
                    child: ProductCard(
                      margin: EdgeInsets.all(6),
                      productId: product.productId,
                      name: product.name,
                      brand: product.brand,
                      image: product.images.isNotEmpty
                          ? product.images.last.url
                          : "https://via.placeholder.com/200",
                      price: product.pricing.finalPrice.toStringAsFixed(0),
                      isFavorite: false,
                    ),
                  ),
                );
              },
            ),
          ),

          SizedBox(height: 14.h),
        ],
      );
    });
  }
}
