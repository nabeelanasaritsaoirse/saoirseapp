import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saoirse_app/models/autopay_status_model.dart';

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
  RxInt daysRequested = 7.obs;

  // ================= ORDERS =================
  RxList<AutopayItem> items = <AutopayItem>[].obs;

  //==============suggested topups==============

  // ================= AUTOPAY SETTINGS =================
  RxBool autopayEnabled = false.obs;
  RxBool pauseAutopay = false.obs; //

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

  // ================= AUTOPAY STATUS =================
  Rx<AutopayStatus?> autopayStatus = Rx<AutopayStatus?>(null);

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
    fetchAutopayStatus();
    fetchSuggestedTopUp();
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

  void applyAutopayStatusForOrder(String orderId) {
    final status = autopayStatus.value;
    if (status == null) return;

    final order = status.data.orders.firstWhereOrNull(
      (o) => o.orderId == orderId,
    );

    if (order == null) return;

    autopayEnabled.value = order.autopay.enabled;
    pauseAutopay.value = !order.autopay.isActive;

    priority.value = order.autopay.priority;
    priorityCtrl.text = order.autopay.priority.toString();

    skipDates.clear();

    if (order.autopay.skipDates.isNotEmpty) {
      skipDates.addAll(
        order.autopay.skipDates
            .map((d) => DateTime.parse(d.toString()))
            .map((d) => DateTime(d.year, d.month, d.day))
            .toList(),
      );
    }

    log("AUTOPAY PREFILLED FOR ORDER $orderId");
    log("SKIP DATES COUNT: ${skipDates.length}");
    log("SKIP DATES: ${skipDates.map((d) => d.toIso8601String()).toList()}");
  }

  // ================= SAVE SETTINGS =================
  Future<void> saveAutopaySettings() async {
    try {
      isSettingsLoading.value = true;

      if (!validateSettings()) return;

      final settingsSuccess = await _service.updateAutopaySettings(
        enabled: autopayEnabled.value,
        lowBalanceThreshold: lowBalanceThreshold.value,
        minimumBalanceLock: minimumBalanceLock.value,
        reminderHoursBefore: reminderHoursBefore.value,
        sendDailyReminder: sendDailyReminder.value,
        timePreference: timePreference.value,
      );

      if (!settingsSuccess) return;

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
//                                                              TODO                      PROGRESS DETAILS

        return AutopayItem(
          orderId: order.id,
          title: order.productName,
          perDay: order.dailyAmount,
          remaining: order.remainingAmount,
          progress: order.progress.toInt(),
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
      log("Limit Reached: Maximum 10 skip dates allowed");
      return;
    }

    final exists = skipDates.any((d) =>
        d.year == normalized.year &&
        d.month == normalized.month &&
        d.day == normalized.day);

    if (exists) {
      log("Duplicate Date: This date is already added");
      return;
    }

    skipDates.add(normalized);
    skipDates.sort((a, b) => a.compareTo(b));

    log("Skip date added: ${normalized.toString()}");
    log("Total skip dates: ${skipDates.length}");
  }

  void removeSkipDate() {
    skipDates.clear();
  }

  Future<void> saveSkipDates(String orderId) async {
    if (skipDates.isEmpty) {
      log("No Dates: Please add at least one skip date");
      return;
    }

    if (orderId.isEmpty) {
      log("ERROR: Order ID is empty");
      return;
    }

    try {
      isSkipDateSaving.value = true;

      log("SAVING SKIP DATES FOR ORDER: $orderId");
      log("SKIP DATES COUNT: ${skipDates.length}");
      log("SKIP DATES: ${skipDates.map((d) => d.toString()).toList()}");

      final success = await _service.addSkipDates(
        orderId: orderId,
        dates: skipDates,
      );

      if (success) {
        log("SKIP DATES SAVED SUCCESSFULLY");

        await fetchAutopayStatus();

        applyAutopayStatusForOrder(orderId);

        Get.back();
      } else {
        log("FAILED TO SAVE SKIP DATES");
      }

      final AutopayController controller = Get.find();
      controller.removeSkipDate();
    } catch (e) {
      log("SAVE SKIP DATES ERROR: $e");
    } finally {
      isSkipDateSaving.value = false;
    }
  }

  Future<void> removeSkipDateApi(DateTime date) async {
    final orderId = selectedOrderId.value;

    if (orderId.isEmpty) {
      log("REMOVE SKIP DATE FAILED: Order ID empty");
      return;
    }

    try {
      isSkipDateSaving.value = true;

      final success = await _service.removeSkipDate(
        orderId: orderId,
        date: date,
      );

      if (success) {
        log("SKIP DATE REMOVED SUCCESSFULLY");

        // Remove locally
        skipDates.removeWhere((d) =>
            d.year == date.year && d.month == date.month && d.day == date.day);

        // Refresh status
        await fetchAutopayStatus();
        applyAutopayStatusForOrder(orderId);
      } else {
        log("FAILED TO REMOVE SKIP DATE");
      }
    } catch (e) {
      log("REMOVE SKIP DATE ERROR: $e");
    } finally {
      isSkipDateSaving.value = false;
    }
  }

  @override
  void onClose() {
    lowBalanceCtrl.dispose();
    minBalanceCtrl.dispose();
    reminderHoursCtrl.dispose();
    priorityCtrl.dispose();
    super.onClose();
  }

  Future<void> fetchAutopayStatus() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _service.getAutopayStatus();
      autopayStatus.value = response;

      if (items.isEmpty && response.data.orders.isNotEmpty) {
        items.value = response.data.orders.map((order) {
          return AutopayItem(
            orderId: order.orderId,
            title: order.productName,
            perDay: order.dailyAmount,
            remaining: order.remainingAmount,
            progress: order.progress,
            priority: order.autopay.priority,
            enabled: order.autopay.enabled,
          );
        }).toList();
      }

      log("AUTOPAY STATUS LOADED");
      log(" AUTOPAY SThereATUS RESPONSE$response");
    } catch (e) {
      errorMessage.value = 'Failed to load autopay status';
      log("AUTOPAY STATUS ERROR: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchSuggestedTopUp({int days = 7}) async {
    try {
      final response = await _service.getSuggestedTopUp(days: days);

      suggestedTopUp.value = response.data.suggestedTopUp;
      daysRequested.value = response.data.daysRequested;

      log("SUGGESTED TOPUP UPDATED: ₹${suggestedTopUp.value}");
    } catch (e) {
      log("SUGGESTED TOPUP ERROR: $e");
    }
  }
}

// ================= ITEM MODEL =================
class AutopayItem {
  final String orderId;
  final String title;
  final int perDay;
  final int remaining;
  final int progress;
  final int priority;
  final bool enabled;

  AutopayItem({
    required this.orderId,
    required this.title,
    required this.perDay,
    required this.remaining,
    required this.progress,
    required this.priority,
    required this.enabled,
  });
}
