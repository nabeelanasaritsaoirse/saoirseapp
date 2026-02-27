import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../constants/app_assets.dart';
import '../../widgets/app_text.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/product_card.dart';
import '../profile/profile_controller.dart';
import '../wishlist/wishlist_screen.dart';
import '/screens/productListing/productListing_controller.dart';
import '../../constants/app_colors.dart';
import 'productlist_shimmer.dart';

class ProductListing extends StatefulWidget {
  const ProductListing({super.key});
  @override
  State<ProductListing> createState() => _ProductListingState();
}

class _ProductListingState extends State<ProductListing> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    if (!Get.isRegistered<ProductlistingController>()) {
      Get.put(ProductlistingController());
    }

    scrollController.addListener(() {
      final controller = Get.find<ProductlistingController>();

      if (!controller.hasNextPage.value) return; // no more pages
      if (controller.isMoreLoading.value) return; // already loading more

      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        controller.fetchProducts();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ProductlistingController productlistingController =
        Get.find<ProductlistingController>();

    productlistingController.products;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(54.h),
        child: AppBar(
          backgroundColor: AppColors.primaryColor,
          elevation: 0,
          titleSpacing: 0,
          leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Icon(Icons.arrow_back, size: 30.sp, color: AppColors.white),
          ),
          title: Padding(
            padding: EdgeInsets.only(right: 15.w),
            child: appTextField(
              controller: productlistingController.nameContoller,
              hintText: "Search",
              hintColor: AppColors.textBlack,
              fillColor: AppColors.white,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20.w, vertical: 10),
              borderRadius: BorderRadius.circular(15.r),
              onChanged: productlistingController.performSearch,
              textColor: AppColors.textBlack,
            ),
          ),
          actions: [
            Obx(() {
              final count = Get.find<ProfileController>().wishlistCount.value;

              return Stack(
                clipBehavior: Clip.none,
                children: [
                  IconBox(
                    image: AppAssets.like_icon,
                    onTap: () {
                      Get.to(() => const WishlistScreen());
                    },
                  ),

                  // Show badge only if count > 0
                  if (count > 0)
                    Positioned(
                      right: 4.w,
                      top: 4.h,
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
                    ),
                ],
              );
            }),
            SizedBox(width: 12.w),
          ],
        ),
      ),
      body: Column(
        children: [
          // Container(
          //   color: AppColors.lightGrey,
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //     children: [
          //       Expanded(
          //         child: GestureDetector(
          //           child: Row(
          //             crossAxisAlignment: CrossAxisAlignment.center,
          //             mainAxisAlignment: MainAxisAlignment.center,
          //             children: [
          //               Icon(LucideIcons.arrowUpDown, size: 18.sp),
          //               appText("sort", fontSize: 18.sp),
          //             ],
          //           ),
          //           onTap: () {
          //             //  SORT BUTTON FUNCTION
          //           },
          //         ),
          //       ),
          //       Container(
          //         width: 1.w,
          //         height: 40.h,
          //         color: AppColors.shadowColor,
          //       ),
          //       Expanded(
          //         child: GestureDetector(
          //           child: Row(
          //             crossAxisAlignment: CrossAxisAlignment.center,
          //             mainAxisAlignment: MainAxisAlignment.center,
          //             children: [
          //               Icon(LucideIcons.filter, size: 18.sp),
          //               appText("Filter", fontSize: 18.sp),
          //             ],
          //           ),
          //           onTap: () {
          //             //  FILTER  BUTTON FUNCTION
          //           },
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          Expanded(
            child: Obx(() {
              if (productlistingController.isLoading.value &&
                  productlistingController.products.isEmpty) {
                return Center(child: ProductGridShimmer());
              }

              if (productlistingController.products.isEmpty) {
                return Center(
                  child: appText(
                    "No products found",
                    fontSize: 16.sp,
                  ),
                );
              }

              return GridView.builder(
                controller: scrollController,
                padding: EdgeInsets.all(12.w),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.70.r,
                  mainAxisExtent: 190.h,
                  mainAxisSpacing: 10.h,
                  crossAxisSpacing: 10.w,
                ),
                itemCount: productlistingController.products.length,
                itemBuilder: (context, index) {
                  final product = productlistingController.products[index];
                  return GestureDetector(
                      child: ProductCard(
                          margin: EdgeInsets.all(0),
                          productId: product.id,
                          name: product.name,
                          brand: product.brand,
                          image: product.images.isNotEmpty
                              ? product.images.last.url
                              : "https://via.placeholder.com/200",
                          price: product.pricing.finalPrice.toStringAsFixed(0),
                          isFavorite: false));
                },
              );
            }),
          ),
          Obx(() {
            return productlistingController.isMoreLoading.value
                ? Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    child: SizedBox(
                      height: 30.h,
                      width: 30.h,
                    ),
                  )
                : const SizedBox.shrink();
          }),
        ],
      ),
    );
  }
}
