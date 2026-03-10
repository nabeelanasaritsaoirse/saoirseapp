import 'dart:convert';
import 'dart:developer';

import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

import 'package:saoirse_app/models/autopay_status_model.dart';
import 'package:saoirse_app/models/autopay_suggested_topup_model.dart';

import '../constants/app_constant.dart';
import '../constants/app_urls.dart';
import '../models/autopay_dashboard_model.dart';
import '../models/autopay_setting_dialog_model.dart';
import 'api_service.dart';



class AutopayService {
  final box = GetStorage();
 
  Future<AutopayDashboardModel?> getAutopayDashboard() async {
  final token = box.read(AppConst.ACCESS_TOKEN);
  final uri = AppURLs.AUTOPAY_DASHBOARD_API;

  return await APIService.getRequest<AutopayDashboardModel>(
    url: uri,
    headers: {
      "Authorization": "Bearer $token",
      "Accept": "application/json",
    },
    onSuccess: (data) {
      log("AUTOPAY_DASHBORD_ GET==_${jsonEncode(data)}");
      return AutopayDashboardModel.fromJson(data);
    },
  );
}

 
  Future<AutopaySettingsDialogModel?> getautopaysettings() async {
  final token = box.read(AppConst.ACCESS_TOKEN);
  final uri = AppURLs.AUTOPAY_SETTINGS_API;

  return await APIService.getRequest<AutopaySettingsDialogModel>(
    url: uri,
    headers: {
      "Authorization": "Bearer $token",
      "Accept": "application/json",
    },
    onSuccess: (data) {
      log("AUTOPAY_SETTINGS_GET_SUCCESS: ${jsonEncode(data)}");
      return AutopaySettingsDialogModel.fromJson(data);
    },
  );
}

  Future<bool> updateAutopaySettings({
    required bool enabled,
    required int lowBalanceThreshold,
    required int minimumBalanceLock,
    required int reminderHoursBefore,
    required bool sendDailyReminder,
    required String timePreference,
  }) async {
    final token = box.read(AppConst.ACCESS_TOKEN);

    final body = {
      "enabled": enabled,
      "timePreference": timePreference,
      "minimumBalanceLock": minimumBalanceLock,
      "lowBalanceThreshold": lowBalanceThreshold,
      "sendDailyReminder": sendDailyReminder,
      "reminderHoursBefore": reminderHoursBefore,
    };

    log("AUTOPAY SETTINGS PUT BODY : ${jsonEncode(body)}");

    final result = await APIService.putRequest<bool>(
      url: AppURLs.AUTOPAY_SETTINGS_API,
      body: body,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      onSuccess: (json) {
        log("AUTOPAY SETTINGS UPDATED RESPONSE PUT========>: $json");
        return json["success"] == true;
      },
    );

    return result ?? false;
  }

  Future<bool> updateNotificationPreferences({
    required bool autopaySuccess,
    required bool autopayFailed,
    required bool lowBalanceAlert,
    required bool dailyReminder,
  }) async {
    final token = box.read(AppConst.ACCESS_TOKEN);

    final body = {
      "autopaySuccess": autopaySuccess,
      "autopayFailed": autopayFailed,
      "lowBalanceAlert": lowBalanceAlert,
      "dailyReminder": dailyReminder,
    };

    log("NOTIFICATION PREFERENCES BODY: ${jsonEncode(body)}");

    final result = await APIService.putRequest<bool>(
      url: AppURLs.AUTOPAY_NOTIFICATION_PREFERENCES_API,
      body: body,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      onSuccess: (json) {
        log("NOTIFICATION PREF RESPONSE PUT=======>: $json");
        return json["success"] == true;
      },
    );

    return result ?? false;
  }

  // ================= ADD SKIP DATES =================
  Future<bool> addSkipDates({
    required String orderId,
    required List<DateTime> dates,
  }) async {
    final token = box.read(AppConst.ACCESS_TOKEN);

    final body = {
      "dates": dates.map((d) => DateFormat('yyyy-MM-dd').format(d)).toList(),
    };

    log("ADD SKIP DATES BODY: ${jsonEncode(body)}");

    final result = await APIService.postRequest<bool>(
      url: "${AppURLs.AUTOPAY_SKIP_DATES_ADD_API}/$orderId",
      body: body,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      onSuccess: (json) {
        log(" ADD SKIP DATES RESPONSE  ==> $json");
        return json["success"] == true;
      },
    );

    return result ?? false;
  }


  Future<AutopayStatus?> getAutopayStatus() async {
  final token = box.read(AppConst.ACCESS_TOKEN);
  final uri = AppURLs.AUTOPAY_STATUS_API;

  return await APIService.getRequest<AutopayStatus>(
    url: uri,
    headers: {
      "Authorization": "Bearer $token",
      "Accept": "application/json",
    },
    onSuccess: (data) {
      log("AUTOPAY_STATUS_GET_SUCCESS: ${jsonEncode(data)}");
      return AutopayStatus.fromJson(data);
    },
  );
}

// ================= REMOVE SKIP DATE =================
  Future<bool> removeSkipDate({
    required String orderId,
    required DateTime date,
  }) async {
    final token = box.read(AppConst.ACCESS_TOKEN);

    final body = {
      "date": DateFormat('yyyy-MM-dd').format(date),
    };

    log("REMOVE SKIP DATE BODY: ${jsonEncode(body)}");

    final result = await APIService.deleteRequest<bool>(
      url: "${AppURLs.AUTOPAY_SKIPDATE_DELET_API}/$orderId",
      body: body,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      onSuccess: (json) {
        log("REMOVE SKIP DATE RESPONSE ==> $json");
        return json["success"] == true;
      },
    );

    return result ?? false;
  }

  

  Future<AutopaySuggestedTopupModel?> getSuggestedTopUp({int days = 7}) async {
  final token = box.read(AppConst.ACCESS_TOKEN);
  final uri = "${AppURLs.AUTOPAY_SUGGESTED_TOPUP_API}?days=$days";

  return await APIService.getRequest<AutopaySuggestedTopupModel>(
    url: uri,
    headers: {
      "Authorization": "Bearer $token",
      "Accept": "application/json",
    },
    onSuccess: (data) {
      log("SUGGESTED_TOPUP_GET_SUCCESS: ${jsonEncode(data)}");
      return AutopaySuggestedTopupModel.fromJson(data);
    },
  );
}

// ================= PAUSE / RESUME AUTOPAY =================
  Future<bool> pauseAutopay({
    required String orderId,
    required DateTime pauseUntil,
  }) async {
    final token = box.read(AppConst.ACCESS_TOKEN);

    final body = {
      "pauseUntil": pauseUntil.toUtc().toIso8601String(),
    };

    log("PAUSE AUTOPAY BODY: ${jsonEncode(body)}");

    final result = await APIService.postRequest<bool>(
      url: "${AppURLs.AUTOPAY_PAUSE_API}/$orderId",
      body: body,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      onSuccess: (json) {
        log("PAUSE AUTOPAY RESPONSE ==> $json");
        return json["success"] == true;
      },
    );

    return result ?? false;
  }

// ================= RESUME AUTOPAY =================
  Future<bool> resumeAutopay({
    required String orderId,
  }) async {
    final token = box.read(AppConst.ACCESS_TOKEN);

    // No body needed for resume, just orderId in URL
    log("RESUME AUTOPAY REQUEST FOR ORDER: $orderId");

    final result = await APIService.postRequest<bool>(
      url: "${AppURLs.AUTOPAY_RESUME_API}/$orderId",
      body: {}, // Empty body or can send null
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      onSuccess: (json) {
        log("RESUME AUTOPAY RESPONSE ==> $json");
        return json["success"] == true;
      },
    );

    return result ?? false;
  }

// ================= ENABLE AUTOPAY FOR ORDER =================
  Future<bool> enableAutopayForOrder({
    required String orderId,
    int priority = 1,
  }) async {
    final token = box.read(AppConst.ACCESS_TOKEN);

    final body = {
      "priority": priority,
    };

    log("ENABLE AUTOPAY FOR ORDER REQUEST: ${jsonEncode(body)}");

    final result = await APIService.postRequest<bool>(
      url: "${AppURLs.AUTOPAY_ENABLE_FOR_ORDER_API}/$orderId",
      body: body,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      onSuccess: (json) {
        log("ENABLE AUTOPAY RESPONSE ==> $json");
        return json["success"] == true;
      },
    );

    return result ?? false;
  }

// ================= DISABLE AUTOPAY FOR ORDER =================
  Future<bool> disableAutopayForOrder({
    required String orderId,
  }) async {
    final token = box.read(AppConst.ACCESS_TOKEN);

    log("DISABLE AUTOPAY FOR ORDER REQUEST: $orderId");

    final result = await APIService.postRequest<bool>(
      url: "${AppURLs.AUTOPAY_DISABLE_FOR_ORDER_API}/$orderId",
      body: {}, // Empty body as per API
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      onSuccess: (json) {
        log("DISABLE AUTOPAY RESPONSE ==> $json");
        return json["success"] == true;
      },
    );

    return result ?? false;
  }

  Future<bool> updateOrderPriority({
    required String orderId,
    required int priority,
  }) async {
    final token = box.read(AppConst.ACCESS_TOKEN);

    final body = {
      "priority": priority,
    };

    log("UPDATE PRIORITY BODY: ${jsonEncode(body)}");

    final result = await APIService.putRequest<bool>(
      url: "${AppURLs.AUTOPAY_PRIORITY_API}/$orderId",
      body: body,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      onSuccess: (json) {
        log("UPDATE PRIORITY RESPONSE ==> $json");
        return json["success"] == true;
      },
    );

    return result ?? false;
  }
}
