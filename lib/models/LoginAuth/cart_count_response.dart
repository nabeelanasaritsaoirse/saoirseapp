class CartCountResponse {
  final bool success;
  final int count;

  CartCountResponse({
    required this.success,
    required this.count,
  });

  factory CartCountResponse.fromJson(Map<String, dynamic> json) {
    return CartCountResponse(
      success: json['success'] ?? false,
      count: json['data']?['count'] ?? 0,
    );
  }
}
