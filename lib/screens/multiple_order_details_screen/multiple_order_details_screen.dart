// ignore_for_file: unnecessary_to_list_in_spreads, deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../constants/payment_methods.dart';
import '../../models/address_response.dart';
import '../../models/bulk_order_preview_response.dart';
import '../../models/cart_response_model.dart';
import '../../models/product_details_model.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_loader.dart';
import '../../widgets/app_text.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/app_toast.dart';
import '../../widgets/custom_appbar.dart';
import '../my_wallet/my_wallet_controller.dart';
import 'multiple_order_details_controller.dart';

class MultipleOrderDetailsScreen extends StatefulWidget {
  final Address addresses;
  final ProductDetailsData? product;
  final CartData cartData;
  final String? selectVarientId;
  final int selectedDays;
  final double selectedAmount;
  final int? quantity;
  const MultipleOrderDetailsScreen(
      {super.key,
      required this.addresses,
      this.product,
      this.selectVarientId,
      required this.selectedDays,
      required this.cartData,
      required this.selectedAmount,
      this.quantity});

  @override
  State<MultipleOrderDetailsScreen> createState() =>
      _MultipleOrderDetailsScreenState();
}

class _MultipleOrderDetailsScreenState
    extends State<MultipleOrderDetailsScreen> {
  final orderController = Get.find<MultipleOrderDetailsController>();
  final walletController = Get.find<MyWalletController>();

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      orderController.previewData.value = null;

      await Future.delayed(const Duration(milliseconds: 10));

      orderController.fetchBulkOrderPreviewWithLoader(
        deliveryAddress: widget.addresses,
      );

      orderController.initProductPricing(
        finalPrice: widget.product!.pricing.finalPrice,
        dailyAmount: widget.selectedAmount,
        days: widget.selectedDays,
      );

      if (widget.quantity != null && widget.quantity! > 1) {
        orderController.quantity.value = widget.quantity!;
        orderController.recalculatePricing();
      }
    });
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
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(10.0.w),
              child: Column(
                children: [
                  // -------------------- ADDRESS SECTION -----------------------
                  Container(
                    width: double.infinity,
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
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
                      final address = orderController.previewAddress;
                      final isLoading = orderController.isPreviewLoading.value;

                      return ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: 100.h,
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            /// 🔹 ADDRESS CONTENT (dynamic height)
                            if (address != null)
                              Opacity(
                                opacity: isLoading ? 0.3 : 1,
                                child: Column(
                                  mainAxisSize:
                                      MainAxisSize.min, // 🔥 IMPORTANT
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 15.w,
                                            vertical: 4.h,
                                          ),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: AppColors.grey),
                                            borderRadius:
                                                BorderRadius.circular(4.r),
                                          ),
                                          child: appText(
                                            AppStrings.address,
                                            fontSize: 11.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(width: 15.w),
                                        appText(
                                          address.name,
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 5.h),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            mainAxisSize: MainAxisSize
                                                .min, // 🔥 IMPORTANT
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              appText(
                                                address.addressLine1,
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w600,
                                                softWrap: true,
                                              ),
                                              if (address
                                                  .addressLine2.isNotEmpty)
                                                appText(
                                                  address.addressLine2,
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w600,
                                                  softWrap: true,
                                                ),
                                              if (address.landmark.isNotEmpty)
                                                appText(
                                                  address.landmark,
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w600,
                                                  softWrap: true,
                                                ),
                                              Row(
                                                children: [
                                                  Flexible(
                                                    child: appText(
                                                      "${address.city}, ",
                                                      fontSize: 12.sp,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  appText(
                                                    address.pincode,
                                                    fontSize: 12.sp,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ],
                                              ),
                                              appText(
                                                address.country,
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              Row(
                                                children: [
                                                  appText(
                                                    AppStrings.phone,
                                                    fontSize: 12.sp,
                                                    fontWeight: FontWeight.w600,
                                                    color: AppColors.grey,
                                                  ),
                                                  appText(
                                                    " ${address.phoneNumber}",
                                                    fontSize: 12.sp,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 10.w),
                                        appButton(
                                          width: 75.w,
                                          height: 27.h,
                                          onTap: () => Get.back(),
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
                              ),

                            /// 🔹 LOADER
                            if (isLoading && address == null)
                              const CupertinoActivityIndicator(),
                          ],
                        ),
                      );
                    }),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  // -------------------- PRODUCT DETAILS (MULTIPLE) -----------------------
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(15.w),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.shadowColor,
                          blurRadius: 6.r,
                          offset: const Offset(0, 2),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        appText(
                          AppStrings.item,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w700,
                        ),

                        SizedBox(height: 8.h),

                        /// 🔥 MULTIPLE PRODUCTS LIST
                        Obx(() {
                          final items = orderController.previewItems;
                          final address = orderController.previewAddress;

                          if (items.isEmpty || address == null) {
                            return const SizedBox.shrink();
                          }
                          return ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: items.length,
                            separatorBuilder: (_, __) => SizedBox(height: 10.h),
                            itemBuilder: (context, index) {
                              final item = items[index];
                              return _buildCartProductItem(item, address);
                            },
                          );
                        })
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),

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
                                    final address =
                                        orderController.previewAddress;

                                    if (address == null) {
                                      appToaster(
                                        error: true,
                                        content:
                                            "Address not ready. Please wait.",
                                      );
                                      return;
                                    }

                                    orderController
                                        .applyCouponLoopWiseForAllProducts(
                                      couponCode: couponController.text.trim(),
                                      deliveryAddress: address,
                                    );
                                  },
                                  width: 90.w,
                                  height: 35.h,
                                  buttonColor: AppColors.primaryColor,
                                  padding: EdgeInsets.all(0.w),
                                  child: Center(
                                    child: appText(
                                      AppStrings.apply,
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.white,
                                    ),
                                  ),
                                ),
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

                                  /// ---------------- AVAILABLE COUPONS ----------------
                                  Wrap(
                                    spacing: 12.w,
                                    runSpacing: 8.h,
                                    children:
                                        orderController.coupons.map((coupon) {
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
                                                color: AppColors.grey,
                                                width: 1.w),
                                            borderRadius:
                                                BorderRadius.circular(5.r),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
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

                                  /// ---------------- COUPON DETAILS (AFTER APPLY) ----------------

                                  Obx(() {
                                    final preview =
                                        orderController.previewData.value;

                                    if (preview == null ||
                                        preview.summary.totalCouponDiscount <=
                                            0) {
                                      return const SizedBox.shrink();
                                    }

                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 10.h),

                                        /// Success message
                                        Container(
                                          width: double.infinity,
                                          alignment: Alignment.center,
                                          child: appText(
                                            "Coupon applied successfully",
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.green,
                                          ),
                                        ),

                                        SizedBox(height: 6.h),

                                        /// Preview-based price details
                                        buildPriceInfo(
                                          label: "Original Price",
                                          content:
                                              "₹ ${preview.summary.totalOriginalPrice.toStringAsFixed(0)}",
                                        ),
                                        buildPriceInfo(
                                          label: "Discount",
                                          content:
                                              "- ₹ ${preview.summary.totalCouponDiscount.toStringAsFixed(0)}",
                                        ),
                                        buildPriceInfo(
                                          label: "Final Price",
                                          content:
                                              "₹ ${preview.summary.totalProductPrice.toStringAsFixed(0)}",
                                        ),
                                        buildPriceInfo(
                                          label: "Pay Now",
                                          content:
                                              "₹ ${preview.summary.totalFirstPayment.toStringAsFixed(0)}",
                                        ),

                                        SizedBox(height: 8.h),

                                        appText(
                                          "Applied Coupon: ${orderController.previewCouponCode.value}",
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.grey,
                                        ),
                                      ],
                                    );
                                  }),

                                  /// ---------------- REMOVE COUPON ----------------
                                  Obx(() {
                                    if (!orderController
                                        .isCouponApplied.value) {
                                      return const SizedBox.shrink();
                                    }

                                    return Align(
                                      alignment: Alignment.centerRight,
                                      child: GestureDetector(
                                        onTap: () {
                                          final address =
                                              orderController.previewAddress;

                                          if (address == null) {
                                            appToaster(
                                              error: true,
                                              content:
                                                  "Address not ready. Please wait.",
                                            );
                                            return;
                                          }

                                          orderController.removePreviewCoupon(
                                            deliveryAddress:
                                                address, // ✅ FROM RESPONSE / MODEL
                                            controller: couponController,
                                          );
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10.w, vertical: 5.h),
                                          decoration: BoxDecoration(
                                            color: Colors.red.shade100,
                                            borderRadius:
                                                BorderRadius.circular(5.r),
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
                                  }),
                                ],
                              );
                            }),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
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
                      borderRadius: BorderRadius.circular(8.r),
                    ),
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

                        /// 🔥 PRODUCT PRICE LIST (MULTIPLE PRODUCTS)
                        Obx(() {
                          final preview = orderController.previewData.value;

                          if (preview == null) {
                            return const SizedBox.shrink();
                          }

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 5.h,
                            children: [
                              /// PRODUCT LINES
                              ...preview.items.map((item) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(vertical: 4.h),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      /// PRODUCT NAME (flexible)
                                      Expanded(
                                        child: appText(
                                          item.product.name,
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.grey,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.left,
                                        ),
                                      ),

                                      /// FIXED SPACE BETWEEN NAME & QTY

                                      /// QUANTITY (FIXED WIDTH — KEY FIX)
                                      SizedBox(
                                        width: 28.w, // 🔥 fixed width
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: appText(
                                            "× ${item.quantity}",
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.grey,
                                          ),
                                        ),
                                      ),

                                      /// FIXED GAP

                                      /// PRICE (FIXED WIDTH, RIGHT ALIGNED)
                                      SizedBox(
                                        width:
                                            60.w, // 🔥 keeps all prices aligned
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: appText(
                                            "₹ ${item.pricing.totalProductPrice.toStringAsFixed(0)}",
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),

                              /// SHIPPING
                              buildPriceInfo(
                                label: AppStrings.shipping_charge,
                                content: "Free",
                              ),

                              /// DISCOUNT (ONLY IF COUPON APPLIED)
                              if (preview.summary.totalCouponDiscount > 0)
                                buildPriceInfo(
                                  label: "Discount",
                                  content:
                                      "- ₹ ${preview.summary.totalCouponDiscount.toStringAsFixed(0)}",
                                ),

                              Divider(color: AppColors.grey),

                              /// TOTAL AMOUNT
                              buildPriceInfo(
                                label: AppStrings.total_amount,
                                content:
                                    "₹ ${preview.summary.totalProductPrice.toStringAsFixed(0)}",
                              ),

                              buildPriceInfo(
                                label: AppStrings.pay_now,
                                content:
                                    "₹ ${preview.summary.totalFirstPayment.toStringAsFixed(0)}",
                              ),
                            ],
                          );
                        }),

                        /// PAY NOW
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: _buildBottomBar(),
        ),
        Obx(() {
          final showLoader = orderController.isPreviewLoading.value ||
              orderController.isPlacingOrder.value;

          if (!showLoader) return const SizedBox.shrink();

          return Positioned.fill(
            child: AbsorbPointer(
              absorbing: true,
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
      child: Row(children: [
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
                    ? null
                    : () {
                        orderController.placeBulkOrder(
                          deliveryAddress: {
                            "name": widget.addresses.name,
                            "phoneNumber": widget.addresses.phoneNumber,
                            "addressLine1": widget.addresses.addressLine1,
                            "city": widget.addresses.city,
                            "state": widget.addresses.state,
                            "pincode": widget.addresses.pincode,
                            "country": widget.addresses.country,
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
      ]),
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
                  final walletBalance =
                      walletController.wallet.value?.walletBalance ?? 0.0;

                  final payNowAmount = orderController
                          .previewData.value?.summary.totalFirstPayment ??
                      0.0;

                  if (walletBalance < payNowAmount) {
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
                          // ================= WALLET VALIDATION =================
                          if (tempPaymentMethod.value == PaymentMethod.wallet) {
                            final walletBalance =
                                walletController.wallet.value?.walletBalance ??
                                    0.0;

                            final payNowAmount = orderController.previewData
                                    .value?.summary.totalFirstPayment ??
                                0.0;

                            if (walletBalance < payNowAmount) {
                              appToaster(
                                error: true,
                                content: "Insufficient wallet balance",
                              );

                              return;
                            }
                          }

                          // ================= FINAL COMMIT =================
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

  Widget _buildCartProductItem(PreviewItem item, Address deliveryAddress) {
    final imageUrl =
        item.product.images.isNotEmpty ? item.product.images.first.url : "";
    final variantText = item.variant?.attributes.color ?? "";
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
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
                imageUrl,
                fit: BoxFit.contain,
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
                // NAME
                appText(
                  item.product.name,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  maxLines: 2,
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                ),

                // VARIANT

                if (variantText.isNotEmpty)
                  appText(
                    variantText,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                  ),

                // PRICE
                appText(
                  "₹ ${item.pricing.finalPrice}",
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),

                // // PLAN
                appText(
                  "Plan - ₹${item.installment.dailyAmount} / "
                  "${item.installment.totalDays} Days",
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),

                SizedBox(height: 2.h),

                // QTY (DISPLAY ONLY)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        final controller =
                            Get.find<MultipleOrderDetailsController>();

                        final index = item.itemIndex;
                        if (index < 0 || index >= controller.products.length) {
                          return;
                        }

                        final cartItem = controller.products[index];

                        controller.openPlanEditor(cartItem);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 3.h),
                        decoration: BoxDecoration(
                            color: AppColors.lightGrey,
                            border: Border.all(color: AppColors.shadowColor),
                            borderRadius: BorderRadius.circular(5.r)),
                        child: Center(
                            child: appText(
                          "Edit",
                          fontSize: 12.sp,
                        )),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    // ----------- QUANTITY SELECTOR ----------
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            // MINUS BUTTON
                            GestureDetector(
                              onTap: () => orderController.decreasePreviewQty(
                                item,
                                deliveryAddress,
                              ),
                              child: Container(
                                width: 22.w,
                                height: 22.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6.r),
                                  border: Border.all(color: AppColors.grey),
                                ),
                                child: Icon(Icons.remove,
                                    size: 15.sp, color: AppColors.textBlack),
                              ),
                            ),

                            SizedBox(width: 10.w),

                            // QUANTITY TEXT
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 9.w, vertical: 4.h),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6.r),
                                border: Border.all(color: AppColors.grey),
                              ),
                              child: appText(
                                "${item.quantity}",
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),

                            SizedBox(width: 10.w),

                            // PLUS BUTTON
                            GestureDetector(
                              onTap: () => orderController.increasePreviewQty(
                                item,
                                deliveryAddress,
                              ),
                              child: Container(
                                width: 22.w,
                                height: 22.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6.r),
                                  border: Border.all(color: AppColors.grey),
                                ),
                                child: Icon(Icons.add,
                                    size: 15.sp, color: AppColors.textBlack),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
