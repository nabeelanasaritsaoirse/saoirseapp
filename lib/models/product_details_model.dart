class ProductDetailsResponse {
  final bool success;
  final ProductDetailsData? data;

  ProductDetailsResponse({
    required this.success,
    required this.data,
  });

  factory ProductDetailsResponse.fromJson(Map<String, dynamic> json) {
    return ProductDetailsResponse(
      success: json['success'] ?? false,
      data: json['data'] != null
          ? ProductDetailsData.fromJson(json['data'])
          : null,
    );
  }
}

class ProductDetailsData {
  final String id;
  final String productId;
  final String name;
  final String brand;
  final String sku;
  final Description description;
  final Category category;
  final Availability availability;
  final Pricing pricing;
  final Warranty warranty;
  final List<ImageData> images;

  final bool isPopular;
  final bool isBestSeller;
  final bool isTrending;

  /// ✅ Added Remaining Fields
  final String status;
  final bool hasVariants;
  final List<dynamic> regionalPricing;
  final List<dynamic> regionalSeo;
  final List<dynamic> regionalAvailability;
  final List<dynamic> relatedProducts;
  final List<dynamic> variants;
  final List<dynamic> plans;
  final String createdAt;
  final String updatedAt;
  final int v;

  ProductDetailsData({
    required this.id,
    required this.productId,
    required this.name,
    required this.brand,
    required this.sku,
    required this.description,
    required this.category,
    required this.availability,
    required this.pricing,
    required this.warranty,
    required this.images,
    required this.isPopular,
    required this.isBestSeller,
    required this.isTrending,

    /// ✅ Added fields
    required this.status,
    required this.hasVariants,
    required this.regionalPricing,
    required this.regionalSeo,
    required this.regionalAvailability,
    required this.relatedProducts,
    required this.variants,
    required this.plans,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory ProductDetailsData.fromJson(Map<String, dynamic> json) {
    return ProductDetailsData(
      id: json["_id"] ?? "",
      productId: json["productId"] ?? "",
      name: json["name"] ?? "",
      brand: json["brand"] ?? "",
      sku: json["sku"] ?? "",

      description: Description.fromJson(json["description"] ?? {}),
      category: Category.fromJson(json["category"] ?? {}),
      availability: Availability.fromJson(json["availability"] ?? {}),
      pricing: Pricing.fromJson(json["pricing"] ?? {}),

      warranty: json["warranty"] != null
          ? Warranty.fromJson(json["warranty"])
          : Warranty(period: 0),

      images: (json["images"] ?? [])
          .map<ImageData>((x) => ImageData.fromJson(x))
          .toList(),

      isPopular: json["isPopular"] ?? false,
      isBestSeller: json["isBestSeller"] ?? false,
      isTrending: json["isTrending"] ?? false,

      /// ✅ Added mappings with safe defaults
      status: json["status"] ?? "",
      hasVariants: json["hasVariants"] ?? false,
      regionalPricing: json["regionalPricing"] ?? [],
      regionalSeo: json["regionalSeo"] ?? [],
      regionalAvailability: json["regionalAvailability"] ?? [],
      relatedProducts: json["relatedProducts"] ?? [],
      variants: json["variants"] ?? [],
      plans: json["plans"] ?? [],
      createdAt: json["createdAt"] ?? "",
      updatedAt: json["updatedAt"] ?? "",
      v: json["__v"] ?? 0,
    );
  }
}

class Description {
  final String short;
  final String long;

  /// ✅ Added missing array field
  final List<dynamic> features;

  Description({
    required this.short,
    required this.long,
    required this.features,
  });

  factory Description.fromJson(Map<String, dynamic> json) {
    return Description(
      short: json["short"] ?? "",
      long: json["long"] ?? "",
      features: json["features"] ?? [],
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
      mainCategoryId: json["mainCategoryId"] ?? "",
      mainCategoryName: json["mainCategoryName"] ?? "",
      subCategoryName: json["subCategoryName"] ?? "",
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
      isAvailable: json["isAvailable"] ?? false,
      stockQuantity: json["stockQuantity"] ?? 0,
      lowStockLevel: json["lowStockLevel"] ?? 0,
      stockStatus: json["stockStatus"] ?? "",
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
      regularPrice: (json["regularPrice"] ?? 0).toDouble(),
      salePrice: (json["salePrice"] ?? 0).toDouble(),
      finalPrice: (json["finalPrice"] ?? 0).toDouble(),
      currency: json["currency"] ?? "USD",
    );
  }
}

class Warranty {
  final int period;

  Warranty({required this.period});

  factory Warranty.fromJson(Map<String, dynamic> json) {
    return Warranty(period: json["period"] ?? 0);
  }
}

class ImageData {
  final String url;
  final String? altText;
  final bool isPrimary;

  /// ✅ Added missing `_id`
  final String id;

  ImageData({
    required this.url,
    required this.altText,
    required this.isPrimary,
    required this.id,
  });

  factory ImageData.fromJson(Map<String, dynamic> json) {
    return ImageData(
      url: json["url"] ?? "",
      altText: json["altText"],
      isPrimary: json["isPrimary"] ?? false,
      id: json["_id"] ?? "",
    );
  }
}
