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
      installmentPlan: InstallmentPlan.fromJson(json['installmentPlan'] ?? {}),
      addedAt: json['addedAt'] ?? "",
      updatedAt: json['updatedAt'] ?? "",
      itemTotal: (json['itemTotal'] ?? 0).toDouble(),
    );
  }

  CartProduct copyWith({
    int? quantity,
    double? itemTotal,
    InstallmentPlan? installmentPlan,
  }) {
    return CartProduct(
      productId: productId,
      name: name,
      brand: brand,
      price: price,
      finalPrice: finalPrice,
      discount: discount,
      images: images,
      stock: stock,
      isActive: isActive,
      quantity: quantity ?? this.quantity,
      variant: variant,
      installmentPlan: installmentPlan ?? this.installmentPlan,
      addedAt: addedAt,
      updatedAt: updatedAt,
      itemTotal: itemTotal ?? this.itemTotal,
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
      attributes: _parseAttributes(json['attributes']),
      description: json['description'] ?? "",
    );
  }

  static VariantAttributes _parseAttributes(dynamic attributesJson) {
    if (attributesJson == null) {
      return VariantAttributes();
    }

    if (attributesJson is List) {
      Map<String, String> others = {};
      VariantAttributes base = VariantAttributes();

      for (var attr in attributesJson) {
        final map = Map<String, dynamic>.from(attr);

        // format 1: {color,size,weight}
        if (map.containsKey("color") ||
            map.containsKey("size") ||
            map.containsKey("weight")) {
          base = VariantAttributes.fromJson(map);
        }

        // format 2: {name,value}
        if (map.containsKey("name") && map.containsKey("value")) {
          others[map["name"].toString()] = map["value"].toString();
        }
      }

      return VariantAttributes(
        color: base.color,
        size: base.size,
        weight: base.weight,
        purity: base.purity,
        material: base.material,
        others: others,
      );
    }

    return VariantAttributes.fromJson(
        Map<String, dynamic>.from(attributesJson));
  }
}

class VariantAttributes {
  final String? color;
  final String? size;
  final String? weight;
  final String? purity;
  final String? material;

  /// Dynamic attributes (Grade, Ripeness, Packaging etc)
  final Map<String, String> others;

  VariantAttributes({
    this.color,
    this.size,
    this.weight,
    this.purity,
    this.material,
    this.others = const {},
  });

  factory VariantAttributes.fromJson(Map<String, dynamic> json) {
    // Case 1 → normal attribute object
    if (json.containsKey("color") ||
        json.containsKey("size") ||
        json.containsKey("weight")) {
      return VariantAttributes(
        color: json['color']?.toString(),
        size: json['size']?.toString(),
        weight: json['weight']?.toString(),
        purity: json['purity']?.toString(),
        material: json['material']?.toString(),
      );
    }

    // Case 2 → name/value attribute
    if (json.containsKey("name") && json.containsKey("value")) {
      return VariantAttributes(
        others: {
          json['name'].toString(): json['value'].toString(),
        },
      );
    }

    return VariantAttributes();
  }
}

class InstallmentPlan {
  final int? totalDays;
  final double? dailyAmount;
  final double totalAmount;

  InstallmentPlan({
    this.totalDays,
    this.dailyAmount,
    required this.totalAmount,
  });

  factory InstallmentPlan.fromJson(Map<String, dynamic> json) {
    return InstallmentPlan(
      totalDays: json['totalDays'], // Can be null
      dailyAmount: json['dailyAmount'] != null
          ? (json['dailyAmount'] as num).toDouble()
          : null,
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
    );
  }

  InstallmentPlan copyWith({
    int? totalDays,
    double? dailyAmount,
    double? totalAmount,
  }) {
    return InstallmentPlan(
      totalDays: totalDays ?? this.totalDays,
      dailyAmount: dailyAmount ?? this.dailyAmount,
      totalAmount: totalAmount ?? this.totalAmount,
    );
  }
}

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
      url: json['url'] ?? "",
      isPrimary: json['isPrimary'] ?? false,
      altText: json['altText'] ?? "",
      order: json['order'] ?? 0,
      id: json['_id'] ?? "",
    );
  }
}
