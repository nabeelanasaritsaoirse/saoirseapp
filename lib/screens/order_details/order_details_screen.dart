import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:saoirse_app/screens/booking_confirmation/booking_confirmation_screen.dart';
import 'package:saoirse_app/screens/razorpay/razorpay_controller.dart';

import '../../constants/app_assets.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../models/address_response.dart';
import '../../models/product_details_model.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/custom_appbar.dart';
import 'order_details_controller.dart';

class OrderDetailsScreen extends StatelessWidget {
  final Address addresses;
  final ProductDetailsData? product;

  OrderDetailsScreen({super.key, required this.addresses, this.product});
  final orderController = Get.put(OrderDetailsController());
  final razorpayController = Get.put(RazorpayController());

  @override
  Widget build(BuildContext context) {
    final couponController = TextEditingController();
    final pricing = product!.pricing;
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
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(15.w),
              constraints: BoxConstraints(
                minHeight: 130.h, // ⬅️ instead of fixed height
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
                  Container(
                    width: double.infinity,
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
                    constraints: BoxConstraints(
                      minHeight: 80.h, // ⬅️ instead of fixed height
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: AppColors.grey),
                    ),
                    child: Row(
                      spacing: 15.w,
                      children: [
                        SizedBox(
                          width: 55.w,
                          height: 55.h,
                          child:
                              Image.asset(AppAssets.iphone, fit: BoxFit.cover),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: appText(
                                      product!.name,
                                      fontSize: 12.sp,
                                      textAlign: TextAlign.left,
                                      fontWeight: FontWeight.w600,
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
                              appText("Red | 1TB",
                                  fontSize: 12.sp, fontWeight: FontWeight.w600),
                              appText("₹ ${product!.pricing.finalPrice}",
                                  fontSize: 12.sp, fontWeight: FontWeight.w600),
                              appText("Plan - ₹100/200 Days",
                                  fontSize: 12.sp, fontWeight: FontWeight.w600),
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

            // -------------------- COUPON SECTION -----------------------
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
                  height: 130.h,
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
                              onTap: () {},
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
                      appText(AppStrings.premoCode,
                          fontSize: 13.sp, fontWeight: FontWeight.w600),
                      Row(
                        spacing: 15.w,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 25.w, vertical: 7.h),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: AppColors.grey, width: 1.w),
                                borderRadius: BorderRadius.circular(5.r)),
                            child: appText("FHD10%",
                                fontSize: 13.sp, fontWeight: FontWeight.w600),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 25.w, vertical: 7.h),
                            decoration: BoxDecoration(
                                border: Border.all(color: AppColors.grey),
                                borderRadius: BorderRadius.circular(5.r)),
                            child: appText("FHD10%",
                                fontSize: 13.sp, fontWeight: FontWeight.w600),
                          )
                        ],
                      )
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
                  buildPriceInfo(label: AppStrings.tax, content: "₹ 950"),
                  buildPriceInfo(label: AppStrings.market_fee, content: "₹ 50"),
                  buildPriceInfo(
                      label: AppStrings.shipping_charge, content: "₹ Free"),
                  Divider(
                    color: AppColors.grey,
                  ),
                  buildPriceInfo(
                      label: AppStrings.total_amount,
                      content: "₹ ${pricing.finalPrice}"),
                  buildPriceInfo(
                      label: AppStrings.your_plan, content: "₹ 100/200 Days"),
                  buildPriceInfo(
                      label: AppStrings.pay_now, content: "₹ 100 Only"),
                ],
              ),
            ),
            // -------------------- ORDER INFORMATION SECTION -----------------------
            SizedBox(
              height: 1.h,
            ),
            // -------------------- PAY NOW BUTTON SECTION -----------------------

            appButton(
              onTap: () {
                 Get.to(() => BookingConfirmationScreen());
                // orderController.placeOrder(
                //   productId: "6921572684a050c6a94f89da",
                //   paymentOption: "daily",
                //   totalDays: 30,
                //   deliveryAddress: {
                //     "name": addresses.name,
                //     "phoneNumber": addresses.phoneNumber,
                //     "addressLine1": addresses.addressLine1,
                //     "city": addresses.city,
                //     "state": addresses.state,
                //     "pincode": addresses.pincode,
                //   },
                // );
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
            )
          ],
        ),
      )),
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
