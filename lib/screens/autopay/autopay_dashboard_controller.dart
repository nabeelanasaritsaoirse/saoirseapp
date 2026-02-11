import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:saoirse_app/models/autopay_dashboard_model.dart';
import 'package:saoirse_app/models/autopay_status_model.dart';

import 'package:saoirse_app/services/autopay_service.dart';

class AutopayController extends GetxController {
  final AutopayService service = AutopayService();

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
  RxDouble suggestedTopUp = 0.0.obs;

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
  RxBool hasSkipDateChanges = false.obs;
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
    // fetchDeleteInfo();
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

  

  Future<void> saveAllSettings() async {
    final orderId = selectedOrderId.value;

    if (orderId.isEmpty) {
      log("SAVE FAILED: Order ID empty");
      return;
    }

    try {
      isSettingsLoading.value = true;

      // 1. Enable/Disable autopay
      if (autopayEnabled.value) {
        await service.enableAutopayForOrder(
          orderId: orderId,
          priority: priority.value,
        );
      } else {
        await service.disableAutopayForOrder(orderId: orderId);
      }

      // 2. Pause or resume
      if (pauseAutopay.value) {
        final pauseUntil = DateTime.now().add(const Duration(days: 7));
        await service.pauseAutopay(
          orderId: orderId,
          pauseUntil: pauseUntil,
        );
      } else {
        await service.resumeAutopay(orderId: orderId);
      }

      // 3. Priority update
      await service.updateOrderPriority(
        orderId: orderId,
        priority: priority.value,
      );

      // 4. Skip dates (only if changed)
      if (hasSkipDateChanges.value) {
        await saveSkipDates(orderId);
      }

      // Refresh data
      await fetchAutopayStatus();
      await fetchDashboard();
      applyAutopayStatusForOrder(orderId);

      log("ALL SETTINGS SAVED SUCCESSFULLY");
    } catch (e) {
      log("SAVE ALL SETTINGS ERROR: $e");
    } finally {
      isSettingsLoading.value = false;
    }
  }

  void applyAutopayStatusForOrder(String orderId, {bool fromApi = true}) {
    final status = autopayStatus.value;
    if (status == null) return;

    final order = status.data.orders.firstWhereOrNull(
      (o) => o.orderId == orderId,
    );

    if (order == null) return;

    autopayEnabled.value = order.autopay.enabled;

    // Enforce rule:
    // If autopay disabled → pause must also be off
    if (!autopayEnabled.value) {
      pauseAutopay.value = false;
    } else {
      pauseAutopay.value = !order.autopay.isActive;
    }

    priority.value = order.autopay.priority;
    priorityCtrl.text = order.autopay.priority.toString();

    if (fromApi) {
      skipDates.clear();

      if (order.autopay.skipDates.isNotEmpty) {
        skipDates.addAll(
          order.autopay.skipDates
              .map((d) => DateTime.parse(d.toString()))
              .map((d) => DateTime(d.year, d.month, d.day))
              .toList(),
        );
      }
      hasSkipDateChanges.value = false;
    }
  }

  // ================= SAVE SETTINGS =================
  Future<void> saveAutopaySettings() async {
    try {
      isSettingsLoading.value = true;

      if (!validateSettings()) return;

      final settingsSuccess = await service.updateAutopaySettings(
        enabled: autopayEnabled.value,
        lowBalanceThreshold: lowBalanceThreshold.value,
        minimumBalanceLock: minimumBalanceLock.value,
        reminderHoursBefore: reminderHoursBefore.value,
        sendDailyReminder: sendDailyReminder.value,
        timePreference: timePreference.value,
      );

      if (!settingsSuccess) return;

      final notificationSuccess = await service.updateNotificationPreferences(
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

      final response = await service.getautopaysettings();
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

      final response = await service.getAutopayDashboard();
      final data = response.data;

      walletBalance.value = data.wallet.balance.toDouble();
      dailyDeduction.value = data.autopay.totalDailyDeduction;
      daysBalanceLasts.value = data.autopay.daysBalanceLasts;
      isLowBalance.value = data.wallet.isLowBalance;
      suggestedTopUp.value = data.suggestions.suggestedTopUp.toDouble();

      items.value = data.orders.map((order) {
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

  Future<void> saveOrderPriorityForOrder(String orderId) async {
    if (orderId.isEmpty) {
      log("SAVE PRIORITY FAILED: Order ID empty");
      return;
    }

    final parsedPriority = int.tryParse(priorityCtrl.text) ?? priority.value;

    if (parsedPriority < 1 || parsedPriority > 100) {
      log("INVALID PRIORITY: $parsedPriority");
      return;
    }

    final success = await service.updateOrderPriority(
      orderId: orderId,
      priority: parsedPriority,
    );

    if (success) {
      priority.value = parsedPriority;
      log("ORDER PRIORITY UPDATED TO $parsedPriority FOR ORDER $orderId");

      // Refresh only from API so this order's data is up to date
      await fetchAutopayStatus();
      await fetchDashboard();
      applyAutopayStatusForOrder(orderId);
    } else {
      log("FAILED TO UPDATE PRIORITY FOR ORDER $orderId");
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

    // Mark that skip dates were changed
    hasSkipDateChanges.value = true;

    log("Skip date added: ${normalized.toString()}");
    log("Total skip dates: ${skipDates.length}");
  }

  void removeSkipDate() {
    skipDates.clear();
  }

  

  Future<void> saveSkipDates(String orderId) async {
    log("SAVE BUTTON -> saveSkipDates() CALLED");
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

      final success = await service.addSkipDates(
        orderId: orderId,
        dates: skipDates,
      );

      if (success) {
        log("SKIP DATES SAVED SUCCESSFULLY");

        // Refresh status from API
        await fetchAutopayStatus();

        // Re-apply updated data to UI
        applyAutopayStatusForOrder(orderId);
        hasSkipDateChanges.value = false;
      } else {
        log("FAILED TO SAVE SKIP DATES");
      }
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

      final success = await service.removeSkipDate(
        orderId: orderId,
        date: date,
      );

      if (success) {
        log("SKIP DATE REMOVED SUCCESSFULLY");

        skipDates.removeWhere((d) =>
            d.year == date.year && d.month == date.month && d.day == date.day);

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
    isLoading.value = true;
    errorMessage.value = '';

    final response = await service.getAutopayStatus();

    autopayStatus.value = response;

    log("AUTOPAY STATUS LOADED");
    log(" AUTOPAY SThereATUS RESPONSE$response");

    isLoading.value = false;
  }

  Future<void> fetchSuggestedTopUp({int days = 7}) async {
    try {
      final response = await service.getSuggestedTopUp(days: days);

      suggestedTopUp.value = response.data.suggestedTopUp.toDouble();
      daysRequested.value = response.data.daysRequested;

      log("SUGGESTED TOPUP UPDATED: ₹${suggestedTopUp.value}");
    } catch (e) {
      log("SUGGESTED TOPUP ERROR: $e");
    }
  }

  // ================= PAUSE / RESUME AUTOPAY ==============

  Future<bool> resumeAutopay() async {
    final orderId = selectedOrderId.value;

    if (orderId.isEmpty) {
      log("RESUME AUTOPAY FAILED: Order ID empty");

      return false;
    }

    try {
      isSettingsLoading.value = true;

      final success = await service.resumeAutopay(
        orderId: orderId,
      );

      if (success) {
        pauseAutopay.value = false;
        log("AUTOPAY RESUMED SUCCESSFULLY");

        await fetchAutopayStatus();

        applyAutopayStatusForOrder(orderId);

        return true;
      } else {
        log("RESUME AUTOPAY FAILED FROM API");

        return false;
      }
    } catch (e) {
      log("RESUME AUTOPAY ERROR: $e");

      return false;
    } finally {
      isSettingsLoading.value = false;
    }
  }

// ================= TOGGLE PAUSE AUTOPAY =================
  Future<void> togglePauseAutopay(bool shouldPause) async {
    final orderId = selectedOrderId.value;

    if (orderId.isEmpty) {
      log("TOGGLE AUTOPAY FAILED: Order ID empty");
      return;
    }

    try {
      isSettingsLoading.value = true;

      if (shouldPause) {
        final pauseUntil = DateTime.now().add(const Duration(days: 7));

        final success = await service.pauseAutopay(
          orderId: orderId,
          pauseUntil: pauseUntil,
        );

        if (!success) {
          log("PAUSE AUTOPAY FAILED FROM API");
          return;
        }

        pauseAutopay.value = true;
        log("AUTOPAY PAUSED  SUCCSESSFULLY UNTIL $pauseUntil");
      } else {
        final success = await resumeAutopay();

        if (success) {
          pauseAutopay.value = false;
          log("AUTOPAY RESUMED SUCCESSFULLY");
        }
      }

      await fetchAutopayStatus();
      await fetchDashboard();
      applyAutopayStatusForOrder(orderId);
    } catch (e) {
      log("TOGGLE PAUSE AUTOPAY ERROR: $e");
    } finally {
      isSettingsLoading.value = false;
    }
  }

// ================= ENABLE AUTOPAY FOR ORDER =================
  Future<void> enableAutopayForOrder(String orderId,
      {int? customPriority}) async {
    if (orderId.isEmpty) {
      log("ENABLE AUTOPAY FAILED: Order ID empty");

      return;
    }

    try {
      isSettingsLoading.value = true;

      final priorityToUse = customPriority ?? priority.value;

      final success = await service.enableAutopayForOrder(
        orderId: orderId,
        priority: priorityToUse,
      );

      if (success) {
        autopayEnabled.value = true;
        log("AUTOPAY ENABLED FOR ORDER $orderId WITH PRIORITY $priorityToUse");

        // Refresh the status & dashboard so only this order reflects the change
        await fetchAutopayStatus();
        await fetchDashboard();
        applyAutopayStatusForOrder(orderId);
      } else {
        log("ENABLE AUTOPAY FAILED FROM API");
      }
    } catch (e) {
      log("ENABLE AUTOPAY ERROR: $e");
    } finally {
      isSettingsLoading.value = false;
    }
  }

// ================= DISABLE AUTOPAY FOR ORDER =================
  Future<void> disableAutopayForOrder(String orderId) async {
    if (orderId.isEmpty) {
      log("DISABLE AUTOPAY FAILED: Order ID empty");

      return;
    }

    try {
      isSettingsLoading.value = true;

      final success = await service.disableAutopayForOrder(
        orderId: orderId,
      );

      if (success) {
        autopayEnabled.value = false;
        log("AUTOPAY DISABLED FOR ORDER $orderId");

        await fetchAutopayStatus();
        await fetchDashboard();
        applyAutopayStatusForOrder(orderId);
      } else {
        log("DISABLE AUTOPAY FAILED FROM API");
      }
    } catch (e) {
      log("DISABLE AUTOPAY ERROR: $e");
    } finally {
      isSettingsLoading.value = false;
    }
  }

// ================= TOGGLE ENABLE/DISABLE AUTOPAY =================
  Future<void> toggleEnableAutopay(bool shouldEnable) async {
    final orderId = selectedOrderId.value;

    if (orderId.isEmpty) {
      log("TOGGLE AUTOPAY FAILED: No order selected");
      return;
    }

    try {
      isSettingsLoading.value = true;

      if (shouldEnable) {
        final priority = int.tryParse(priorityCtrl.text) ?? this.priority.value;
        await enableAutopayForOrder(orderId, customPriority: priority);
      } else {
        await disableAutopayForOrder(orderId);
      }
    } catch (e) {
      log("TOGGLE AUTOPAY ERROR: $e");
    } finally {
      isSettingsLoading.value = false;
    }
  }

  Future<void> saveOrderPriority() async {
    final orderId = selectedOrderId.value;

    if (orderId.isEmpty) {
      log("SAVE PRIORITY FAILED: Order ID empty");
      return;
    }

    final parsedPriority = int.tryParse(priorityCtrl.text) ?? priority.value;

    if (parsedPriority < 1 || parsedPriority > 100) {
      log("INVALID PRIORITY: $parsedPriority");
      return;
    }

    final success = await service.updateOrderPriority(
      orderId: orderId,
      priority: parsedPriority,
    );

    if (success) {
      priority.value = parsedPriority;
      log("ORDER PRIORITY UPDATED TO $parsedPriority");

      await fetchAutopayStatus();
      await fetchDashboard();

      applyAutopayStatusForOrder(orderId);
    } else {
      log("FAILED TO UPDATE PRIORITY");
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