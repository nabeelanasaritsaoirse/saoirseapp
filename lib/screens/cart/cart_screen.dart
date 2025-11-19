// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:saoirse_app/constants/app_assets.dart';
import 'package:saoirse_app/constants/app_colors.dart';
import 'package:saoirse_app/constants/app_strings.dart';
import 'package:saoirse_app/screens/cart/cart_controller.dart';
import 'package:saoirse_app/screens/select_Address/select_address.dart';
import 'package:saoirse_app/widgets/app_button.dart';
import 'package:saoirse_app/widgets/app_text.dart';

import 'package:saoirse_app/widgets/custom_appbar.dart';

class CartScreen extends StatelessWidget {
  CartScreen({super.key});

  final CartController controller = Get.put(CartController());

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
            onTap: () => controller.cartItems.clear(),
          )
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 10.h),

          /// CART LIST
          Expanded(
            child: Obx(() {
              if (controller.cartItems.isEmpty) {
                return const Center(child: Text("Your cart is empty"));
              }

              return ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                itemCount: controller.cartItems.length,
                itemBuilder: (context, index) {
                  final item = controller.cartItems[index];

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
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// IMAGE
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10.r),
                          child: Image.asset(
                            item.image,
                            width: 70.w,
                            height: 70.h,
                            fit: BoxFit.cover,
                          ),
                        ),

                        SizedBox(width: 12.w),

                        /// PRODUCT DETAILS
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              appText(item.name,
                                  fontSize: 16.sp, fontWeight: FontWeight.w600),
                              SizedBox(height: 3.h),
                              appText("${item.color}   |   ${item.storage}",
                                  fontSize: 13.sp, color: AppColors.black54),
                              SizedBox(height: 3.h),
                              appText("₹ ${item.price}",
                                  fontSize: 14.sp, fontWeight: FontWeight.bold),
                              SizedBox(height: 3.h),
                              appText("Plan - ${item.plan}",
                                  fontSize: 12.sp, color: AppColors.black87)
                            ],
                          ),
                        ),

                        /// DELETE + QUANTITY
                        Column(
                          children: [
                            /// DELETE ICON
                            GestureDetector(
                              onTap: () => controller.removeItem(index),
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
                                border: Border.all(color: AppColors.black26),
                              ),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () => controller.decreaseQty(index),
                                    child: Icon(Icons.remove,
                                        size: 15.sp, color: AppColors.black),
                                  ),
                                  SizedBox(width: 10.w),
                                  appText(
                                    "${item.quantity}",
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  SizedBox(width: 10.w),
                                  GestureDetector(
                                    onTap: () => controller.increaseQty(index),
                                    child: Icon(Icons.add,
                                        size: 15.sp, color: AppColors.black),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
          ),

          /// TOTAL + CHECKOUT
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.h),
            color: AppColors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// Total Amount
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    appText(
                      "Total Amount",
                      color: AppColors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                    ),
                    Obx(() => Text("₹ ${controller.totalAmount}",
                        style: TextStyle(
                            fontSize: 14.sp, fontWeight: FontWeight.w700))),
                  ],
                ),

                appButton(
                    onTap: () => Get.to(SelectAddress()),
                    width: 140.w,
                    height: 35.h,
                    buttonColor: AppColors.primaryColor,
                    padding: EdgeInsets.all(0.w),
                    borderRadius: BorderRadius.circular(10.r),
                    child: Center(
                      child: appText(AppStrings.checkout,
                          color: AppColors.white,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold),
                    ))
              ],
            ),
          ),
          Divider(
            height: 2.h,
            color: AppColors.grey.withOpacity(0.1),
          )
        ],
      ),
    );
  }
}
