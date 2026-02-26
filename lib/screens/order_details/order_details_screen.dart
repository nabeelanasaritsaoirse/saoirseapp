// ignore_for_file: prefer_const_constructors_in_immutables, deprecated_member_use

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
import '../../widgets/app_loader.dart';
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

  final razorpayController = Get.find<RazorpayController>();

  final walletController = Get.find<MyWalletController>();
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      orderController.initPreviewContext(
        productId: widget.product!.id,
        variantId: widget.selectVarientId ?? "",
        deliveryAddress: buildDeliveryAddress(widget.addresses),
      );

      /// INIT QUANTITY ONLY ON FIRST ENTRY
      if (orderController.orderPreview.value == null) {
        orderController.quantity.value = widget.quantity ?? 1;
      }

      /// FIRST TIME API CALL
      if (orderController.orderPreview.value == null) {
        orderController.fetchOrderPreview(
          productId: widget.product!.id,
          variantId: widget.selectVarientId ?? "",
          quantity: orderController.quantity.value,
          totalDays: widget.selectedDays,
          couponCode: "",
          deliveryAddress: buildDeliveryAddress(widget.addresses),
        );
      } else {
        /// 🔥 ADDRESS CHANGED → UPDATE CACHE FIRST
        orderController.updateDeliveryAddress(
          buildDeliveryAddress(widget.addresses),
        );

        /// THEN REFRESH PREVIEW
        orderController.refreshOrderPreview();
      }

      orderController.initProductPricing(
        finalPrice: widget.product!.pricing.finalPrice,
        dailyAmount: widget.selectedAmount,
        days: widget.selectedDays,
      );

      // 2️⃣ INIT QUANTITY ONLY ON FIRST ENTRY
      if (orderController.orderPreview.value == null) {
        orderController.quantity.value = widget.quantity ?? 1;
      }

      if (orderController.orderPreview.value == null) {
        orderController.fetchOrderPreview(
          productId: widget.product!.id,
          variantId: widget.selectVarientId ?? "",
          quantity: orderController.quantity.value,
          totalDays: widget.selectedDays,
          // couponCode: orderController.appliedCouponCode.value,
          couponCode: "",

          deliveryAddress: buildDeliveryAddress(widget.addresses),
        );
      } else {
        // 🔥 Address changed → refresh preview WITH SAME QTY
        orderController.refreshOrderPreview();
      }

      orderController.initProductPricing(
        finalPrice: widget.product!.pricing.finalPrice,
        dailyAmount: widget.selectedAmount,
        days: widget.selectedDays,
      );
    });
  }

  Map<String, dynamic> buildDeliveryAddress(Address address) {
    final map = {
      "name": address.name,
      "phoneNumber": address.phoneNumber,
      "addressLine1": address.addressLine1,
      "city": address.city,
      "state": address.state,
      "pincode": address.pincode,
      "country": address.country,
    };

    if (address.addressLine2.trim().isNotEmpty) {
      map["addressLine2"] = address.addressLine2;
    }

    if (address.landmark.trim().isNotEmpty) {
      map["landmark"] = address.landmark;
    }

    return map;
  }

  @override
  Widget build(BuildContext context) {
    if (orderController.originalAmount == 0.0) {
      orderController.originalAmount = widget.selectedAmount;
      orderController.originalDays = widget.selectedDays;
    }

    final couponController = TextEditingController();

    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppColors.paperColor,
          appBar: CustomAppBar(
            title: AppStrings.order_details,
            showBack: true,
          ),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(10.w),
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
                          child: Obx(() {
                            final address = orderController
                                .orderPreview.value?.deliveryAddress;

                            return Column(
                              spacing: 5.h,
                              children: [
                                // ---------------- NAME ----------------
                                Row(
                                  spacing: 15.w,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 15.w, vertical: 4.h),
                                      decoration: BoxDecoration(
                                        border:
                                            Border.all(color: AppColors.grey),
                                        borderRadius:
                                            BorderRadius.circular(4.r),
                                      ),
                                      child: appText(
                                        AppStrings.address,
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    appText(
                                      address?.name ?? '',
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ],
                                ),

                                // ---------------- ADDRESS DETAILS ----------------
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        spacing: 2.h,
                                        children: [
                                          // Address line
                                          appText(
                                            address?.addressLine1 ?? '',
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w600,
                                            textAlign: TextAlign.left,
                                            softWrap: true,
                                            maxLines: null,
                                          ),

                                          if (address?.addressLine2 != null &&
                                              address!.addressLine2!
                                                  .trim()
                                                  .isNotEmpty)
                                            appText(
                                              address.addressLine2!,
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w600,
                                            ),

                                          if (address?.landmark != null &&
                                              address!.landmark!
                                                  .trim()
                                                  .isNotEmpty)
                                            appText(
                                              address.landmark!,
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w600,
                                            ),

                                          // City + Pincode
                                          Row(
                                            spacing: 5.w,
                                            children: [
                                              appText(
                                                address?.city != null
                                                    ? "${address!.city},"
                                                    : '',
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w600,
                                                height: 1.3.h,
                                              ),
                                              appText(
                                                address?.pincode ?? '',
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w600,
                                                height: 1.3.h,
                                              ),
                                            ],
                                          ),

                                          // Country
                                          appText(
                                            address?.country ?? '',
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w600,
                                            height: 1.3.h,
                                          ),

                                          // Phone
                                          Row(
                                            children: [
                                              appText(
                                                AppStrings.phone,
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.grey,
                                              ),
                                              SizedBox(width: 4.w),
                                              appText(
                                                address?.phoneNumber ?? '',
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),

                                    // ---------------- CHANGE BUTTON ----------------
                                    Column(
                                      children: [
                                        appButton(
                                          width: 75.w,
                                          height: 27.h,
                                          onTap: () {
                                            Get.back();
                                          },
                                          padding: EdgeInsets.zero,
                                          buttonColor: AppColors.primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(8.r),
                                          child: Center(
                                            child: appText(
                                              AppStrings.change,
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            );
                          }),
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
                            child: Obx(() {
                              final preview =
                                  orderController.orderPreview.value;
                              final product = preview?.product;
                              return Column(
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
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 15.w, vertical: 5.h),
                                    constraints:
                                        BoxConstraints(minHeight: 80.h),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.r),
                                      border: Border.all(color: AppColors.grey),
                                    ),
                                    child: Row(
                                      spacing: 15.w,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // ----------- PRODUCT IMAGE --------------
                                        SizedBox(
                                          width: 55.w,
                                          height: 55.h,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.r),
                                            child: Image.network(
                                              product?.images.isNotEmpty == true
                                                  ? product!.images.first.url
                                                  : '',
                                              width: 55.w,
                                              height: 55.h,
                                              fit: BoxFit.contain,
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
                                              errorBuilder: (_, __, ___) =>
                                                  Container(
                                                color: Colors.grey.shade200,
                                                child: Icon(Icons.broken_image,
                                                    size: 28.sp),
                                              ),
                                            ),
                                          ),
                                        ),

                                        // ----------- PRODUCT DETAILS --------------
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // NAME + QTY
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: appText(
                                                      product?.name ?? '',
                                                      fontSize: 12.sp,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      textAlign: TextAlign.left,
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
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
                                              if (product?.variant.variantId
                                                      .isNotEmpty ==
                                                  true)
                                                appText(
                                                  "Variant: ${product!.variant.variantId}",
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w600,
                                                ),

                                              // ----------- PRICE --------------
                                              appText(
                                                "₹ ${preview?.pricing.finalProductPrice ?? 0}",
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
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Obx(() {
                                                    return Row(
                                                      children: [
                                                        // MINUS BUTTON
                                                        GestureDetector(
                                                          onTap: () =>
                                                              orderController
                                                                  .decreaseQty(),
                                                          child: Container(
                                                            width: 22.w,
                                                            height: 22.w,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          6.r),
                                                              border: Border.all(
                                                                  color:
                                                                      AppColors
                                                                          .grey),
                                                            ),
                                                            child: Icon(
                                                                Icons.remove,
                                                                size: 15.sp,
                                                                color: AppColors
                                                                    .textBlack),
                                                          ),
                                                        ),

                                                        SizedBox(width: 10.w),

                                                        // QUANTITY TEXT
                                                        Container(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      9.w,
                                                                  vertical:
                                                                      4.h),
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        6.r),
                                                            border: Border.all(
                                                                color: AppColors
                                                                    .grey),
                                                          ),
                                                          child: appText(
                                                            "${orderController.quantity.value}",
                                                            fontSize: 10.sp,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                          ),
                                                        ),

                                                        SizedBox(width: 10.w),

                                                        // PLUS BUTTON
                                                        GestureDetector(
                                                          onTap: () =>
                                                              orderController
                                                                  .increaseQty(),
                                                          child: Container(
                                                            width: 22.w,
                                                            height: 22.w,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          6.r),
                                                              border: Border.all(
                                                                  color:
                                                                      AppColors
                                                                          .grey),
                                                            ),
                                                            child: Icon(
                                                                Icons.add,
                                                                size: 15.sp,
                                                                color: AppColors
                                                                    .textBlack),
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
                              );
                            })),

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
                                          borderRadius:
                                              BorderRadius.circular(15.w),
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
                                              couponCode:
                                                  couponController.text.trim(),
                                              productId: widget.product!.id,
                                              totalDays: orderController
                                                  .selectedDays.value,
                                              dailyAmount: orderController
                                                  .selectedAmount.value,
                                              variantId:
                                                  widget.selectVarientId ?? "",
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                          children: orderController.coupons
                                              .map((coupon) {
                                            return GestureDetector(
                                              onTap: () {
                                                orderController.selectCoupon(
                                                    coupon, couponController);
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 15.w,
                                                    vertical: 8.h),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: AppColors.grey,
                                                      width: 1.w),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.r),
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  spacing: 4.h,
                                                  children: [
                                                    appText(
                                                      coupon.couponCode,
                                                      fontSize: 13.sp,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                    appText(
                                                      "Min : ₹${coupon.minOrderValue.toStringAsFixed(0)}",
                                                      fontSize: 11.sp,
                                                      fontWeight:
                                                          FontWeight.w600,
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
                                          final preview = orderController
                                              .orderPreview.value;

                                          if (preview == null ||
                                              preview.coupon == null) {
                                            return const SizedBox.shrink();
                                          }

                                          // Pricing info
                                          final coupon = preview.coupon!;
                                          final pricing = preview.pricing;
                                          final ins = preview.installment;
                                          final benefits = coupon.benefits;

                                          return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(height: 10.h),

                                              // Savings message (short)
                                              if (benefits
                                                  .savingsMessage.isNotEmpty)
                                                Container(
                                                  width: double.infinity,
                                                  alignment: Alignment.center,
                                                  child: appText(
                                                    benefits.savingsMessage,
                                                    fontSize: 13.sp,
                                                    fontWeight: FontWeight.w700,
                                                    color: AppColors.green,
                                                  ),
                                                ),

                                              SizedBox(height: 6.h),

                                              // How it works (longer explanation)
                                              if (benefits
                                                  .howItWorksMessage.isNotEmpty)
                                                appText(
                                                    benefits.howItWorksMessage,
                                                    fontSize: 12.sp,
                                                    fontWeight: FontWeight.w600,
                                                    color: AppColors.textBlack),

                                              SizedBox(height: 10.h),

                                              // Price details from server (use your buildPriceInfo helper)
                                              buildPriceInfo(
                                                  label: "Original Price",
                                                  content:
                                                      "₹ ${pricing.originalPrice.toStringAsFixed(0)}"),
                                              buildPriceInfo(
                                                  label: "Discount",
                                                  content:
                                                      "- ₹ ${pricing.couponDiscount.toStringAsFixed(0)}"),
                                              buildPriceInfo(
                                                  label: "Final Price",
                                                  content:
                                                      "₹ ${pricing.finalProductPrice.toStringAsFixed(0)}"),

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
                                              // if (ins.reducedDays != null)
                                              buildPriceInfo(
                                                  label: "Reduced Days",
                                                  content:
                                                      "${ins.reducedDays}"),

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
                                          final preview = orderController
                                              .orderPreview.value;

                                          if (preview == null ||
                                              preview.coupon == null) {
                                            return const SizedBox.shrink();
                                          }

                                          return Align(
                                            alignment: Alignment.centerRight,
                                            child: GestureDetector(
                                              onTap: () {
                                                orderController
                                                    .appliedCouponCode
                                                    .value = "";
                                                orderController
                                                    .fetchOrderPreview(
                                                  productId: widget.product!.id,
                                                  variantId:
                                                      widget.selectVarientId ??
                                                          "",
                                                  quantity: orderController
                                                      .quantity.value,
                                                  totalDays: orderController
                                                      .selectedDays.value,
                                                  deliveryAddress:
                                                      orderController
                                                          .previewAddress,
                                                );
                                                couponController.clear();
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10.w,
                                                    vertical: 5.h),
                                                decoration: BoxDecoration(
                                                  color: Colors.red.shade100,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.r),
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
                          child: Obx(() {
                            final preview = orderController.orderPreview.value;
                            final pricing = preview?.pricing;
                            final installment = preview?.installment;
                            final product = preview?.product;

                            return Column(
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

                                // ---------- PRICE BREAKUP (FROM PREVIEW API) ----------
                                if (pricing != null) ...[
                                  buildPriceInfo(
                                    label: product?.name ?? '',
                                    content:
                                        "₹ ${pricing.originalPrice.toStringAsFixed(1)}",
                                  ),
                                  buildPriceInfo(
                                    label: AppStrings.shipping_charge,
                                    content: "Free",
                                  ),
                                  if (pricing.couponDiscount > 0)
                                    buildPriceInfo(
                                      label: "Discount",
                                      content:
                                          "- ₹ ${pricing.couponDiscount.toStringAsFixed(1)}",
                                    ),
                                  Divider(color: AppColors.grey),
                                  buildPriceInfo(
                                    label: AppStrings.total_amount,
                                    content:
                                        "₹ ${pricing.finalProductPrice.toStringAsFixed(1)}",
                                  ),
                                ],

                                // ---------- PLAN DETAILS ----------
                                if (installment != null)
                                  buildPriceInfo(
                                    label: AppStrings.your_plan,
                                    content:
                                        "₹${installment.dailyAmount.toStringAsFixed(1)} / ${installment.totalDays} Days",
                                  ),

                                // ---------- PAY NOW ----------
                                if (installment != null)
                                  buildPriceInfo(
                                    label: AppStrings.pay_now,
                                    content:
                                        "₹${installment.dailyAmount.toStringAsFixed(1)}",
                                  ),
                              ],
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              _buildBottomBar(),
            ],
          ),
        ),
        Obx(() {
          if (!orderController.isLoading.value &&
              !orderController.isPlacingOrder.value) {
            return const SizedBox.shrink();
          }

          return Positioned.fill(
            child: AbsorbPointer(
              absorbing: true, // ⛔ blocks all taps
              child: Center(
                child: appLoader(),
              ),
            ),
          );
        }),
      ],
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
            child: Obx(() => ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: orderController.isPlacingOrder.value
                        ? AppColors.grey
                        : AppColors.lightAmber,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                  ),
                  onPressed: orderController.isPlacingOrder.value
                      ? null // 🚫 disable
                      : () {
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
                  child: orderController.isPlacingOrder.value
                      ? SizedBox(
                          height: 18.h,
                          width: 18.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.white,
                          ),
                        )
                      : appText(
                          AppStrings.pay_now,
                          color: AppColors.white,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                        ),
                )),
          ),
        ],
      ),
    );
  }

  void _showPaymentMethodSheet() {
    walletController.fetchWallet();

    // 🔹 TEMP state (does NOT affect order until confirmed)
    final RxString tempPaymentMethod =
        orderController.selectedPaymentMethod.value.obs;
    final RxBool tempEnableAutoPay = orderController.enableAutoPay.value.obs;

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
            // ---------------- HEADER ----------------
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
                  constraints: const BoxConstraints(),
                ),
              ],
            ),

            SizedBox(height: 15.h),

            // ---------------- WALLET OPTION ----------------
            Obx(() {
              final walletData = walletController.wallet.value;
              final walletBalance = walletData?.walletBalance ?? 0.0;
              final isSelected =
                  tempPaymentMethod.value == PaymentMethod.wallet;

              return GestureDetector(
                onTap: () {
                  if (walletBalance < orderController.selectedAmount.value) {
                    appToaster(
                      content: "Insufficient wallet balance",
                      error: true,
                    );
                    return;
                  }

                  // ✅ TEMP selection only
                  tempPaymentMethod.value = PaymentMethod.wallet;
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primaryColor.withOpacity(0.08)
                        : AppColors.white,
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primaryColor
                          : AppColors.grey.withOpacity(0.4),
                      width: isSelected ? 2 : 1.5,
                    ),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
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
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Wallet Payment",
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  "Balance: ₹${walletBalance.toStringAsFixed(1)}",
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    color: AppColors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          _buildRadio(isSelected),
                        ],
                      ),
                      SizedBox(height: 6.h),
                      Padding(
                        padding: EdgeInsets.only(left: 3.w),
                        child: Obx(() {
                          final show =
                              tempPaymentMethod.value == PaymentMethod.wallet;

                          return AnimatedOpacity(
                            duration: const Duration(milliseconds: 250),
                            opacity: show ? 1 : 0,
                            child: AnimatedSlide(
                              duration: const Duration(milliseconds: 250),
                              offset:
                                  show ? Offset.zero : const Offset(0, -0.1),
                              child: show
                                  ? Padding(
                                      padding:
                                          EdgeInsets.only(left: 3.w, top: 6.h),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 18.w,
                                            height: 18.w,
                                            child: Checkbox(
                                              value: tempEnableAutoPay.value,
                                              onChanged: (val) {
                                                tempEnableAutoPay.value =
                                                    val ?? true;
                                              },
                                              activeColor:
                                                  AppColors.primaryColor,
                                              materialTapTargetSize:
                                                  MaterialTapTargetSize
                                                      .shrinkWrap,
                                            ),
                                          ),
                                          SizedBox(width: 8.w),
                                          Text(
                                            "Enable AutoPay for future payments",
                                            style: TextStyle(
                                              fontSize: 12.5.sp,
                                              color: AppColors.grey,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              );
            }),

            SizedBox(height: 12.h),

            // ---------------- RAZORPAY OPTION ----------------
            Obx(() {
              final isSelected =
                  tempPaymentMethod.value == PaymentMethod.razorpay;

              return GestureDetector(
                onTap: () {
                  // ✅ TEMP selection only
                  tempPaymentMethod.value = PaymentMethod.razorpay;
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primaryColor.withOpacity(0.08)
                        : AppColors.white,
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primaryColor
                          : AppColors.grey.withOpacity(0.4),
                      width: isSelected ? 2 : 1.5,
                    ),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    children: [
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
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Razorpay Payment",
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              "UPI, Card, Net Banking & More",
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: AppColors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      _buildRadio(isSelected),
                    ],
                  ),
                ),
              );
            }),

            SizedBox(height: 20.h),

            // ---------------- CONFIRM BUTTON ----------------
            Obx(() {
              final canConfirm = tempPaymentMethod.value.isNotEmpty;

              return SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: canConfirm
                      ? () {
                          // ✅ FINAL COMMIT
                          orderController.selectPaymentMethod(
                            tempPaymentMethod.value,
                          );

                          orderController.enableAutoPay.value =
                              tempEnableAutoPay.value;

                          Get.back();
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    disabledBackgroundColor: AppColors.grey.withOpacity(0.4),
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    "Confirm Payment Method",
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
      isScrollControlled: true,
      enableDrag: true,
    );
  }

// ---------------- RADIO HELPER ----------------
  Widget _buildRadio(bool isSelected) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: 24.w,
      height: 24.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? AppColors.primaryColor : Colors.transparent,
        border: Border.all(
          color: isSelected
              ? AppColors.primaryColor
              : AppColors.grey.withOpacity(0.5),
          width: 2,
        ),
      ),
      child: isSelected
          ? Icon(Icons.check, size: 16.sp, color: Colors.white)
          : null,
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
