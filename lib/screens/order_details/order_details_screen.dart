// ignore_for_file: unused_local_variable

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:saoirse_app/widgets/app_text_field.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../models/address_response.dart';
import '../../models/product_details_model.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text.dart';
import '../../widgets/custom_appbar.dart';
import '../product_details/product_details_controller.dart';
import '../razorpay/razorpay_controller.dart';
import 'order_details_controller.dart';

class OrderDetailsScreen extends StatelessWidget {
  final Address addresses;
  final ProductDetailsData? product;
  final String? selectVarientId;
  final int selectedDays;
  final double selectedAmount;

  OrderDetailsScreen({
    super.key,
    required this.addresses,
    this.product,
    required this.selectedDays,
    required this.selectedAmount,
    this.selectVarientId,
  });
  final orderController = Get.find<OrderDetailsController>();
  final razorpayController = Get.put(RazorpayController());

  @override
  Widget build(BuildContext context) {
    log("DEBUG → incoming selectVarientId: $selectVarientId");

    final couponController = TextEditingController();
    final pricing = product!.pricing;

    final String? productImageUrl =
        product != null && product!.images.isNotEmpty
            ? product!.images
                .firstWhere(
                  (img) => img.isPrimary,
                  orElse: () => product!.images.first,
                )
                .url
            : null;

    return Scaffold(
      backgroundColor: AppColors.paperColor,
      appBar: CustomAppBar(
        title: AppStrings.order_details,
        showBack: true,
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: EdgeInsets.all(10.0.w),
        child: Column(
          spacing: 10.h,
          children: [
            // -------------------- ADDRESS SECTION -----------------------
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(15.w),
              decoration: BoxDecoration(
                  color: AppColors.white,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadowColor,
                      blurRadius: 6.r,
                      offset: Offset(0, 2),
                    )
                  ],
                  borderRadius: BorderRadius.circular(8.r)),
              child: Column(
                spacing: 5.h,
                children: [
                  Row(
                    spacing: 15.w,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 15.w, vertical: 4.h),
                        decoration: BoxDecoration(
                            border: Border.all(color: AppColors.grey),
                            borderRadius: BorderRadius.circular(4.r)),
                        child: appText(AppStrings.address,
                            fontSize: 11.sp, fontWeight: FontWeight.w600),
                      ),
                      appText(
                        addresses.name,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 2.h,
                        children: [
                          appText(addresses.addressLine1,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              height: 1.3.h,
                              textAlign: TextAlign.left),
                          Row(
                            spacing: 5.w,
                            children: [
                              appText("${addresses.city},",
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  height: 1.3.h,
                                  textAlign: TextAlign.left),
                              appText(addresses.pincode,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  height: 1.3.h,
                                  textAlign: TextAlign.left),
                            ],
                          ),
                          appText(addresses.country,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              height: 1.3.h,
                              textAlign: TextAlign.left),
                          Row(
                            children: [
                              appText(AppStrings.phone,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.grey),
                              appText(
                                addresses.phoneNumber,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ],
                          )
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          appButton(
                              width: 75.w,
                              height: 27.h,
                              onTap: () {
                                Get.back();
                              },
                              padding: EdgeInsets.all(0.w),
                              buttonColor: AppColors.primaryColor,
                              borderRadius: BorderRadius.circular(8.r),
                              child: Center(
                                child: appText(AppStrings.change,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.white),
                              ))
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
            // -------------------- PRODUCT DETAILS -----------------------
            // Container(
            //   width: double.infinity,
            //   padding: EdgeInsets.all(15.w),
            //   constraints: BoxConstraints(
            //     minHeight: 130.h, // ⬅️ instead of fixed height
            //   ),
            //   decoration: BoxDecoration(
            //     color: AppColors.white,
            //     boxShadow: [
            //       BoxShadow(
            //         color: AppColors.shadowColor,
            //         blurRadius: 6.r,
            //         offset: Offset(0, 2),
            //       )
            //     ],
            //     borderRadius: BorderRadius.circular(8.r),
            //   ),
            //   child: Column(
            //     spacing: 6.h,
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       appText(
            //         AppStrings.item,
            //         fontSize: 13.sp,
            //         fontWeight: FontWeight.w700,
            //       ),
            //       Container(
            //         width: double.infinity,
            //         padding:
            //             EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
            //         constraints: BoxConstraints(
            //           minHeight: 80.h, // ⬅️ instead of fixed height
            //         ),
            //         decoration: BoxDecoration(
            //           borderRadius: BorderRadius.circular(8.r),
            //           border: Border.all(color: AppColors.grey),
            //         ),
            //         child: Row(
            //           spacing: 15.w,
            //           children: [
            //             SizedBox(
            //                 width: 55.w,
            //                 height: 55.h,
            //                 child: ClipRRect(
            //                   borderRadius: BorderRadius.circular(8.r),
            //                   child: Image.network(
            //                     product!.images.isNotEmpty
            //                         ? product!.images
            //                             .firstWhere(
            //                               (img) => img.isPrimary,
            //                               orElse: () => product!.images.first,
            //                             )
            //                             .url
            //                         : "", // empty triggers errorBuilder
            //                     width: 70.w,
            //                     height: 70.w,
            //                     fit: BoxFit.cover,
            //                     errorBuilder: (_, __, ___) {
            //                       return Container(
            //                         width: 70.w,
            //                         height: 70.w,
            //                         color: Colors.grey.shade200,
            //                         child: Icon(
            //                           Icons.broken_image,
            //                           size: 28.sp,
            //                           color: Colors.grey,
            //                         ),
            //                       );
            //                     },
            //                     loadingBuilder:
            //                         (context, child, loadingProgress) {
            //                       if (loadingProgress == null) return child;

            //                       return Center(
            //                         child: SizedBox(
            //                           width: 24.w,
            //                           height: 24.w,
            //                           child: CircularProgressIndicator(
            //                             strokeWidth: 2,
            //                             color: Colors.grey,
            //                           ),
            //                         ),
            //                       );
            //                     },
            //                   ),
            //                 )),
            //             Expanded(
            //               child: Column(
            //                 crossAxisAlignment: CrossAxisAlignment.start,
            //                 mainAxisAlignment: MainAxisAlignment.center,
            //                 children: [
            //                   Row(
            //                     mainAxisAlignment:
            //                         MainAxisAlignment.spaceBetween,
            //                     children: [
            //                       Expanded(
            //                         child: appText(
            //                           product!.name,
            //                           fontSize: 12.sp,
            //                           textAlign: TextAlign.left,
            //                           fontWeight: FontWeight.w600,
            //                           maxLines: 2,
            //                           overflow: TextOverflow.ellipsis,
            //                         ),
            //                       ),
            //                       appText(
            //                         "${AppStrings.qty} 1",
            //                         fontSize: 13.sp,
            //                         fontWeight: FontWeight.w700,
            //                       ),
            //                     ],
            //                   ),
            //                   // if (product!.hasVariants)
            //                   //   Obx(() {
            //                   //     final productCtrl = Get.find<ProductDetailsController>();
            //                   //     final selectedVariant = productCtrl.getSelectedVariant();

            //                   //     if (selectedVariant == null) {
            //                   //       return SizedBox.shrink();
            //                   //     }

            //                   //     return appText(
            //                   //       selectedVariant.attributes.color,
            //                   //       fontSize: 12.sp,
            //                   //       fontWeight: FontWeight.w600,
            //                   //     );
            //                   //   }),
            //                   if (product!.hasVariants)
            //                     appText(
            //                       product!.variantId.isNotEmpty
            //                           ? "Variant: $selectVarientId"
            //                           : "",
            //                       fontSize: 12.sp,
            //                       fontWeight: FontWeight.w600,
            //                     ),

            //                   appText("₹ ${product!.pricing.finalPrice}",
            //                       fontSize: 12.sp, fontWeight: FontWeight.w600),
            //                   Obx(() {
            //                     return appText(
            //                       "Plan - ₹${orderController.selectedAmount.value} / ${orderController.selectedDays.value} Days",
            //                       fontSize: 12.sp,
            //                       fontWeight: FontWeight.w600,
            //                     );
            //                   }),
            //                 ],
            //               ),
            //             ),
            //           ],
            //         ),
            //       ),
            //     ],
            //   ),
            // ),

            // -------------------- PRODUCT DETAILS -----------------------
Container(
  width: double.infinity,
  padding: EdgeInsets.all(15.w),
  constraints: BoxConstraints(
    minHeight: 130.h,
  ),
  decoration: BoxDecoration(
    color: AppColors.white,
    boxShadow: [
      BoxShadow(
        color: AppColors.shadowColor,
        blurRadius: 6.r,
        offset: Offset(0, 2),
      )
    ],
    borderRadius: BorderRadius.circular(8.r),
  ),
  child: Column(
    spacing: 6.h,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      appText(
        AppStrings.item,
        fontSize: 13.sp,
        fontWeight: FontWeight.w700,
      ),

      // MAIN PRODUCT BOX
      Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
        constraints: BoxConstraints(minHeight: 80.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: AppColors.grey),
        ),

        child: Row(
          spacing: 15.w,
          children: [
            // ----------- PRODUCT IMAGE --------------
            SizedBox(
              width: 55.w,
              height: 55.h,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: Image.network(
                  product!.images.isNotEmpty
                      ? product!.images
                          .firstWhere(
                            (img) => img.isPrimary,
                            orElse: () => product!.images.first,
                          )
                          .url
                      : "",
                  width: 55.w,
                  height: 55.h,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: Colors.grey.shade200,
                    child: Icon(Icons.broken_image, size: 28.sp),
                  ),
                ),
              ),
            ),

            // ----------- PRODUCT DETAILS --------------
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // NAME + QTY
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: appText(
                          product!.name,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          textAlign: TextAlign.left,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      appText(
                        "${AppStrings.qty} 1",
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ],
                  ),

                  // ----------- VARIANT (COLOR / SIZE) --------------
                  if (product!.hasVariants)
                    appText(
                      selectVarientId != null && selectVarientId!.isNotEmpty
                          ? "Variant: $selectVarientId"
                          : "",
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),

                  // ----------- PRICE --------------
                  appText(
                    "₹ ${product!.pricing.finalPrice}",
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),

                  // ----------- PLAN (Daily Amount / Days) ----------
                  Obx(() {
                    return appText(
                      "Plan - ₹${orderController.selectedAmount.value} / ${orderController.selectedDays.value} Days",
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    ],
  ),
),


            // -------------------- PRODUCT DETAILS -----------------------

            // // -------------------- COUPON SECTION -----------------------
            Column(
              spacing: 10.h,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                appText(
                  AppStrings.apply_coupen,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(15.w),
                  constraints: BoxConstraints(
                    minHeight: 65.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadowColor,
                        blurRadius: 6.r,
                        offset: Offset(0, 2),
                      )
                    ],
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Column(
                    spacing: 10.h,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        spacing: 10.w,
                        children: [
                          SizedBox(
                            width: 180.w,
                            child: appTextField(
                              borderRadius: BorderRadius.circular(15.w),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 8.h, horizontal: 8.w),
                              controller: couponController,
                              hintText: AppStrings.coupen_hint,
                              hintSize: 13.sp,
                              textColor: AppColors.textBlack,
                              hintColor: AppColors.grey,
                            ),
                          ),
                          appButton(
                              onTap: () {
                                //added coupon edit
                                orderController.applyCouponApi(
                                  couponCode: couponController.text.trim(),
                                  productId: product!.id,
                                  totalDays: orderController.selectedDays.value,
                                  dailyAmount: orderController.selectedAmount.value,
                                  variantId: selectVarientId ?? "",
                                  quantity: 1,
                                );
                              },
                              width: 90.w,
                              height: 35.h,
                              buttonColor: AppColors.primaryColor,
                              padding: EdgeInsets.all(0.w),
                              child: Center(
                                child: appText(AppStrings.apply,
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.white),
                              )),
                        ],
                      ),
                      // Added this for Coupon edit---------------------------------------
                      Obx(() {
                        if (orderController.coupons.isEmpty) {
                          return SizedBox.shrink();
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            appText(
                              "Available Coupons",
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w700,
                            ),
                            SizedBox(height: 8.h),
                            Wrap(
                              spacing: 12.w,
                              runSpacing: 8.h,
                              children: orderController.coupons.map((coupon) {
                                return GestureDetector(
                                  onTap: () {
                                    orderController.selectCoupon(coupon, couponController);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: AppColors.grey, width: 1.w),
                                      borderRadius: BorderRadius.circular(5.r),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      spacing: 4.h,
                                      children: [
                                        appText(
                                          coupon.couponCode,
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        appText(
                                          "Min : ₹${coupon.minOrderValue.toStringAsFixed(0)}",
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.grey,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                            // 2) Add this Obx block (to show validation result) below the coupon input / promo chips.
                            // Place inside the same Column that contains the coupon UI so it updates in real-time.
                            Obx(() {
                              final v = orderController.couponValidation.value;
                              if (v == null) return SizedBox.shrink();

                              // Pricing info
                              final p = v.pricing;
                              final ins = v.installment;
                              final b = v.benefits;
                              final type = v.coupon.type;

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 10.h),

                                  // Savings message (short)
                                  if (b.savingsMessage.isNotEmpty) appText(b.savingsMessage, fontSize: 13.sp, fontWeight: FontWeight.w700),

                                  SizedBox(height: 6.h),

                                  // How it works (longer explanation)
                                  if (b.howItWorksMessage.isNotEmpty)
                                    appText(b.howItWorksMessage, fontSize: 12.sp, fontWeight: FontWeight.w600, color: AppColors.grey),

                                  SizedBox(height: 10.h),

                                  // Price details from server (use your buildPriceInfo helper)
                                  buildPriceInfo(label: "Original Price", content: "₹ ${p.originalPrice.toStringAsFixed(0)}"),
                                  buildPriceInfo(label: "Discount", content: "- ₹ ${p.discountAmount.toStringAsFixed(0)}"),
                                  buildPriceInfo(label: "Final Price", content: "₹ ${p.finalPrice.toStringAsFixed(0)}"),

                                  // Installment details
                                  buildPriceInfo(label: "Installment Days", content: "${ins.totalDays}"),
                                  buildPriceInfo(label: "Daily Amount", content: "₹ ${ins.dailyAmount.toStringAsFixed(0)}"),
                                  if (ins.freeDays > 0) buildPriceInfo(label: "Free Days", content: "${ins.freeDays}"),
                                  if (ins.reducedDays != null) buildPriceInfo(label: "Reduced Days", content: "${ins.reducedDays}"),

                                  SizedBox(height: 8.h),

                                  // Small label showing coupon type & applied code
                                  appText(
                                      "Applied: ${orderController.appliedCouponCode.value.isNotEmpty ? orderController.appliedCouponCode.value : couponController.text.trim()}  •  Type: $type",
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.grey),
                                ],
                              );
                            })
                          ],
                        );
                      })
                      //------------------------coupon edit close-------------------------
                    ],
                  ),
                ),
              ],
            ),
            // -------------------- COUPON SECTION -----------------------

            // -------------------- ORDER INFORMATION SECTION -----------------------
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(15.w),
              decoration: BoxDecoration(
                  color: AppColors.white,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadowColor,
                      blurRadius: 6.r,
                      offset: Offset(0, 2),
                    )
                  ],
                  borderRadius: BorderRadius.circular(8.r)),
              child: Column(
                spacing: 5.h,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: appText(
                      "Price Details",
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  buildPriceInfo(
                      label: product!.name, content: "₹ ${pricing.finalPrice}"),
                  buildPriceInfo(
                      label: AppStrings.shipping_charge, content: "Free"),
                  Divider(
                    color: AppColors.grey,
                  ),
                  buildPriceInfo(label: AppStrings.total_amount, content: "₹ ${pricing.finalPrice}"),
                  Obx(() {
                    return buildPriceInfo(
                        label: AppStrings.your_plan,
                        content:
                            "₹${orderController.selectedAmount.value}/ ${orderController.selectedDays.value} Days");
                  }),
                  Obx(() {
                    return buildPriceInfo(
                        label: AppStrings.pay_now,
                        content: "₹${orderController.selectedAmount.value}");
                  }),
                ],
              ),
            ),
            // -------------------- ORDER INFORMATION SECTION -----------------------

            // -------------------- PAY NOW BUTTON SECTION -----------------------
          ],
        ),
      )),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(12.w),
        color: AppColors.transparent,
        child: appButton(
          onTap: () {
            orderController.placeOrder(
              productId: product!.id,
              variantId: selectVarientId ?? "",
              paymentOption: "daily",
              totalDays: orderController.selectedDays.value,
              deliveryAddress: {
                "name": addresses.name,
                "phoneNumber": addresses.phoneNumber,
                "addressLine1": addresses.addressLine1,
                "city": addresses.city,
                "state": addresses.state,
                "pincode": addresses.pincode,
              },
            );
          },
          width: double.infinity,
          height: 45.h,
          buttonColor: AppColors.lightAmber,
          borderRadius: BorderRadius.circular(20.r),
          child: Center(
            child: appText(
              AppStrings.pay_now,
              fontSize: 15.sp,
              color: AppColors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildPriceInfo({
    required String label,
    required String content,
    bool isProductName = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: appText(
            label,
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            textAlign: TextAlign.left,
            color: AppColors.grey,
            maxLines: isProductName ? 2 : 1,
            softWrap: isProductName,
            overflow:
                isProductName ? TextOverflow.visible : TextOverflow.ellipsis,
          ),
        ),
        SizedBox(width: 10.w),
        appText(
          content,
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
        ),
      ],
    );
  }
}
