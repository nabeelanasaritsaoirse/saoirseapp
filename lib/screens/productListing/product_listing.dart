import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:saoirse_app/models/product_detiails_response.dart';
import 'package:saoirse_app/models/product_list_response.dart';
import 'package:saoirse_app/screens/product_details/product_details_screen.dart';
import 'package:saoirse_app/widgets/app_loader.dart';

import '/screens/productListing/productListing_controller.dart';
import '/widgets/app_text_field.dart';
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
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        titleSpacing: 0,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(Icons.arrow_back, size: 30.sp, color: AppColors.white),
        ),
        title: Container(
          height: 30.h,
          margin: EdgeInsets.only(right: 12.w),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Row(
            children: [
              Expanded(
                child: appTextField(
                  prefixWidth: 12.w,

                  borderRadius: BorderRadius.circular(20.r),
                  controller: productlistingController.nameContoller,
                  hintText: "Search",
                  hintColor: AppColors.black,
                  textColor: AppColors.black,

                  // Need validation for search field
                  validator: (value) {
                    return null;
                  },
                ),
              ),
            ],
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              //    FAVORITE BUTTON FUNCTION
            },
            child: Icon(
              Icons.favorite_border,
              color: AppColors.white,
              size: 30.sp,
            ),
          ),
          SizedBox(width: 10.w),
        ],
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
                  childAspectRatio: 0.60.r,
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
                      child: productCard(product));
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

  Widget productCard(Product product) {
    final imageUrl = product.images.isNotEmpty
        ? product.images.first.url
        : "https://via.placeholder.com/200";
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(color: AppColors.grey, spreadRadius: 1.r, blurRadius: 3.r),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(14.r)),
                child: Image.network(
                  imageUrl,
                  height: 115.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 115.h,
                    width: double.infinity,
                    color: Colors.grey.shade200,
                    child: Icon(Icons.broken_image, size: 40.sp),
                  ),
                ),
              ),
              Positioned(
                top: 8.h,
                right: 8.w,
                child: Icon(
                  product.hasVariants ? Icons.favorite : Icons.favorite_border,
                  color: product.hasVariants ? Colors.red : Colors.grey,
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(10.w, 8.h, 10.w, 2.h),
            child: appText(
              product.name,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.h),
            child: appText(
              product.brand,
              fontSize: 13.sp,
              color: AppColors.grey,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 6.w),
            child: appText(
              "₹ ${product.pricing.finalPrice}",
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          // Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 10.h),
          //   child: Row(
          //     children: [
          //       Icon(Icons.star, color: AppColors.mediumAmber, size: 16.sp),
          //       SizedBox(width: 4.w),
          //       appText(product.id, fontSize: 13.sp),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
