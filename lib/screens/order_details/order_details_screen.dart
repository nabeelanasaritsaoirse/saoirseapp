import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../constants/app_assets.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';

import '../../widgets/app_button.dart';
import '../../widgets/app_text.dart';
import '../../widgets/app_text_field.dart';


class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final couponController = TextEditingController();
    return Scaffold(
      backgroundColor: AppColors.paperColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.white, size: 24.sp),
          onPressed: () => Get.back(),
        ),
        title: appText(
          AppStrings.editLabel,
          color: AppColors.white,
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
        ),
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
              height: 120.h,
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
                        "Albert Dan J",
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
                          appText(
                              "United State\n1234 Maplewood Lane\nSpringfeild,IL 62704",
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
                                "+45 5696566",
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
                              onTap: () {},
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
                  borderRadius: BorderRadius.circular(8.r)),
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
                    height: 80.h,
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
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
                          child: Image.asset(
                            AppAssets.iphone,
                            fit: BoxFit.cover,
                          ),
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
                                  appText(
                                    "IPhone 14",
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  appText(
                                    "${AppStrings.qty} 1",
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ],
                              ),
                              appText(
                                "Red | 1TB",
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                              ),
                              appText(
                                "₹ 53999",
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                              ),
                              appText(
                                "Plan - ₹100/200 Days",
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                              )
                            ],
                          ),
                        )
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
              height: 190.h,
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
                      label: "Iphone 14 ${AppStrings.total_ex_tax}",
                      content: "₹ 52999"),
                  buildPriceInfo(label: AppStrings.tax, content: "₹ 950"),
                  buildPriceInfo(label: AppStrings.market_fee, content: "₹ 50"),
                  buildPriceInfo(
                      label: AppStrings.shipping_charge, content: "₹ Free"),
                  Divider(
                    color: AppColors.grey,
                  ),
                  buildPriceInfo(
                      label: AppStrings.total_amount, content: "₹ 53999"),
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
                onTap: () {},
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
                ))
          ],
        ),
      )),
    );
  }

  Widget buildPriceInfo({
    required String label,
    required String content,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        appText(
          label,
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.grey,
          maxLines: 2,
        ),
        appText(
          content,
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
        ),
      ],
    );
  }
}
