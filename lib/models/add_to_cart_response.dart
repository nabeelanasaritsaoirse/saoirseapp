class AddToCartResponse {
  final bool success;
  final String message;
  final CartItem? cartItem;

  AddToCartResponse({
    required this.success,
    required this.message,
    this.cartItem,
  });

  factory AddToCartResponse.fromJson(Map<String, dynamic> json) {
    return AddToCartResponse(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      cartItem:
          json["cartItem"] != null ? CartItem.fromJson(json["cartItem"]) : null,
    );
  }
}

class CartItem {
  final String productId;
  final String? variantId;
  final int totalDays;
  final double dailyAmount;
  final int quantity;

  CartItem({
    required this.productId,
    this.variantId,
    required this.totalDays,
    required this.dailyAmount,
    required this.quantity,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      productId: json["productId"] ?? "",
      variantId: json["variantId"],
      totalDays: json["totalDays"] ?? 0,
      dailyAmount: (json["dailyAmount"] ?? 0).toDouble(),
      quantity: json["quantity"] ?? 1,
    );
  }
}







