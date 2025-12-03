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
      products: (json['products'] as List<dynamic>)
          .map((item) => CartProduct.fromJson(item))
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
  final String brand;
  final double price;
  final double finalPrice;
  final int discount;
  final List<ProductImage> images;
  final int stock;
  final bool isActive;
  int quantity;

  final Variant? variant;
  final InstallmentPlan installmentPlan;

  final String addedAt;
  final String updatedAt;
  final double itemTotal;

  CartProduct({
    required this.productId,
    required this.name,
    required this.brand,
    required this.price,
    required this.finalPrice,
    required this.discount,
    required this.images,
    required this.stock,
    required this.isActive,
    required this.quantity,
    required this.variant,
    required this.installmentPlan,
    required this.addedAt,
    required this.updatedAt,
    required this.itemTotal,
  });

  factory CartProduct.fromJson(Map<String, dynamic> json) {
    return CartProduct(
      productId: json['productId'] ?? "",
      name: json['name'] ?? "",
      brand: json['brand'] ?? "",
      price: (json['price'] ?? 0).toDouble(),
      finalPrice: (json['finalPrice'] ?? 0).toDouble(),
      discount: json['discount'] ?? 0,
      images: (json['images'] as List<dynamic>)
          .map((img) => ProductImage.fromJson(img))
          .toList(),
      stock: json['stock'] ?? 0,
      isActive: json['isActive'] ?? false,
      quantity: json['quantity'] ?? 1,

      variant:
          json['variant'] != null ? Variant.fromJson(json['variant']) : null,

      installmentPlan:
          InstallmentPlan.fromJson(json['installmentPlan'] ?? {}),

      addedAt: json['addedAt'] ?? "",
      updatedAt: json['updatedAt'] ?? "",
      itemTotal: (json['itemTotal'] ?? 0).toDouble(),
    );
  }
}

class Variant {
  final String variantId;
  final String sku;
  final VariantAttributes attributes;
  final String description;

  Variant({
    required this.variantId,
    required this.sku,
    required this.attributes,
    required this.description,
  });

  factory Variant.fromJson(Map<String, dynamic> json) {
    return Variant(
      variantId: json['variantId'] ?? "",
      sku: json['sku'] ?? "",
      attributes: VariantAttributes.fromJson(json['attributes'] ?? {}),
      description: json['description'] ?? "",
    );
  }
}

class VariantAttributes {
  final String? color;
  final String? size;
  final String? weight;
  final String? purity;
  final String? material;

  VariantAttributes({
    this.color,
    this.size,
    this.weight,
    this.purity,
    this.material,
  });

  factory VariantAttributes.fromJson(Map<String, dynamic> json) {
    return VariantAttributes(
      color: json['color'],
      size: json['size'],
      weight: json['weight'],
      purity: json['purity'],
      material: json['material'],
    );
  }
}

class InstallmentPlan {
  final int totalDays;
  final double dailyAmount;
  final double totalAmount;

  InstallmentPlan({
    required this.totalDays,
    required this.dailyAmount,
    required this.totalAmount,
  });

  factory InstallmentPlan.fromJson(Map<String, dynamic> json) {
    return InstallmentPlan(
      totalDays: json['totalDays'] ?? 0,
      dailyAmount: (json['dailyAmount'] ?? 0).toDouble(),
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
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





