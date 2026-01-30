import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:saoirse_app/constants/app_colors.dart';
import 'package:saoirse_app/constants/app_strings.dart';
import 'package:saoirse_app/screens/autopay_dashboard/autopay_dashboard_controller.dart';
import 'package:saoirse_app/widgets/app_button.dart';
import 'package:saoirse_app/widgets/app_loader.dart';
import 'package:saoirse_app/widgets/app_text.dart';
import 'package:saoirse_app/widgets/app_text_field.dart';
import 'package:saoirse_app/widgets/custom_appbar.dart';

class AutopayDashboardScreen extends StatelessWidget {
  AutopayDashboardScreen({super.key});

  final AutopayController controller = Get.put(AutopayController());

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (_, __) {
        return Scaffold(
          backgroundColor: AppColors.offWhite,
          appBar: CustomAppBar(
            title: AppStrings.AutopayDashboard_Title,
            showBack: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.settings, color: AppColors.white),
                onPressed: () async {
                  final controller = Get.find<AutopayController>();
                  controller.fetchAutopaySettings();

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

            if (controller.errorMessage.isNotEmpty) {
              return Center(
                child: appText(
                  controller.errorMessage.value,
                  color: AppColors.red,
                ),
              );
            }

            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(16.w),
                  child: walletCard(),
                ),
                SizedBox(height: 12.h),
                Expanded(
                  child: forecastAndList(),
                ),
              ],
            );
          }),
        );
      },
    );
  }

  Widget walletCard() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppColors.black,
            blurRadius: 12.0,
          ),
        ],
        gradient: const LinearGradient(
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
            appText(
              'Daily Deductions: ₹${controller.dailyDeduction.value}',
              fontSize: 14.sp,
              color: AppColors.grey,
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
          // SizedBox(width: 3.w),
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
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0B0F5C),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                onPressed: () {},
                child: appText(
                  'Quick Add ₹${controller.suggestedTopUp.value}',
                  fontSize: 14.sp,
                  color: AppColors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Expanded(
              child: controller.items.isEmpty
                  ? Center(
                      child: appText(
                        'No autopay orders found',
                        fontSize: 13.sp,
                        color: AppColors.grey,
                      ),
                    )
                  : ListView.builder(
                      itemCount: controller.items.length,
                      itemBuilder: (_, index) {
                        return autopayCard(controller.items[index]);
                      },
                    ),
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
        color: isDisabled ? AppColors.grey : AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.darkGray,
        ),
      ),
      child: Opacity(
        opacity: isDisabled ? 0.55 : 1,
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
                    Icon(
                      Icons.settings,
                      size: 18.sp,
                      color: AppColors.grey,
                    ),
                    SizedBox(height: 6.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.purple.shade100,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: appText(
                        'Priority: ${item.priority}',
                        fontSize: 11.sp,
                        color: AppColors.gradientBlue,
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
            SizedBox(
              height: 6.h,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50.r),
                child: LinearProgressIndicator(
                  value: item.progress,
                  backgroundColor: Colors.grey.shade300,
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(AppColors.purple),
                ),
              ),
            ),
            SizedBox(height: 6.h),
          ],
        ),
      ),
    );
  }
}

class AutopaySettingsDialog extends StatelessWidget {
  AutopaySettingsDialog({super.key});

  final AutopayController controller = Get.find<AutopayController>();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Obx(() {
        if (controller.isSettingsLoading.value) {
          return appLoader();
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              header(),
              switchTile(
                'Enable Autopay',
                controller.autopayEnabled.value,
                (v) => controller.autopayEnabled.value = v,
              ),
              const SizedBox(height: 10),
              timePreference(),
              const SizedBox(height: 14),
              appText('Wallet Reserves', fontWeight: FontWeight.w600),

              const SizedBox(height: 8),

//=================================================================
//              AUTYOPAY SETTINGS DIALOG - RUPEE TEXT FIELDS
//=================================================================
              appTextField(
                controller: controller.minBalanceCtrl,
                hintText: "Minimum Balance Lock",
                fillColor: AppColors.white,
                hintColor: AppColors.black,
                textColor: AppColors.black,
                onChanged: (v) =>
                    controller.minimumBalanceLock.value = int.tryParse(v) ?? 0,
                textInputType: TextInputType.number,
                prefixWidget: appText(
                  '₹',
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.grey,
                ),
              ),
              const SizedBox(height: 10),
              appTextField(
                controller: controller.lowBalanceCtrl,
                hintText: "Low Balance Threshold",
                fillColor: AppColors.white,
                hintColor: AppColors.black,
                textColor: AppColors.black,
                onChanged: (v) =>
                    controller.lowBalanceThreshold.value = int.tryParse(v) ?? 0,
                textInputType: TextInputType.number,
                prefixWidget: appText(
                  '₹',
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.grey,
                ),
              ),

              const SizedBox(height: 14),
//===============================================================================
//          AUTYOPAY SETTINGS DIALOG - REMINDER HOURS FIELD
//===============================================================================

              appText('Reminder', fontWeight: FontWeight.w600),

              const SizedBox(height: 8),
              appTextField(
                controller: controller.reminderHoursCtrl,
                hintText: 'Hours Before Payment (1–12)',
                fillColor: AppColors.white,
                hintColor: AppColors.black,
                textColor: AppColors.black,
                onChanged: (v) {
                  final val = int.tryParse(v) ?? 1;
                  controller.reminderHoursBefore.value = val;
                },
                validator: (v) {
                  final val = int.tryParse(v ?? '');
                  if (val == null || val < 1 || val > 12) {
                    return 'Enter a value between 1 and 12';
                  }
                  return null;
                },
                textInputType: TextInputType.number,
                suffixWidget: appText(
                  'hours',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color.fromARGB(255, 13, 9, 9),
                ),
              ),

//=====================================================================================
//              AUTYOPAY SETTINGS DIALOG - NOTIFICATION PREFERENCES
//=====================================================================================
              const SizedBox(height: 14),
              appText('Notification Preferences', fontWeight: FontWeight.w600),

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
              const SizedBox(height: 20),
//==============================================================================
//                            SAVE & CANCEL BUTTONS
//==============================================================================

              Row(
                children: [
                  Expanded(
                    child: appButton(
                        onTap: () => Get.back(),
                        buttonText: "Cancel",
                        textColor: AppColors.primaryColor,
                        buttonColor: AppColors.white,
                        borderColor: AppColors.primaryColor),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: appButton(
                      onTap: () {
                        FocusScope.of(Get.context!).unfocus();
                        controller.saveAutopaySettings();
                      },
                      buttonText: "Save Settings",
                      textColor: AppColors.white,
                      buttonColor: AppColors.primaryColor,
                      borderColor: AppColors.white,
                      borderWidth: 1.5,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget header() {
    return Center(
      child: Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: appText('Autopay Settings',
              fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }

  Widget switchTile(String title, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      title: appText(title, textAlign: TextAlign.left),
      value: value,
      onChanged: onChanged,
    );
  }

  Widget timePreference() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        appText('Time Preference', fontWeight: FontWeight.w600),
        const SizedBox(height: 6),
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
        borderRadius: BorderRadius.circular(8),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    );
  }
}
