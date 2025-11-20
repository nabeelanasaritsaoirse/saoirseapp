// models/product_model.dart
class Product {
  final String id;
  final String productId;
  final String name;
  final String brand;
  final String sku;
  final List<ProductImage> images;
  final Description description;
  final Category category;
  final Pricing pricing;
  final Availability availability;
  final bool isPopular;
  final bool isBestSeller;
  final bool isTrending;
  final String status;

  Product({
    required this.id,
    required this.productId,
    required this.name,
    required this.brand,
    required this.sku,
    required this.images,
    required this.description,
    required this.category,
    required this.pricing,
    required this.availability,
    required this.isPopular,
    required this.isBestSeller,
    required this.isTrending,
    required this.status,
  });

  // For backward compatibility with your existing UI
  String get image => images.isNotEmpty ? images.first.url : '';
  double get price => pricing.finalPrice;
  bool get hasDiscount => pricing.regularPrice > pricing.salePrice;
  bool isFavorite = false; // You can manage this separately

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'] ?? '',
      productId: json['productId'] ?? '',
      name: json['name'] ?? '',
      brand: json['brand'] ?? '',
      sku: json['sku'] ?? '',
      images: (json['images'] as List?)
              ?.map((img) => ProductImage.fromJson(img))
              .toList() ??
          [],
      description: Description.fromJson(json['description'] ?? {}),
      category: Category.fromJson(json['category'] ?? {}),
      pricing: Pricing.fromJson(json['pricing'] ?? {}),
      availability: Availability.fromJson(json['availability'] ?? {}),
      isPopular: json['isPopular'] ?? false,
      isBestSeller: json['isBestSeller'] ?? false,
      isTrending: json['isTrending'] ?? false,
      status: json['status'] ?? '',
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