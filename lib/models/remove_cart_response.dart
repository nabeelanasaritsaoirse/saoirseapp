class RemoveCartItemResponse {
  final bool success;
  final String message;
  final int cartItemCount;

  RemoveCartItemResponse({
    required this.success,
    required this.message,
    required this.cartItemCount,
  });

  factory RemoveCartItemResponse.fromJson(Map<String, dynamic> json) {
    return RemoveCartItemResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? "",
      cartItemCount: json['data']?['cartItemCount'] ?? 0,
    );
  }
}
