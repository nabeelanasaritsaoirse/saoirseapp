class AddToCartResponse {
  final bool success;
  final String message;
  final int cartItemCount;

  AddToCartResponse({
    required this.success,
    required this.message,
    required this.cartItemCount,
  });

  factory AddToCartResponse.fromJson(Map<String, dynamic> json) {
    return AddToCartResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? "",
      cartItemCount: json['data']?['cartItemCount'] ?? 0,
    );
  }
}
