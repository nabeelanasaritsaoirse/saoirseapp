class ProductDetailsResponse {
  final bool success;
  final ProductDetails productDetails;

  ProductDetailsResponse({
    required this.success,
    required this.productDetails,
  });

  factory ProductDetailsResponse.fromJson(Map<String, dynamic> json) {
    return ProductDetailsResponse(
      success: json["success"],
      productDetails: ProductDetails.fromJson(json["productDetails"]),
    );
  }
}

class ProductDetails {
  final String productName;
  final String productId;
  final String dateOfPurchase;
  final int totalPrice;
  final int commissionPerDay;
  final int totalCommission;
  final int earnedCommission;
  final int pendingDays;
  final int pendingInvestmentAmount;
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
    required this.status,
  });

  factory ProductDetails.fromJson(Map<String, dynamic> json) {
    return ProductDetails(
      productName: json["productName"],
      productId: json["productId"],
      dateOfPurchase: json["dateOfPurchase"],
      totalPrice: json["totalPrice"],
      commissionPerDay: json["commissionPerDay"],
      totalCommission: json["totalCommission"],
      earnedCommission: json["earnedCommission"],
      pendingDays: json["pendingDays"],
      pendingInvestmentAmount: json["pendingInvestmentAmount"],
      status: json["status"],
    );
  }
}
