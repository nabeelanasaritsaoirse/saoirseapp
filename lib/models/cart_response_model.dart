class CartResponse {
  final bool success;
  final String message;
  final CartData data;

  CartResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory CartResponse.fromJson(Map<String, dynamic> json) {
    return CartResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? "",
      data: CartData.fromJson(json['data']),
    );
  }
}

class CartData {
  final List<CartProduct> products;
  final int totalItems;
  final double totalPrice;
  final double subtotal;

  CartData({
    required this.products,
    required this.totalItems,
    required this.totalPrice,
    required this.subtotal,
  });

  factory CartData.fromJson(Map<String, dynamic> json) {
    return CartData(
      products: (json['products'] as List)
          .map((e) => CartProduct.fromJson(e))
          .toList(),
      totalItems: json['totalItems'] ?? 0,
      totalPrice: (json['totalPrice'] ?? 0).toDouble(),
      subtotal: (json['subtotal'] ?? 0).toDouble(),
    );
  }
}

class CartProduct {
  final String productId;
  final String name;
  final double price;
  final double finalPrice;
  final int discount;
  final List<ProductImage> images;
  final int stock;
  final bool isActive;
  int quantity;
  final String addedAt;
  final double itemTotal;

  CartProduct({
    required this.productId,
    required this.name,
    required this.price,
    required this.finalPrice,
    required this.discount,
    required this.images,
    required this.stock,
    required this.isActive,
    required this.quantity,
    required this.addedAt,
    required this.itemTotal,
  });

  factory CartProduct.fromJson(Map<String, dynamic> json) {
    return CartProduct(
      productId: json['productId'] ?? "",
      name: json['name'] ?? "",
      price: (json['price'] ?? 0).toDouble(),
      finalPrice: (json['finalPrice'] ?? 0).toDouble(),
      discount: json['discount'] ?? 0,
      images: (json['images'] as List)
          .map((e) => ProductImage.fromJson(e))
          .toList(),
      stock: json['stock'] ?? 0,
      isActive: json['isActive'] ?? false,
      quantity: json['quantity'] ?? 0,
      addedAt: json['addedAt'] ?? "",
      itemTotal: (json['itemTotal'] ?? 0).toDouble(),
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
      url: json['url'] ?? "",
      isPrimary: json['isPrimary'] ?? false,
      altText: json['altText'] ?? "",
      id: json['_id'] ?? "",
    );
  }
}
