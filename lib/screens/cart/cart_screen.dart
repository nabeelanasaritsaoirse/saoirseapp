import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:saoirse_app/constants/app_colors.dart';
import 'package:saoirse_app/constants/app_strings.dart';
import 'package:saoirse_app/screens/cart/cart_controller.dart';
import 'package:saoirse_app/widgets/app_text.dart';

class CartScreen extends StatelessWidget {
  CartScreen({super.key});

  final CartController controller = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        title: appText(
          AppStrings.carttitle,
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.white,
        ),
        centerTitle: false,
        actions: [
          GestureDetector(
            onTap: () => controller.cartItems.clear(),
            child: Container(
              margin: EdgeInsets.only(right: 15.w),
              width: 36.w,
              height: 36.h,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Center(
                child: Icon(
                  Iconsax.trash,
                  color: AppColors.primaryColor,
                  size: 22.sp,
                ),
              ),
            ),
          ),
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
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(25.r),
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
                            width: 80.w,
                            height: 80.w,
                            fit: BoxFit.cover,
                          ),
                        ),

                        SizedBox(width: 12.w),

                        /// PRODUCT DETAILS
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.name,
                                  style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600)),
                              SizedBox(height: 3.h),
                              Text("${item.color}   |   ${item.storage}",
                                  style: TextStyle(
                                      fontSize: 13.sp,
                                      color: AppColors.black54)),
                              SizedBox(height: 3.h),
                              Text("₹ ${item.price}",
                                  style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(height: 3.h),
                              Text("Plan - ${item.plan}",
                                  style: TextStyle(
                                      fontSize: 12.sp,
                                      color: AppColors.black87)),
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
                                  Text("${item.quantity}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10.sp)),
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
                    Text("Total Amount",
                        style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.black,
                            fontWeight: FontWeight.bold)),
                    Obx(() => Text("₹ ${controller.totalAmount}",
                        style: TextStyle(
                            fontSize: 14.sp, fontWeight: FontWeight.w700))),
                  ],
                ),

                /// Check Out Button
                Container(
                  height: 35.h,
                  width: 140.w,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Center(
                    child: Text("Check Out",
                        style: TextStyle(
                            color: AppColors.white,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
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
