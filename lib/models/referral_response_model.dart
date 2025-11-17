class ReferralResponse {
  final bool success;
  final String message;
  final String referralCode;
  final List<Referral> referrals;

  ReferralResponse({
    required this.success,
    required this.message,
    required this.referralCode,
    required this.referrals,
  });

  factory ReferralResponse.fromJson(Map<String, dynamic> json) {
    return ReferralResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      referralCode: json['referralCode'] ?? '',
      referrals: (json['referrals'] as List<dynamic>?)
              ?.map((e) => Referral.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "referralCode": referralCode,
        "referrals": referrals.map((e) => e.toJson()).toList(),
      };
}

// -------------------------------------------------------------
// REFERRAL ITEM
// -------------------------------------------------------------

class Referral {
  final String id;
  final ReferredUser? referredUser;
  final int? totalProducts;
  final double totalCommission;
  final List<ProductItem> productList;

  Referral({
    required this.id,
    required this.referredUser,
    required this.totalProducts,
    required this.totalCommission,
    required this.productList,
  });

  factory Referral.fromJson(Map<String, dynamic> json) {
    return Referral(
      id: json['_id'] ?? '',
      referredUser: ReferredUser.fromJson(json['referredUser'] ?? {}),
      totalProducts: json['totalProducts'] ?? 0,
      totalCommission: (json['totalCommission'] ?? 0).toDouble(),
      productList: (json['productList'] as List<dynamic>?)
              ?.map((e) => ProductItem.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "referredUser": referredUser!.toJson(),
        "totalProducts": totalProducts,
        "totalCommission": totalCommission,
        "productList": productList.map((e) => e.toJson()).toList(),
      };
}

// -------------------------------------------------------------
// REFERRED USER
// -------------------------------------------------------------

class ReferredUser {
  final String id;
  final String name;
  final String profilePicture;

  ReferredUser({
    required this.id,
    required this.name,
    required this.profilePicture,
  });

  factory ReferredUser.fromJson(Map<String, dynamic> json) {
    return ReferredUser(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      profilePicture: json['profilePicture'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "profilePicture": profilePicture,
      };
}

// -------------------------------------------------------------
// PRODUCT ITEM
// -------------------------------------------------------------

class ProductItem {
  final String productName;
  final String productId;
  final String pendingStatus;
  final double totalAmount;
  final DateTime dateOfPurchase;

  ProductItem({
    required this.productName,
    required this.productId,
    required this.pendingStatus,
    required this.totalAmount,
    required this.dateOfPurchase,
  });

  factory ProductItem.fromJson(Map<String, dynamic> json) {
    return ProductItem(
      productName: json['productName'] ?? '',
      productId: json['productId'] ?? '',
      pendingStatus: json['pendingStatus'] ?? '',
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      dateOfPurchase: DateTime.tryParse(json['dateOfPurchase'] ?? '') ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        "productName": productName,
        "productId": productId,
        "pendingStatus": pendingStatus,
        "totalAmount": totalAmount,
        "dateOfPurchase": dateOfPurchase.toIso8601String(),
      };
}
