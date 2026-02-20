// ignore_for_file: deprecated_member_use, curly_braces_in_flow_control_structures

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../constants/app_constant.dart';
import '../../main.dart';
import '../../models/product_details_model.dart';
import '../../models/review_resposne.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_loader.dart';
import '../../widgets/build_expandable_header.dart';
import '../../widgets/product_card.dart';
import '../../widgets/warning_dialog.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../widgets/app_text.dart';
import '../all_review/all_review_screen.dart';
import '../cart/cart_controller.dart';
import '../productListing/product_listing.dart';
import '../product_faq/product_faq_screen.dart';
import '../login/login_page.dart';
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

  bool get isLoggedIn {
    return storage.read(AppConst.USER_ID) != null;
  }

  void requireLogin(VoidCallback onAuthenticated) {
    if (!isLoggedIn) {
      Get.to(() => LoginPage());
      return;
    }
    onAuthenticated();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      body: SafeArea(
        child: Obx(() {
          final product = controller.product.value;

          if (controller.isProductLoading.value && product == null) {
            return Center(child: appLoader());
          }

          if (product == null) {
            return Center(child: Text("Product not found"));
          }

          return Column(
            children: [
              Expanded(
                child: buildBody(product),
              ),
              buildBottomBar(),
            ],
          );
        }),
      ),
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
          buildFaqAndReviewSection(),
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
                  requireLogin(() {
                    if (cartController.isAddToCartLoading.value) return;

                    final selectedVariantId =
                        controller.selectedVariantId.value.isEmpty
                            ? null
                            : controller.selectedVariantId.value;

                    cartController.addProductToCart(
                      productId: controller.product.value!.id,
                      variantId: selectedVariantId,
                    );
                  });
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
                requireLogin(() {
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

                  Get.to(
                    () => SelectAddress(
                      product: controller.product.value!,
                      selectVarientId: controller.selectedVariantId.value,
                      selectedDays: selectedDays,
                      selectedAmount: selectedAmount,
                      checkoutSource: CheckoutSource.product,
                    ),
                  );
                });
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

  Widget buildFaqAndReviewSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      child: Column(
        children: [
          // FAQ BUTTON
          Obx(() => ExpandableSectionHeader(
                title: "FAQ",
                isExpanded: controller.isFaqExpanded.value,
                onTap: () => controller.isFaqExpanded.toggle(),
              )),

          Obx(() {
            return AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: controller.isFaqExpanded.value
                  ? _buildFaqContent()
                  : const SizedBox.shrink(),
            );
          }),

          SizedBox(height: 1.h),

          // REVIEW BUTTON
          Obx(() => ExpandableSectionHeader(
                title: "Reviews",
                isExpanded: controller.isReviewExpanded.value,
                onTap: () => controller.isReviewExpanded.toggle(),
              )),

          Obx(() {
            return AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: controller.isReviewExpanded.value
                  ? buildReviewSection()
                  : const SizedBox.shrink(),
            );
          }),

          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget _buildFaqContent() {
    if (controller.isFaqLoading.value) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 20.h),
        child: Center(
          child: SizedBox(
            width: 22,
            height: 22,
            child: CupertinoActivityIndicator(color: AppColors.grey),
          ),
        ),
      );
    }

    if (controller.faqs.isEmpty) {
      return Container(
        margin: EdgeInsets.only(top: 10.h),
        padding: EdgeInsets.symmetric(vertical: 20.h),
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.lightGrey,
          borderRadius: BorderRadius.circular(10.r),
        ),
        alignment: Alignment.center,
        child: appText(
          "No FAQs available",
          fontSize: 13.sp,
          fontWeight: FontWeight.w500,
          color: AppColors.grey,
        ),
      );
    }

    return Column(
      children: [
        ...List.generate(
          controller.faqs.length,
          (index) {
            final faq = controller.faqs[index];
            final isOpen = controller.expandedFaqIndex.value == index;

            return Container(
              margin: EdgeInsets.only(top: 10.h),
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                color: AppColors.lightGrey,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 1.h),
                        child: appText(
                          (index + 1).toString().padLeft(2, '0'),
                          fontWeight: FontWeight.w600,
                          fontSize: 12.sp,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: appText(
                          faq.question,
                          fontWeight: FontWeight.w500,
                          textAlign: TextAlign.left,
                          maxLines: isOpen ? null : 2,
                          overflow: isOpen
                              ? TextOverflow.visible
                              : TextOverflow.ellipsis,
                          fontSize: 13.sp,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          controller.expandedFaqIndex.value =
                              isOpen ? -1 : index;
                        },
                        child: Icon(
                          isOpen ? Icons.remove : Icons.add,
                          size: 20.sp,
                        ),
                      ),
                    ],
                  ),
                  AnimatedSize(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    child: isOpen
                        ? Padding(
                            padding: EdgeInsets.only(left: 22.w, top: 8.h),
                            child: appText(
                              faq.answer,
                              textAlign: TextAlign.left,
                              fontSize: 12.sp,
                              color: AppColors.textBlack,
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            );
          },
        ),
        SizedBox(height: 12.h),
        InkWell(
          onTap: () {
            Get.to(() => ProductFaqScreen(
                  productId: widget.productId,
                ));
          },
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 12.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: AppColors.black87),
            ),
            alignment: Alignment.center,
            child: appText(
              "Show all FAQ",
              fontWeight: FontWeight.w600,
              fontSize: 13.sp,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildReviewSection() {
    if (controller.isReviewLoading.value) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 20.h),
        child: Center(
          child: CupertinoActivityIndicator(
            radius: 12,
          ),
        ),
      );
    }
    return Container(
      margin: EdgeInsets.only(top: 10.h),
      padding: EdgeInsets.symmetric(vertical: 14.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// RATING ROW
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Obx(() => appText(
                    controller.averageRating.value.toStringAsFixed(1),
                    fontSize: 30.sp,
                    fontWeight: FontWeight.bold,
                  )),
              SizedBox(width: 6.w),
              appText(
                "OUT OF 5",
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.grey,
              ),
              Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  buildStarRow(controller.averageRating.value),
                  SizedBox(height: 4.h),
                  Obx(() => appText(
                        "${controller.totalRatings.value} ratings",
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.grey,
                      )),
                  SizedBox(height: 4.h),
                ],
              )
            ],
          ),

          SizedBox(height: 10.h),

          /// REVIEW ACTION ROW
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              appText(
                "${controller.totalReviews.value} Reviews",
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.lightBlue,
              ),
            ],
          ),

          SizedBox(height: 10.h),

          /// REVIEW IMAGES PREVIEW (SAFE)
          Obx(() {
            if (controller.reviewImagesPreview.isEmpty) {
              return const SizedBox.shrink();
            }

            return Row(
              children: controller.reviewImagesPreview.map((img) {
                // 🔐 Safety: empty or null URL check
                if (img.url.isEmpty) {
                  return const SizedBox.shrink();
                }

                return Padding(
                  padding: EdgeInsets.only(right: 6.w),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: Image.network(
                      img.url,
                      height: 65.h,
                      width: 80.w,
                      fit: BoxFit.cover,

                      /// 🔥 FIX: prevent red image error
                      errorBuilder: (_, __, ___) {
                        return Container(
                          height: 65.h,
                          width: 80.w,
                          color: AppColors.lightGrey,
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.image_not_supported,
                            size: 18.sp,
                            color: AppColors.grey,
                          ),
                        );
                      },
                    ),
                  ),
                );
              }).toList(),
            );
          }),

          SizedBox(height: 12.h),

          /// REVIEW CARDS
          Obx(() {
            if (controller.reviews.isEmpty) {
              return appText(
                "No reviews yet",
                color: AppColors.grey,
              );
            }

            return SizedBox(
              height: 90.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: controller.reviews.length.clamp(0, 3),
                separatorBuilder: (_, __) => SizedBox(width: 10.w),
                itemBuilder: (_, index) {
                  final review = controller.reviews[index];
                  return buildReviewCard(review);
                },
              ),
            );
          }),

          SizedBox(height: 14.h),

          /// SHOW ALL REVIEWS
          InkWell(
            onTap: () {
              Get.to(() => AllReviewsScreen(
                    productId: widget.productId,
                  ));
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 12.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: AppColors.black87),
              ),
              alignment: Alignment.center,
              child: appText(
                "Show all reviews",
                fontWeight: FontWeight.w600,
                fontSize: 13.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildStarRow(double rating) {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < rating.round() ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: 16.sp,
        );
      }),
    );
  }

  Widget buildReviewCard(Review review) {
    return Container(
      width: 230.w,
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(5.w),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(5.r),
                ),
                child: Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 11.sp),
                    SizedBox(width: 3.w),
                    appText(
                      review.rating.toStringAsFixed(1),
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 5.w),
              Expanded(
                child: appText(
                  review.title,
                  fontWeight: FontWeight.w600,
                  fontSize: 12.sp,
                  maxLines: 2,
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          appText(
            review.comment,
            fontSize: 11.sp,
            textAlign: TextAlign.left,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
