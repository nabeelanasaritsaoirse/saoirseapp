// ignore_for_file: deprecated_member_use

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../constants/app_assets.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_gradient.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_loader.dart';
import '../../widgets/app_text.dart';
import '../../constants/app_strings.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/investment_status_card.dart';
import '../../widgets/product_card.dart';
import '../category/category_controller.dart';
import '../dashboard/dashboard_controller.dart';
import '../my_wallet/my_wallet.dart';
import '../notification/notification_controller.dart';
import '../notification/notification_screen.dart';
import '../pending_transaction/pending_transaction_screen.dart';
import '../productListing/product_listing.dart';
import '../product_details/product_details_screen.dart';
import 'home_controller.dart';
import 'investment_status_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeController homeController = Get.put(HomeController());
  NotificationController notificationController =
      Get.put(NotificationController());
  InvestmentStatusController investmentController =
      Get.put(InvestmentStatusController());

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.delayed(Duration(milliseconds: 200), () {
      Get.find<InvestmentStatusController>().fetchInvestmentStatus();
      debugPrint("👍Investment Status Refreshed");
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
              onTap: () => Get.to(WalletScreen())),
          SizedBox(width: 12.w),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 8.h),

            // --------- Carousel Section (Banner Top)-------------------------
            Obx(
              () => homeController.carouselImages.isEmpty
                  ? Container(
                      height: 140.h,
                      margin: EdgeInsets.symmetric(horizontal: 8.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        color: AppColors.lightBlack.withOpacity(0.1),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.lightBlack,
                            blurRadius: 8.r,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          Icons.image,
                          size: 50.sp,
                          color: Colors.grey.withOpacity(0.5),
                        ),
                      ),
                    )
                  : Stack(
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
                                    image: DecorationImage(
                                      image: NetworkImage(imagePath),
                                      fit: BoxFit.cover,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.lightBlack,
                                        blurRadius: 8.r,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
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
                                  width: homeController
                                              .currentCarouselIndex.value ==
                                          entry.key
                                      ? 24.w
                                      : 8.w,
                                  height: 8.h,
                                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4.r),
                                    color: homeController
                                                .currentCarouselIndex.value ==
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
                                  width: homeController
                                              .currentCarouselIndex.value ==
                                          entry.key
                                      ? 24.w
                                      : 8.w,
                                  height: 8.h,
                                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4.r),
                                    color: homeController
                                                .currentCarouselIndex.value ==
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
                    ),
            ),

            SizedBox(height: 10.h),

            //-------------------------- Category Section--------------------------------//
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Obx(() {
                final categories = homeController.parentCategories;

                if (homeController.homeCategoryLoading.value) {
                  return SizedBox();
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
                      InkWell(
                        onTap: () => Get.to(ProductListing()),
                        child: appText(
                          AppStrings.see_all,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.06,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8.h),
                SizedBox(
                  height: 205.h,
                  child: Obx(() {
                    if (homeController.loading.value &&
                        homeController.mostPopularProducts.isEmpty) {
                      return Center(child: appLoader());
                    }

                    if (homeController.mostPopularProducts.isEmpty) {
                      return Center(
                        child: appText(
                          AppStrings.no_popular_products,
                          fontSize: 14.sp,
                          color: Colors.grey,
                        ),
                      );
                    }

                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding:
                          EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
                      itemCount: homeController.mostPopularProducts.length,
                      itemBuilder: (context, index) {
                        final product =
                            homeController.mostPopularProducts[index];
                        return ProductCard(
                          productId: product.productId,
                          showFavorite: false,
                          id: product.id,
                          name: product.name,
                          image: product.images.isNotEmpty
                              ? product.images[1].url
                              : '',
                          brand: product.brand,
                          price: product.price.toStringAsFixed(0),
                          isFavorite: product.isFavorite,
                          margin: EdgeInsets.only(right: 12.w),
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
            SizedBox(height: 13.h),

            // Best seller Product section
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      appText(
                        AppStrings.best_products,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.06,
                      ),
                      InkWell(
                        onTap: () => Get.to(ProductListing()),
                        child: appText(
                          AppStrings.see_all,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.06,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8.h),
                SizedBox(
                  height: 85.h,
                  child: Obx(
                    () {
                      if (homeController.bestSellerLoading.value) {
                        return Center(
                          child: appLoader(),
                        );
                      }

                      if (homeController.bestSellerProducts.isEmpty) {
                        return Center(
                            child: appText(AppStrings.no_best_seller_products));
                      }

                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        itemCount: homeController.bestSellerProducts.length,
                        itemBuilder: (context, index) {
                          final product =
                              homeController.bestSellerProducts[index];

                          return Padding(
                            padding: EdgeInsets.all(8.0.w),
                            child: InkWell(
                              onTap: () => Get.to(
                                ProductDetailsScreen(
                                  productId: product.productId,
                                  id: product.id,
                                ),
                              ),
                              child: Container(
                                width: 220.w,
                                padding: EdgeInsets.all(5.sp),
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(12.sp),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.shadowColor,
                                      blurRadius: 6.r,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    // --- PRODUCT IMAGE --- //
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8.r),
                                      child: Image.network(
                                        product.image,
                                        width: 70.w,
                                        height: 70.w,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) {
                                          return Container(
                                            width: 70.w,
                                            height: 70.w,
                                            color: Colors.grey.shade200,
                                            child: Icon(
                                              Icons.broken_image,
                                              size: 28.sp,
                                              color: Colors.grey,
                                            ),
                                          );
                                        },
                                        loadingBuilder:
                                            (context, child, loadingProgress) {
                                          if (loadingProgress == null) {
                                            return child;
                                          }

                                          return Center(
                                            child: SizedBox(
                                              width: 24.w,
                                              height: 24.w,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),

                                    SizedBox(width: 12.w),

                                    // --- PRODUCT TEXT --- //
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 5.h),
                                          appText(
                                            product.name,
                                            fontFamily: 'inter',
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w600,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(height: 4.h),
                                          appText(
                                            "₹ ${product.price.toStringAsFixed(0)}",
                                            fontFamily: 'inter',
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
                      );
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),

            // Trending Product section
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      appText(
                        AppStrings.trending,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.06,
                      ),
                      InkWell(
                        onTap: () => Get.to(ProductListing()),
                        child: appText(
                          AppStrings.see_all,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.06,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12.h),
                SizedBox(
                  height: 205.h,
                  child: Obx(() {
                    if (homeController.loading.value &&
                        homeController.trendingProducts.isEmpty) {
                      return Center(child: appLoader());
                    }

                    if (homeController.trendingProducts.isEmpty) {
                      return Center(
                        child: appText(
                          AppStrings.no_trending_products,
                          fontSize: 14.sp,
                          color: Colors.grey,
                        ),
                      );
                    }

                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding:
                          EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
                      itemCount: homeController.trendingProducts.length,
                      itemBuilder: (context, index) {
                        final product = homeController.trendingProducts[index];
                        return ProductCard(
                          productId: product.productId,
                          showFavorite: false,
                          id: product.id,
                          name: product.name,
                          image: product.images.isNotEmpty
                              ? product.images[1].url
                              : '',
                          brand: product.brand,
                          price: product.price.toStringAsFixed(0),
                          isFavorite: product.isFavorite,
                          margin: EdgeInsets.only(right: 12.w),
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
            SizedBox(height: 10.h),

            // Adverticement Section
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: double.infinity,
                height: 153.h,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.r),
                    image: DecorationImage(
                        image: AssetImage(AppAssets.add_banner),
                        fit: BoxFit.contain)),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 75.h,
                      ),
                      appButton(
                          onTap: () {
                            Get.to(() => ProductListing());
                          },
                          buttonColor: AppColors.white,
                          borderRadius: BorderRadius.circular(5.r),
                          padding: EdgeInsets.all(0),
                          width: 120.w,
                          height: 30.h,
                          child: Center(
                            child: appText(AppStrings.purchase,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.red),
                          ))
                    ],
                  ),
                ),
              ),
            ),
//-------------- Success  Story Section---------------------
            Container(
              width: double.infinity,
              height: 420.h,
              decoration: BoxDecoration(
                gradient: AppGradients.succesGradient,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 10.h),
                    Obx(
                      () {
                        return Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            CarouselSlider(
                              items: homeController.successStories.map((story) {
                                return Builder(
                                  builder: (BuildContext context) {
                                    return Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 8.w),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(20.r),
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.lightBlack,
                                            blurRadius: 8.r,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(20.r),
                                        child: Image.network(
                                          story.imageUrl,
                                          fit: BoxFit.cover,
                                          width: MediaQuery.of(context)
                                              .size
                                              .width
                                              .w,

                                          // 👇 If image not found → show simple grey container with icon
                                          errorBuilder: (_, __, ___) =>
                                              Container(
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
                                height: 170.h,
                                onPageChanged: (index, reason) {
                                  homeController
                                      .currentBottomCarouselIndex.value = index;
                                },
                              ),
                            ),
                            Positioned(
                              bottom: 10.h,
                              child: Obx(
                                () => Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: homeController.successStories
                                      .asMap()
                                      .entries
                                      .map((entry) {
                                    return Container(
                                      width: homeController
                                                  .currentBottomCarouselIndex
                                                  .value ==
                                              entry.key
                                          ? 24.w
                                          : 8.w,
                                      height: 8.h,
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 4.w),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(4.r),
                                        color: homeController
                                                    .currentBottomCarouselIndex
                                                    .value ==
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
                      },
                    ),
                    SizedBox(height: 10.h),

                    // Refer Section
                    Container(
                      width: double.infinity,
                      height: 200.h,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(AppAssets.refer_image),
                          fit: BoxFit.fill,
                        ),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            right: 30.w,
                            top: 37.h,
                            child: appText(
                              AppStrings.refer,
                              fontSize: 25.sp,
                              fontWeight: FontWeight.w900,
                              color: AppColors.skyBlue,
                              fontFamily: "jakarta",
                            ),
                          ),
                          Positioned(
                            right: 40.w,
                            top: 75.h,
                            child: appText(
                              AppStrings.refer_heding,
                              fontSize: 28.sp,
                              fontWeight: FontWeight.w900,
                              color: AppColors.white,
                              fontFamily: "jakarta",
                              textAlign: TextAlign.start,
                            ),
                          ),
                          Positioned(
                            bottom: 5.h,
                            right: 35.w,
                            child: appButton(
                              onTap: () {
                                final dashboard =
                                    Get.find<DashboardController>();
                                dashboard.changeTab(2);
                              },
                              width: 195.w,
                              height: 45.h,
                              buttonColor: AppColors.white,
                              borderRadius: BorderRadius.circular(12),
                              padding: EdgeInsets.symmetric(),
                              child: appText(
                                AppStrings.refer_button_lebel,
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w800,
                                color: AppColors.gradientDarkBlue,
                                fontFamily: "jakarta",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }
}
