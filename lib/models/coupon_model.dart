class Coupon {
  final String id;
  final String couponCode;
  final String discountType; 
  final double discountValue;
  final String couponType;
  final double minOrderValue;
  final DateTime? expiryDate;
  final bool isActive;

  Coupon({
    required this.id,
    required this.couponCode,
    required this.discountType,
    required this.discountValue,
    required this.couponType,
    required this.minOrderValue,
    required this.expiryDate,
    required this.isActive,
  });

  factory Coupon.fromJson(Map<String, dynamic> json) {
    DateTime? expiry;
    if (json["expiryDate"] != null && (json["expiryDate"] as String).isNotEmpty) {
      try {
        expiry = DateTime.parse(json["expiryDate"]);
      } catch (_) {
        expiry = null;
      }
    }

    return Coupon(
      id: json["_id"] ?? "",
      couponCode: json["couponCode"] ?? "",
      discountType: json["discountType"] ?? "flat",
      discountValue: (json["discountValue"] ?? 0).toDouble(),
      couponType: json["couponType"] ?? "",
      minOrderValue: (json["minOrderValue"] ?? 0).toDouble(),
      expiryDate: expiry,
      isActive: json["isActive"] ?? false,
    );
  }
}
