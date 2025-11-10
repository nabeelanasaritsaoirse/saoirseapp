import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/app_assets.dart';
import '../../constants/app_colors.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text.dart';
import 'home_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeController homeController = Get.put(HomeController());

  Widget _iconBox({String? image, double? padding}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: EdgeInsets.all(padding!),
        child: Image.asset(image!),
      ),
    );
  }

  final List<String> imageList = [
    AppAssets.success_image_1,
    AppAssets.success_image_2,
    AppAssets.success_image_3,
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.white,
        // Header Section (app-bar)
        appBar: PreferredSize(
          preferredSize: Size(0, 54.h),
          child: AppBar(
            backgroundColor: AppColors.primaryColor,
            elevation: 0,
            leadingWidth: 70.w,
            leading: Padding(
              padding: EdgeInsets.only(left: 12.w),
              child: Padding(
                padding: EdgeInsets.only(top: 1.h),
                child: Image.asset(
                  AppAssets.app_logo,
                  height: 35.h,
                  width: 35.w,
                ),
              ),
            ),
            titleSpacing: 0,

            actions: [
              _iconBox(image: AppAssets.notification, padding: 3.w),
              SizedBox(width: 8.w),
              _iconBox(image: AppAssets.search, padding: 7.w),
              SizedBox(width: 8.w),
              _iconBox(image: AppAssets.wallet, padding: 5.w),
              SizedBox(width: 12.w),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 15.h),

              //  Carousel Section
              Obx(
                () => Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    CarouselSlider(
                      items: homeController.carouselImages.map((imagePath) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Container(
                              margin: EdgeInsets.symmetric(horizontal: 8.w),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.r),
                                image: DecorationImage(
                                  image: NetworkImage(imagePath),
                                  fit: BoxFit.cover,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.lightBlack,
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      gradient: LinearGradient(
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                        colors: [
                                          AppColors.lightBlack,
                                          AppColors.transparent,
                                        ],
                                      ),
                                    ),
                                  ),

                                  // Text and Button overlay
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 24.w,
                                      vertical: 20.h,
                                    ),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: FittedBox(
                                        alignment: Alignment.centerLeft,
                                        fit: BoxFit.scaleDown,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            appText(
                                              "Stylish",
                                              fontSize: 24.sp,
                                              color: AppColors.white,
                                              fontWeight: FontWeight.w800,
                                              fontStyle: FontStyle.italic,
                                              fontFamily: "Times New Roman",
                                            ),
                                            SizedBox(height: 8.h),
                                            Text(
                                              'Turn your savings into success\ninvest today and secure the future you’ve always wanted!',
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                                color: AppColors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),

                                            SizedBox(height: 16.h),
                                            appButton(
                                              onTap: () {},
                                              buttonText: 'Book Now',
                                              buttonColor: AppColors.white,
                                              textColor: Colors.black87,
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              borderRadius:
                                                  BorderRadius.circular(8.r),
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 37.w,
                                                vertical: 11.h,
                                              ),

                                              child: appText(
                                                'Book Now',
                                                color: Colors.black87,
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
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
                        height: 200,
                        onPageChanged: (index, reason) {
                          homeController.currentCarouselIndex.value = index;
                        },
                      ),
                    ),

                    Positioned(
                      bottom: 10.h,
                      child: Obx(
                        () => Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: homeController.carouselImages
                              .asMap()
                              .entries
                              .map((entry) {
                                return Container(
                                  width:
                                      homeController
                                              .currentCarouselIndex
                                              .value ==
                                          entry.key
                                      ? 24.w
                                      : 8.w,
                                  height: 8.h,
                                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4.r),
                                    color:
                                        homeController
                                                .currentCarouselIndex
                                                .value ==
                                            entry.key
                                        ? AppColors.white
                                        : AppColors.transparentWhite,
                                  ),
                                );
                              })
                              .toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 10.h),

              // Category Section
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: ['Technology', 'Fashion', 'Sports', 'Digital']
                        .map((category) {
                          // final isFirst = category == 'Technology';
                          return Container(
                            margin: EdgeInsets.only(right: 10.w),
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.w,
                              vertical: 6.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(15.r),
                              border: Border.all(color: Colors.grey.shade400),
                            ),
                            child: appText(
                              category,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textBlack,
                            ),
                          );
                        })
                        .toList(),
                  ),
                ),
              ),
              SizedBox(height: 10.h),

              // Most Popular Product Section
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        appText(
                          'Most Popular',
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.06,
                        ),

                        appText(
                          'See All',
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
                          vertical: 5,
                        ),
                        itemCount: homeController.mostPopularProducts.length,
                        itemBuilder: (context, index) {
                          final product =
                              homeController.mostPopularProducts[index];
                          return Container(
                            width: 150.w,
                            margin: EdgeInsets.only(right: 15.w),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
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
                                        color: Colors.grey.shade100,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Center(
                                        child: Image.asset(
                                          product.image,
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
                                                  BorderRadius.circular(10.r),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
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
              SizedBox(height: 20.h),

              // Best seller Product section
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        appText(
                          'Best Seller Products',
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.06,
                        ),

                        appText(
                          'See All',
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.06,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 12.h),
                  SizedBox(
                    height: 85.h,
                    child: Obx(
                      () => ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        itemCount: homeController.bestSellerProducts.length,
                        itemBuilder: (context, index) {
                          final product =
                              homeController.bestSellerProducts[index];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: 220.w,
                              padding: EdgeInsets.all(5.sp),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(12.sp),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.shadowColor,
                                    blurRadius: 6,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  // Product Image
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8.sp),
                                    child: Image.asset(
                                      product.image,
                                      width: 70.w,
                                      height: 70.w,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(width: 12.w),

                                  // Product Info
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
                          );
                        },
                      ),
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
                          "Trending Products",
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.06,
                        ),

                        appText(
                          'See All',
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
                          vertical: 5,
                        ),
                        itemCount: homeController.trendingProducts.length,
                        itemBuilder: (context, index) {
                          final product =
                              homeController.trendingProducts[index];
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
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Center(
                                        child: Image.asset(
                                          product.image,
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
                                                  BorderRadius.circular(10.r),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
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
              SizedBox(height: 10.h),

              // Adverticement Section
              Padding(
                padding: EdgeInsets.all(8.w),
                child: Container(
                  width: double.infinity,
                  height: 168.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(23),
                    gradient: LinearGradient(
                      colors: [AppColors.gradientPink, AppColors.gradientBlue],
                      begin: Alignment.topLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 24.h,
                        left: 25.w,
                        child: Text(
                          "Explore\nMore!!",
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 25.sp,
                            fontWeight: FontWeight.w800,
                            color: AppColors.lightAmber,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 83.h,
                        left: 24.w,
                        child: appButton(
                          onTap: () {},
                          width: 140.w,
                          height: 33.h,
                          buttonColor: AppColors.white,
                          borderRadius: BorderRadius.circular(10),
                          child: Center(
                            child: appText(
                              "START PURCHASING",
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w800,
                              color: AppColors.gradientPink,
                              fontFamily: "jakarta",
                            ),
                          ),
                        ),
                      ),

                      Positioned(
                        bottom: 10.h,
                        left: 24.w,
                        child: SizedBox(
                          width: 240.w,
                          child: appText(
                            "Just save minimum ₹100 everyday\nto get your desired product",
                            fontSize: 15.sp,
                            color: AppColors.white,
                            fontWeight: FontWeight.w400,
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 105.w,
                        top: 5.h,
                        child: Image.asset(
                          AppAssets.remote_product,
                          width: 100.w,
                        ),
                      ),
                      Positioned(
                        right: 5.w,
                        child: Image.asset(
                          AppAssets.game_product,
                          width: 125.w,
                        ),
                      ),
                      Positioned(
                        right: -10,
                        bottom: 18.h,
                        child: Image.asset(
                          AppAssets.earpod_product,
                          width: 90.w,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Success Section
              Container(
                width: double.infinity,
                height: 420.h,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.gradientLightBlue,
                      AppColors.gradientDarkBlue,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 10.h),
                      Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          CarouselSlider(
                            items: homeController.successImages.map((
                              imagePath,
                            ) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return Container(
                                    margin: EdgeInsets.symmetric(
                                      horizontal: 8.w,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20.r),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.lightBlack,
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20.r),
                                      child: Image.asset(
                                        imagePath,
                                        fit: BoxFit.cover,
                                        width: MediaQuery.of(
                                          context,
                                        ).size.width,
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
                              height: 200,
                              onPageChanged: (index, reason) {
                                homeController
                                        .currentBottomCarouselIndex
                                        .value =
                                    index;
                              },
                            ),
                          ),

                          Positioned(
                            bottom: 16,
                            child: Obx(
                              () => Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: homeController.successImages
                                    .asMap()
                                    .entries
                                    .map((entry) {
                                      return Container(
                                        width:
                                            homeController
                                                    .currentBottomCarouselIndex
                                                    .value ==
                                                entry.key
                                            ? 24
                                            : 8,
                                        height: 8,
                                        margin: EdgeInsets.symmetric(
                                          horizontal: 4.w,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            4.r,
                                          ),
                                          color:
                                              homeController
                                                      .currentBottomCarouselIndex
                                                      .value ==
                                                  entry.key
                                              ? AppColors.white
                                              : AppColors.transparentWhite,
                                        ),
                                      );
                                    })
                                    .toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),

                      // Refer Section
                      Container(
                        width: double.infinity,
                        height: 200.h,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(AppAssets.refer_image),
                          ),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              right: 30.w,
                              top: 37.h,
                              child: appText(
                                "Refer EPI",
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
                                "Earn Money\nEveryday",
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
                                onTap: () {},
                                buttonColor: AppColors.white,
                                borderRadius: BorderRadius.circular(12),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 34.w,
                                  vertical: 10.h,
                                ),
                                // Simulate elevation using BoxShadow
                                child: appText(
                                  "Refer A Friend Now",
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
              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }
}
