class ProductDetailsResponse {
  final bool success;
  final ProductDetailsData? data;
  final PriceRange? priceRange; // NEW FIELD

  ProductDetailsResponse({
    required this.success,
    required this.data,
    this.priceRange, // NEW FIELD
  });

  factory ProductDetailsResponse.fromJson(Map<String, dynamic> json) {
    return ProductDetailsResponse(
      success: json['success'] ?? false,
      data: json['data'] != null
          ? ProductDetailsData.fromJson(json['data'])
          : null,
      priceRange: json['priceRange'] != null // NEW FIELD
          ? PriceRange.fromJson(json['priceRange'])
          : null,
    );
  }
}

// NEW CLASS
class PriceRange {
  final double min;
  final double max;
  final String currency;

  PriceRange({
    required this.min,
    required this.max,
    required this.currency,
  });

  factory PriceRange.fromJson(Map<String, dynamic> json) {
    return PriceRange(
      min: (json['min'] ?? 0).toDouble(),
      max: (json['max'] ?? 0).toDouble(),
      currency: json['currency'] ?? '',
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

  // NEW FIELDS
  final Origin? origin;
  final Dimensions? dimensions;
  final ReviewStats? reviewStats;
  final SellerInfo? sellerInfo;
  final String condition;
  final List<dynamic> tags;
  final String? defaultVariantId;
  final String? sellerId;
  final String listingStatus;
  final dynamic listingRejectionReason;
  final dynamic listingReviewedBy;
  final dynamic listingReviewedAt;
  final bool isGlobalProduct;
  final PaymentPlan? paymentPlan;
  final ReferralBonus? referralBonus;
  final bool isFeatured;
  final dynamic deletedAt;
  final dynamic deletedByEmail;
  final dynamic restoredAt;
  final dynamic restoredByEmail;
  final String createdByEmail;
  final String updatedByEmail;
  final bool isDeleted;

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
    // NEW FIELDS - make them nullable
    this.origin,
    this.dimensions,
    this.reviewStats,
    this.sellerInfo,
    this.condition = '',
    this.tags = const [],
    this.defaultVariantId,
    this.sellerId,
    this.listingStatus = '',
    this.listingRejectionReason,
    this.listingReviewedBy,
    this.listingReviewedAt,
    this.isGlobalProduct = false,
    this.paymentPlan,
    this.referralBonus,
    this.isFeatured = false,
    this.deletedAt,
    this.deletedByEmail,
    this.restoredAt,
    this.restoredByEmail,
    this.createdByEmail = '',
    this.updatedByEmail = '',
    this.isDeleted = false,
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
      
      // NEW FIELDS
      origin: json["origin"] != null ? Origin.fromJson(json["origin"]) : null,
      dimensions: json["dimensions"] != null ? Dimensions.fromJson(json["dimensions"]) : null,
      reviewStats: json["reviewStats"] != null ? ReviewStats.fromJson(json["reviewStats"]) : null,
      sellerInfo: json["sellerInfo"] != null ? SellerInfo.fromJson(json["sellerInfo"]) : null,
      condition: json["condition"] ?? "",
      tags: json["tags"] ?? [],
      defaultVariantId: json["defaultVariantId"],
      sellerId: json["sellerId"],
      listingStatus: json["listingStatus"] ?? "",
      listingRejectionReason: json["listingRejectionReason"],
      listingReviewedBy: json["listingReviewedBy"],
      listingReviewedAt: json["listingReviewedAt"],
      isGlobalProduct: json["isGlobalProduct"] ?? false,
      paymentPlan: json["paymentPlan"] != null ? PaymentPlan.fromJson(json["paymentPlan"]) : null,
      referralBonus: json["referralBonus"] != null ? ReferralBonus.fromJson(json["referralBonus"]) : null,
      isFeatured: json["isFeatured"] ?? false,
      deletedAt: json["deletedAt"],
      deletedByEmail: json["deletedByEmail"],
      restoredAt: json["restoredAt"],
      restoredByEmail: json["restoredByEmail"],
      createdByEmail: json["createdByEmail"] ?? "",
      updatedByEmail: json["updatedByEmail"] ?? "",
      isDeleted: json["isDeleted"] ?? false,
    );
  }
}

// NEW CLASS
class Origin {
  final String country;
  final String manufacturer;

  Origin({
    required this.country,
    required this.manufacturer,
  });

  factory Origin.fromJson(Map<String, dynamic> json) {
    return Origin(
      country: json["country"] ?? "",
      manufacturer: json["manufacturer"] ?? "",
    );
  }
}

// NEW CLASS
class Dimensions {
  final String weightUnit;
  final String dimensionUnit;
  final double weight;
  final double length;
  final double width;
  final double height;

  Dimensions({
    required this.weightUnit,
    required this.dimensionUnit,
    required this.weight,
    required this.length,
    required this.width,
    required this.height,
  });

  factory Dimensions.fromJson(Map<String, dynamic> json) {
    return Dimensions(
      weightUnit: json["weightUnit"] ?? "",
      dimensionUnit: json["dimensionUnit"] ?? "",
      weight: (json["weight"] ?? 0).toDouble(),
      length: (json["length"] ?? 0).toDouble(),
      width: (json["width"] ?? 0).toDouble(),
      height: (json["height"] ?? 0).toDouble(),
    );
  }
}

// NEW CLASS
class ReviewStats {
  final AspectRatings aspectRatings;
  final Map<String, int> ratingDistribution;
  final double averageRating;
  final int totalReviews;

  ReviewStats({
    required this.aspectRatings,
    required this.ratingDistribution,
    required this.averageRating,
    required this.totalReviews,
  });

  factory ReviewStats.fromJson(Map<String, dynamic> json) {
    return ReviewStats(
      aspectRatings: AspectRatings.fromJson(json["aspectRatings"] ?? {}),
      ratingDistribution: Map.from(json["ratingDistribution"] ?? {})
          .map((k, v) => MapEntry(k.toString(), v as int)),
      averageRating: (json["averageRating"] ?? 0).toDouble(),
      totalReviews: json["totalReviews"] ?? 0,
    );
  }
}

// NEW CLASS
class AspectRatings {
  final double quality;
  final double valueForMoney;
  final double delivery;
  final double accuracy;

  AspectRatings({
    required this.quality,
    required this.valueForMoney,
    required this.delivery,
    required this.accuracy,
  });

  factory AspectRatings.fromJson(Map<String, dynamic> json) {
    return AspectRatings(
      quality: (json["quality"] ?? 0).toDouble(),
      valueForMoney: (json["valueForMoney"] ?? 0).toDouble(),
      delivery: (json["delivery"] ?? 0).toDouble(),
      accuracy: (json["accuracy"] ?? 0).toDouble(),
    );
  }
}

// NEW CLASS
class SellerInfo {
  final String? storeName;
  final double? rating;
  final bool isVerified;

  SellerInfo({
    this.storeName,
    this.rating,
    required this.isVerified,
  });

  factory SellerInfo.fromJson(Map<String, dynamic> json) {
    return SellerInfo(
      storeName: json["storeName"],
      rating: json["rating"]?.toDouble(),
      isVerified: json["isVerified"] ?? false,
    );
  }
}

// NEW CLASS
class ReferralBonus {
  final bool enabled;
  final String type;
  final double value;
  final double minPurchaseAmount;
  final String id;

  ReferralBonus({
    required this.enabled,
    required this.type,
    required this.value,
    required this.minPurchaseAmount,
    required this.id,
  });

  factory ReferralBonus.fromJson(Map<String, dynamic> json) {
    return ReferralBonus(
      enabled: json["enabled"] ?? false,
      type: json["type"] ?? "",
      value: (json["value"] ?? 0).toDouble(),
      minPurchaseAmount: (json["minPurchaseAmount"] ?? 0).toDouble(),
      id: json["_id"] ?? "",
    );
  }
}

// UPDATE EXISTING CLASS - Description
class Description {
  final String short;
  final String long;  // This maps to 'features' in your old model? 
  final List<dynamic> features;
  final List<dynamic> specifications; // NEW FIELD

  Description({
    required this.short,
    required this.long,
    required this.features,
    required this.specifications, // NEW FIELD
  });

  factory Description.fromJson(Map<String, dynamic> json) {
    return Description(
      short: json["short"] ?? "",
      long: json["long"] ?? "",
      features: json["features"] ?? [],
      specifications: json["specifications"] ?? [], // NEW FIELD
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


// UPDATE EXISTING CLASS - Warranty
class Warranty {
  final int period;
  final String warrantyUnit; // NEW FIELD
  final int returnPolicy; // NEW FIELD

  Warranty({
    required this.period,
    this.warrantyUnit = '', // NEW FIELD
    this.returnPolicy = 0, // NEW FIELD
  });

  factory Warranty.fromJson(Map<String, dynamic> json) {
    return Warranty(
      period: json["period"] ?? 0,
      warrantyUnit: json["warrantyUnit"] ?? '', // NEW FIELD
      returnPolicy: json["returnPolicy"] ?? 0, // NEW FIELD
    );
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

class Variant {
 final List<VariantAttributes> attributes;
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
      attributes: (json["attributes"] ?? [])
    .map<VariantAttributes>((x) => VariantAttributes.fromJson(x))
    .toList(),
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


// UPDATE EXISTING CLASS - Seo
class Seo {
  final String metaTitle; // NEW FIELD
  final String metaDescription; // NEW FIELD
  final List<dynamic> keywords;

  Seo({
    required this.keywords,
    this.metaTitle = '', // NEW FIELD
    this.metaDescription = '', // NEW FIELD
  });

  factory Seo.fromJson(Map<String, dynamic> json) {
    return Seo(
      keywords: json["keywords"] ?? [],
      metaTitle: json["metaTitle"] ?? '', // NEW FIELD
      metaDescription: json["metaDescription"] ?? '', // NEW FIELD
    );
  }
}

// UPDATE EXISTING CLASS - Plan
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

// UPDATE EXISTING CLASS - PaymentPlan
class PaymentPlan {
  final bool enabled;
  final double interestRate;
  final String id;
  final int? minDownPayment; // NEW FIELD
  final int? maxDownPayment; // NEW FIELD

  PaymentPlan({
    required this.enabled,
    required this.interestRate,
    required this.id,
    this.minDownPayment, // NEW FIELD
    this.maxDownPayment, // NEW FIELD
  });

  factory PaymentPlan.fromJson(Map<String, dynamic> json) {
    return PaymentPlan(
      enabled: json["enabled"] ?? false,
      interestRate: (json["interestRate"] ?? 0).toDouble(),
      id: json["_id"] ?? "",
      minDownPayment: json["minDownPayment"], // NEW FIELD
      maxDownPayment: json["maxDownPayment"], // NEW FIELD
    );
  }
}

// The following classes remain unchanged:
// - Category
// - Availability
// - Pricing
// - ImageData
// - RegionalPricing
// - RegionalSeo
// - RegionalAvailability
// - RelatedProduct
// - Variant
// - VariantAttributes

