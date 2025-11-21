// ignore_for_file: unused_local_variable, body_might_complete_normally_nullable

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:saoirse_app/widgets/app_loader.dart';

import '../../widgets/warning_dialog.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../widgets/app_text.dart';
import '../select_Address/select_address.dart';
import 'product_details_controller.dart';

class ProductDetailsScreen extends StatelessWidget {
  final String? productId;
  final String? id;

  const ProductDetailsScreen({super.key, this.productId, this.id});

  @override
  Widget build(BuildContext context) {
    final ProductDetailsController controller =
        Get.put(ProductDetailsController(productId!, id!));

    return Obx(() {
      /// -------------------------
      /// 1. LOADING STATE
      /// -------------------------
      if (controller.isLoading.value) {
        return Scaffold(
          backgroundColor: AppColors.scaffoldColor,
          body: Center(child: appLoader()),
        );
      }

      /// -------------------------
      /// 2. PRODUCT NOT FOUND
      /// -------------------------
      if (controller.product.value == null) {
        return Scaffold(
          backgroundColor: AppColors.scaffoldColor,
          body: Center(child: Text("Product not found")),
        );
      }

      /// -------------------------
      /// 3. SAFE PRODUCT ACCESS
      /// -------------------------
      final product = controller.product.value!;

      return Scaffold(
        backgroundColor: AppColors.scaffoldColor,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Carousel with Overlay Buttons
                Column(
                  children: [
                    Stack(
                      children: [
                        CarouselSlider(
                          options: CarouselOptions(
                            height: 280.h,
                            viewportFraction: 1.0,
                            enableInfiniteScroll: false,
                            onPageChanged: (index, reason) {
                              controller.updateImageIndex(index);
                            },
                          ),
                          items: product.images.map((img) {
                            return Container(
                              color: AppColors.lightGrey,
                              alignment: Alignment.center,
                              child: Padding(
                                padding: EdgeInsets.all(15.0.w),
                                child: Image.network(
                                  img.url,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Icon(
                                    Icons.broken_image,
                                    size: 40,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),

                        /// Indicator Dots
                        Positioned(
                          bottom: 10.h,
                          left: 0.w,
                          right: 0.w,
                          child: Obx(() {
                            final images = product.images;
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: images.asMap().entries.map((entry) {
                                final index = entry.key;
                                return AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  width: controller.currentImageIndex.value ==
                                          index
                                      ? 18.w
                                      : 8.w,
                                  height: 6.h,
                                  margin: EdgeInsets.symmetric(horizontal: 2.w),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4.r),
                                    color: controller.currentImageIndex.value ==
                                            index
                                        ? AppColors.black
                                        : AppColors.textBlack,
                                  ),
                                );
                              }).toList(),
                            );
                          }),
                        ),

                        /// Back Button + Favorite Button
                        Positioned(
                          top: 20.h,
                          left: 15.w,
                          right: 15.w,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
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
                              Obx(
                                () => GestureDetector(
                                  onTap: controller.toggleFavorite,
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      controller.isFavorite.value
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      size: 22,
                                      color: controller.isFavorite.value
                                          ? Colors.red
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    /// PRODUCT DETAILS BELOW SLIDER
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Brand
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              appText(
                                product.brand,
                                fontSize: 14.sp,
                                color: AppColors.black,
                                fontWeight: FontWeight.w500,
                              ),
                              Row(
                                children: [
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
                                  SizedBox(width: 4.w),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 5.w,
                                      vertical: 2.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.mediumAmber,
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.star,
                                            size: 8.sp,
                                            color: AppColors.darkAmber),
                                        appText("4.3", fontSize: 8.sp),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          SizedBox(height: 4.h),

                          // Product Name
                          appText(
                            product.name,
                            fontSize: 24,
                            textAlign: TextAlign.left,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textBlack,
                          ),
                          SizedBox(height: 8.h),

                          // Price
                          Row(
                            children: [
                              appText(
                                "₹${product.pricing.currency} ${product.pricing.finalPrice}",
                                fontSize: 22.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textBlack,
                              ),
                              SizedBox(width: 8.w),
                              appText(
                                "₹${product.pricing.currency} ${product.pricing.regularPrice}",
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.grey,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ],
                          ),
                          SizedBox(height: 10),

                          appText(
                            AppStrings.ColorAvailable,
                            fontWeight: FontWeight.w600,
                            fontSize: 14.sp,
                            color: AppColors.textBlack,
                          ),
                          SizedBox(height: 12.h),

                          // Thumbnails
                          SizedBox(
                            height: 64.h,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: product.images.length,
                              itemBuilder: (context, index) {
                                final img = product.images[index];
                                return Container(
                                  margin: EdgeInsets.only(right: 10.w),
                                  width: 60.w,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.r),
                                    border:
                                        Border.all(color: Colors.grey.shade300),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(7.r),
                                    child: Image.network(
                                      img.url,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),

                          SizedBox(height: 20),
                        ],
                      ),
                    )
                  ],
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
                        fontWeight: FontWeight.w400,
                        color: AppColors.grey,
                        height: 1.5.h,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 50),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.r),
                topRight: Radius.circular(15.r)),
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
              /// 🔹 Select Plan Button
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
                  onPressed: () => controller.openSelectPlanSheet(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppStrings.selectPlan,
                        style: TextStyle(
                          color: AppColors.textBlack,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Icon(
                        Icons.keyboard_arrow_down,
                        color: AppColors.textBlack,
                        size: 20.sp,
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(width: 10.w),

              /// 🔹 Check Out Button
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
                    if (controller.selectedPlanIndex.value == -1) {
                      WarningDialog.show(
                        title: "Please Select Your Plan",
                        message:
                            "You haven’t selected a plan yet. Please choose a plan before proceeding to Add to Cart.",
                      );
                      return;
                    }

                    Get.to(SelectAddress());
                  },
                  child: Text(
                    AppStrings.addToCart,
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
        ),
      );
    });
  }
}
