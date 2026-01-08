import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../constants/app_colors.dart';
import '../../widgets/app_text.dart';
import '../../widgets/custom_appbar.dart';
import 'add_money_controller.dart';

class AddMoneyScreen extends StatelessWidget {
  AddMoneyScreen({super.key});

  final AddMoneyController controller = Get.find<AddMoneyController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paperColor,
      appBar: CustomAppBar(
        title: "Add Money",
        showBack: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    appText(
                      "Enter Amount",
                      fontSize: 17.sp,
                      color: AppColors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        appText(
                          "₹",
                          fontSize: 38.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.black87,
                        ),
                        SizedBox(width: 8.w),
                        Flexible(
                          child: IntrinsicWidth(
                            child: Obx(() {
                              return TextField(
                                controller: controller.amountController,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d+\.?\d{0,2}'),
                                  ),
                                ],
                                onChanged: controller.onAmountChanged,
                                style: TextStyle(
                                  fontSize: 38.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.black87,
                                ),
                                decoration: InputDecoration(
                                  hintText:
                                      controller.showSuffix.value ? '' : '0.00',
                                  hintStyle: TextStyle(
                                    fontSize: 38.sp,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.black26,
                                  ),
                                  border: InputBorder.none,
                                  suffixText: controller.showSuffix.value
                                      ? ".00"
                                      : null,
                                  suffixStyle: TextStyle(
                                    fontSize: 38.sp,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.black,
                                  ),
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                ),
                                textAlign: TextAlign.left,
                                autofocus: true,
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      height: 2.h,
                      width: 180.w,
                      color: AppColors.shadowColor,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20.w),
            child: SizedBox(
              width: double.infinity,
              height: 45.h,
              child: ElevatedButton(
                onPressed: controller.addMoney,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.lightAmber,
                  foregroundColor: AppColors.black87,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: appText(
                  "Add Money",
                  fontSize: 16.sp,
                  color: AppColors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
