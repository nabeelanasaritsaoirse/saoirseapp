class FriendDetailsResponse {
  final bool success;
  final FriendDetails friendDetails;

  FriendDetailsResponse({
    required this.success,
    required this.friendDetails,
  });

  factory FriendDetailsResponse.fromJson(Map<String, dynamic> json) {
    return FriendDetailsResponse(
      success: json["success"] ?? false,
      friendDetails: FriendDetails.fromJson(json["friendDetails"] ?? {}),
    );
  }
}

// ------------------------------------------------------------

class FriendDetails {
  final String id;
  final String name;
  final String email;
  final String profilePicture;

  final int totalProducts;
  final double totalCommission;

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
      id: json["_id"]?.toString() ?? "",
      name: json["name"] ?? "N/A",
      email: json["email"] ?? "",
      profilePicture: json["profilePicture"] ?? "",
      totalProducts: (json["totalProducts"] as num?)?.toInt() ?? 0,
      totalCommission: (json["totalCommission"] as num?)?.toDouble() ?? 0.0,
      products: (json["products"] as List? ?? [])
          .map((item) => FriendProduct.fromJson(item ?? {}))
          .toList(),
    );
  }
}

// ------------------------------------------------------------

class FriendProduct {
  final String productId;
  final String productName;

  final ProductImage? productImage;

  final String pendingStatus;
  final int totalAmount;
  final String dateOfPurchase;

  final int days;
  final double commissionPerDay;

  final int paidDays;
  final int pendingDays;

  final String source;
  final String orderId;

  FriendProduct({
    required this.productId,
    required this.productName,
    this.productImage,
    required this.pendingStatus,
    required this.totalAmount,
    required this.dateOfPurchase,
    required this.days,
    required this.commissionPerDay,
    required this.paidDays,
    required this.pendingDays,
    required this.source,
    required this.orderId,
  });

  factory FriendProduct.fromJson(Map<String, dynamic> json) {
    return FriendProduct(
      productId: json["productId"]?.toString() ?? "",
      productName: json["productName"] ?? "",
      productImage: json["productImage"] != null
          ? ProductImage.fromJson(json["productImage"])
          : null,
      pendingStatus: json["pendingStatus"] ?? "",
      totalAmount: (json["totalAmount"] as num?)?.toInt() ?? 0,
      dateOfPurchase: json["dateOfPurchase"] ?? "",
      days: (json["days"] as num?)?.toInt() ?? 0,
      commissionPerDay: (json["commissionPerDay"] as num?)?.toDouble() ?? 0.0,
      paidDays: (json["paidDays"] as num?)?.toInt() ?? 0,
      pendingDays: (json["pendingDays"] as num?)?.toInt() ?? 0,
      source: json["source"] ?? "",
      orderId: json["orderId"] ?? "",
    );
  }
}

// ------------------------------------------------------------

class ProductImage {
  final String url;
  final bool isPrimary;
  final String altText;
  final int order;
  final String id;

  ProductImage({
    required this.url,
    required this.isPrimary,
    required this.altText,
    required this.order,
    required this.id,
  });

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      url: json["url"] ?? "",
      isPrimary: json["isPrimary"] ?? false,
      altText: json["altText"] ?? "",
      order: (json["order"] as num?)?.toInt() ?? 0,
      id: json["_id"] ?? "",
    );
  }
}

// class FriendDetailsResponse {
//   final bool success;
//   final FriendDetails friendDetails;

//   FriendDetailsResponse({
//     required this.success,
//     required this.friendDetails,
//   });

//   factory FriendDetailsResponse.fromJson(Map<String, dynamic> json) {
//     return FriendDetailsResponse(
//       success: json["success"] ?? false,
//       friendDetails: FriendDetails.fromJson(
//         json["friendDetails"] ?? {},
//       ),
//     );
//   }
// }

// class FriendDetails {
//   final String id;
//   final String name;
//   final String email;
//   final String profilePicture;
//   final int totalProducts;
//   final int totalCommission;
//   final List<FriendProduct> products;

//   FriendDetails({
//     required this.id,
//     required this.name,
//     required this.email,
//     required this.profilePicture,
//     required this.totalProducts,
//     required this.totalCommission,
//     required this.products,
//   });

//   factory FriendDetails.fromJson(Map<String, dynamic> json) {
//     return FriendDetails(
//       id: json["_id"]?.toString() ?? "",
//       name: json["name"] ?? "N/A",
//       email: json["email"] ?? "",
//       profilePicture: json["profilePicture"] ?? "",
//       totalProducts: (json["totalProducts"] as num?)?.toInt() ?? 0,
//       totalCommission: (json["totalCommission"] as num?)?.toInt() ?? 0,
//       products: (json["products"] as List? ?? [])
//           .map((item) => FriendProduct.fromJson(item ?? {}))
//           .toList(),
//     );
//   }
// }

// class FriendProduct {
//   final String productId;
//   final String productName;
//   final String pendingStatus;
//   final int totalAmount;
//   final String dateOfPurchase;
//   final int days;
//   final double commissionPerDay;
//   final int paidDays;
//   final int pendingDays;

//   FriendProduct({
//     required this.productId,
//     required this.productName,
//     required this.pendingStatus,
//     required this.totalAmount,
//     required this.dateOfPurchase,
//     required this.days,
//     required this.commissionPerDay,
//     required this.paidDays,
//     required this.pendingDays,
//   });

//   factory FriendProduct.fromJson(Map<String, dynamic> json) {
//     return FriendProduct(
//       productId: json["productId"]?.toString() ?? "",
//       productName: json["productName"] ?? "",
//       pendingStatus: json["pendingStatus"] ?? "",
//       totalAmount: (json["totalAmount"] as num?)?.toInt() ?? 0,
//       dateOfPurchase: json["dateOfPurchase"] ?? "",
//       days: (json["days"] as num?)?.toInt() ?? 0,
//       commissionPerDay: (json["commissionPerDay"] as num?)?.toDouble() ?? 0.0,
//       paidDays: (json["paidDays"] as num?)?.toInt() ?? 0,
//       pendingDays: (json["pendingDays"] as num?)?.toInt() ?? 0,
//     );
//   }
// }
