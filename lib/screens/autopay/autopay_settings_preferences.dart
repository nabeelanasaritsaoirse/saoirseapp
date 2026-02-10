import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:saoirse_app/constants/app_colors.dart';

import 'package:saoirse_app/widgets/app_button.dart';
import 'package:saoirse_app/widgets/app_text.dart';
import 'package:saoirse_app/widgets/app_text_field.dart';

import 'autopay_dashboard_controller.dart';

class AutopaySettingsSheet extends StatelessWidget {
  AutopaySettingsSheet({super.key});

  final AutopayController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    if (controller.selectedOrderId.value.isEmpty) {
      final status = controller.autopayStatus.value;
      if (status != null && status.data.orders.isNotEmpty) {
        final fallbackOrderId = status.data.orders.first.orderId;
        controller.selectedOrderId.value = fallbackOrderId;
        controller.applyAutopayStatusForOrder(fallbackOrderId);
        log("AutopaySettingsSheet: fallback selectedOrderId = $fallbackOrderId");
      }
    }

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

          Obx(
            () => appButton(
              buttonText: controller.isSkipDateSaving.value
                  ? 'SAVING...'
                  : 'SAVE CHANGES',
              onTap: controller.isSkipDateSaving.value
                  ? () {}
                  : () async {
                      // Save global autopay settings first
                      await controller.saveAutopaySettings();

                      // Then save skip dates for the currently selected order
                      final orderId = controller.selectedOrderId.value;

                      if (orderId.isEmpty) {
                        log("AutopaySettingsSheet: selectedOrderId is empty, skip dates not saved");
                        return;
                      }

                      await controller.saveSkipDates(orderId);
                      log("Skip dates saved: ${controller.skipDates.toString()}");
                    },
              buttonColor: controller.isSkipDateSaving.value
                  ? AppColors.grey
                  : AppColors.primaryColor,
              textColor: AppColors.white,
              height: 48.h,
            ),
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
      // Check if autopay is currently paused by checking the status
      final isCurrentlyPaused = controller.pauseAutopay.value;
      final orderId = controller.selectedOrderId.value;

      // Get the pauseUntil date from status if available
      DateTime? pauseUntilDate;
      if (controller.autopayStatus.value != null && orderId.isNotEmpty) {
        final order = controller.autopayStatus.value!.data.orders
            .firstWhereOrNull((o) => o.orderId == orderId);
        if (order != null && order.autopay.pausedUntil != null) {
          // Check if pausedUntil is already a DateTime or needs parsing
          if (order.autopay.pausedUntil is DateTime) {
            pauseUntilDate = order.autopay.pausedUntil as DateTime;
          } else if (order.autopay.pausedUntil is String) {
            pauseUntilDate =
                DateTime.parse(order.autopay.pausedUntil as String);
          }
        }
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  appText(
                    isCurrentlyPaused ? 'Autopay Paused' : 'Pause Autopay',
                    fontWeight: FontWeight.w600,
                  ),
                  if (pauseUntilDate != null && isCurrentlyPaused)
                    Padding(
                      padding: EdgeInsets.only(top: 4.h),
                      child: appText(
                        'Until ${DateFormat('dd MMM yyyy').format(pauseUntilDate)}',
                        fontSize: 12.sp,
                        color: AppColors.textGray,
                      ),
                    ),
                ],
              ),
              Switch(
                value:
                    !isCurrentlyPaused, // Switch shows enabled when NOT paused
                onChanged: (v) async {
                  // v = true means switch is ON (autopay active)
                  // v = false means switch is OFF (autopay paused)
                  final shouldPause = !v;
                  await controller.togglePauseAutopay(shouldPause);
                },
                // ignore: deprecated_member_use
                activeColor: AppColors.primaryColor,
              ),
            ],
          ),

          // Add resume button if autopay is paused
          if (isCurrentlyPaused &&
              pauseUntilDate != null &&
              pauseUntilDate.isAfter(DateTime.now()))
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.play_arrow_rounded,
                    color: Colors.white, size: 18.sp),
                SizedBox(width: 8.w),
                appText(
                  'Resume Autopay Now',
                  color: Colors.green,
                  fontWeight: FontWeight.w600,
                ),
              ],
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
                    appText(DateFormat('d MMMM yyyy').format(date),
                        fontWeight: FontWeight.w600, fontSize: 16.sp),
                    GestureDetector(
                      child: Icon(Icons.delete_outline, color: Colors.red),
                      onTap: () async {
                        await controller.removeSkipDateApi(date);
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
