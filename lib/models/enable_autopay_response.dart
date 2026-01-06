class EnableAutoPayResponse {
  final bool success;
  final String message;
  final AutoPayData data;

  EnableAutoPayResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory EnableAutoPayResponse.fromJson(Map<String, dynamic> json) {
    return EnableAutoPayResponse(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      data: AutoPayData.fromJson(json["data"] ?? {}),
    );
  }
}

class AutoPayData {
  final String orderId;
  final String productName;
  final AutoPay autopay;

  AutoPayData({
    required this.orderId,
    required this.productName,
    required this.autopay,
  });

  factory AutoPayData.fromJson(Map<String, dynamic> json) {
    return AutoPayData(
      orderId: json["orderId"] ?? "",
      productName: json["productName"] ?? "",
      autopay: AutoPay.fromJson(json["autopay"] ?? {}),
    );
  }
}

class AutoPay {
  final bool enabled;
  final int priority;
  final DateTime? enabledAt;

  AutoPay({
    required this.enabled,
    required this.priority,
    this.enabledAt,
  });

  factory AutoPay.fromJson(Map<String, dynamic> json) {
    return AutoPay(
      enabled: json["enabled"] ?? false,
      priority: json["priority"] ?? 0,
      enabledAt: json["enabledAt"] != null
          ? DateTime.parse(json["enabledAt"])
          : null,
    );
  }
}
