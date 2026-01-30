import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/models/autopay_dashboard-model.dart';

import '/services/autopay_service.dart';

class AutopayController extends GetxController {
  final AutopayService _service = AutopayService();

  // UI states
  RxBool isLoading = true.obs;
  RxString errorMessage = ''.obs;

  // Wallet
  RxDouble walletBalance = 0.0.obs;
  RxInt dailyDeduction = 0.obs;
  RxInt daysBalanceLasts = 0.obs;
  RxBool isLowBalance = false.obs;
  //  Streak
  RxInt currentStreak = 0.obs;
  RxInt longestStreak = 0.obs;
  Rx<NextMilestone?> nextMilestone = Rx<NextMilestone?>(null);

  // Suggestions
  RxInt suggestedTopUp = 0.obs;

  // Orders
  RxList<AutopayItem> items = <AutopayItem>[].obs;

  // ================= AUTOPAY SETTINGS =================


  RxBool isSettingsLoading = false.obs;

// Settings toggle values
  RxBool autopayEnabled = false.obs;
  RxInt lowBalanceThreshold = 0.obs;
  RxInt minimumBalanceLock = 0.obs;
  RxInt reminderHoursBefore = 1.obs;
  RxBool sendDailyReminder = false.obs;
  RxString timePreference = ''.obs;

// Notification preferences
  RxBool notifyAutopaySuccess = false.obs;
  RxBool notifyAutopayFailed = false.obs;
  RxBool notifyLowBalance = false.obs;
  RxBool notifyDailyReminder = false.obs;

  late TextEditingController lowBalanceCtrl;
  late TextEditingController minBalanceCtrl;
  late TextEditingController reminderHoursCtrl;

  @override
  void onInit() {
    super.onInit();
    lowBalanceCtrl = TextEditingController();
    minBalanceCtrl = TextEditingController();
    reminderHoursCtrl = TextEditingController();
    fetchDashboard();
  }

  bool validateSettings() {
    if (reminderHoursBefore.value < 1 || reminderHoursBefore.value > 12) {
      log("Invalid reminder hours: ${reminderHoursBefore.value}");
      return false;
    }
    return true;
  }

  Future<void> saveAutopaySettings() async {
    try {
      isSettingsLoading.value = true;

      final success = await _service.updateAutopaySettings(
        enabled: autopayEnabled.value,
        lowBalanceThreshold: lowBalanceThreshold.value,
        minimumBalanceLock: minimumBalanceLock.value,
        reminderHoursBefore: reminderHoursBefore.value,
        sendDailyReminder: sendDailyReminder.value,
        timePreference: timePreference.value,
      );

      if (success) {
        await fetchAutopaySettings(); 
        await fetchDashboard(); 

        Get.back();
       
        log("AUTOPAY SETTINGS UPDATED SUCCESSFULLY");
      }
    } catch (e) {
      log(  "AUTOPAY SETTINGS UPDATE FAILED: $e");
      
    } finally {
      isSettingsLoading.value = false;
    }
  }

  

  Future<void> fetchAutopaySettings() async {
    try {
      isSettingsLoading.value = true;

      final response = await _service.getautopaysettings();
      final settings = response.data.settings;
      final notifications = response.data.notificationPreferences;

      autopayEnabled.value = settings.enabled;
      lowBalanceThreshold.value = settings.lowBalanceThreshold;
      minimumBalanceLock.value = settings.minimumBalanceLock;
      reminderHoursBefore.value = settings.reminderHoursBefore;
      sendDailyReminder.value = settings.sendDailyReminder;
      timePreference.value = settings.timePreference;

      notifyAutopaySuccess.value = notifications.autopaySuccess;
      notifyAutopayFailed.value = notifications.autopayFailed;
      notifyLowBalance.value = notifications.lowBalanceAlert;
      notifyDailyReminder.value = notifications.dailyReminder;

      
      lowBalanceCtrl.text = settings.lowBalanceThreshold.toString();
      minBalanceCtrl.text = settings.minimumBalanceLock.toString();
      reminderHoursCtrl.text = settings.reminderHoursBefore.toString();
    } finally {
      isSettingsLoading.value = false;
    }
  }

  

  Future<void> fetchDashboard() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final AutopayDashboardModel response =
          await _service.getAutopayDashboard();

      final data = response.data;

     
      walletBalance.value = data.wallet.balance.toDouble();
      dailyDeduction.value = data.autopay.totalDailyDeduction;
      daysBalanceLasts.value = data.autopay.daysBalanceLasts;
      isLowBalance.value = data.wallet.isLowBalance;

      
      suggestedTopUp.value = data.suggestions.suggestedTopUp;

      items.value = data.orders.map((order) {
        final total = order.remainingAmount + order.dailyAmount;
        final progress = total == 0 ? 0.0 : 1 - (order.remainingAmount / total);

        return AutopayItem(
          title: order.productName,
          perDay: order.dailyAmount,
          remaining: order.remainingAmount,
          progress: progress.clamp(0.0, 1.0),
          priority: order.priority,
          enabled: order.autopayEnabled,
        );
      }).toList();
    } catch (e) {
      errorMessage.value = 'Failed to load dashboard';
    } finally {
      isLoading.value = false;
    }
  }
}

class AutopayItem {
  final String title;
  final int perDay;
  final int remaining;
  final double progress;
  final int priority;
  final bool enabled;

  AutopayItem({
    required this.title,
    required this.perDay,
    required this.remaining,
    required this.progress,
    required this.priority,
    required this.enabled,
  });
}
