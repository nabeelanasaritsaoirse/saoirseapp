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
  final String variantId;
  final String name;
  final String brand;
  final String sku;

  final Description description;
  final Category category;
  final Availability availability;
  final Pricing pricing;
  final Seo seo;

  final Warranty warranty;
  final List<ImageData> images;

  final bool isPopular;
  final bool isBestSeller;
  final bool isTrending;

  final String status;
  final bool hasVariants;

  final List<RegionalPricing> regionalPricing;
  final List<RegionalSeo> regionalSeo;
  final List<RegionalAvailability> regionalAvailability;
  final List<RelatedProduct> relatedProducts;
  final List<Variant> variants;
  final List<Plan> plans;

  final String createdAt;
  final String updatedAt;
  final int v;

  ProductDetailsData({
    required this.id,
    required this.productId,
    required this.variantId,
    required this.name,
    required this.brand,
    required this.sku,
    required this.description,
    required this.category,
    required this.availability,
    required this.pricing,
    required this.seo,
    required this.warranty,
    required this.images,
    required this.isPopular,
    required this.isBestSeller,
    required this.isTrending,
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
      variantId: json["variantId"] ?? "",
      name: json["name"] ?? "",
      brand: json["brand"] ?? "",
      sku: json["sku"] ?? "",
      description: Description.fromJson(json["description"] ?? {}),
      category: Category.fromJson(json["category"] ?? {}),
      availability: Availability.fromJson(json["availability"] ?? {}),
      pricing: Pricing.fromJson(json["pricing"] ?? {}),
      seo: Seo.fromJson(json["seo"] ?? {}),
      warranty: json["warranty"] != null
          ? Warranty.fromJson(json["warranty"])
          : Warranty(period: 0),
      images: (json["images"] ?? [])
          .map<ImageData>((x) => ImageData.fromJson(x))
          .toList(),
      isPopular: json["isPopular"] ?? false,
      isBestSeller: json["isBestSeller"] ?? false,
      isTrending: json["isTrending"] ?? false,
      status: json["status"] ?? "",
      hasVariants: json["hasVariants"] ?? false,
      regionalPricing: (json["regionalPricing"] ?? [])
          .map<RegionalPricing>((x) => RegionalPricing.fromJson(x))
          .toList(),
      regionalSeo: (json["regionalSeo"] ?? [])
          .map<RegionalSeo>((x) => RegionalSeo.fromJson(x))
          .toList(),
      regionalAvailability: (json["regionalAvailability"] ?? [])
          .map<RegionalAvailability>((x) => RegionalAvailability.fromJson(x))
          .toList(),
      relatedProducts: (json["relatedProducts"] ?? [])
          .map<RelatedProduct>((x) => RelatedProduct.fromJson(x))
          .toList(),
      variants: (json["variants"] ?? [])
          .map<Variant>((x) => Variant.fromJson(x))
          .toList(),
      plans: (json["plans"] ?? []).map<Plan>((x) => Plan.fromJson(x)).toList(),
      createdAt: json["createdAt"] ?? "",
      updatedAt: json["updatedAt"] ?? "",
      v: json["__v"] ?? 0,
    );
  }
}

class Description {
  final String short;
  final String long;
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
  final String subCategoryId;
  final String subCategoryName;

  Category({
    required this.mainCategoryId,
    required this.mainCategoryName,
    required this.subCategoryId,
    required this.subCategoryName,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      mainCategoryId: json["mainCategoryId"] ?? "",
      mainCategoryName: json["mainCategoryName"] ?? "",
      subCategoryId: json["subCategoryId"]?.toString() ?? "",
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
      currency: json["currency"] ?? "",
    );
  }
}

class Seo {
  final List<dynamic> keywords;

  Seo({
    required this.keywords,
  });

  factory Seo.fromJson(Map<String, dynamic> json) {
    return Seo(
      keywords: json["keywords"] ?? [],
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

class RegionalPricing {
  final String region;
  final String currency;
  final double regularPrice;
  final double salePrice;
  final double finalPrice;
  final String id;

  RegionalPricing({
    required this.region,
    required this.currency,
    required this.regularPrice,
    required this.salePrice,
    required this.finalPrice,
    required this.id,
  });

  factory RegionalPricing.fromJson(Map<String, dynamic> json) {
    return RegionalPricing(
      region: json["region"] ?? "",
      currency: json["currency"] ?? "",
      regularPrice: (json["regularPrice"] ?? 0).toDouble(),
      salePrice: (json["salePrice"] ?? 0).toDouble(),
      finalPrice: (json["finalPrice"] ?? 0).toDouble(),
      id: json["_id"] ?? "",
    );
  }
}

class RegionalSeo {
  RegionalSeo();

  factory RegionalSeo.fromJson(Map<String, dynamic> json) {
    return RegionalSeo();
  }
}

class RegionalAvailability {
  final String region;
  final int stockQuantity;
  final int lowStockLevel;
  final bool isAvailable;
  final String stockStatus;
  final String id;

  RegionalAvailability({
    required this.region,
    required this.stockQuantity,
    required this.lowStockLevel,
    required this.isAvailable,
    required this.stockStatus,
    required this.id,
  });

  factory RegionalAvailability.fromJson(Map<String, dynamic> json) {
    return RegionalAvailability(
      region: json["region"] ?? "",
      stockQuantity: json["stockQuantity"] ?? 0,
      lowStockLevel: json["lowStockLevel"] ?? 0,
      isAvailable: json["isAvailable"] ?? false,
      stockStatus: json["stockStatus"] ?? "",
      id: json["_id"] ?? "",
    );
  }
}

class RelatedProduct {
  RelatedProduct();

  factory RelatedProduct.fromJson(Map<String, dynamic> json) {
    return RelatedProduct();
  }
}

class Plan {
  final String name;
  final int days;
  final double perDayAmount;
  final double totalAmount;
  final bool isRecommended;
  final String description;
  final String id;

  Plan({
    required this.name,
    required this.days,
    required this.perDayAmount,
    required this.totalAmount,
    required this.isRecommended,
    required this.description,
    required this.id,
  });

  factory Plan.fromJson(Map<String, dynamic> json) {
    return Plan(
      name: json["name"] ?? "",
      days: json["days"] ?? 0,
      perDayAmount: (json["perDayAmount"] ?? 0).toDouble(),
      totalAmount: (json["totalAmount"] ?? 0).toDouble(),
      isRecommended: json["isRecommended"] ?? false,
      description: json["description"] ?? "",
      id: json["_id"] ?? "",
    );
  }
}

class Variant {
  final VariantAttributes attributes;
  final String variantId;
  final String sku;
  final double price;
  final double salePrice;
  final PaymentPlan paymentPlan;
  final int stock;
  final List<ImageData> images;
  final bool isActive;
  final String id;

  Variant({
    required this.attributes,
    required this.variantId,
    required this.sku,
    required this.price,
    required this.salePrice,
    required this.paymentPlan,
    required this.stock,
    required this.images,
    required this.isActive,
    required this.id,
  });

  factory Variant.fromJson(Map<String, dynamic> json) {
    return Variant(
      attributes: VariantAttributes.fromJson(json["attributes"] ?? {}),
      variantId: json["variantId"] ?? "",
      sku: json["sku"] ?? "",
      price: (json["price"] ?? 0).toDouble(),
      salePrice: (json["salePrice"] ?? 0).toDouble(),
      paymentPlan: PaymentPlan.fromJson(json["paymentPlan"] ?? {}),
      stock: json["stock"] ?? 0,
      images: (json["images"] ?? [])
          .map<ImageData>((x) => ImageData.fromJson(x))
          .toList(),
      isActive: json["isActive"] ?? false,
      id: json["_id"] ?? "",
    );
  }
}

class VariantAttributes {
  final String color;

  VariantAttributes({required this.color});

  factory VariantAttributes.fromJson(Map<String, dynamic> json) {
    return VariantAttributes(
      color: json["color"] ?? "",
    );
  }
}

class PaymentPlan {
  final bool enabled;
  final double interestRate;
  final String id;

  PaymentPlan({
    required this.enabled,
    required this.interestRate,
    required this.id,
  });

  factory PaymentPlan.fromJson(Map<String, dynamic> json) {
    return PaymentPlan(
      enabled: json["enabled"] ?? false,
      interestRate: (json["interestRate"] ?? 0).toDouble(),
      id: json["_id"] ?? "",
    );
  }
}
