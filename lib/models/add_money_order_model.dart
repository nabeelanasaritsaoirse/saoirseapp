class AddMoneyOrderModel {
  final bool success;
  final String orderId;
  final int amount;
  final String transactionId;

  AddMoneyOrderModel({
    required this.success,
    required this.orderId,
    required this.amount,
    required this.transactionId,
  });

  factory AddMoneyOrderModel.fromJson(Map<String, dynamic> json) {
    return AddMoneyOrderModel(
      success: json["success"] ?? false,
      orderId: json["order_id"] ?? "",
      amount: json["amount"] ?? 0,
      transactionId: json["transaction_id"] ?? "",
    );
  }
}
