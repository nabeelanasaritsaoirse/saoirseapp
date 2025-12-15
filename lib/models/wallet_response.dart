class WalletmModels {
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

  WalletmModels({
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

  factory WalletmModels.fromJson(Map<String, dynamic> json) {
    return WalletmModels(
      success: json["success"],
      message: json["message"],
      walletBalance: json["walletBalance"],
      totalBalance: json["totalBalance"],
      holdBalance: json["holdBalance"],
      referralBonus: json["referralBonus"],
      investedAmount: json["investedAmount"],
      requiredInvestment: json["requiredInvestment"],
      availableBalance: json["availableBalance"],
      totalEarnings: json["totalEarnings"],
      transactions: (json["transactions"] as List)
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

  final PaymentDetails paymentDetails;

  /// 🔥 THESE ARE JUST ID STRINGS IN API
  final String product;
  final String order;

  WalletTransaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.status,
    required this.paymentMethod,
    required this.description,
    required this.createdAt,
    required this.paymentDetails,
    required this.product,
    required this.order,
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

      paymentDetails: PaymentDetails.fromJson(json["paymentDetails"]),

      /// ✔ product and order IDs only
      product: json["product"] ?? "",
      order: json["order"] ?? "",
    );
  }
}

class PaymentDetails {
  final String orderId;
  final int emiNumber;
  final bool isCommissionProcessed;

  /// 🆕 New optional fields from API
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

      /// 🆕 Safely parse new fields if present
      paymentId: json["paymentId"],
      signature: json["signature"],
    );
  }
}
