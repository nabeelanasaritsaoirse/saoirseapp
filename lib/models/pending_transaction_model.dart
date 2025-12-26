class PendingTransactionResponse {
  final bool success;
  final String message;
  final PendingTransactionData data;

  PendingTransactionResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory PendingTransactionResponse.fromJson(Map<String, dynamic> json) {
    return PendingTransactionResponse(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      data: PendingTransactionData.fromJson(json["data"] ?? {}),
    );
  }
}

class PendingTransactionData {
  final int count;
  final int totalAmount;
  final List<PendingPayment> payments;

  PendingTransactionData({
    required this.count,
    required this.totalAmount,
    required this.payments,
  });

  factory PendingTransactionData.fromJson(Map<String, dynamic> json) {
    return PendingTransactionData(
      count: json["count"] ?? 0,
      totalAmount: json["totalAmount"] ?? 0,
      payments: (json["payments"] as List<dynamic>? ?? [])
          .map((e) => PendingPayment.fromJson(e))
          .toList(),
    );
  }
}

class PendingPayment {
  final String orderId;
  final String productName;
  final int installmentNumber;
  final int amount;
  final String dueDate;
  final String productImage;

  PendingPayment({
    required this.orderId,
    required this.productName,
    required this.installmentNumber,
    required this.amount,
    required this.dueDate,
     required this.productImage,
  });

  factory PendingPayment.fromJson(Map<String, dynamic> json) {
    return PendingPayment(
      orderId: json["orderId"] ?? "",
      productName: json["productName"] ?? "",
      installmentNumber: json["installmentNumber"] ?? 0,
      amount: json["amount"] ?? 0,
      dueDate: json["dueDate"] ?? "",
      productImage: (json["productImage"] != null &&
        json["productImage"]["url"] != null)
    ? json["productImage"]["url"].toString()
    : "",
    );
  }
}

