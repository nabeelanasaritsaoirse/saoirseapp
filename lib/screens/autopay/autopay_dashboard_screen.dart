// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../constants/app_assets.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_loader.dart';
import '../../widgets/app_text.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/custom_appbar.dart';
import 'autopay_dashboard_controller.dart';
import 'autopay_settings_preferences.dart';

class AutopayDashboardScreen extends StatelessWidget {
  AutopayDashboardScreen({super.key});

  final AutopayController controller = Get.put(AutopayController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.offWhite,
      appBar: CustomAppBar(
        title: AppStrings.AutopayDashboard_Title,
        showBack: true,
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              AppAssets.globalSetings,
              width: 18.h,
              height: 18.h,
              colorFilter: ColorFilter.mode(
                AppColors.white,
                BlendMode.srcIn,
              ),
            ),
            onPressed: () async {
              await controller.fetchAutopaySettings();
              Get.dialog(
                AutopaySettingsDialog(),
                barrierDismissible: true,
              );
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return appLoader();
        }
        // if (controller.errorMessage.isNotEmpty) {
        //   return Center(
        //     child: appText(
        //       controller.errorMessage.value,
        //       color: AppColors.red,
        //     ),
        //   );
        // }

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(10.w),
                child: walletCard(),
              ),
              SizedBox(height: 12.h),
              forecastAndList(),
              SizedBox(height: 20.h),
            ],
          ),
        );
      }),
    );
  }

  Widget walletCard() {
    return Container(
      padding: EdgeInsets.only(
        left: 12.w,
        top: 12.h,
        right: 12.w,
        bottom: 10.h,
      ),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppColors.black,
            blurRadius: 12.0,
          ),
        ],
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0B0F5C), Color(0xFF1B2AAE)],
        ),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Obx(() {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            appText(
              '₹ ${controller.walletBalance.value.toStringAsFixed(2)}',
              color: AppColors.white,
              fontSize: 26.sp,
              fontWeight: FontWeight.bold,
            ),
            SizedBox(height: 4.h),
            appText(
              'Wallet Balance',
              fontSize: 14.sp,
              color: AppColors.grey,
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                streakBox(
                  icon: Icons.warning_amber_rounded,
                  text: 'Funds for ${controller.daysBalanceLasts.value} Days',
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF7B2FF7),
                      Color.fromARGB(255, 216, 78, 221)
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                streakBox(
                  icon: Icons.local_fire_department,
                  text: '${controller.currentStreak.value} Day Streak',
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF8C42), Color(0xFFFF5F1F)],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Container(
              height: 1.h,
              color: AppColors.grey,
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                appText(
                  'Daily Deductions:',
                  fontSize: 14.sp,
                  color: AppColors.grey,
                ),
                appText(
                  '₹${controller.dailyDeduction.value}',
                  fontSize: 14.sp,
                  color: AppColors.white,
                ),
              ],
            ),
          ],
        );
      }),
    );
  }

  Widget streakBox({
    required IconData icon,
    required String text,
    required LinearGradient gradient,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.15),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14.sp,
            color: Colors.white,
          ),
          appText(
            text,
            fontSize: 12.sp,
            color: AppColors.white,
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    );
  }

  Widget forecastAndList() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.r),
          topRight: Radius.circular(30.r),
          bottomLeft: Radius.circular(30.r),
          bottomRight: Radius.circular(30.r),
        ),
      ),
      child: Obx(() {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            appText(
              'Forecast & Action',
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
            SizedBox(height: 12.h),
            SizedBox(
              width: double.infinity,
              height: 44.h,
              child: appButton(
                onTap: () {},
                buttonText: 'Quick Add ₹${controller.suggestedTopUp.value}',
                buttonColor: AppColors.primaryColor,
                textColor: AppColors.white,
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            SizedBox(height: 16.h),
            Column(
              children: controller.items.isEmpty
                  ? [
                      appText(
                        'No autopay orders found',
                        fontSize: 13.sp,
                        color: AppColors.grey,
                      ),
                    ]
                  : controller.items.map((item) => autopayCard(item)).toList(),
            ),
          ],
        );
      }),
    );
  }

  Widget autopayCard(AutopayItem item) {
    final isDisabled = !item.enabled;

    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color:
            
            AppColors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: AppColors.offWhite,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: appText(
                item.title,
                maxLines: 2,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                textAlign: TextAlign.start,
              )),
              SizedBox(width: 6.w),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      appText(
                        isDisabled ? 'Inactive' : 'Active',
                        fontSize: 11.sp,
                        color: isDisabled ? Colors.red : AppColors.green,
                        fontWeight: FontWeight.w500,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                        onTap: () {
                          final controller = Get.find<AutopayController>();

                          controller.selectedOrderId.value = item.orderId;
                          controller.applyAutopayStatusForOrder(item.orderId);

                          // OPEN BOTTOM SHEET
                          showAutopayPreferenceSheet(Get.context!);
                        },
                        child: Icon(
                          Icons.open_in_new_rounded,
                          size: 18.sp,
                          color: AppColors.skyBlue,
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 6.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 2.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.lightAmber,
                      borderRadius: BorderRadius.circular(5.r),
                    ),
                    child: appText(
                      'Priority: ${item.priority}',
                      fontSize: 11.sp,
                      color: AppColors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              appText(
                '₹${item.perDay}/day',
                fontSize: 13.sp,
                color: AppColors.black,
              ),
              appText(
                'Remaining: ₹${item.remaining}',
                fontSize: 12.sp,
                color: AppColors.black,
              ),
            ],
          ),
          SizedBox(height: 8.h),
          customGradientProgress(
            value: item.progress / 100.0,
          )
        ],
      ),
    );
  }
}

Widget customGradientProgress({
  required double value,
}) {
  return Container(
    height: 8.h,
    width: double.infinity,
    decoration: BoxDecoration(
      color: const Color(0xFFE8EEFF),
      borderRadius: BorderRadius.circular(50),
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: constraints.maxWidth * value.clamp(0.0, 1.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color(0xFF9CB6FF),
                    Color(0xFF5A7CFF),
                    Color(0xFF4A5BFF),
                  ],
                ),
                borderRadius: BorderRadius.circular(50),
              ),
            ),
          );
        },
      ),
    ),
  );
}

//                                                                                        AUTOPAY SETTINGS DIALOGBOX
class AutopaySettingsDialog extends StatelessWidget {
  AutopaySettingsDialog({super.key});

  final AutopayController controller = Get.find<AutopayController>();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.r)),
      child: Obx(() {
        if (controller.isSettingsLoading.value) {
          return appLoader();
        }

        return SizedBox(
          height: MediaQuery.of(context).size.height * .9.h,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      autopayTitle(),
                      switchTile(
                        'Enable Autopay',
                        controller.autopayEnabled.value,
                        (v) => controller.autopayEnabled.value = v,
                      ),
                      SizedBox(height: 10.h),
                      timePreference(),
                      SizedBox(height: 14.h),
                      appText('Wallet Reserves', fontWeight: FontWeight.w600),
                      SizedBox(height: 8.h),
                      appTextField(
                        controller: controller.minBalanceCtrl,
                        hintText: "₹Minimum Balance Lock",
                        fillColor: AppColors.white,
                        hintColor: AppColors.grey,
                        textColor: AppColors.black,
                        onChanged: (v) => controller.minimumBalanceLock.value =
                            int.tryParse(v) ?? 0,
                        textInputType: TextInputType.number,
                      ),
                      SizedBox(height: 10.h),
                      appTextField(
                        controller: controller.lowBalanceCtrl,
                        hintText: "₹ Low Balance Threshold",
                        fillColor: AppColors.white,
                        hintColor: AppColors.grey,
                        textColor: AppColors.black,
                        onChanged: (v) => controller.lowBalanceThreshold.value =
                            int.tryParse(v) ?? 0,
                        textInputType: TextInputType.number,
                      ),
                      SizedBox(height: 14.h),

//                                                                                                   REMINDER

                      appText('Reminder', fontWeight: FontWeight.w600),
                      SizedBox(height: 8.h),
                      appTextField(
                        controller: controller.reminderHoursCtrl,
                        hintText: 'Hours Before Payment (1–12)',
                        fillColor: AppColors.white,
                        hintColor: AppColors.grey,
                        textColor: AppColors.black,
                        onChanged: (v) {
                          controller.reminderHoursBefore.value =
                              int.tryParse(v) ?? 1;
                        },
                        textInputType: TextInputType.number,
                        suffixWidget: appText(
                          'hours',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 14.h),

//                                                                                   NOTIFICATION PREFERENCES

                      appText('Notification Preferences',
                          fontWeight: FontWeight.w600),
                      SizedBox(height: 10.h),
                      switchTile(
                        'Autopay Success',
                        controller.notifyAutopaySuccess.value,
                        (v) => controller.notifyAutopaySuccess.value = v,
                      ),
                      switchTile(
                        'Autopay Failed',
                        controller.notifyAutopayFailed.value,
                        (v) => controller.notifyAutopayFailed.value = v,
                      ),
                      switchTile(
                        'Low Balance Alert',
                        controller.notifyLowBalance.value,
                        (v) => controller.notifyLowBalance.value = v,
                      ),
                      switchTile(
                        'Daily Reminder',
                        controller.notifyDailyReminder.value,
                        (v) => controller.notifyDailyReminder.value = v,
                      ),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),

//                                                                                SAVE & CANCEL BUTTONS

              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Row(
                  children: [
                    Expanded(
                      child: appButton(
                        onTap: () => Get.back(),
                        buttonText: "Cancel",
                        textColor: AppColors.primaryColor,
                        buttonColor: AppColors.white,
                        borderColor: AppColors.primaryColor,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: appButton(
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          controller.saveAutopaySettings();
                        },
                        buttonText: "Save ",
                        textColor: AppColors.white,
                        buttonColor: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

//                                                                                   AUTOPAY SETTINGS Title
  Widget autopayTitle() {
    return Center(
      child: Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: appText('Autopay Settings',
              fontSize: 18.sp, fontWeight: FontWeight.w600)),
    );
  }

  Widget switchTile(String title, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      activeColor: AppColors.primaryColor,
      dense: true,
      contentPadding: EdgeInsets.zero,
      title: appText(title,
          textAlign: TextAlign.left, fontWeight: FontWeight.w600),
      value: value,
      onChanged: onChanged,
    );
  }

//                                                                               TIME PREFERENCE DROPDOWN
  Widget timePreference() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        appText('Time Preference', fontWeight: FontWeight.w600),
        SizedBox(height: 6.h),
        DropdownButtonFormField<String>(
          value: controller.timePreference.value,
          items: const [
            DropdownMenuItem(
              value: 'MORNING_6AM',
              child: Text('MORNING_6AM'),
            ),
            DropdownMenuItem(
              value: 'AFTERNOON_12PM',
              child: Text('AFTERNOON_12PM'),
            ),
            DropdownMenuItem(
              value: 'EVENING_6PM',
              child: Text('EVENING_6PM'),
            ),
          ],
          onChanged: (v) {
            if (v != null) controller.timePreference.value = v;
          },
          decoration: inputDecoration(),
        ),
      ],
    );
  }

  InputDecoration inputDecoration({
    String? hint,
    Widget? prefix,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: prefix,
      suffixIcon: suffix,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 12.w),
    );
  }
}

void showAutopayPreferenceSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
    ),
    builder: (_) {
      return AutopaySettingsSheet();
    },
  );
}
