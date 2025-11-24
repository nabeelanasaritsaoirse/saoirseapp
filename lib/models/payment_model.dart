class PaymentModel {
  final String orderId;
  final int amount;
  final String currency;
  final String transactionId;
  final String keyId;

  PaymentModel({
    required this.orderId,
    required this.amount,
    required this.currency,
    required this.transactionId,
    required this.keyId,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      orderId: json["order_id"] ?? "",
      amount: json["amount"] ?? 0,
      currency: json["currency"] ?? "INR",
      transactionId: json["transaction_id"] ?? "",
      keyId: json["key_id"] ?? "",
    );
  }
}
