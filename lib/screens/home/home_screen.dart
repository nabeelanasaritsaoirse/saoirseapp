import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../constants/app_assets.dart';
import '../../constants/app_colors.dart';
import '../../widgets/app_text.dart';
import '../../constants/app_strings.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/investment_status_card.dart';
import '../category/category_controller.dart';
import '../dashboard/dashboard_controller.dart';
import '../my_wallet/my_wallet.dart';
import '../notification/notification_controller.dart';
import '../notification/notification_screen.dart';
import '../pending_transaction/pending_transaction_screen.dart';
import '../productListing/product_listing.dart';
import 'home_controller.dart';
import 'home_shimmer.dart';
import 'investment_status_controller.dart';
import 'render.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeController homeController = Get.find<HomeController>();
  NotificationController notificationController =
      Get.find<NotificationController>();
  InvestmentStatusController investmentController =
      Get.find<InvestmentStatusController>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.delayed(Duration(milliseconds: 200), () {
      Get.find<InvestmentStatusController>().fetchInvestmentStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paperColor,
      // Header Section (app-bar)
      appBar: CustomAppBar(
        showLogo: true,
        actions: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconBox(
                image: AppAssets.notification,
                padding: 3.w,
                onTap: () {
                  Get.to(() => NotificationScreen());
                },
              ),

              /// BADGE ONLY IF unreadCount > 0
              Obx(() {
                final count =
                    Get.find<NotificationController>().unreadCount.value;
                if (count == 0) return const SizedBox();

                return Positioned(
                  right: -2,
                  top: -2,
                  child: Container(
                    padding: EdgeInsets.all(4.r),
                    decoration: BoxDecoration(
                      color: AppColors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      count > 9 ? "9+" : count.toString(),
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 9.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
          SizedBox(width: 8.w),
          IconBox(
              image: AppAssets.search,
              padding: 7.w,
              onTap: () {
                Get.to(() => const ProductListing());
              }),
          SizedBox(width: 8.w),
          IconBox(
              image: AppAssets.wallet,
              padding: 5.w,
              onTap: () => Get.to(() => WalletScreen())),
          SizedBox(width: 12.w),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 8.h),

            // --------- Carousel Section (Banner Top)-------------------------
            Obx(() {
              if (homeController.bannerLoading.value) {
                return const HomeBannerShimmer();
              }
              if (homeController.carouselImages.isEmpty) {
                return const SizedBox.shrink();
              }
              return Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  CarouselSlider(
                    items: homeController.carouselImages.map((imagePath) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                            margin: EdgeInsets.symmetric(horizontal: 8.w),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.r),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.lightBlack,
                                  blurRadius: 8.r,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12.r),
                              child: Image.network(
                                imagePath,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
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
                                errorBuilder: (_, __, ___) => Container(
                                  color: Colors.grey.shade300,
                                  child: Icon(
                                    Icons.broken_image,
                                    size: 40.sp,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }).toList(),
                    options: CarouselOptions(
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 5),
                      enlargeCenterPage: true,
                      viewportFraction: 1.0,
                      height: 140.h,
                      onPageChanged: (index, reason) {
                        homeController.currentCarouselIndex.value = index;
                      },
                    ),
                  ),
                  Positioned(
                    bottom: 8.h,
                    child: Obx(
                      () => Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: homeController.carouselImages
                            .asMap()
                            .entries
                            .map((entry) {
                          return Container(
                            width: homeController.currentCarouselIndex.value ==
                                    entry.key
                                ? 24.w
                                : 8.w,
                            height: 8.h,
                            margin: EdgeInsets.symmetric(horizontal: 4.w),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4.r),
                              color:
                                  homeController.currentCarouselIndex.value ==
                                          entry.key
                                      ? AppColors.white
                                      : AppColors.transparentWhite,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 8.h,
                    child: Obx(
                      () => Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: homeController.carouselImages
                            .asMap()
                            .entries
                            .map((entry) {
                          return Container(
                            width: homeController.currentCarouselIndex.value ==
                                    entry.key
                                ? 24.w
                                : 8.w,
                            height: 8.h,
                            margin: EdgeInsets.symmetric(horizontal: 4.w),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4.r),
                              color:
                                  homeController.currentCarouselIndex.value ==
                                          entry.key
                                      ? AppColors.white
                                      : AppColors.transparentWhite,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              );
            }),

            SizedBox(height: 10.h),

            //-------------------------- Category Section--------------------------------//
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Obx(() {
                final categories = homeController.parentCategories;

                if (homeController.homeCategoryLoading.value) {
                  return const CategoryChipShimmer();
                }

                if (categories.isEmpty) {
                  return const SizedBox.shrink();
                }

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: categories.map((cat) {
                      return GestureDetector(
                        onTap: () {
                          //---------Navigate to Category Screen with selected category---------//
                          int index =
                              homeController.parentCategories.indexOf(cat);
                          Get.find<DashboardController>().selectedIndex.value =
                              1;
                          Future.delayed(Duration(milliseconds: 100), () {
                            Get.find<CategoryController>().selectedIndex.value =
                                index;
                          });
                          //---------------------------------------------------------------//
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 8.w),
                          padding: EdgeInsets.symmetric(
                              horizontal: 14.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(color: Colors.grey.shade400),
                          ),
                          child: appText(
                            cat.name,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textBlack,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                );
              }),
            ),

            SizedBox(height: 10.h),
//----------------Progress Card Section----------------//
            Obx(() {
              final data = investmentController.overview.value;

              if (data.remainingDays <= 0) {
                return const SizedBox.shrink();
              }

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    InvestmentStatusCard(
                      balanceAmount: data.totalRemainingAmount.toInt(),
                      daysLeft: data.remainingDays,
                      progress: data.progressPercent / 100,
                      onPayNow: () => Get.to(PendingTransaction()),
                    ),
                    SizedBox(height: 10.h),
                  ],
                ),
              );
            }),
//--------------------------------------------------------
            // Most Popular Product Section
            Obx(() {
              //Loading state
              if (homeController.featuredLoading.value) {
                return Column(
                  children: List.generate(
                    3,
                    (index) => Padding(
                      padding: EdgeInsets.only(bottom: 14.h),
                      child: FeaturedProductShimmer(isBig: index % 2 == 0),
                    ),
                  ),
                );
              }

              // Empty state
              if (homeController.featuredLists.isEmpty) {
                return Center(
                  child: appText(
                    "No featured products available",
                    color: Colors.grey,
                  ),
                );
              }

              //Data state
              return Column(
                children: List.generate(
                  homeController.featuredLists.length,
                  (index) {
                    final list = homeController.featuredLists[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (list.design != 5)
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                appText(
                                  list.listName,
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                                InkWell(
                                  onTap: () {
                                    Get.to(
                                      () => const ProductListing(),
                                      arguments: {
                                        'slug': list.slug,
                                        'listId': list.listId,
                                        'title': list.listName,
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
                        if (list.design != 5) SizedBox(height: 8.h),
                        FeatureListRenderer(feature: list),
                        SizedBox(height: 14.h),
                      ],
                    );
                  },
                ),
              );
            }),

            // // Adverticement Section
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Container(
            //     width: double.infinity,
            //     height: 153.h,
            //     decoration: BoxDecoration(
            //         borderRadius: BorderRadius.circular(15.r),
            //         image: DecorationImage(
            //             image: AssetImage(AppAssets.add_banner),
            //             fit: BoxFit.contain)),
            //     child: Padding(
            //       padding: EdgeInsets.symmetric(horizontal: 15.w),
            //       child: Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           SizedBox(
            //             height: 75.h,
            //           ),
            //           appButton(
            //               onTap: () {
            //                 Get.to(() => ProductListing());
            //               },
            //               buttonColor: AppColors.white,
            //               borderRadius: BorderRadius.circular(5.r),
            //               padding: EdgeInsets.all(0),
            //               width: 120.w,
            //               height: 30.h,
            //               child: Center(
            //                 child: appText(AppStrings.purchase,
            //                     fontSize: 10.sp,
            //                     fontWeight: FontWeight.w600,
            //                     color: AppColors.red),
            //               ))
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
//-------------- Success  Story Section---------------------
            SizedBox(
              height: 190.h, // total carousel height
              child: Obx(
                () {
                  return Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      CarouselSlider(
                        items: homeController.successStories.map((story) {
                          return Container(
                            margin: EdgeInsets.symmetric(horizontal: 8.w),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.r),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.lightBlack,
                                  blurRadius: 8.r,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20.r),
                              child: Image.network(
                                story.imageUrl,
                                width: double.infinity,
                                fit: BoxFit.cover,

                                // loading
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return const Center(
                                    child: CupertinoActivityIndicator(),
                                  );
                                },

                                // error
                                errorBuilder: (_, __, ___) => Container(
                                  color: Colors.grey.shade300,
                                  child: const Icon(
                                    Icons.broken_image,
                                    size: 40,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                        options: CarouselOptions(
                          height: 170.h,
                          autoPlay: true,
                          autoPlayInterval: const Duration(seconds: 5),
                          enlargeCenterPage: true,
                          viewportFraction: 1.0,
                          onPageChanged: (index, reason) {
                            homeController.currentBottomCarouselIndex.value =
                                index;
                          },
                        ),
                      ),

                      /// INDICATOR
                      Positioned(
                        bottom: 10.h,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: homeController.successStories
                              .asMap()
                              .entries
                              .map((entry) {
                            final isActive = homeController
                                    .currentBottomCarouselIndex.value ==
                                entry.key;

                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              width: isActive ? 24.w : 8.w,
                              height: 8.h,
                              margin: EdgeInsets.symmetric(horizontal: 4.w),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4.r),
                                color: isActive
                                    ? AppColors.white
                                    : AppColors.transparentWhite,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }

  // Widget _bigProductList(FeaturedList list) {
  //   return ListView.builder(
  //     scrollDirection: Axis.horizontal,
  //     padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
  //     itemCount: list.products.length,
  //     itemBuilder: (context, index) {
  //       final product = list.products[index];

  //       return ProductCard(
  //         productId: product.productId,
  //         id: product.productMongoId,
  //         name: product.name,
  //         image: product.image,
  //         brand: product.brand ?? "",
  //         price: product.finalPrice.toStringAsFixed(0),
  //         isFavorite: product.isFavorite,
  //         showFavorite: false,
  //         margin: EdgeInsets.only(right: 12.w),
  //       );
  //     },
  //   );
  // }

  // Widget _compactProductList(FeaturedList list) {
  //   return ListView.builder(
  //     scrollDirection: Axis.horizontal,
  //     padding: EdgeInsets.symmetric(horizontal: 16.w),
  //     itemCount: list.products.length,
  //     itemBuilder: (context, index) {
  //       final product = list.products[index];

  //       return Padding(
  //         padding: EdgeInsets.all(8.0.w),
  //         child: InkWell(
  //           onTap: () => Get.to(
  //             ProductDetailsScreen(
  //               productId: product.productId,
  //               id: product.productMongoId,
  //             ),
  //           ),
  //           child: Container(
  //             width: 220.w,
  //             padding: EdgeInsets.all(6.sp),
  //             decoration: BoxDecoration(
  //               color: AppColors.white,
  //               borderRadius: BorderRadius.circular(12.sp),
  //               boxShadow: [
  //                 BoxShadow(
  //                   color: AppColors.shadowColor,
  //                   blurRadius: 6.r,
  //                   offset: Offset(0, 2),
  //                 ),
  //               ],
  //             ),
  //             child: Row(
  //               children: [
  //                 ClipRRect(
  //                   borderRadius: BorderRadius.circular(8.r),
  //                   child: Image.network(
  //                     product.image,
  //                     width: 70.w,
  //                     height: 70.w,
  //                     fit: BoxFit.cover,
  //                     errorBuilder: (_, __, ___) => Icon(
  //                       Icons.broken_image,
  //                       color: Colors.grey,
  //                     ),
  //                   ),
  //                 ),
  //                 SizedBox(width: 12.w),
  //                 Expanded(
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       appText(
  //                         product.name,
  //                         fontSize: 13.sp,
  //                         maxLines: 2,
  //                         textAlign: TextAlign.left,
  //                         overflow: TextOverflow.ellipsis,
  //                         fontWeight: FontWeight.w600,
  //                       ),
  //                       SizedBox(height: 4.h),
  //                       appText(
  //                         "₹ ${product.finalPrice.toStringAsFixed(0)}",
  //                         fontSize: 13.sp,
  //                         fontWeight: FontWeight.w800,
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
}
