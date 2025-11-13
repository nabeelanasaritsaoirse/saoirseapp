import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../constants/app_strings.dart';
import '../../constants/app_colors.dart';
import '../../screens/product_details/product_details_controller.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/app_text.dart';

class SelectPlanSheet extends StatelessWidget {
  const SelectPlanSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController dayController = TextEditingController();
    final TextEditingController amountController = TextEditingController();
    final ProductDetailsController controller = Get.put(
      ProductDetailsController(),
    );

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      maxChildSize: 0.95,
      minChildSize: 0.50,
      expand: false,
      builder: (context, sheetController) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
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
                    appText(AppStrings.select_plan,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        textAlign: TextAlign.center),
                    IconButton(
                      icon: Icon(
                        Icons.close,
                        size: 25.sp,
                      ),
                      onPressed: () => Get.back(),
                    )
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

                /// Input Row
                Row(
                  children: [
                    Expanded(
                      child: appTextField(
                        controller: dayController,
                        hintText: AppStrings.enter_days,
                        hintColor: AppColors.grey,
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 11.w, vertical: 8.h),
                        maxLines: 1,
                        hintSize: 10.sp,
                        hintWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 5.w),
                    Expanded(
                      child: appTextField(
                        controller: amountController,
                        hintText: AppStrings.enter_amount,
                        hintColor: AppColors.grey,
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 11.w, vertical: 8.h),
                        maxLines: 1,
                        hintSize: 10.sp,
                        hintWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 18.w, vertical: 12.h),
                      decoration: BoxDecoration(
                        color: AppColors.gradientDarkBlue,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Center(
                          child: appText(AppStrings.convert,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.white)),
                    )
                  ],
                ),

                SizedBox(height: 10.h),

                /// --- List of Plans ---
                Obx(() {
                  return Column(
                    children: List.generate(5, (index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Radio<int>(
                                value: index,
                                groupValue: controller.selectedPlanIndex.value,
                                activeColor: AppColors.gradientDarkBlue,
                                onChanged: (value) {
                                  controller.selectedPlanIndex.value = value!;
                                },
                              ),
                              // the content will be get fromt the api
                              appText("Pay INR 100 for 570 Days",
                                  fontSize: 14.sp, fontWeight: FontWeight.w600),
                              Spacer(),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8.w, vertical: 4.h),
                                decoration: BoxDecoration(
                                  color: AppColors.yellow,
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Text(
                                  index == 0
                                      ? AppStrings.auto_generated
                                      : AppStrings.recommented,
                                  style: TextStyle(fontSize: 10.sp),
                                ),
                              )
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 45.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    appText(AppStrings.equivalent_time,
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.grey),
                                    appText("570 ${AppStrings.days}",
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.grey),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    appText(
                                        "${AppStrings.start_on} 11 Nov 2025",
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.grey),
                                    appText("${AppStrings.end_on} 13 May 2026",
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.grey),
                                  ],
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
                SizedBox(height: 15.h),

                /// --- Final Selected Button ---
                appButton(
                    onTap: () {},
                    buttonColor: AppColors.primaryColor,
                    width: 170.w,
                    height: 40.h,
                    borderRadius: BorderRadius.circular(8.r),
                    child: Center(
                      child: appText(AppStrings.selected,
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.white),
                    ))
              ],
            ),
          ),
        );
      },
    );
  }
}
