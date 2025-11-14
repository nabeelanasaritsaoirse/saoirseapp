import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../widgets/warning_dialog.dart';
import '../../constants/app_assets.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../widgets/app_text.dart';
import 'product_details_controller.dart';


class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final ProductDetailsController controller = Get.put(
      ProductDetailsController(),
    );

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
                        items: controller.product.images.map((image) {
                          return Container(
                            color: AppColors.lightGrey,
                            alignment: Alignment.center,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxHeight: 250.h,
                                minHeight: 150.h,
                                maxWidth: double.infinity,
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(15.0.w),
                                child: Image.asset(
                                  image,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      Positioned(
                        bottom: 10.h,
                        left: 0.w,
                        right: 0.w,
                        child: Obx(
                          () => Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: controller.product.images
                                .asMap()
                                .entries
                                .map((entry) {
                              final index = entry.key;
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                                width:
                                    controller.currentImageIndex.value == index
                                        ? 18.w
                                        : 8.w,
                                height: 6.h,
                                margin: EdgeInsets.symmetric(
                                  horizontal: 2.w,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4.r),
                                  color: controller.currentImageIndex.value ==
                                          index
                                      ? AppColors.black
                                      : AppColors.textBlack,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),

                      // Overlay Buttons
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

                      Positioned(
                        top: 60.h,
                        right: 15.w,
                        child: GestureDetector(
                          onTap: () {},
                          child: Container(
                            width: 33.w,
                            height: 33.h,
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.shadowColor,
                                  blurRadius: 4.r,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Image.asset(AppAssets.share, width: 26.w),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Brand
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            appText(
                              controller.product.brand,
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Icon(
                                        Icons.star,
                                        size: 8.sp,
                                        color: AppColors.darkAmber,
                                      ),
                                      appText("4.3", fontSize: 8.sp),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        SizedBox(height: 4.h),

                        // Product Name and Shipping Badge
                        Row(
                          children: [
                            Expanded(
                              child: appText(
                                controller.product.name,
                                fontSize: 24,
                                textAlign: TextAlign.left,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textBlack,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),

                        // Price
                        Row(
                          children: [
                            appText(
                              "₹${controller.product.price.toStringAsFixed(0)}",
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textBlack,
                            ),
                            SizedBox(width: 8.h),
                            appText(
                              "₹${controller.product.price.toStringAsFixed(0)}",
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textBlack,
                              decoration: TextDecoration.lineThrough,
                            ),
                            SizedBox(width: 8.h),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.lightRed,
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: appText(
                                controller.product.discount,
                                fontSize: 8.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.white,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5.h),

                        appText(
                          AppStrings.ColorAvailable,
                          fontWeight: FontWeight.w600,
                          fontSize: 14.sp,
                          color: AppColors.textBlack,
                        ),
                        SizedBox(height: 12.h),

                        // Color Options
                        SizedBox(
                          height: 64.h,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: controller.product.colors.length,
                            itemBuilder: (context, index) {
                              return Obx(() {
                                final isSelected =
                                    controller.selectedColorIndex.value ==
                                        index;
                                return GestureDetector(
                                  onTap: () => controller.selectColor(index),
                                  child: Container(
                                    margin: EdgeInsets.only(right: 10.w),
                                    width: 60.w,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: isSelected
                                            ? Colors.black
                                            : Colors.grey.shade300,
                                        width: isSelected ? 2.w : 1.w,
                                      ),
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(7.r),
                                      child: Image.asset(
                                        controller.product.colors[index].image,
                                        width: 80.w,
                                        height: 80.w,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                );
                              });
                            },
                          ),
                        ),

                        SizedBox(height: 10.h),

                        // Storage
                        appText(
                          "Storage",
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        SizedBox(height: 12.h),

                        // Storage Options
                        Obx(
                          () => Row(
                            children: List.generate(
                              controller.product.storageOptions.length,
                              (index) {
                                final isSelected =
                                    controller.selectedStorageIndex.value ==
                                        index;
                                return GestureDetector(
                                  onTap: () => controller.selectStorage(index),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 250),
                                    curve: Curves.easeInOut,
                                    margin: EdgeInsets.only(right: 10.w),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: isSelected ? 20.w : 18.w,
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? AppColors.black
                                          : AppColors.lightGrey,
                                      border: Border.all(
                                        color: isSelected
                                            ? AppColors.black
                                            : AppColors.lightGrey,
                                      ),
                                      borderRadius: BorderRadius.circular(14.r),
                                      boxShadow: isSelected
                                          ? [
                                              BoxShadow(
                                                color: AppColors.shadowColor,
                                                blurRadius: 6.r,
                                                offset: const Offset(0, 3),
                                              ),
                                            ]
                                          : [],
                                    ),
                                    child: appText(
                                      controller.product.storageOptions[index],
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w600,
                                      color: isSelected
                                          ? AppColors.white
                                          : AppColors.textBlack,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),

                        SizedBox(height: 10.h),
                      ],
                    ),
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10.h),
                    appText(
                      AppStrings.description,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textBlack,
                    ),
                    SizedBox(height: 8.h),
                    appText(
                      controller.product.description,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      textAlign: TextAlign.start,
                      color: AppColors.grey,
                      height: 1.5.h,
                    ),
                    SizedBox(height: 10.h),
                  ],
                ),
              ),

              Column(
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            appText(
                              AppStrings.poular,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.06,
                            ),
                            appText(
                              AppStrings.see_all,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.06,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 12.h),
                      SizedBox(
                        height: 195.h,
                        child: Obx(
                          () => ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 5.h,
                            ),
                            itemCount: controller.mostPopularProducts.length,
                            itemBuilder: (context, index) {
                              final product =
                                  controller.mostPopularProducts[index];
                              return Container(
                                width: 150.w,
                                margin: EdgeInsets.only(right: 15.w),
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
                                    Stack(
                                      children: [
                                        Container(
                                          height: 120.h,
                                          margin: EdgeInsets.symmetric(
                                            horizontal: 5.w,
                                            vertical: 5.h,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColors.lightGrey,
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: Center(
                                            child: Image.asset(
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
                                              color: product.isFavorite
                                                  ? AppColors.red
                                                  : AppColors.grey,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 10.w,
                                        vertical: 2.h,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              appText(
                                                product.name,
                                                fontSize: 13.sp,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.textBlack,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Spacer(),
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 5.w,
                                                  vertical: 2.h,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: AppColors.lightAmber,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    10.r,
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Icon(
                                                      Icons.star,
                                                      size: 8.sp,
                                                      color:
                                                          AppColors.darkAmber,
                                                    ),
                                                    appText(
                                                      "4.3",
                                                      fontSize: 8.sp,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 2.h),
                                          appText(
                                            product.name,
                                            fontFamily: 'inter',
                                            fontSize: 10.sp,
                                            fontWeight: FontWeight.w400,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(height: 2.h),
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
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      SizedBox(
                        height: 195.h,
                        child: Obx(
                          () => ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 5.h,
                            ),
                            itemCount: controller.mostPopularProducts.length,
                            itemBuilder: (context, index) {
                              final product =
                                  controller.mostPopularProducts[index];
                              return Container(
                                width: 150.w,
                                margin: EdgeInsets.only(right: 15.w),
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
                                    Stack(
                                      children: [
                                        Container(
                                          height: 120.h,
                                          margin: EdgeInsets.symmetric(
                                            horizontal: 5.w,
                                            vertical: 5.h,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColors.lightGrey,
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: Center(
                                            child: Image.asset(
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
                                              color: product.isFavorite
                                                  ? AppColors.red
                                                  : AppColors.grey,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 10.w,
                                        vertical: 2.h,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              appText(
                                                product.name,
                                                fontSize: 13.sp,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.textBlack,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Spacer(),
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 5.w,
                                                  vertical: 2.h,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: AppColors.lightAmber,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    10.r,
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Icon(
                                                      Icons.star,
                                                      size: 8.sp,
                                                      color:
                                                          AppColors.darkAmber,
                                                    ),
                                                    appText(
                                                      "4.3",
                                                      fontSize: 8.sp,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 2.h),
                                          appText(
                                            product.name,
                                            fontFamily: 'inter',
                                            fontSize: 10.sp,
                                            fontWeight: FontWeight.w400,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(height: 2.h),
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
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.r), topRight: Radius.circular(15.r)),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowColor,
              blurRadius: 8,
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

                  controller.handleCheckout();
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
  }
}
