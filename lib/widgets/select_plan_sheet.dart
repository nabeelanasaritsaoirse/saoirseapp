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
import '../constants/app_constant.dart';
import '../main.dart';
import '../screens/login/login_page.dart';
import 'app_loader.dart';
import 'app_toast.dart';

class SelectPlanSheet extends StatelessWidget {
  final String productId;

  const SelectPlanSheet({
    super.key,
    required this.productId,
  });

  @override
  Widget build(BuildContext context) {
    /// ✅ FIX: Find controller USING TAG
    final ProductDetailsController controller =
        Get.find<ProductDetailsController>(tag: productId);

    final TextEditingController dayController = TextEditingController();
    final TextEditingController amountController = TextEditingController();

    /// LISTENERS FOR AUTO UPDATE
    dayController.addListener(() {
      controller.updateAmountFromDays(dayController, amountController);
    });

    amountController.addListener(() {
      controller.updateDaysFromAmount(dayController, amountController);
    });

    return SafeArea(
      top: false,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// --- Header ---
              SizedBox(
                height: 30.h,
                child: Stack(
                  children: [
                    Center(
                      child: appText(
                        AppStrings.select_plan,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Positioned(
                      bottom: -6.h,
                      right: 0,
                      child: IconButton(
                        icon: Icon(Icons.close, size: 25.sp),
                        onPressed: () => Get.back(),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 10.h),

              /// --- Customize My Plan ---
              Align(
                alignment: Alignment.centerLeft,
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
                          double.tryParse(amountController.text.trim()) ?? 0.0;

                      // 🔹 VALIDATIONS (unchanged)
                      if (days <= 0 || amount <= 0) {
                        appToast(
                          error: true,
                          title: "Invalid Input",
                          content: "Please enter valid days and amount",
                        );
                        return;
                      }

                      if (days < 5) {
                        appToast(
                          error: true,
                          title: "Invalid Days",
                          content: "Days cannot be less than 5",
                        );
                        return;
                      }

                      if (amount < 50) {
                        appToast(
                          error: true,
                          title: "Invalid Amount",
                          content: "Amount cannot be more less 50",
                        );
                        return;
                      }

                      // 🔐 LOGIN CHECK (ONLY HERE)
                      final isLoggedIn = storage.read(AppConst.USER_ID) != null;

                      if (!isLoggedIn) {
                        Get.back(); // close bottom sheet first
                        Get.to(() => LoginPage());
                        return;
                      }

                      // ✅ ORIGINAL FLOW (unchanged)
                      controller.customDays.value = days;
                      controller.customAmount.value = amount;
                      Get.back();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 18.w,
                        vertical: 12.h,
                      ),
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

              /// --- Plans List ---
              Obx(() {
                if (controller.isProductLoading.value) {
                  return Center(child: appLoader());
                }

                if (controller.plans.isEmpty) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 30.h),
                    child: appText(
                      "No plans available",
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.grey,
                    ),
                  );
                }

                return Column(
                  children: List.generate(controller.plans.length, (index) {
                    final plan = controller.plans[index];

                    return Column(
                      children: [
                        InkWell(
                          onTap: () {
                            controller.selectedPlanIndex.value == index
                                ? controller.selectedPlanIndex.value = -1
                                : controller.selectApiPlan(index);
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Radio<int>(
                                value: index,
                                groupValue:
                                    controller.selectedPlanIndex.value == -1
                                        ? null
                                        : controller.selectedPlanIndex.value,
                                activeColor: AppColors.primaryColor,
                                onChanged: (_) {
                                  controller.selectApiPlan(index);
                                },
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
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
                                        ),
                                        if (plan.isRecommended)
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8.w, vertical: 4.h),
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
                                    appText(
                                      "Pay ${plan.perDayAmount.toStringAsFixed(0)} daily for ${plan.days} days",
                                      fontSize: 11.sp,
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
              Obx(() {
                final hasSelectedPlan =
                    controller.selectedPlanIndex.value != -1 ||
                        (controller.customDays.value > 0 &&
                            controller.customAmount.value > 0);

                if (!hasSelectedPlan) return SizedBox.shrink();

                return appButton(
                  onTap: () {
                    final selected = controller.getSelectedPlan();

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
                );
              }),

              SizedBox(height: 13.h),
            ],
          ),
        ),
      ),
    );
  }
}















// // ignore_for_file: deprecated_member_use

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';

// import '../../screens/order_details/order_details_controller.dart';
// import '../../constants/app_strings.dart';
// import '../../constants/app_colors.dart';
// import '../../screens/product_details/product_details_controller.dart';
// import '../../widgets/app_button.dart';
// import '../../widgets/app_text_field.dart';
// import '../../widgets/app_text.dart';
// import 'app_loader.dart';
// import 'app_toast.dart';

// class SelectPlanSheet extends StatelessWidget {
//    final String productId;

//   const SelectPlanSheet({
//     super.key,
//     required this.productId,
//   });

//   @override
//   Widget build(BuildContext context) {
//      final ProductDetailsController controller =
//         Get.find<ProductDetailsController>(tag: productId);

//     final TextEditingController dayController = TextEditingController();
//     final TextEditingController amountController = TextEditingController();

//     /// LISTENERS FOR AUTO UPDATE
//     dayController.addListener(() {
//       controller.updateAmountFromDays(dayController, amountController);
//     });

//     amountController.addListener(() {
//       controller.updateDaysFromAmount(dayController, amountController);
//     });

//     return SafeArea(
//       top: false,
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
//         decoration: BoxDecoration(
//           color: AppColors.white,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
//         ),
//         child: SingleChildScrollView(
//           physics: const BouncingScrollPhysics(),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               /// --- Header ---
//               SizedBox(
//                 height: 30.h,
//                 child: Stack(
//                   children: [
//                     Center(
//                       child: appText(
//                         AppStrings.select_plan,
//                         fontSize: 18.sp,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     Positioned(
//                       bottom: -6.h,
//                       right: 0,
//                       child: IconButton(
//                         icon: Icon(Icons.close, size: 25.sp),
//                         onPressed: () => Get.back(),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               SizedBox(height: 10.h),

//               /// --- Customize My Plan ----
//               Align(
//                 alignment: Alignment.centerLeft,
//                 child: appText(
//                   AppStrings.costomize_plan,
//                   fontSize: 15.sp,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),

//               SizedBox(height: 12.h),

//               /// Input Row (Days + Amount + Convert)
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: [
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         appText(
//                           "Days",
//                           fontSize: 14.sp,
//                           fontWeight: FontWeight.w600,
//                         ),
//                         SizedBox(height: 6.h),
//                         appTextField(
//                           controller: dayController,
//                           textInputType: TextInputType.datetime,
//                           hintText: AppStrings.enter_days,
//                           textColor: AppColors.textBlack,
//                           textSize: 13.sp,
//                           textWeight: FontWeight.w600,
//                           hintColor: AppColors.grey,
//                           contentPadding: EdgeInsets.symmetric(
//                             horizontal: 12.w,
//                             vertical: 11.h,
//                           ),
//                           maxLines: 1,
//                           hintSize: 12.sp,
//                           hintWeight: FontWeight.w400,
//                         ),
//                       ],
//                     ),
//                   ),

//                   SizedBox(width: 10.w),

//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         appText(
//                           "Amount",
//                           fontSize: 14.sp,
//                           fontWeight: FontWeight.w600,
//                         ),
//                         SizedBox(height: 6.h),
//                         appTextField(
//                           controller: amountController,
//                           textInputType: TextInputType.number,
//                           hintText: AppStrings.enter_amount,
//                           textColor: AppColors.textBlack,
//                           textSize: 13.sp,
//                           textWeight: FontWeight.w600,
//                           hintColor: AppColors.grey,
//                           contentPadding: EdgeInsets.symmetric(
//                             horizontal: 12.w,
//                             vertical: 11.h,
//                           ),
//                           maxLines: 1,
//                           hintSize: 12.sp,
//                           hintWeight: FontWeight.w400,
//                         ),
//                       ],
//                     ),
//                   ),

//                   SizedBox(width: 12.w),

//                   /// Convert Button
//                   GestureDetector(
//                     onTap: () {
//                       final int days =
//                           int.tryParse(dayController.text.trim()) ?? 0;
//                       final double amount =
//                           double.tryParse(amountController.text.trim()) ?? 0.0;

//                       if (days <= 0 || amount <= 0) {
//                         appToast(
//                           error: true,
//                           title: "Invalid Input",
//                           content: "Please enter valid days and amount",
//                         );
//                         return;
//                       }

//                       if (days < 5) {
//                         appToast(
//                           error: true,
//                           title: "Invalid Days",
//                           content: "Days cannot be less than 5",
//                         );
//                         return;
//                       }

//                       if (amount < 50) {
//                         appToast(
//                           error: true,
//                           title: "Invalid Amount",
//                           content: "Amount cannot be more less 50",
//                         );
//                         return;
//                       }

//                       controller.customDays.value = days;
//                       controller.customAmount.value = amount;
//                       Get.back();
//                     },
//                     child: Container(
//                       padding: EdgeInsets.symmetric(
//                         horizontal: 18.w,
//                         vertical: 12.h,
//                       ),
//                       decoration: BoxDecoration(
//                         color: AppColors.gradientDarkBlue,
//                         borderRadius: BorderRadius.circular(10.r),
//                       ),
//                       child: appText(
//                         AppStrings.convert,
//                         fontSize: 12.sp,
//                         fontWeight: FontWeight.w600,
//                         color: AppColors.white,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),

//               SizedBox(height: 10.h),

//               Obx(() {
//                 if (controller.isProductLoading.value) {
//                   return Center(child: appLoader());
//                 } 

//                 if (controller.plans.isEmpty) {
//                   return Padding(
//                     padding: EdgeInsets.symmetric(vertical: 30.h),
//                     child: appText(
//                       "No plans available",
//                       fontSize: 14.sp,
//                       fontWeight: FontWeight.w600,
//                       color: AppColors.grey,
//                     ),
//                   );
//                 }

//                 return Column(
//                   children: List.generate(controller.plans.length, (index) {
//                     final plan = controller.plans[index];

//                     return Column(
//                       children: [
//                         InkWell(
//                           onTap: () {
//                             controller.selectedPlanIndex.value == index
//                                 ? controller.selectedPlanIndex.value = -1
//                                 : controller.selectApiPlan(index);
//                           },
//                           child: Row(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Radio<int>(
//                                 value: index,
//                                 groupValue:
//                                     controller.selectedPlanIndex.value == -1
//                                         ? null
//                                         : controller.selectedPlanIndex.value,
//                                 activeColor: AppColors.primaryColor,
//                                 onChanged: (_) {
//                                   controller.selectApiPlan(index);
//                                 },
//                               ),
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         appText(
//                                           plan.name,
//                                           fontSize: 14.sp,
//                                           fontWeight: controller
//                                                       .selectedPlanIndex
//                                                       .value ==
//                                                   index
//                                               ? FontWeight.w700
//                                               : FontWeight.w600,
//                                           color: AppColors.textBlack,
//                                         ),
//                                         if (plan.isRecommended)
//                                           Container(
//                                             padding: EdgeInsets.symmetric(
//                                                 horizontal: 8.w, vertical: 4.h),
//                                             decoration: BoxDecoration(
//                                               color: AppColors.skyBlue,
//                                               borderRadius:
//                                                   BorderRadius.circular(8.r),
//                                             ),
//                                             child: appText(
//                                               "Recommended",
//                                               fontSize: 10.sp,
//                                               fontWeight: FontWeight.w600,
//                                             ),
//                                           ),
//                                       ],
//                                     ),
//                                     SizedBox(height: 4.h),
//                                     appText(
//                                       "Pay ${plan.perDayAmount.toStringAsFixed(0)} daily for ${plan.days} days",
//                                       fontSize: 11.sp,
//                                       color: AppColors.grey,
//                                     ),
//                                     SizedBox(height: 4.h),
//                                     appText(
//                                       "Total Amount : INR ${plan.totalAmount.toStringAsFixed(2)}",
//                                       fontSize: 12.sp,
//                                       fontWeight: FontWeight.w600,
//                                       color: AppColors.primaryColor,
//                                     ),
//                                     SizedBox(height: 10.h),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         Divider(),
//                       ],
//                     );
//                   }),
//                 );
//               }),

//               SizedBox(height: 13.h),

//               /// --- Final Selected Button ---
//               Obx(() {
//                 final hasSelectedPlan =
//                     controller.selectedPlanIndex.value != -1 ||
//                         (controller.customDays.value > 0 &&
//                             controller.customAmount.value > 0);

//                 if (!hasSelectedPlan) return SizedBox.shrink();

//                 return appButton(
//                   onTap: () {
//                     final selected = controller.getSelectedPlan();

//                     final orderCtrl = Get.isRegistered<OrderDetailsController>()
//                         ? Get.find<OrderDetailsController>()
//                         : Get.put(OrderDetailsController());

//                     orderCtrl.setCustomPlan(
//                       selected["days"],
//                       selected["amount"],
//                     );

//                     Get.back();
//                   },
//                   buttonColor: AppColors.primaryColor,
//                   width: 170.w,
//                   height: 40.h,
//                   borderRadius: BorderRadius.circular(8.r),
//                   child: Center(
//                     child: appText(
//                       AppStrings.selected,
//                       fontSize: 17.sp,
//                       fontWeight: FontWeight.w600,
//                       color: AppColors.white,
//                     ),
//                   ),
//                 );
//               }),
//               SizedBox(height: 13.h),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
