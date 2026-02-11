class AutopayStatus {
  final bool success;
  final AutopayStatusData data;

  AutopayStatus({
    required this.success,
    required this.data,
  });

  factory AutopayStatus.fromJson(Map<String, dynamic> json) {
    return AutopayStatus(
      success: json['success'] ?? false,
      data: AutopayStatusData.fromJson(json['data'] ?? {}),
    );
  }
}

class AutopayStatusData {
  final int totalOrders;
  final int autopayEnabled;
  final int totalDailyAmount;
  final List<AutopayOrderStatus> orders;

  AutopayStatusData({
    required this.totalOrders,
    required this.autopayEnabled,
    required this.totalDailyAmount,
    required this.orders,
  });

  factory AutopayStatusData.fromJson(Map<String, dynamic> json) {
    return AutopayStatusData(
      totalOrders: json['totalOrders'] ?? 0,
      autopayEnabled: json['autopayEnabled'] ?? 0,
      totalDailyAmount: json['totalDailyAmount'] ?? 0,
      orders: (json['orders'] as List<dynamic>? ?? [])
          .map((e) => AutopayOrderStatus.fromJson(e))
          .toList(),
    );
  }
}

class AutopayOrderStatus {
  final String orderId;
  final String productName;
  final String productImage;
  final int dailyAmount;
  final int remainingAmount;
  final int progress;
  final AutopayConfig autopay;

  AutopayOrderStatus({
    required this.orderId,
    required this.productName,
    required this.productImage,
    required this.dailyAmount,
    required this.remainingAmount,
    required this.progress,
    required this.autopay,
  });

  factory AutopayOrderStatus.fromJson(Map<String, dynamic> json) {
    return AutopayOrderStatus(
      orderId: json['orderId'] ?? '',
      productName: json['productName'] ?? '',
      productImage: json['productImage'] ?? '',
      dailyAmount: json['dailyAmount'] ?? 0,
      remainingAmount: json['remainingAmount'] ?? 0,
      progress: json['progress'] ?? 0,
      autopay: AutopayConfig.fromJson(json['autopay'] ?? {}),
    );
  }
}

class AutopayConfig {
  final bool enabled;
  final int priority;
  final DateTime? pausedUntil;
  final List<DateTime> skipDates;
  final bool isActive;
  final int successCount;
  final int failedCount;

  AutopayConfig({
    required this.enabled,
    required this.priority,
    this.pausedUntil,
    required this.skipDates,
    required this.isActive,
    required this.successCount,
    required this.failedCount,
  });

  factory AutopayConfig.fromJson(Map<String, dynamic> json) {
    return AutopayConfig(
      enabled: json['enabled'] ?? false,
      priority: json['priority'] ?? 0,
      pausedUntil: json['pausedUntil'] != null
          ? DateTime.parse(json['pausedUntil'])
          : null,
      skipDates: (json['skipDates'] as List<dynamic>? ?? [])
          .map((e) {
            try {
              final date = DateTime.parse(e.toString());
              // Normalize to date only (remove time component)
              return DateTime(date.year, date.month, date.day);
            } catch (e) {
              return null;
            }
          })
          .whereType<DateTime>()
          .toList(),
      isActive: json['isActive'] ?? false,
      successCount: json['successCount'] ?? 0,
      failedCount: json['failedCount'] ?? 0,
    );
  }
}
