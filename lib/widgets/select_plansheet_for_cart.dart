// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../constants/app_strings.dart';
import '../../constants/app_colors.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/app_text.dart';
import '../models/plan_model.dart';
import 'app_toast.dart';

class SelectPlanSheetForCart extends StatefulWidget {
  final String productId;
  final List<PlanModel> plans;
  final int initialDays;
  final double initialAmount;
  final double totalProductAmount;

  final Function(int days, double amount) onPlanSelected;

  const SelectPlanSheetForCart({
    super.key,
    required this.productId,
    required this.plans,
    required this.initialDays,
    required this.totalProductAmount,
    required this.initialAmount,
    required this.onPlanSelected,
  });

  @override
  State<SelectPlanSheetForCart> createState() => _SelectPlanSheetForCartState();
}

class _SelectPlanSheetForCartState extends State<SelectPlanSheetForCart> {
  int selectedPlanIndex = -1;
  bool isUpdating = false;

  late TextEditingController dayController;
  late TextEditingController amountController;

  @override
  void initState() {
    super.initState();

    dayController = TextEditingController(text: widget.initialDays.toString());
    amountController = TextEditingController(
      text: widget.initialAmount > 0
          ? widget.initialAmount.toStringAsFixed(2)
          : "",
    );

    dayController.addListener(_updateAmountFromDays);
    amountController.addListener(_updateDaysFromAmount);
  }

  void _updateAmountFromDays() {
    if (isUpdating) return;
    isUpdating = true;

    final int days = int.tryParse(dayController.text.trim()) ?? 0;

    if (days <= 0) {
      amountController.text = "";
      isUpdating = false;
      return;
    }

    // 🔥 RAW calculation
    final double perDayRaw = widget.totalProductAmount / days;

    // 🔒 Normalize to 2 decimals
    final double perDay = double.parse(perDayRaw.toStringAsFixed(2));

    amountController.text = perDay.toStringAsFixed(2);

    isUpdating = false;
  }

  void _updateDaysFromAmount() {
    if (isUpdating) return;
    isUpdating = true;

    final double perDay = double.tryParse(amountController.text.trim()) ?? 0;

    if (perDay <= 0) {
      dayController.text = "";
      isUpdating = false;
      return;
    }

    final int days = (widget.totalProductAmount / perDay).round();
    dayController.text = days.toString();

    // 🔒 Re-normalize amount
    final double normalized =
        double.parse((widget.totalProductAmount / days).toStringAsFixed(2));

    amountController.text = normalized.toStringAsFixed(2);

    isUpdating = false;
  }

  @override
  void dispose() {
    dayController.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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

              /// --- Customize My Plan ----
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
                        appText(AppStrings.days,
                            fontSize: 14.sp, fontWeight: FontWeight.w600),
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
                        appText(AppStrings.amount_2,
                            fontSize: 14.sp, fontWeight: FontWeight.w600),
                        SizedBox(height: 6.h),
                        appTextField(
                          controller: amountController,
                          textInputType: const TextInputType.numberWithOptions(
                              decimal: true),
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

                          // ✅ FORMAT WHEN USER FINISHES INPUT
                          onFieldSubmitted: (_) {
                            final value =
                                double.tryParse(amountController.text.trim());

                            if (value != null) {
                              amountController.text = value.toStringAsFixed(2);
                            }
                          },
                        ),
                      ],
                    ),
                  ),

                  SizedBox(width: 12.w),

                  /// Convert Button
                  GestureDetector(
                    onTap: () {
                      final days = int.tryParse(dayController.text.trim()) ?? 0;
                      final amount =
                          double.tryParse(amountController.text.trim()) ?? 0;

                      if (days < 5 || amount < 50) {
                        appToast(
                          error: true,
                          content: AppStrings.minimum_5_days_and_50_amount_r,
                        );
                        return;
                      }

                      // 🔥 THIS IS THE MISSING PIECE
                      widget.onPlanSelected(days, amount);

                      // Reset radio selection (optional)
                      setState(() {
                        selectedPlanIndex = -1;
                      });

                      // Close sheet
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

              /// --- PLAN LIST ---
              if (widget.plans.isEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 30.h),
                  child: appText(
                    AppStrings.no_plans_available,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.grey,
                  ),
                )
              else
                Column(
                  children: List.generate(widget.plans.length, (index) {
                    final plan = widget.plans[index];

                    return Column(
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              selectedPlanIndex =
                                  selectedPlanIndex == index ? -1 : index;
                              dayController.text = plan.days.toString();
                              amountController.text =
                                  plan.perDayAmount.toStringAsFixed(0);
                            });
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Radio<int>(
                                value: index,
                                groupValue: selectedPlanIndex == -1
                                    ? null
                                    : selectedPlanIndex,
                                activeColor: AppColors.primaryColor,
                                onChanged: (_) {
                                  setState(() {
                                    selectedPlanIndex = index;
                                    dayController.text = plan.days.toString();
                                    amountController.text =
                                        plan.perDayAmount.toStringAsFixed(0);
                                  });
                                },
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    appText(
                                      plan.name,
                                      fontSize: 14.sp,
                                      fontWeight: selectedPlanIndex == index
                                          ? FontWeight.w700
                                          : FontWeight.w600,
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
                ),

              SizedBox(height: 13.h),

              /// --- Final Selected Button ---
              appButton(
                onTap: () {
                  final days = int.tryParse(dayController.text.trim()) ?? 0;
                  final amount =
                      double.tryParse(amountController.text.trim()) ?? 0;

                  if (days <= 0 || amount <= 0) {
                    appToast(
                      error: true,
                      content: AppStrings.please_select_or_customize_a_p,
                    );
                    return;
                  }

                  widget.onPlanSelected(days, amount);
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

              SizedBox(height: 13.h),
            ],
          ),
        ),
      ),
    );
  }
}
