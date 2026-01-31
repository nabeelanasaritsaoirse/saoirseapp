import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/models/autopay_dashboard-model.dart';
import '/services/autopay_service.dart';

class AutopayController extends GetxController {
  final AutopayService _service = AutopayService();

  // ================= UI STATES =================
  RxBool isLoading = true.obs;
  RxBool isSettingsLoading = false.obs;
  RxString errorMessage = ''.obs;

  // ================= WALLET =================
  RxDouble walletBalance = 0.0.obs;
  RxInt dailyDeduction = 0.obs;
  RxInt daysBalanceLasts = 0.obs;
  RxBool isLowBalance = false.obs;

  // ================= STREAK =================
  RxInt currentStreak = 0.obs;
  RxInt longestStreak = 0.obs;
  Rx<NextMilestone?> nextMilestone = Rx<NextMilestone?>(null);

  // ================= SUGGESTIONS =================
  RxInt suggestedTopUp = 0.obs;

  // ================= ORDERS =================
  RxList<AutopayItem> items = <AutopayItem>[].obs;

  // ================= AUTOPAY SETTINGS =================
  RxBool autopayEnabled = false.obs;
  RxBool pauseAutopay = false.obs; // 🆕 bottom sheet support

  RxInt lowBalanceThreshold = 0.obs;
  RxInt minimumBalanceLock = 0.obs;
  RxInt reminderHoursBefore = 1.obs;
  RxBool sendDailyReminder = false.obs;
  RxString timePreference = ''.obs;

  // ================= NOTIFICATIONS =================
  RxBool notifyAutopaySuccess = false.obs;
  RxBool notifyAutopayFailed = false.obs;
  RxBool notifyLowBalance = false.obs;
  RxBool notifyDailyReminder = false.obs;

  // ================= PRIORITY (BOTTOM SHEET) =================
  RxInt priority = 50.obs;
  late TextEditingController priorityCtrl;

  // ================= SKIP DATES (BOTTOM SHEET) =================
  RxList<DateTime> skipDates = <DateTime>[].obs;
  RxBool isSkipDateSaving = false.obs;

//=====================SelectOrderid===============================
  RxString selectedOrderId = ''.obs;

  // ================= TEXT CONTROLLERS =================
  late TextEditingController lowBalanceCtrl;
  late TextEditingController minBalanceCtrl;
  late TextEditingController reminderHoursCtrl;

  @override
  void onInit() {
    super.onInit();
    lowBalanceCtrl = TextEditingController();
    minBalanceCtrl = TextEditingController();
    reminderHoursCtrl = TextEditingController();
    priorityCtrl = TextEditingController(text: '50');

    fetchDashboard();
  }

  // ================= VALIDATION =================
  bool validateSettings() {
    if (reminderHoursBefore.value < 1 || reminderHoursBefore.value > 12) {
      log("Invalid reminder hours");
      return false;
    }
    if (priority.value < 1 || priority.value > 100) {
      log("Invalid priority");
      return false;
    }
    return true;
  }

  // ================= SAVE SETTINGS =================
  Future<void> saveAutopaySettings() async {
    try {
      isSettingsLoading.value = true;

      if (!validateSettings()) return;

      // 1️⃣ Core settings
      final settingsSuccess = await _service.updateAutopaySettings(
        enabled: autopayEnabled.value,
        lowBalanceThreshold: lowBalanceThreshold.value,
        minimumBalanceLock: minimumBalanceLock.value,
        reminderHoursBefore: reminderHoursBefore.value,
        sendDailyReminder: sendDailyReminder.value,
        timePreference: timePreference.value,
      );

      if (!settingsSuccess) return;

      // 2️⃣ Notification preferences
      final notificationSuccess = await _service.updateNotificationPreferences(
        autopaySuccess: notifyAutopaySuccess.value,
        autopayFailed: notifyAutopayFailed.value,
        lowBalanceAlert: notifyLowBalance.value,
        dailyReminder: notifyDailyReminder.value,
      );

      if (!notificationSuccess) return;

      await fetchAutopaySettings();
      await fetchDashboard();

      Get.back();
      log("AUTOPAY SETTINGS UPDATED SUCCESSFULLY");
    } catch (e) {
      log("SAVE AUTOPAY SETTINGS FAILED: $e");
    } finally {
      isSettingsLoading.value = false;
    }
  }

  // ================= FETCH SETTINGS =================
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

  // ================= DASHBOARD =================
  Future<void> fetchDashboard() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _service.getAutopayDashboard();
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

  // ================= SKIP DATE HELPERS =================
  void addSkipDate(DateTime date) {
    final normalized = DateTime(date.year, date.month, date.day);

    if (skipDates.length >= 10) {
      // Get.snackbar("Limit Reached", "Maximum 10 skip dates allowed");
      log("Limit Reached" "Maximum 10 skip dates allowed");
      return;
    }

    final exists = skipDates.any((d) =>
        d.year == normalized.year &&
        d.month == normalized.month &&
        d.day == normalized.day);

    if (exists) {
      log("Duplicate Date" "This date is already added");
      return;
    }

    skipDates.add(normalized);
    skipDates.sort((a, b) => a.compareTo(b));
  }

  Future<void> saveSkipDates(String orderId) async {
    if (skipDates.isEmpty) {
      log("No Dates" "Please add at least one skip date");
      return;
    }

    try {
      isSkipDateSaving.value = true;

      final success = await _service.addSkipDates(
        orderId: orderId,
        dates: skipDates,
      );

      if (success) {
        Get.back();

        log("SKIP DATES SAVED SUCCESSFULLY");
      }
    } catch (e) {
      log("SAVE SKIP DATES ERROR: $e");
    } finally {
      isSkipDateSaving.value = false;
    }
  }

  void removeSkipDate(DateTime date) {
    skipDates.removeWhere((d) =>
        d.year == date.year && d.month == date.month && d.day == date.day);
  }

  @override
  void onClose() {
    lowBalanceCtrl.dispose();
    minBalanceCtrl.dispose();
    reminderHoursCtrl.dispose();
    priorityCtrl.dispose();
    super.onClose();
  }
}

// ================= ITEM MODEL =================
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



