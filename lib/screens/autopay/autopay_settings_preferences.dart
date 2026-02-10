// ignore_for_file: deprecated_member_use

import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

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
              buttonText: controller.isSkipDateSaving.value ||
                      controller.isSettingsLoading.value
                  ? 'SAVING...'
                  : 'SAVE CHANGES',
              onTap: controller.isSkipDateSaving.value ||
                      controller.isSettingsLoading.value
                  ? () {}
                  : () async {
                      
                      await controller.saveOrderPriority();

                   
                      final orderId = controller.selectedOrderId.value;
                      if (orderId.isNotEmpty) {
                        await controller.saveSkipDates(orderId);
                      }

                      log("AutopaySettingsSheet: Save button tapped. isSettingsLoading=${controller.isSettingsLoading.value}, isSkipDateSaving=${controller.isSkipDateSaving.value}, selectedOrderId=${controller.selectedOrderId.value}");

               
                      Get.back();
                    },
              buttonColor: controller.isSkipDateSaving.value ||
                      controller.isSettingsLoading.value
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
      final orderId = controller.selectedOrderId.value;
      bool isEnabled = controller.autopayEnabled.value;

      if (controller.autopayStatus.value != null && orderId.isNotEmpty) {
        final order = controller.autopayStatus.value!.data.orders
            .firstWhereOrNull((o) => o.orderId == orderId);
        if (order != null) {
          isEnabled = order.autopay.enabled;
        }
      }

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          appText(
            'Enable Autopay',
            fontWeight: FontWeight.w600,
          ),
          Switch(
            value: isEnabled,
            onChanged: orderId.isNotEmpty
                ? (value) async {
                    if (value) {
                      final priority =
                          int.tryParse(controller.priorityCtrl.text) ?? 1;
                      await controller.enableAutopayForOrder(orderId,
                          customPriority: priority);
                    } else {
                      await controller.disableAutopayForOrder(orderId);
                    }
                  }
                : null,
            activeColor: AppColors.primaryColor,
          ),
        ],
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
            onChanged: (value) async {
          
              final parsed = int.tryParse(value);
              if (parsed != null && parsed >= 1 && parsed <= 100) {
             
                await Future.delayed(Duration(milliseconds: 500));
                await controller.saveOrderPriority();
              }
            },
          ),
        ),
      ],
    );
  }

 

  Widget pauseAutopay() {
    return Obx(() {
      
      final isCurrentlyPaused = controller.pauseAutopay.value;
      final orderId = controller.selectedOrderId.value;

      DateTime? pauseUntilDate;
      if (controller.autopayStatus.value != null && orderId.isNotEmpty) {
        final order = controller.autopayStatus.value!.data.orders
            .firstWhereOrNull((o) => o.orderId == orderId);
        if (order != null && order.autopay.pausedUntil != null) {
     
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
                value: !isCurrentlyPaused,
                onChanged: (v) async {
                  final shouldPause = !v;
                  await controller.togglePauseAutopay(shouldPause);
                },
                activeColor: AppColors.primaryColor,
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
