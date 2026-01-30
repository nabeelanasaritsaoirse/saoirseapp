import 'dart:convert';
import 'dart:developer';

import 'package:get_storage/get_storage.dart';

import '../constants/app_constant.dart';
import '../constants/app_urls.dart';
import '../models/autopay_dashboard-model.dart';
import '../models/autopay_setting_dialog_model.dart';
import 'api_service.dart';

import 'package:http/http.dart' as http;

class AutopayService {
  final box = GetStorage();
  Future<AutopayDashboardModel> getAutopayDashboard() async {
    final token = box.read(AppConst.ACCESS_TOKEN);
    final uri = Uri.parse(AppURLs.AUTOPAY_DASHBOARD_API);

    final response = await http.get(
      uri,
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      log("AUTOPAY_DASHBORD_ GET==_${response.body}");

      final dashboardModel = AutopayDashboardModel.fromJson(decoded);
      return dashboardModel;
    } else {
      throw Exception(
        "Failed to load Autopay Dashboard (${response.statusCode})",
      );
    }
  }

  Future<AutopaySettingsDialogModel> getautopaysettings() async {
    final token = box.read(AppConst.ACCESS_TOKEN);
    final uri = Uri.parse(AppURLs.AUTOPAY_SETTINGS_API);

    final response = await http.get(
      uri,
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
    );
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      log("AUTOPAY SETTINGS_ GET==${response.body}");
      final settingsModel = AutopaySettingsDialogModel.fromJson(decoded);
      return settingsModel;
    } else {
      throw Exception(
        "Failed to load Autopay Settings (${response.statusCode})",
      );
    }
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

    log("AUTOPAY SETTINGS BODY FINAL: ${jsonEncode(body)}");

    final result = await APIService.putRequest<bool>(
      url: AppURLs.AUTOPAY_SETTINGS_API,
      body: body,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      onSuccess: (json) {
        log("AUTOPAY SETTINGS UPDATED RESPONSE: $json");
        return json["success"] == true;
      },
    );

    return result ?? false;
  }

//   Future<bool> updateAutopaySettings({
//     required bool enabled,
//     required int lowBalanceThreshold,
//     required int minimumBalanceLock,
//     required int reminderHoursBefore,
//     required bool sendDailyReminder,
//     required String timePreference,
//     required bool autopaySuccess,
//     required bool autopayFailed,
//     required bool lowBalanceAlert,
//     required bool dailyReminder,
//   }) async {
//     final token = box.read(AppConst.ACCESS_TOKEN);
//     final body = {
//   "enabled": enabled,
//   "timePreference": timePreference,
//   "minimumBalanceLock": minimumBalanceLock,
//   "lowBalanceThreshold": lowBalanceThreshold,
//   "sendDailyReminder": sendDailyReminder,
//   "reminderHoursBefore": reminderHoursBefore,
// };

//     // final body = {
//     //   "enabled": false,
//     //   "lowBalanceThreshold": 500,
//     //   "minimumBalanceLock": 0,
//     //   "reminderHoursBefore": 1,
//     //   "sendDailyReminder": true,
//     //   "timePreference": "MORNING_6AM"
//     // };

//     //  {
//     //   "enabled": enabled,
//     //   "timePreference": "timePreference",
//     //   "minimumBalanceLock": minimumBalanceLock,
//     //   "lowBalanceThreshold": lowBalanceThreshold,
//     //   "sendDailyReminder": sendDailyReminder,
//     //   "reminderHoursBefore": reminderHoursBefore
//     // };
//     log("AUTOPAY SETTINGS BODY:============= $body");
//     final result = await APIService.putRequest<bool>(
//         url: AppURLs.AUTOPAY_SETTINGS_API_PUT,
//         body: body,
//         headers: {
//           "Authorization": "Bearer $token",
//           "Content-Type": "application/json",
//         },
//         onSuccess: (json) {
//           log("AUTOPAY SETTINGS UPDATED:============= $json");
//           return json["success"] == true;
//         });

//     return result ?? false;
//   }
}
