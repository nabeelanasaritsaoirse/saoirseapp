// ignore_for_file: deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../constants/app_assets.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../widgets/app_text.dart';
import '../../widgets/custom_appbar.dart';
import '../select_address/select_address.dart';
import 'cart_controller.dart';

class CartScreen extends StatelessWidget {
  CartScreen({super.key});

  final CartController controller = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(
        title: AppStrings.carttitle,
        actions: [
          IconBox(
            image: AppAssets.delete,
            padding: 5.w,
            onTap: () {
              controller.clearCartItems();
            },
          ),
          SizedBox(
            width: 12.w,
          )
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 10.h),

          /// CART LIST
          Expanded(
            child: Obx(() {
              if (controller.cartData.value == null ||
                  controller.cartData.value!.products.isEmpty) {
                return ListView(
                  children: const [
                    SizedBox(
                      height: 300,
                      child: Center(
                        child: Text("Your cart is empty"),
                      ),
                    )
                  ],
                );
              }

              return ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                itemCount: controller.cartData.value!.products.length,
                itemBuilder: (context, index) {
                  final item = controller.cartData.value!.products[index];
                  final variantText = buildVariantText({
                    "color": item.variant?.attributes.color,
                    "weight": item.variant?.attributes.weight,
                    "size": item.variant?.attributes.size,
                    "material": item.variant?.attributes.material,
                  });
                  return Container(
                    margin: EdgeInsets.only(bottom: 15.h),
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(20.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2), // light shadow
                          blurRadius: 15, // smooth blur
                          spreadRadius: 2, // subtle spread
                          offset: const Offset(0, 4), // slight downward shadow
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// IMAGE
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10.r),
                              child: SizedBox(
                                width: 80.w,
                                height: 80.h,
                                child: item.images.isNotEmpty
                                    ? item.images.first.url.startsWith('http')
                                        ? Image.network(
                                            item.images.first.url,
                                            width: 80.w,
                                            height: 80.h,
                                            fit: BoxFit.cover,
                                            loadingBuilder: (context, child,
                                                loadingProgress) {
                                              if (loadingProgress == null) {
                                                return child;
                                              }
                                              return Center(
                                                child:
                                                    CupertinoActivityIndicator(
                                                  radius: 10.0,
                                                  color: AppColors.textGray,
                                                ),
                                              );
                                            },
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Center(
                                                child: Icon(
                                                  Icons.broken_image,
                                                  size: 80.sp,
                                                  color: AppColors.grey,
                                                ),
                                              );
                                            },
                                          )
                                        : Image.asset(
                                            item.images.first.url,
                                            width: 80.w,
                                            height: 80.h,
                                            fit: BoxFit.cover,
                                          )
                                    : Center(
                                        child: Icon(
                                          Icons.broken_image,
                                          size: 80.sp,
                                          color: AppColors.grey,
                                        ),
                                      ),
                              ),
                            ),

                            SizedBox(width: 12.w),

                            /// PRODUCT DETAILS
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  appText(
                                    item.name,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    textAlign: TextAlign.start,
                                  ),
                                  SizedBox(height: 3.h),
                                  if (variantText.isNotEmpty)
                                    appText(variantText,
                                        fontSize: 13.sp,
                                        color: AppColors.black54),
                                  SizedBox(height: 3.h),
                                  appText("₹ ${item.finalPrice}",
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold),
                                  SizedBox(height: 3.h),
                                  appText(
                                      "Plan - ₹${item.installmentPlan.dailyAmount}/${item.installmentPlan.totalDays} Days",
                                      fontSize: 12.sp,
                                      color: AppColors.black87)
                                ],
                              ),
                            ),

                            /// DELETE + QUANTITY
                            Column(
                              children: [
                                /// DELETE ICON
                                GestureDetector(
                                  onTap: () {
                                    controller.removeCartItem(item.productId);
                                  },
                                  child: const Icon(Iconsax.trash,
                                      color: AppColors.black),
                                ),

                                SizedBox(height: 20.h),

                                /// QUANTITY WIDGET
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10.w, vertical: 5.h),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.r),
                                    border:
                                        Border.all(color: AppColors.black26),
                                  ),
                                  child: Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () =>
                                            controller.decreaseQty(index),
                                        child: Icon(Icons.remove,
                                            size: 15.sp,
                                            color: AppColors.black),
                                      ),
                                      SizedBox(width: 10.w),
                                      appText(
                                        "${item.quantity}",
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      SizedBox(width: 10.w),
                                      GestureDetector(
                                        onTap: () =>
                                            controller.increaseQty(index),
                                        child: Icon(Icons.add,
                                            size: 15.sp,
                                            color: AppColors.black),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Align(
                          alignment: AlignmentGeometry.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              final productDetails =
                                  controller.convertCartToProductDetails(item);

                              Get.to(() => SelectAddress(
                                    product: productDetails,
                                    selectVarientId:
                                        item.variant?.variantId ?? "",
                                    selectedDays:
                                        item.installmentPlan.totalDays,
                                    selectedAmount:
                                        item.installmentPlan.dailyAmount,
                                    quantity: item.quantity,
                                  ));
                            },
                            child: Container(
                              width: 120.w,
                              height: 30.h,
                              decoration: BoxDecoration(
                                  color: AppColors.primaryColor,
                                  borderRadius: BorderRadius.circular(10.r)),
                              child: Center(
                                child: appText("Buy Now",
                                    color: AppColors.white,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
              );
            }),
          ),

          Divider(
            height: 2.h,
            color: AppColors.grey.withOpacity(0.1),
          )
        ],
      ),
    );
  }

  String buildVariantText(Map<String, dynamic>? attributes) {
    if (attributes == null) return '';

    // Filter only non-null & non-empty values
    Map<String, String> valid = {};
    attributes.forEach((k, v) {
      if (v != null && v.toString().trim().isNotEmpty) {
        valid[k] = v.toString().trim();
      }
    });

    if (valid.isEmpty) return ""; // No values → Hide widget

    String? color = valid["color"];
    String? weight = valid["weight"];

    // Convert remaining attributes (exclude color & weight)
    List<String> others = valid.entries
        .where((e) => e.key != "color" && e.key != "weight")
        .map((e) => e.value)
        .toList();

    //  color + weight available → show only these two
    if (color != null && weight != null) {
      return "$color   |   $weight";
    }

    //  color exists → color + one fallback (if exists)
    if (color != null) {
      if (weight != null) return "$color   |   $weight";
      if (others.isNotEmpty) return "$color   |   ${others.first}";
      return color; // only one → show it
    }

    // 3no color → use weight + fallback (max 2)
    List<String> finalList = [];
    if (weight != null) finalList.add(weight);
    finalList.addAll(others);

    return finalList.take(2).join("   |   "); // one or two both show
  }
}
