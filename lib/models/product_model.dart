// models/product_model.dart
class FeaturedList {
  final String listId;
  final String listName;
  final String slug;
  final String description;
  final List<FeaturedProduct> products;

  FeaturedList({
    required this.listId,
    required this.listName,
    required this.slug,
    required this.description,
    required this.products,
  });

  factory FeaturedList.fromJson(Map<String, dynamic> json) {
    return FeaturedList(
      listId: json['listId'] ?? '',
      listName: json['listName'] ?? '',
      slug: json['slug'] ?? '',
      description: json['description'] ?? '',
      products: (json['products'] as List? ?? [])
          .map((p) => FeaturedProduct.fromJson(p))
          .toList(),
    );
  }
}

class FeaturedProduct {
  final String productId;
  final String productMongoId;
  final String name;
  final String brand;
  final String image;
  final double price;
  final double finalPrice;
  final int order;

  FeaturedProduct({
    required this.productId,
    required this.productMongoId,
    required this.name,
    required this.brand,
    required this.image,
    required this.price,
    required this.finalPrice,
    required this.order,
  });

  bool get hasDiscount => price > finalPrice;
  bool isFavorite = false;

  static const String placeholderImage =
      'https://via.placeholder.com/300x300.png?text=No+Image';

  factory FeaturedProduct.fromJson(Map<String, dynamic> json) {
    final rawImage = json['productImage'];

    return FeaturedProduct(
      productId: json['productId'] ?? '',
      productMongoId: json['productMongoId'] ?? '',
      name: json['productName'] ?? '',
      brand: json['brand'] ?? '',
      image: (rawImage != null && rawImage.toString().isNotEmpty)
          ? rawImage
          : placeholderImage,

      // NO /100 — backend already sends rupees
      price: (json['price'] ?? 0).toDouble(),
      finalPrice: (json['finalPrice'] ?? 0).toDouble(),

      order: json['order'] ?? 0,
    );
  }
}

class ProductImage {
  final String url;
  final bool isPrimary;
  final String altText;

  ProductImage({
    required this.url,
    required this.isPrimary,
    required this.altText,
  });

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      url: json['url'] ?? '',
      isPrimary: json['isPrimary'] ?? false,
      altText: json['altText'] ?? '',
    );
  }
}

class Description {
  final String short;
  final String long;
  final List<String> features;

  Description({
    required this.short,
    required this.long,
    required this.features,
  });

  factory Description.fromJson(Map<String, dynamic> json) {
    return Description(
      short: json['short'] ?? '',
      long: json['long'] ?? '',
      features: List<String>.from(json['features'] ?? []),
    );
  }
}

class Category {
  final String mainCategoryId;
  final String mainCategoryName;
  final String subCategoryName;

  Category({
    required this.mainCategoryId,
    required this.mainCategoryName,
    required this.subCategoryName,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      mainCategoryId: json['mainCategoryId'] ?? '',
      mainCategoryName: json['mainCategoryName'] ?? '',
      subCategoryName: json['subCategoryName'] ?? '',
    );
  }
}

class Pricing {
  final double regularPrice;
  final double salePrice;
  final double finalPrice;
  final String currency;

  Pricing({
    required this.regularPrice,
    required this.salePrice,
    required this.finalPrice,
    required this.currency,
  });

  factory Pricing.fromJson(Map<String, dynamic> json) {
    return Pricing(
      regularPrice: (json['regularPrice'] ?? 0).toDouble(),
      salePrice: (json['salePrice'] ?? 0).toDouble(),
      finalPrice: (json['finalPrice'] ?? 0).toDouble(),
      currency: json['currency'] ?? 'USD',
    );
  }
}

class Availability {
  final bool isAvailable;
  final int stockQuantity;
  final int lowStockLevel;
  final String stockStatus;

  Availability({
    required this.isAvailable,
    required this.stockQuantity,
    required this.lowStockLevel,
    required this.stockStatus,
  });

  factory Availability.fromJson(Map<String, dynamic> json) {
    return Availability(
      isAvailable: json['isAvailable'] ?? false,
      stockQuantity: json['stockQuantity'] ?? 0,
      lowStockLevel: json['lowStockLevel'] ?? 0,
      stockStatus: json['stockStatus'] ?? '',
    );
  }
}
