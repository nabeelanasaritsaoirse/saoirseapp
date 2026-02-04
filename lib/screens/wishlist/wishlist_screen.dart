import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:saoirse_app/constants/app_colors.dart';
import 'package:saoirse_app/constants/app_constant.dart';
import 'package:saoirse_app/main.dart';
import 'package:saoirse_app/screens/login/login_page.dart';
import 'package:saoirse_app/widgets/app_button.dart';
import 'package:saoirse_app/widgets/app_text.dart';

import '../../constants/app_strings.dart';
import '../../widgets/app_loader.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/product_card.dart';
import 'wishlist_controller.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  bool get isLoggedIn {
  return storage.read(AppConst.USER_ID) != null;
  }

  @override
  Widget build(BuildContext context) {
    WishlistController controller = Get.find<WishlistController>();

    return Scaffold(
      backgroundColor: AppColors.paperColor,
      appBar: CustomAppBar(
        title: AppStrings.wishlist,
        showBack: true,
      ),
      body:!isLoggedIn
    ? _loginOnlyView()
    : Obx(() {
        if (controller.isLoading.value) {
          return Center(child: appLoader());
        }

        if (controller.wishlistProducts.isEmpty) {
          return Center(
            child: Text(
              "Your wishlist is empty",
              style: TextStyle(fontSize: 16.sp),
            ),
          );
        }

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          child: GridView.builder(
            itemCount: controller.wishlistProducts.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 12.h,
              childAspectRatio: 0.72,
            ),
            itemBuilder: (context, index) {
              final product = controller.wishlistProducts[index];

              return ProductCard(
                productId: product.productId,
                showFavorite: true,
                margin: EdgeInsets.all(0),
                name: product.name,
                brand: product.brand.isNotEmpty ? product.brand : "Brand",
                image:
                    product.images.isNotEmpty ? product.images.first.url : "",
                price: product.finalPrice.toStringAsFixed(0),
                isFavorite: true,
                onFavoriteTap: () {
                  controller.removeItem(product.productId);
                },
              );
            },
          ),
        );
      }),
    );
  }

  Widget _loginOnlyView() {
  return Center(
    child: Padding(
      padding: EdgeInsets.all(20.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          appText(
            "Please login to view your wishlist",
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
          SizedBox(height: 20.h),
          appButton(
            buttonColor: AppColors.primaryColor,
            onTap: () {
              Get.to(() => LoginPage());
            },
            child: appText(
              "Login",
              color: AppColors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
  );
}
}
