import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:saoirse_app/constants/app_strings.dart';
import 'package:saoirse_app/screens/home/home_controller.dart';

import 'package:saoirse_app/widgets/custom_appbar.dart';
import 'package:saoirse_app/widgets/product_card.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    HomeController homeController = Get.put(HomeController());

    return Scaffold(
      appBar: CustomAppBar(
        title: AppStrings.wishlist,
        showBack: true,
      ),
      body: Obx(
        () => Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          child: GridView.builder(
            itemCount: homeController.trendingProducts.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 12.h,
              childAspectRatio: 0.77,
            ),
            itemBuilder: (context, index) {
              final product = homeController.trendingProducts[index];
              return ProductCard(
                product: product,
                margin: EdgeInsets.all(0.w),
              );
            },
          ),
        ),
      ),
    );
  }
}
