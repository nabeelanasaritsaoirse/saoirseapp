// ignore_for_file: unnecessary_null_comparison

class WalletModels {
  final bool success;
  final String message;

  /// Monetary values (API sends decimals)
  final double walletBalance;
  final double totalBalance;
  final double holdBalance;
  final double referralBonus;
  final double investedAmount;
  final double requiredInvestment;
  final double availableBalance;
  final double totalEarnings;

  final List<WalletTransaction> transactions;

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

      /// 🛡 Safe numeric parsing (int / double / null)
      walletBalance: (json["walletBalance"] as num?)?.toDouble() ?? 0.0,
      totalBalance: (json["totalBalance"] as num?)?.toDouble() ?? 0.0,
      holdBalance: (json["holdBalance"] as num?)?.toDouble() ?? 0.0,
      referralBonus: (json["referralBonus"] as num?)?.toDouble() ?? 0.0,
      investedAmount: (json["investedAmount"] as num?)?.toDouble() ?? 0.0,
      requiredInvestment:
          (json["requiredInvestment"] as num?)?.toDouble() ?? 0.0,
      availableBalance:
          (json["availableBalance"] as num?)?.toDouble() ?? 0.0,
      totalEarnings: (json["totalEarnings"] as num?)?.toDouble() ?? 0.0,

      transactions: (json["transactions"] as List? ?? [])
          .map((e) => WalletTransaction.fromJson(e))
          .toList(),
    );
  }
}

// -------------------------------------------------------------

class WalletTransaction {
  final String id;
  final String type;

  /// Always decimal-safe
  final double amount;

  final String status;
  final String? paymentMethod;
  final String description;
  final DateTime createdAt;

  /// Optional nested objects
  final PaymentDetails? paymentDetails;

  /// Can be object / string / null
  final String? product;
  final String? order;

  WalletTransaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.status,
    this.paymentMethod,
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
      amount: (json["amount"] as num?)?.toDouble() ?? 0.0,
      status: json["status"] ?? "",
      paymentMethod: json["paymentMethod"],
      description: json["description"] ?? "",

      /// 🛡 Safe date parsing
      createdAt: DateTime.tryParse(json["createdAt"] ?? "") ??
          DateTime.fromMillisecondsSinceEpoch(0),

      /// 🛡 Optional nested object
      paymentDetails: json["paymentDetails"] != null
          ? PaymentDetails.fromJson(json["paymentDetails"])
          : null,

      /// 🛡 Extract IDs safely
      product:
          json["product"] is Map ? json["product"]["_id"] : json["product"],
      order: json["order"] is Map ? json["order"]["_id"] : json["order"],
    );
  }
}

// -------------------------------------------------------------

class PaymentDetails {
  final String orderId;
  final int emiNumber;
  final bool isCommissionProcessed;

  /// Optional
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




