// ignore_for_file: unused_local_variable, deprecated_member_use

import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../constants/payment_methods.dart';
import '../../models/address_response.dart';
import '../../models/product_details_model.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/app_toast.dart';
import '../../widgets/custom_appbar.dart';
import '../my_wallet/my_wallet_controller.dart';
import '../razorpay/razorpay_controller.dart';
import 'order_details_controller.dart';

class OrderDetailsScreen extends StatefulWidget {
  final Address addresses;
  final ProductDetailsData? product;
  final String? selectVarientId;
  final int selectedDays;
  final double selectedAmount;
  final int? quantity;

  OrderDetailsScreen({
    super.key,
    required this.addresses,
    this.product,
    required this.selectedDays,
    required this.selectedAmount,
    this.selectVarientId,
    this.quantity,
  });

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  final orderController = Get.find<OrderDetailsController>();

  final razorpayController = Get.put(RazorpayController());

  final walletController = Get.put(MyWalletController());
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 🔥 THIS IS MANDATORY
      orderController.initProductPricing(
        finalPrice: widget.product!.pricing.finalPrice,
        dailyAmount: widget.selectedAmount,
        days: widget.selectedDays,
      );

      // also sync initial quantity if passed
      if (widget.quantity != null && widget.quantity! > 1) {
        orderController.quantity.value = widget.quantity!;
        orderController.recalculatePricing();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    log("DEBUG → incoming selectVarientId: ${widget.selectVarientId}");

    if (orderController.originalAmount == 0.0) {
      orderController.originalAmount = widget.selectedAmount;
      orderController.originalDays = widget.selectedDays;
    }

    final couponController = TextEditingController();
    final pricing = widget.product!.pricing;

    final String? productImageUrl =
        widget.product != null && widget.product!.images.isNotEmpty
            ? widget.product!.images
                .firstWhere(
                  (img) => img.isPrimary,
                  orElse: () => widget.product!.images.first,
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
                        widget.addresses.name,
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
                          appText(widget.addresses.addressLine1,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              height: 1.3.h,
                              textAlign: TextAlign.left),
                          Row(
                            spacing: 5.w,
                            children: [
                              appText("${widget.addresses.city},",
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  height: 1.3.h,
                                  textAlign: TextAlign.left),
                              appText(widget.addresses.pincode,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  height: 1.3.h,
                                  textAlign: TextAlign.left),
                            ],
                          ),
                          appText(widget.addresses.country,
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
                                widget.addresses.phoneNumber,
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
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
                    constraints: BoxConstraints(minHeight: 80.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: AppColors.grey),
                    ),
                    child: Row(
                      spacing: 15.w,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ----------- PRODUCT IMAGE --------------
                        SizedBox(
                          width: 55.w,
                          height: 55.h,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.r),
                            child: Image.network(
                              widget.product!.images.isNotEmpty
                                  ? widget.product!.images
                                      .firstWhere(
                                        (img) => img.isPrimary,
                                        orElse: () =>
                                            widget.product!.images.first,
                                      )
                                      .url
                                  : "",
                              width: 55.w,
                              height: 55.h,
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                }
                                return Center(
                                  child: CupertinoActivityIndicator(
                                    radius: 10.0,
                                    color: AppColors.textGray,
                                  ),
                                );
                              },
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: appText(
                                      widget.product!.name,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                      textAlign: TextAlign.left,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  // appText(
                                  //   "${AppStrings.qty} ${quantity ?? 1}",
                                  //   fontSize: 13.sp,
                                  //   fontWeight: FontWeight.w700,
                                  // ),
                                ],
                              ),

                              // ----------- VARIANT (COLOR / SIZE) --------------
                              if (widget.product!.hasVariants)
                                appText(
                                  widget.selectVarientId != null &&
                                          widget.selectVarientId!.isNotEmpty
                                      ? "Variant: ${widget.selectVarientId}"
                                      : "",
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                ),

                              // ----------- PRICE --------------
                              appText(
                                "₹ ${widget.product!.pricing.finalPrice}",
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

                              SizedBox(height: 2.h),
                              // ----------- QUANTITY SELECTOR ----------
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Obx(() {
                                    return Row(
                                      children: [
                                        // MINUS BUTTON
                                        GestureDetector(
                                          onTap: () =>
                                              orderController.decreaseQty(),
                                          child: Container(
                                            width: 22.w,
                                            height: 22.w,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(6.r),
                                              border: Border.all(
                                                  color: AppColors.grey),
                                            ),
                                            child: Icon(Icons.remove,
                                                size: 15.sp,
                                                color: AppColors.textBlack),
                                          ),
                                        ),

                                        SizedBox(width: 10.w),

                                        // QUANTITY TEXT
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 9.w, vertical: 4.h),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(6.r),
                                            border: Border.all(
                                                color: AppColors.grey),
                                          ),
                                          child: appText(
                                            "${orderController.quantity.value}",
                                            fontSize: 10.sp,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),

                                        SizedBox(width: 10.w),

                                        // PLUS BUTTON
                                        GestureDetector(
                                          onTap: () =>
                                              orderController.increaseQty(),
                                          child: Container(
                                            width: 22.w,
                                            height: 22.w,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(6.r),
                                              border: Border.all(
                                                  color: AppColors.grey),
                                            ),
                                            child: Icon(Icons.add,
                                                size: 15.sp,
                                                color: AppColors.textBlack),
                                          ),
                                        ),
                                      ],
                                    );
                                  }),
                                ],
                              ),
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
                                  productId: widget.product!.id,
                                  totalDays: orderController.selectedDays.value,
                                  dailyAmount:
                                      orderController.selectedAmount.value,
                                  variantId: widget.selectVarientId ?? "",
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
                                    orderController.selectCoupon(
                                        coupon, couponController);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 15.w, vertical: 8.h),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: AppColors.grey, width: 1.w),
                                      borderRadius: BorderRadius.circular(5.r),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
//---------------------IF USER APPLIED COUPON THIS DATA WILL APPEAR IN THE SCREEN------------------------------------------//
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
                                  if (b.savingsMessage.isNotEmpty)
                                    Container(
                                      width: double.infinity,
                                      alignment: Alignment.center,
                                      child: appText(
                                        b.savingsMessage,
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.green,
                                      ),
                                    ),

                                  SizedBox(height: 6.h),

                                  // How it works (longer explanation)
                                  if (b.howItWorksMessage.isNotEmpty)
                                    appText(b.howItWorksMessage,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textBlack),

                                  SizedBox(height: 10.h),

                                  // Price details from server (use your buildPriceInfo helper)
                                  buildPriceInfo(
                                      label: "Original Price",
                                      content:
                                          "₹ ${p.originalPrice.toStringAsFixed(0)}"),
                                  buildPriceInfo(
                                      label: "Discount",
                                      content:
                                          "- ₹ ${p.discountAmount.toStringAsFixed(0)}"),
                                  buildPriceInfo(
                                      label: "Final Price",
                                      content:
                                          "₹ ${p.finalPrice.toStringAsFixed(0)}"),

                                  // Installment details
                                  buildPriceInfo(
                                      label: "Installment Days",
                                      content: "${ins.totalDays}"),
                                  buildPriceInfo(
                                      label: "Daily Amount",
                                      content:
                                          "₹ ${ins.dailyAmount.toStringAsFixed(0)}"),
                                  if (ins.freeDays > 0)
                                    buildPriceInfo(
                                        label: "Free Days",
                                        content: "${ins.freeDays}"),
                                  if (ins.reducedDays != null)
                                    buildPriceInfo(
                                        label: "Reduced Days",
                                        content: "${ins.reducedDays}"),

                                  SizedBox(height: 8.h),

                                  // Small label showing coupon type & applied code
                                  appText(
                                      "Applied Coupon: ${orderController.appliedCouponCode.value.isNotEmpty ? orderController.appliedCouponCode.value : couponController.text.trim()}",
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.grey),
                                ],
                              );
                            }),
                            Obx(() {
                              if (orderController.couponValidation.value ==
                                  null) {
                                return SizedBox.shrink();
                              }

                              return Align(
                                alignment: Alignment.centerRight,
                                child: GestureDetector(
                                  onTap: () {
                                    orderController
                                        .removeCoupon(couponController);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10.w, vertical: 5.h),
                                    decoration: BoxDecoration(
                                      color: Colors.red.shade100,
                                      borderRadius: BorderRadius.circular(5.r),
                                    ),
                                    child: appText(
                                      "Remove Coupon",
                                      color: Colors.red,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              );
                            })
                          ],
                        );
                      })
                    ],
                  ),
                ),
              ],
            ),
            // -------------------- COUPON SECTION END --------------------------

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

                  // ---------- Pricing block: show server response when available ----------
                  Obx(() {
                    final v = orderController.couponValidation.value;

                    // If coupon validation exists, use server-provided pricing
                    if (v != null) {
                      final p = v.pricing;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 5.h,
                        children: [
                          buildPriceInfo(
                              label: widget.product!.name,
                              content:
                                  "₹ ${p.originalPrice.toStringAsFixed(0)}"),
                          buildPriceInfo(
                              label: AppStrings.shipping_charge,
                              content: "Free"),
                          if (p.discountAmount > 0)
                            buildPriceInfo(
                                label: "Discount",
                                content:
                                    "- ₹ ${p.discountAmount.toStringAsFixed(0)}"),
                          Divider(color: AppColors.grey),
                          buildPriceInfo(
                              label: AppStrings.total_amount,
                              content: "₹ ${p.finalPrice.toStringAsFixed(0)}"),
                        ],
                      );
                    }

                    // Fallback: show original product pricing when no coupon applied
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 5.h,
                      children: [
                        buildPriceInfo(
                            label: widget.product!.name,
                            content: "₹ ${pricing.finalPrice}"),
                        buildPriceInfo(
                            label: AppStrings.shipping_charge, content: "Free"),
                        Divider(color: AppColors.grey),
                        Obx(() {
                          return buildPriceInfo(
                            label: AppStrings.total_amount,
                            content: "₹ ${orderController.totalAmount.value}",
                          );
                        }),
                      ],
                    );
                  }),

                  // ---------- Plan & Pay Now (apply coupon after automatically update) ----------
                  Obx(() {
                    return buildPriceInfo(
                        label: AppStrings.your_plan,
                        content:
                            "₹${orderController.selectedAmount.value}/ ${orderController.selectedDays.value} Days");
                  }),
                  Obx(() {
                    return buildPriceInfo(
                      label: AppStrings.pay_now,
                      content: "₹${orderController.selectedAmount.value}",
                    );
                  })
                ],
              ),
            ),
// -------------------- ORDER INFORMATION SECTION -----------------------

            // -------------------- PAY NOW BUTTON SECTION -----------------------
          ],
        ),
      )),
     
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15.r),
          topRight: Radius.circular(15.r),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 6.r,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // ---------------- PAYMENT METHOD BUTTON ----------------
          Expanded(
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: AppColors.white,
                side: BorderSide(color: AppColors.shadowColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                padding: EdgeInsets.symmetric(vertical: 10.h),
              ),
              onPressed: () => _showPaymentMethodSheet(),
              child: Obx(() {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    appText(
                      orderController.selectedPaymentMethod.value ==
                              PaymentMethod.razorpay
                          ? "Razorpay"
                          : "Wallet",
                      color: AppColors.textBlack,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    SizedBox(width: 6.w),
                    Icon(Icons.keyboard_arrow_up,
                        size: 20.sp, color: AppColors.textBlack),
                  ],
                );
              }),
            ),
          ),

          SizedBox(width: 10.w),

          // ---------------- PAY NOW BUTTON ----------------
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.lightAmber,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                padding: EdgeInsets.symmetric(vertical: 10.h),
              ),
             
              onPressed: () {
                orderController.placeOrder(
                  productId: widget.product!.id,
                  variantId: widget.selectVarientId ?? "",
                  totalDays: orderController.selectedDays.value,
                  couponCode: orderController.appliedCouponCode.value,
                  deliveryAddress: {
                    "name": widget.addresses.name,
                    "phoneNumber": widget.addresses.phoneNumber,
                    "addressLine1": widget.addresses.addressLine1,
                    "city": widget.addresses.city,
                    "state": widget.addresses.state,
                    "pincode": widget.addresses.pincode,
                  },
                );
              },

              child: appText(
                AppStrings.pay_now,
                color: AppColors.white,
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPaymentMethodSheet() {
    final walletBalance = walletController.wallet.value?.walletBalance ?? 0.0;

    Get.bottomSheet(
      Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 25.h),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.r),
            topRight: Radius.circular(24.r),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with close button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                appText(
                  "Select Payment Method",
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryColor,
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: Icon(Icons.close, size: 24.sp),
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                ),
              ],
            ),

            SizedBox(height: 15.h),

            // ================= WALLET OPTION =================
            Obx(() => GestureDetector(
                  onTap: () {
                    if (walletBalance < orderController.selectedAmount.value) {
                      appToaster(
                        content: "Insufficient wallet balance",
                        error: true,
                      );
                      return; // stop here, do not select wallet
                    }

                    // If enough balance → allow selection
                    orderController.selectPaymentMethod(PaymentMethod.wallet);
                    Get.back();
                  },
                  child: Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: orderController.selectedPaymentMethod.value ==
                              "wallet"
                          ? AppColors.primaryColor
                          : AppColors.white,
                      border: Border.all(
                        color: orderController.selectedPaymentMethod.value ==
                                "wallet"
                            ? AppColors.primaryColor
                            : AppColors.grey,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      children: [
                        // Icon Container
                        Container(
                          padding: EdgeInsets.all(10.w),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Icon(
                            Icons.account_balance_wallet_rounded,
                            color: AppColors.primaryColor,
                            size: 24.sp,
                          ),
                        ),

                        SizedBox(width: 12.w),

                        // Text Content
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Wallet Payment",
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                "Balance: ₹${walletBalance.toStringAsFixed(1)}",
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: AppColors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Radio Button
                        Container(
                          width: 24.w,
                          height: 24.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color:
                                  orderController.selectedPaymentMethod.value ==
                                          "wallet"
                                      ? AppColors.primaryColor
                                      : AppColors.grey.withOpacity(0.5),
                              width: 2,
                            ),
                            color:
                                orderController.selectedPaymentMethod.value ==
                                        "wallet"
                                    ? AppColors.primaryColor
                                    : Colors.transparent,
                          ),
                          child: orderController.selectedPaymentMethod.value ==
                                  "wallet"
                              ? Icon(
                                  Icons.check,
                                  size: 16.sp,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                      ],
                    ),
                  ),
                )),

            SizedBox(height: 12.h),

            // ================= RAZORPAY OPTION =================
            Obx(() => GestureDetector(
                  onTap: () {
                    orderController.selectPaymentMethod(PaymentMethod.razorpay);
                    Get.back();
                  },
                  child: Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: orderController.selectedPaymentMethod.value ==
                              "razorpay"
                          ? AppColors.primaryColor.withOpacity(0.08)
                          : AppColors.white,
                      border: Border.all(
                        color: orderController.selectedPaymentMethod.value ==
                                "razorpay"
                            ? AppColors.primaryColor
                            : AppColors.grey.withOpacity(0.3),
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      children: [
                        // Icon Container
                        Container(
                          padding: EdgeInsets.all(10.w),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Icon(
                            Icons.payment_rounded,
                            color: AppColors.primaryColor,
                            size: 24.sp,
                          ),
                        ),

                        SizedBox(width: 12.w),

                        // Text Content
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Razorpay Payment",
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                "UPI, Card, Net Banking & More",
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: AppColors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Radio Button
                        Container(
                          width: 24.w,
                          height: 24.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color:
                                  orderController.selectedPaymentMethod.value ==
                                          "razorpay"
                                      ? AppColors.primaryColor
                                      : AppColors.grey.withOpacity(0.5),
                              width: 2,
                            ),
                            color:
                                orderController.selectedPaymentMethod.value ==
                                        "razorpay"
                                    ? AppColors.primaryColor
                                    : Colors.transparent,
                          ),
                          child: orderController.selectedPaymentMethod.value ==
                                  "razorpay"
                              ? Icon(
                                  Icons.check,
                                  size: 16.sp,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                      ],
                    ),
                  ),
                )),

            SizedBox(height: 20.h),
          ],
        ),
      ),
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
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
