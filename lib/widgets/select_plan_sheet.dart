// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../screens/order_details/order_details_controller.dart';
import '../../constants/app_strings.dart';
import '../../constants/app_colors.dart';
import '../../screens/product_details/product_details_controller.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/app_text.dart';
import '../screens/select_address/select_address.dart';
import 'app_snackbar.dart';

class SelectPlanSheet extends StatelessWidget {
  const SelectPlanSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final ProductDetailsController controller = Get.find();

    final TextEditingController dayController = TextEditingController();
    final TextEditingController amountController = TextEditingController();

    /// LISTENERS FOR AUTO UPDATE
    dayController.addListener(() {
      controller.updateAmountFromDays(dayController, amountController);
    });

    amountController.addListener(() {
      controller.updateDaysFromAmount(dayController, amountController);
    });

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      maxChildSize: 0.95,
      minChildSize: 0.50,
      expand: false,
      builder: (context, sheetController) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          ),
          child: SingleChildScrollView(
            controller: sheetController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// --- Header ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  spacing: 60.w,
                  children: [
                    appText(
                      AppStrings.select_plan,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      textAlign: TextAlign.center,
                    ),
                    IconButton(
                      icon: Icon(Icons.close, size: 25.sp),
                      onPressed: () => Get.back(),
                    ),
                  ],
                ),

                SizedBox(height: 10.h),

                /// --- Customize My Plan ----
                Align(
                  alignment: AlignmentGeometry.centerLeft,
                  child: appText(
                    AppStrings.costomize_plan,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                SizedBox(height: 12.h),

                /// Input Row (Days + Amount + Convert)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    /// Days Column
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          appText(
                            "Days",
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                          SizedBox(height: 6.h),
                          appTextField(
                            controller: dayController,
                            textInputType: TextInputType.datetime,
                            hintText: AppStrings.enter_days,
                            textColor: AppColors.textBlack,
                            textSize: 13.sp,
                            textWeight: FontWeight.w600,
                            hintColor: AppColors.grey,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 11.h,
                            ),
                            maxLines: 1,
                            hintSize: 12.sp,
                            hintWeight: FontWeight.w400,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(width: 10.w),

                    /// Amount Column
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          appText(
                            "Amount",
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                          SizedBox(height: 6.h),
                          appTextField(
                            controller: amountController,
                            textInputType: TextInputType.number,
                            hintText: AppStrings.enter_amount,
                            textColor: AppColors.textBlack,
                            textSize: 13.sp,
                            textWeight: FontWeight.w600,
                            hintColor: AppColors.grey,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 11.h,
                            ),
                            maxLines: 1,
                            hintSize: 12.sp,
                            hintWeight: FontWeight.w400,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(width: 12.w),

                    /// Convert Button
                    GestureDetector(
                      onTap: () {
                        final int days =
                            int.tryParse(dayController.text.trim()) ?? 0;
                        final double amount =
                            double.tryParse(amountController.text.trim()) ??
                                0.0;

                        if (days <= 0 || amount <= 0) {
                          appSnackbar(
                              error: true,
                              title: "Invalid Input",
                              content: "Please enter valid days and amount");
                          return;
                        }

                        if (days < 5) {
                          appSnackbar(
                              error: true,
                              title: "Invalid Days",
                              content: "Days cannot be less than 5");
                          return;
                        }

                        if (amount < 50) {
                          appSnackbar(
                              error: true,
                              title: "Invalid Amount",
                              content: "Amount cannot be more less 50");
                          return;
                        }

                        // SAVE PLAN IN PRODUCT CONTROLLER
                        final productCtrl =
                            Get.find<ProductDetailsController>();
                        productCtrl.customDays.value = days;
                        productCtrl.customAmount.value = amount;

                        // Get.to(() =>
                        //     SelectAddress(product: productCtrl.product.value));
                        Get.back();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 18.w, vertical: 12.h),
                        decoration: BoxDecoration(
                          color: AppColors.gradientDarkBlue,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: appText(
                          AppStrings.convert,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 10.h),

                Obx(() {
                  if (controller.isLoading.value) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (controller.plans.isEmpty) {
                    return Center(child: appText("No plans available"));
                  }

                  return Column(
                    children: List.generate(controller.plans.length, (index) {
                      final plan = controller.plans[index];
                    

                      return Column(
                        children: [
                          InkWell(
                            onTap: () {
                              if (controller.selectedPlanIndex.value == index) {
                                // 🔹 Tapped the same plan → unselect
                                controller.selectedPlanIndex.value = -1;
                                controller.customDays.value = 0;
                                controller.customAmount.value = 0;
                              } else {
                                // 🔹 Selected a new plan
                                controller.selectApiPlan(index);
                              }
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /// Radio Button (visual only)
                                Radio<int>(
                                  value: index,
                                  groupValue:
                                      controller.selectedPlanIndex.value == -1
                                          ? null
                                          : controller.selectedPlanIndex.value,
                                  onChanged: (_) {
                                    // We handle everything in InkWell.onTap
                                  },
                                  activeColor: AppColors.primaryColor,
                                ),

                                /// Plan Content
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      /// Title Row
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          appText(
                                            plan.name,
                                            fontSize: 14.sp,
                                            fontWeight: controller
                                                        .selectedPlanIndex
                                                        .value ==
                                                    index
                                                ? FontWeight.w700
                                                : FontWeight.w600,
                                            color: AppColors.textBlack,
                                          ),
                                          if (plan.isRecommended)
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 8.w,
                                                  vertical: 4.h),
                                              decoration: BoxDecoration(
                                                color: AppColors.skyBlue,
                                                borderRadius:
                                                    BorderRadius.circular(8.r),
                                              ),
                                              child: appText(
                                                "Recommended",
                                                fontSize: 10.sp,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                        ],
                                      ),

                                      SizedBox(height: 4.h),

                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          appText(
                                            AppStrings.equivalent_time,
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.grey,
                                          ),
                                          appText(
                                            "${plan.days} Days",
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.grey,
                                          ),
                                        ],
                                      ),

                                      SizedBox(height: 4.h),

                                      if (plan.description != null &&
                                          plan.description!.trim().isNotEmpty)
                                        appText(
                                          plan.description!,
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.w400,
                                          color: AppColors.grey,
                                        ),

                                      SizedBox(height: 4.h),

                                      appText(
                                        "Total Amount : INR ${plan.totalAmount.toStringAsFixed(2)}",
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.primaryColor,
                                      ),

                                      SizedBox(height: 10.h),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(),
                        ],
                      );
                    }),
                  );
                }),

                SizedBox(height: 13.h),

                /// --- Final Selected Button ---
                appButton(
                  onTap: () {
                    final selected = controller.getSelectedPlan();

                    if (selected["days"] == 0 || selected["amount"] == 0) {
                      appSnackbar(
                          error: true, content: "Please select a plan!");
                      return;
                    }

                    /// ✅ Ensure controller is registered
                    final orderCtrl = Get.isRegistered<OrderDetailsController>()
                        ? Get.find<OrderDetailsController>()
                        : Get.put(OrderDetailsController());

                    orderCtrl.setCustomPlan(
                      selected["days"],
                      selected["amount"],
                    );

                    Get.back();
                  },
                  buttonColor: AppColors.primaryColor,
                  width: 170.w,
                  height: 40.h,
                  borderRadius: BorderRadius.circular(8.r),
                  child: Center(
                    child: appText(
                      AppStrings.selected,
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
