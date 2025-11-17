class FriendDetailsResponse {
  final bool success;
  final FriendDetails friendDetails;

  FriendDetailsResponse({
    required this.success,
    required this.friendDetails,
  });

  factory FriendDetailsResponse.fromJson(Map<String, dynamic> json) {
    return FriendDetailsResponse(
      success: json["success"],
      friendDetails: FriendDetails.fromJson(json["friendDetails"]),
    );
  }
}

class FriendDetails {
  final String id;
  final String name;
  final String email;
  final String profilePicture;
  final int totalProducts;
  final int totalCommission;
  final List<FriendProduct> products;

  FriendDetails({
    required this.id,
    required this.name,
    required this.email,
    required this.profilePicture,
    required this.totalProducts,
    required this.totalCommission,
    required this.products,
  });

  factory FriendDetails.fromJson(Map<String, dynamic> json) {
    return FriendDetails(
      id: json["_id"],
      name: json["name"] ?? "N/A",
      email: json["email"] ?? "",
      profilePicture: json["profilePicture"] ?? "",
      totalProducts: json["totalProducts"] ?? 0,
      totalCommission: json["totalCommission"] ?? 0,
      products: (json["products"] as List)
          .map((item) => FriendProduct.fromJson(item))
          .toList(),
    );
  }
}

class FriendProduct {
  final String productId;
  final String productName;
  final String pendingStatus;
  final int totalAmount;
  final String dateOfPurchase;
  final int days;
  final int commissionPerDay;
  final int paidDays;
  final int pendingDays;

  FriendProduct({
    required this.productId,
    required this.productName,
    required this.pendingStatus,
    required this.totalAmount,
    required this.dateOfPurchase,
    required this.days,
    required this.commissionPerDay,
    required this.paidDays,
    required this.pendingDays,
  });

  factory FriendProduct.fromJson(Map<String, dynamic> json) {
    return FriendProduct(
      productId: json["productId"],
      productName: json["productName"],
      pendingStatus: json["pendingStatus"],
      totalAmount: json["totalAmount"],
      dateOfPurchase: json["dateOfPurchase"],
      days: json["days"],
      commissionPerDay: json["commissionPerDay"],
      paidDays: json["paidDays"],
      pendingDays: json["pendingDays"],
    );
  }
}
