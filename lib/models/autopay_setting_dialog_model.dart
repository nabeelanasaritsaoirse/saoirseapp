class AutopaySettingsDialogModel {
  final bool success;
  final AutopayData data;

  AutopaySettingsDialogModel({
    required this.success,
    required this.data,
  });

  factory AutopaySettingsDialogModel.fromJson(Map<String, dynamic> json) {
    return AutopaySettingsDialogModel(
      success: json['success'] ?? false,
      data: AutopayData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data.toJson(),
    };
  }
}

class AutopayData {
  final AutopaySettings settings;
  final NotificationPreferences notificationPreferences;

  AutopayData({
    required this.settings,
    required this.notificationPreferences,
  });

  factory AutopayData.fromJson(Map<String, dynamic> json) {
    return AutopayData(
      settings: AutopaySettings.fromJson(json['settings'] ?? {}),
      notificationPreferences: NotificationPreferences.fromJson(
          json['notificationPreferences'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'settings': settings.toJson(),
      'notificationPreferences': notificationPreferences.toJson(),
    };
  }
}

class AutopaySettings {
  final bool enabled;
  final int lowBalanceThreshold;
  final int minimumBalanceLock;
  final int reminderHoursBefore;
  final bool sendDailyReminder;
  final String timePreference;

  AutopaySettings({
    required this.enabled,
    required this.lowBalanceThreshold,
    required this.minimumBalanceLock,
    required this.reminderHoursBefore,
    required this.sendDailyReminder,
    required this.timePreference,
  });

  factory AutopaySettings.fromJson(Map<String, dynamic> json) {
    return AutopaySettings(
      enabled: json['enabled'] ?? false,
      lowBalanceThreshold: json['lowBalanceThreshold'] ?? 0,
      minimumBalanceLock: json['minimumBalanceLock'] ?? 0,
      reminderHoursBefore: json['reminderHoursBefore'] ?? 1,
      sendDailyReminder: json['sendDailyReminder'] ?? false,
      timePreference: json['timePreference'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'enabled': enabled,
      'lowBalanceThreshold': lowBalanceThreshold,
      'minimumBalanceLock': minimumBalanceLock,
      'reminderHoursBefore': reminderHoursBefore,
      'sendDailyReminder': sendDailyReminder,
      'timePreference': timePreference,
    };
  }
}

class NotificationPreferences {
  final bool autopaySuccess;
  final bool autopayFailed;
  final bool lowBalanceAlert;
  final bool dailyReminder;

  NotificationPreferences({
    required this.autopaySuccess,
    required this.autopayFailed,
    required this.lowBalanceAlert,
    required this.dailyReminder,
  });

  factory NotificationPreferences.fromJson(Map<String, dynamic> json) {
    return NotificationPreferences(
      autopaySuccess: json['autopaySuccess'] ?? false,
      autopayFailed: json['autopayFailed'] ?? false,
      lowBalanceAlert: json['lowBalanceAlert'] ?? false,
      dailyReminder: json['dailyReminder'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'autopaySuccess': autopaySuccess,
      'autopayFailed': autopayFailed,
      'lowBalanceAlert': lowBalanceAlert,
      'dailyReminder': dailyReminder,
    };
  }
}
