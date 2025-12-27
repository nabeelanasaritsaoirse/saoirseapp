class ProductDetailsResponse {
  final bool success;
  final ProductDetails productDetails;

  ProductDetailsResponse({
    required this.success,
    required this.productDetails,
  });

  factory ProductDetailsResponse.fromJson(Map<String, dynamic> json) {
    return ProductDetailsResponse(
      success: json["success"] ?? false,
      productDetails: ProductDetails.fromJson(json["productDetails"] ?? {}),
    );
  }
}

// ------------------------------------------------------------

class ProductDetails {
  final String productName;
  final String productId;
  final String dateOfPurchase;

  final int totalPrice;

  /// 🔐 API sends decimal
  final double commissionPerDay;

  final int totalCommission;
  final int earnedCommission;
  final int pendingDays;
  final int pendingInvestmentAmount;

  /// 🆕 New field from API
  final int dailySip;

  final String status;

  ProductDetails({
    required this.productName,
    required this.productId,
    required this.dateOfPurchase,
    required this.totalPrice,
    required this.commissionPerDay,
    required this.totalCommission,
    required this.earnedCommission,
    required this.pendingDays,
    required this.pendingInvestmentAmount,
    required this.dailySip,
    required this.status,
  });

  factory ProductDetails.fromJson(Map<String, dynamic> json) {
    return ProductDetails(
      productName: json["productName"] ?? "",
      productId: json["productId"] ?? "",
      dateOfPurchase: json["dateOfPurchase"] ?? "",

      totalPrice: json["totalPrice"] ?? 0,

      /// 🛡 Safe num → double
      commissionPerDay:
          (json["commissionPerDay"] as num?)?.toDouble() ?? 0.0,

      totalCommission: json["totalCommission"] ?? 0,
      earnedCommission: json["earnedCommission"] ?? 0,
      pendingDays: json["pendingDays"] ?? 0,
      pendingInvestmentAmount:
          json["pendingInvestmentAmount"] ?? 0,

      /// 🆕 New API field
      dailySip: json["dailySip"] ?? 0,

      status: json["status"] ?? "",
    );
  }
}

