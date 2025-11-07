import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saoirse_app/constants/app_assets.dart';
import 'package:saoirse_app/constants/app_colors.dart';
import 'package:saoirse_app/screens/home/home_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeController homeController = Get.put(HomeController());

  Widget _iconBox(IconData icon) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: Colors.black87, size: 22),
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
            backgroundColor: const Color(0xFF000E63), // dark blue
            elevation: 0,
            leadingWidth: 70.w,
            leading: Padding(
              padding: EdgeInsets.only(left: 12.w),
              child: Image.asset(AppAssets.app_logo, height: 35.h, width: 35.w),
            ),
            titleSpacing: 0,

            actions: [
              _iconBox(Icons.notifications_none_rounded),
              SizedBox(width: 8.w),
              _iconBox(Icons.search),
              SizedBox(width: 8.w),
              _iconBox(Icons.account_balance_wallet_outlined),
              SizedBox(width: 12.w),
            ],
          ),
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
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
                                    color: Colors.black.withOpacity(0.15),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Stack(
                                children: [
                                  // Gradient overlay for text readability
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      gradient: LinearGradient(
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                        colors: [
                                          Colors.black.withOpacity(0.5),
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
                                            Text(
                                              'Stylish',
                                              style: TextStyle(
                                                fontSize: 24.sp,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w800,
                                                fontStyle: FontStyle.italic,
                                                fontFamily: 'Times New Roman',
                                              ),
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
                                            ElevatedButton(
                                              onPressed: () {},
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    AppColors.white,
                                                foregroundColor: Colors.black87,
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 37.w,
                                                  vertical: 11.h,
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        8.r,
                                                      ),
                                                ),
                                                elevation: 3,
                                              ),
                                              child: const Text(
                                                'Book Now',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 13,
                                                ),
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
                                  height: 8,
                                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color:
                                        homeController
                                                .currentCarouselIndex
                                                .value ==
                                            entry.key
                                        ? AppColors.white
                                        : Colors.white.withOpacity(
                                            0.5,
                                          ), // Semi-transparent inactive dots
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
                            child: Text(
                              category,
                              style: GoogleFonts.poppins(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.text_black,
                              ),
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
                        Text(
                          'Most Popular',
                          style: GoogleFonts.poppins(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.06,
                          ),
                        ),
                        Text(
                          'See All',
                          style: GoogleFonts.poppins(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                          ),
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
                                  blurRadius: 6,
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
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          product.isFavorite
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          size: 16.sp,
                                          color: product.isFavorite
                                              ? Colors.red
                                              : Colors.grey,
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
                                          Text(
                                            product.name,
                                            style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                fontSize: 13.sp,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black87,
                                              ),
                                            ),
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
                                              color: Color(0xFFF4BB00),
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
                                                  color: const Color.fromARGB(
                                                    255,
                                                    112,
                                                    90,
                                                    10,
                                                  ),
                                                ),
                                                Text(
                                                  "4.3",
                                                  style: TextStyle(
                                                    fontSize: 8.sp,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 2.h),
                                      Text(
                                        product.name,
                                        style: GoogleFonts.inter(
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.w400,
                                          color: AppColors.text_black,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 2.h),
                                      Text(
                                        '₹ ${product.price.toStringAsFixed(0)}',
                                        style: GoogleFonts.inter(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.text_black,
                                        ),
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
                        Text(
                          'Best Seller Products',
                          style: GoogleFonts.poppins(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.06,
                          ),
                        ),
                        Text(
                          'See All',
                          style: GoogleFonts.poppins(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                          ),
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
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12.sp),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
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
                                        Text(
                                          product.name,
                                          style: GoogleFonts.inter(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 4.h),
                                        Text(
                                          "₹ ${product.price.toStringAsFixed(0)}",
                                          style: GoogleFonts.inter(
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.w800,
                                            color: AppColors.text_black,
                                          ),
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
                        Text(
                          'Trending Products',
                          style: GoogleFonts.poppins(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.06,
                          ),
                        ),
                        Text(
                          'See All',
                          style: GoogleFonts.poppins(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                          ),
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
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 6,
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
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          product.isFavorite
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          size: 16.sp,
                                          color: product.isFavorite
                                              ? Colors.red
                                              : Colors.grey,
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
                                          Text(
                                            product.name,
                                            style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                fontSize: 13.sp,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black87,
                                              ),
                                            ),
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
                                              color: Color(0xFFF4BB00),
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
                                                  color: const Color.fromARGB(
                                                    255,
                                                    112,
                                                    90,
                                                    10,
                                                  ),
                                                ),
                                                Text(
                                                  "4.3",
                                                  style: TextStyle(
                                                    fontSize: 8.sp,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 2.h),
                                      Text(
                                        product.name,
                                        style: GoogleFonts.inter(
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.w400,
                                          color: AppColors.text_black,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 2.h),
                                      Text(
                                        '₹ ${product.price.toStringAsFixed(0)}',
                                        style: GoogleFonts.inter(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.text_black,
                                        ),
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
                padding: EdgeInsets.all(10.w),
                child: Container(
                  width: double.infinity,
                  height: 168.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(23),
                    gradient: LinearGradient(
                      colors: [
                        AppColors.gradientPink, // Deep purple
                        AppColors.gradientBlue, // Pinkish purple
                        // Color.fromRGBO(206, 4, 140, 1.0),
                        // Color.fromRGBO(77, 10, 142, 1.0),
                      ],
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
                        top: 80.h,
                        left: 24.w,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            fixedSize: Size(140.w, 27.h),
                            backgroundColor: AppColors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            "START PURCHASING",
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFFFF5500),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 10.h,
                        left: 24.w,
                        child: SizedBox(
                          width: 240.w,
                          child: Text(
                            "Just save minimum ₹100 everyday\nto get your desired product",
                            style: GoogleFonts.poppins(
                              fontSize: 15.sp,
                              color: AppColors.white,
                              fontWeight: FontWeight.w400,
                            ),
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
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.15),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
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
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                          color:
                                              homeController
                                                      .currentBottomCarouselIndex
                                                      .value ==
                                                  entry.key
                                              ? AppColors.white
                                              : Colors.white.withOpacity(0.5),
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
                              child: Text(
                                "Refer EPI",
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 25.sp,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.skyBlue,
                                ),
                              ),
                            ),
                            Positioned(
                              right: 40.w,
                              top: 75.h,
                              child: Text(
                                "Earn Money\nEveryday",
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 28.sp,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 5.h,
                              right: 35.w,
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.white,
                                  foregroundColor: AppColors.gradientDarkBlue,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 34.w,
                                    vertical: 10.h,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 2,
                                ),
                                child: Text(
                                  'Refer A Friend Now',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.gradientDarkBlue,
                                  ),
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
