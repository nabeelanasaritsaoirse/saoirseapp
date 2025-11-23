class WishlistResponse {
  final bool success;
  final String message;
  final List<WishlistItem> data;

  WishlistResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory WishlistResponse.fromJson(Map<String, dynamic> json) {
    return WishlistResponse(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      data: (json["data"] as List<dynamic>?)
              ?.map((e) => WishlistItem.fromJson(e))
              .toList() 
          ?? [],
    );
  }
}

class WishlistItem {
  final String productId;
  final String name;
  final String brand;
  final double price;
  final double finalPrice;
  final int discount;
  final List<ProductImage> images;
  final int stock;
  final bool isActive;

  WishlistItem({
    required this.productId,
    required this.name,
    required this.brand,
    required this.price,
    required this.finalPrice,
    required this.discount,
    required this.images,
    required this.stock,
    required this.isActive,
  });

  factory WishlistItem.fromJson(Map<String, dynamic> json) {
    return WishlistItem(
      productId: json["productId"] ?? "",
      name: json["name"] ?? "",
      brand: json["brand"] ?? "",
      price: (json["price"] ?? 0).toDouble(),
      finalPrice: (json["finalPrice"] ?? 0).toDouble(),
      discount: json["discount"] ?? 0,
      images: (json["images"] as List<dynamic>?)
              ?.map((e) => ProductImage.fromJson(e))
              .toList() 
          ?? [],
      stock: json["stock"] ?? 0,
      isActive: json["isActive"] ?? false,
    );
  }
}

class ProductImage {
  final String url;
  final bool isPrimary;
  final String altText;
  final String id;

  ProductImage({
    required this.url,
    required this.isPrimary,
    required this.altText,
    required this.id,
  });

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      url: json["url"] ?? "",
      isPrimary: json["isPrimary"] ?? false,
      altText: json["altText"] ?? "",
      id: json["_id"] ?? "",
    );
  }
}
