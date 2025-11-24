import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:saoirse_app/constants/app_assets.dart';
import 'package:saoirse_app/widgets/app_text_field.dart';
import 'package:saoirse_app/widgets/custom_appbar.dart';
import 'package:saoirse_app/widgets/product_card.dart';


import '../../widgets/app_loader.dart';
import '../product_details/product_details_screen.dart';
import '/screens/productListing/productListing_controller.dart';
import '../../constants/app_colors.dart';
import '../../widgets/app_text.dart';

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

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        Get.find<ProductlistingController>().fetchProducts(); // LOAD NEXT PAGE
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ProductlistingController productlistingController = Get.put(
      ProductlistingController(),
    );

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
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20.w, vertical: 10),
              fillColor: AppColors.white,
              borderRadius: BorderRadius.circular(15.r),
            ),
          ),
          actions: [
            IconBox(image: AppAssets.wish, padding: 8, onTap: () {}),
            SizedBox(width: 12.w),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            color: AppColors.lightGrey,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: GestureDetector(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(LucideIcons.arrowUpDown, size: 18.sp),
                        appText("sort", fontSize: 18.sp),
                      ],
                    ),
                    onTap: () {
                      //  SORT BUTTON FUNCTION
                    },
                  ),
                ),
                Container(
                  width: 1.w,
                  height: 40.h,
                  color: AppColors.shadowColor,
                ),
                Expanded(
                  child: GestureDetector(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(LucideIcons.filter, size: 18.sp),
                        appText("Filter", fontSize: 18.sp),
                      ],
                    ),
                    onTap: () {
                      //  FILTER  BUTTON FUNCTION
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              if (productlistingController.isLoading.value &&
                  productlistingController.products.isEmpty) {
                return Center(child: appLoader());
              }

              if (productlistingController.products.isEmpty) {
                return const Center(child: Text("No products found"));
              }

              return GridView.builder(
                controller: scrollController,
                padding: EdgeInsets.all(12.w),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.70.r,
                  mainAxisSpacing: 10.h,
                  crossAxisSpacing: 10.w,
                ),
                itemCount: productlistingController.products.length,
                itemBuilder: (context, index) {
                  final product = productlistingController.products[index];
                  return GestureDetector(
                      onTap: () {
                        Get.to(() => ProductDetailsScreen(
                              productId: product.productId,
                              id: product.id,
                            ));
                      },
                      child: ProductCard(
                          productId: product.id,
                          name: product.name,
                          brand: product.brand,
                          image: product.images.isNotEmpty
                              ? product.images.last.url
                              : "https://via.placeholder.com/200",
                          price: product.pricing.finalPrice.toStringAsFixed(0),
                          isFavorite: true));
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
                      child: appLoader(),
                    ),
                  )
                : const SizedBox();
          }),
        ],
      ),
    );
  }

  
}
