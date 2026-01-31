import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:saoirse_app/constants/app_colors.dart';
import 'package:saoirse_app/screens/autopay_dashboard/autopay_dashboard_controller.dart';
import 'package:saoirse_app/widgets/app_button.dart';
import 'package:saoirse_app/widgets/app_text.dart';
import 'package:saoirse_app/widgets/app_text_field.dart';


class AutopaySettingsSheet extends StatelessWidget {
   AutopaySettingsSheet({super.key});

  final AutopayController controller = Get.find();


  

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          dragHandle(),
          SizedBox(height: 12.h),

          // HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              appText(
                'Autopay Preference',
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
              GestureDetector(
                onTap: () => Get.back(),
                child: Icon(Icons.close, size: 20.sp),
              ),
            ],
          ),

          SizedBox(height: 20.h),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  enableAutopay(),
                  SizedBox(height: 16.h),
                  priorityInput(),
                  SizedBox(height: 16.h),
                  pauseAutopay(),
                  SizedBox(height: 16.h),
                  Container(
                    height: 1.h,
                    color: AppColors.grey,
                  ),
                  SizedBox(height: 8.h),
                  skipDates(),
                ],
              ),
            ),
          ),

          SizedBox(height: 10.h),

          appButton(
            buttonText: 'SAVE CHANGES',
            onTap: () {
              controller.saveAutopaySettings();
              //  controller.saveSkipDates(orderId);
              controller.saveSkipDates(
  controller.selectedOrderId.value,
);


            },
            buttonColor: AppColors.primaryColor,
            textColor: AppColors.white,
            height: 48.h,
          )
        ],
      ),
    );
  }

  Widget dragHandle() {
    return Center(
      child: Container(
        width: 40.w,
        height: 4.h,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  Widget enableAutopay() {
    return Obx(() {
      return SwitchListTile(
        contentPadding: EdgeInsets.zero,
        title: appText('Enable Autopay',
            fontWeight: FontWeight.w600, textAlign: TextAlign.start),
        value: controller.autopayEnabled.value,
        onChanged: (v) => controller.autopayEnabled.value = v,
        // ignore: deprecated_member_use
        activeColor: AppColors.primaryColor,
      );
    });
  }

  Widget priorityInput() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        appText(
          'Priority (1-100)',
          fontWeight: FontWeight.w600,
        ),
        SizedBox(
          width: 80.w,
          child: appTextField(
            textColor: AppColors.black,
            controller: controller.priorityCtrl,
            textInputType: TextInputType.number,
            hintText: '85',
            hintColor: AppColors.textGray,
          ),
        ),
      ],
    );
  }

  Widget pauseAutopay() {
    return Obx(() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          appText('Pause Autopay', fontWeight: FontWeight.w600),
          Switch(
            value: controller.pauseAutopay.value,
            onChanged: (v) => controller.pauseAutopay.value = v,
            // ignore: deprecated_member_use
            activeColor: AppColors.primaryColor,
          ),
        ],
      );
    });
  }

  Widget skipDates() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            appText(
              'Skip Dates',
              fontWeight: FontWeight.w600,
            ),
            GestureDetector(
              onTap: () => pickSkipDate(Get.context!),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.add, color: Colors.white, size: 16),
                    SizedBox(width: 4.w),
                    appText(
                      'Add',
                      color: AppColors.white,
                      fontSize: 12.sp,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        Obx(() {
          if (controller.skipDates.isEmpty) {
            return Padding(
              padding: EdgeInsets.only(top: 8.h),
              child: appText(
                'No skip dates added',
                fontSize: 12.sp,
                color: AppColors.grey,
              ),
            );
          }

          return Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: controller.skipDates.map((date) {
              return Container(
                margin: EdgeInsets.only(bottom: 8.h),
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.calendar_month_rounded,
                        color: AppColors.textGray),
                    appText(

                     
                        DateFormat('d MMMM yyyy').format(date),
                        fontWeight: FontWeight.w600,
                        fontSize: 16.sp),
                    GestureDetector(
                      child: Icon(Icons.delete_outline, color: Colors.red),
                      onTap: () {
                        controller.removeSkipDate(date);
                      },
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        }),
      ],
    );
  }

  Future<void> pickSkipDate(BuildContext context) async {
    final AutopayController controller = Get.find();

    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (selectedDate != null) {
      controller.addSkipDate(selectedDate);
    }
  }
}
