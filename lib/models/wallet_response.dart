class WalletModels {
  bool success;
  String message;
  int walletBalance;
  int totalBalance;
  int holdBalance;
  int referralBonus;
  int investedAmount;
  int requiredInvestment;
  int availableBalance;
  int totalEarnings;
  List<WalletTransaction> transactions;

  WalletModels({
    required this.success,
    required this.message,
    required this.walletBalance,
    required this.totalBalance,
    required this.holdBalance,
    required this.referralBonus,
    required this.investedAmount,
    required this.requiredInvestment,
    required this.availableBalance,
    required this.totalEarnings,
    required this.transactions,
  });

  factory WalletModels.fromJson(Map<String, dynamic> json) {
    return WalletModels(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      walletBalance: json["walletBalance"] ?? 0,
      totalBalance: json["totalBalance"] ?? 0,
      holdBalance: json["holdBalance"] ?? 0,
      referralBonus: json["referralBonus"] ?? 0,
      investedAmount: json["investedAmount"] ?? 0,
      requiredInvestment: json["requiredInvestment"] ?? 0,
      availableBalance: json["availableBalance"] ?? 0,
      totalEarnings: json["totalEarnings"] ?? 0,
      transactions: (json["transactions"] as List? ?? [])
          .map((e) => WalletTransaction.fromJson(e))
          .toList(),
    );
  }
}

class WalletTransaction {
  final String id;
  final String type;
  final double amount;
  final String status;
  final String paymentMethod;
  final String description;
  final DateTime createdAt;

  /// ✅ paymentDetails can be null (many APIs don’t send it)
  final PaymentDetails? paymentDetails;

  /// ✅ product & order may be object OR string OR null
  final String? product;
  final String? order;

  WalletTransaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.status,
    required this.paymentMethod,
    required this.description,
    required this.createdAt,
    this.paymentDetails,
    this.product,
    this.order,
  });

  factory WalletTransaction.fromJson(Map<String, dynamic> json) {
    return WalletTransaction(
      id: json["_id"] ?? "",
      type: json["type"] ?? "",
      amount: (json["amount"] ?? 0).toDouble(),
      status: json["status"] ?? "",
      paymentMethod: json["paymentMethod"] ?? "",
      description: json["description"] ?? "",
      createdAt: DateTime.parse(json["createdAt"]),

      /// ✅ SAFE NULL CHECK
      paymentDetails: json["paymentDetails"] != null
          ? PaymentDetails.fromJson(json["paymentDetails"])
          : null,

      /// ✅ Extract only IDs safely
      product: json["product"] is Map
          ? json["product"]["_id"]
          : json["product"],

      order: json["order"] is Map
          ? json["order"]["_id"]
          : json["order"],
    );
  }
}

class PaymentDetails {
  final String orderId;
  final int emiNumber;
  final bool isCommissionProcessed;

  /// Optional fields
  final String? paymentId;
  final String? signature;

  PaymentDetails({
    required this.orderId,
    required this.emiNumber,
    required this.isCommissionProcessed,
    this.paymentId,
    this.signature,
  });

  factory PaymentDetails.fromJson(Map<String, dynamic> json) {
    return PaymentDetails(
      orderId: json["orderId"] ?? "",
      emiNumber: json["emiNumber"] ?? 0,
      isCommissionProcessed: json["isCommissionProcessed"] ?? false,
      paymentId: json["paymentId"],
      signature: json["signature"],
    );
  }
}

