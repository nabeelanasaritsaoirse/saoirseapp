class WalletTransactionsResponse {
  final bool success;
  final List<WalletTransaction> transactions;
  final WalletSummary summary;

  WalletTransactionsResponse({
    required this.success,
    required this.transactions,
    required this.summary,
  });

  factory WalletTransactionsResponse.fromJson(Map<String, dynamic> json) {
    return WalletTransactionsResponse(
      success: json["success"] ?? false,
      transactions: (json["transactions"] as List)
          .map((e) => WalletTransaction.fromJson(e))
          .toList(),
      summary: WalletSummary.fromJson(json["summary"]),
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

  final PaymentDetails? paymentDetails;
  final ProductInfo? product;
  final OrderInfo? order;

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

      paymentDetails: json["paymentDetails"] != null
          ? PaymentDetails.fromJson(json["paymentDetails"])
          : null,

      product: json["product"] != null
          ? ProductInfo.fromJson(json["product"])
          : null,

      order: json["order"] != null
          ? OrderInfo.fromJson(json["order"])
          : null,
    );
  }
}

class PaymentDetails {
  final String orderId;
  final int emiNumber;
  final bool isCommissionProcessed;

  PaymentDetails({
    required this.orderId,
    required this.emiNumber,
    required this.isCommissionProcessed,
  });

  factory PaymentDetails.fromJson(Map<String, dynamic> json) {
    return PaymentDetails(
      orderId: json["orderId"] ?? "",
      emiNumber: json["emiNumber"] ?? 0,
      isCommissionProcessed: json["isCommissionProcessed"] ?? false,
    );
  }
}

class ProductInfo {
  final String id;
  final String name;
  final ProductPricing pricing;

  ProductInfo({
    required this.id,
    required this.name,
    required this.pricing,
  });

  factory ProductInfo.fromJson(Map<String, dynamic> json) {
    return ProductInfo(
      id: json["_id"] ?? "",
      name: json["name"] ?? "",
      pricing: ProductPricing.fromJson(json["pricing"]),
    );
  }
}

class ProductPricing {
  final double regularPrice;
  final double salePrice;
  final double finalPrice;

  ProductPricing({
    required this.regularPrice,
    required this.salePrice,
    required this.finalPrice,
  });

  factory ProductPricing.fromJson(Map<String, dynamic> json) {
    return ProductPricing(
      regularPrice: (json["regularPrice"] ?? 0).toDouble(),
      salePrice: (json["salePrice"] ?? 0).toDouble(),
      finalPrice: (json["finalPrice"] ?? 0).toDouble(),
    );
  }
}

class OrderInfo {
  final String id;
  final double orderAmount;
  final String orderStatus;

  OrderInfo({
    required this.id,
    required this.orderAmount,
    required this.orderStatus,
  });

  factory OrderInfo.fromJson(Map<String, dynamic> json) {
    return OrderInfo(
      id: json["_id"] ?? "",
      orderAmount: (json["orderAmount"] ?? 0).toDouble(),
      orderStatus: json["orderStatus"] ?? "",
    );
  }
}

class WalletSummary {
  final int total;
  final int completed;
  final int pending;
  final int failed;
  final int razorpayPayments;
  final int walletTransactions;
  final int emiPayments;
  final int commissions;
  final double totalEarnings;
  final double totalSpent;

  WalletSummary({
    required this.total,
    required this.completed,
    required this.pending,
    required this.failed,
    required this.razorpayPayments,
    required this.walletTransactions,
    required this.emiPayments,
    required this.commissions,
    required this.totalEarnings,
    required this.totalSpent,
  });

  factory WalletSummary.fromJson(Map<String, dynamic> json) {
    return WalletSummary(
      total: json["total"] ?? 0,
      completed: json["completed"] ?? 0,
      pending: json["pending"] ?? 0,
      failed: json["failed"] ?? 0,
      razorpayPayments: json["razorpayPayments"] ?? 0,
      walletTransactions: json["walletTransactions"] ?? 0,
      emiPayments: json["emiPayments"] ?? 0,
      commissions: json["commissions"] ?? 0,
      totalEarnings: (json["totalEarnings"] ?? 0).toDouble(),
      totalSpent: (json["totalSpent"] ?? 0).toDouble(),
    );
  }
}
