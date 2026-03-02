class ProductListResponse {
  final bool success;
  final List<Product> data;
  final Pagination pagination;

  ProductListResponse({
    required this.success,
    required this.data,
    required this.pagination,
  });

  factory ProductListResponse.fromJson(Map<String, dynamic> json) {
    return ProductListResponse(
      success: json["success"] ?? false,
      data: (json["data"] as List? ?? [])
          .map((e) => Product.fromJson(e))
          .toList(),
      pagination: json["pagination"] != null
          ? Pagination.fromJson(json["pagination"])
          : Pagination.empty(),
    );
  }
}

class Product {
  // Core required fields
  final String id;
  final String productId;
  final String? variantId;
  final String name;
  final String brand;
  final String sku;

  // Nested objects
  final Description description;
  final Category category;
  final Availability availability;
  final Pricing pricing;
  
  // New optional nested objects
  final Origin? origin;
  final Dimensions? dimensions;
  final Warranty? warranty;
  final ReviewStats? reviewStats;
  final Seo? seo;
  final SellerInfo? sellerInfo;

  // Variant related
  final bool hasVariants;
  final List<Variant> variants;
  final List<ProductImage> images;

  // Status and flags
  final String condition;
  final List<dynamic> tags;
  final String? defaultVariantId;
  final String? sellerId;
  final String listingStatus;
  final dynamic listingRejectionReason;
  final dynamic listingReviewedBy;
  final dynamic listingReviewedAt;
  final bool isGlobalProduct;
  
  // Payment and plans
  final PaymentPlan? paymentPlan;
  final List<Plan> plans;
  final ReferralBonus? referralBonus;
  
  // Popularity flags
  final bool isFeatured;
  final bool isPopular;
  final bool isBestSeller;
  final bool isTrending;
  
  // Status and timestamps
  final String status;
  final String createdAt;
  final String updatedAt;
  final String createdByEmail;
  final String updatedByEmail;
  final bool isDeleted;
  final int v;
  
  // Deletion/Restoration tracking
  final dynamic deletedAt;
  final dynamic deletedByEmail;
  final dynamic restoredAt;
  final dynamic restoredByEmail;
  
  // Regional and related data
  final List<RegionalPricing> regionalPricing;
  final List<RegionalSeo> regionalSeo;
  final List<RegionalAvailability> regionalAvailability;
  final List<RelatedProduct> relatedProducts;

  Product({
    // Required core fields
    required this.id,
    required this.productId,
    this.variantId,
    required this.name,
    required this.brand,
    required this.sku,
    required this.description,
    required this.category,
    required this.availability,
    required this.pricing,
    
    // Optional fields with defaults
    this.origin,
    this.dimensions,
    this.warranty,
    this.reviewStats,
    this.seo,
    this.sellerInfo,
    required this.hasVariants,
    required this.variants,
    required this.images,
    this.condition = 'new',
    this.tags = const [],
    this.defaultVariantId,
    this.sellerId,
    this.listingStatus = '',
    this.listingRejectionReason,
    this.listingReviewedBy,
    this.listingReviewedAt,
    this.isGlobalProduct = false,
    this.paymentPlan,
    this.plans = const [],
    this.referralBonus,
    this.isFeatured = false,
    this.isPopular = false,
    this.isBestSeller = false,
    this.isTrending = false,
    this.status = '',
    this.createdAt = '',
    this.updatedAt = '',
    this.createdByEmail = '',
    this.updatedByEmail = '',
    this.isDeleted = false,
    this.v = 0,
    this.deletedAt,
    this.deletedByEmail,
    this.restoredAt,
    this.restoredByEmail,
    this.regionalPricing = const [],
    this.regionalSeo = const [],
    this.regionalAvailability = const [],
    this.relatedProducts = const [],
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      // Core fields
      id: json["_id"] ?? "",
      productId: json["productId"] ?? "",
      variantId: json["variantId"],
      name: json["name"] ?? "",
      brand: json["brand"] ?? "",
      sku: json["sku"] ?? "",
      
      // Nested objects
      description: Description.fromJson(json["description"] ?? {}),
      category: Category.fromJson(json["category"] ?? {}),
      availability: Availability.fromJson(json["availability"] ?? {}),
      pricing: Pricing.fromJson(json["pricing"] ?? {}),
      
      // New optional nested objects
      origin: json["origin"] != null ? Origin.fromJson(json["origin"]) : null,
      dimensions: json["dimensions"] != null ? Dimensions.fromJson(json["dimensions"]) : null,
      warranty: json["warranty"] != null ? Warranty.fromJson(json["warranty"]) : null,
      reviewStats: json["reviewStats"] != null ? ReviewStats.fromJson(json["reviewStats"]) : null,
      seo: json["seo"] != null ? Seo.fromJson(json["seo"]) : null,
      sellerInfo: json["sellerInfo"] != null ? SellerInfo.fromJson(json["sellerInfo"]) : null,
      
      // Variant related
      hasVariants: json["hasVariants"] ?? false,
      variants: (json["variants"] as List? ?? [])
          .map((e) => Variant.fromJson(e))
          .toList(),
      images: (json["images"] as List? ?? [])
          .map((e) => ProductImage.fromJson(e))
          .toList(),
      
      // Status and flags
      condition: json["condition"] ?? "new",
      tags: json["tags"] ?? [],
      defaultVariantId: json["defaultVariantId"],
      sellerId: json["sellerId"],
      listingStatus: json["listingStatus"] ?? "",
      listingRejectionReason: json["listingRejectionReason"],
      listingReviewedBy: json["listingReviewedBy"],
      listingReviewedAt: json["listingReviewedAt"],
      isGlobalProduct: json["isGlobalProduct"] ?? false,
      
      // Payment and plans
      paymentPlan: json["paymentPlan"] != null ? PaymentPlan.fromJson(json["paymentPlan"]) : null,
      plans: (json["plans"] as List? ?? []).map((e) => Plan.fromJson(e)).toList(),
      referralBonus: json["referralBonus"] != null ? ReferralBonus.fromJson(json["referralBonus"]) : null,
      
      // Popularity flags
      isFeatured: json["isFeatured"] ?? false,
      isPopular: json["isPopular"] ?? false,
      isBestSeller: json["isBestSeller"] ?? false,
      isTrending: json["isTrending"] ?? false,
      
      // Status and timestamps
      status: json["status"] ?? "",
      createdAt: json["createdAt"] ?? "",
      updatedAt: json["updatedAt"] ?? "",
      createdByEmail: json["createdByEmail"] ?? "",
      updatedByEmail: json["updatedByEmail"] ?? "",
      isDeleted: json["isDeleted"] ?? false,
      v: json["__v"] ?? 0,
      
      // Deletion/Restoration tracking
      deletedAt: json["deletedAt"],
      deletedByEmail: json["deletedByEmail"],
      restoredAt: json["restoredAt"],
      restoredByEmail: json["restoredByEmail"],
      
      // Regional and related data
      regionalPricing: (json["regionalPricing"] as List? ?? [])
          .map((e) => RegionalPricing.fromJson(e))
          .toList(),
      regionalSeo: (json["regionalSeo"] as List? ?? [])
          .map((e) => RegionalSeo.fromJson(e))
          .toList(),
      regionalAvailability: (json["regionalAvailability"] as List? ?? [])
          .map((e) => RegionalAvailability.fromJson(e))
          .toList(),
      relatedProducts: (json["relatedProducts"] as List? ?? [])
          .map((e) => RelatedProduct.fromJson(e))
          .toList(),
    );
  }
}

// UPDATED Description class
class Description {
  final String short;
  final String long;
  final List<dynamic> features; // NEW FIELD
  final List<dynamic> specifications; // NEW FIELD

  Description({
    required this.short,
    required this.long,
    this.features = const [],
    this.specifications = const [],
  });

  factory Description.fromJson(Map<String, dynamic> json) {
    return Description(
      short: json["short"] ?? "",
      long: json["long"] ?? "",
      features: json["features"] ?? [],
      specifications: json["specifications"] ?? [],
    );
  }
}

// UPDATED Category class
class Category {
  final String mainCategoryId;
  final String mainCategoryName;
  final String? subCategoryId; // NEW FIELD (optional)
  final String? subCategoryName; // NEW FIELD (optional)

  Category({
    required this.mainCategoryId,
    required this.mainCategoryName,
    this.subCategoryId,
    this.subCategoryName,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      mainCategoryId: json["mainCategoryId"] ?? "",
      mainCategoryName: json["mainCategoryName"] ?? "",
      subCategoryId: json["subCategoryId"]?.toString(),
      subCategoryName: json["subCategoryName"],
    );
  }
}

// UPDATED Availability class
class Availability {
  final bool isAvailable;
  final int stockQuantity;
  final int lowStockLevel; // NEW FIELD
  final String stockStatus; // NEW FIELD

  Availability({
    required this.isAvailable,
    required this.stockQuantity,
    this.lowStockLevel = 0,
    this.stockStatus = '',
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

// UPDATED Pricing class
class Pricing {
  final int regularPrice;
  final int salePrice;
  final int finalPrice;
  final String currency;
  final String? baseCurrency; // NEW FIELD

  Pricing({
    required this.regularPrice,
    required this.salePrice,
    required this.finalPrice,
    required this.currency,
    this.baseCurrency,
  });

  factory Pricing.fromJson(Map<String, dynamic> json) {
    return Pricing(
      regularPrice: (json["regularPrice"] is num)
          ? (json["regularPrice"] as num).round()
          : 0,
      salePrice:
          (json["salePrice"] is num) ? (json["salePrice"] as num).round() : 0,
      finalPrice:
          (json["finalPrice"] is num) ? (json["finalPrice"] as num).round() : 0,
      currency: json["currency"] ?? "INR",
      baseCurrency: json["baseCurrency"],
    );
  }
}

// NEW CLASS - Origin
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

// NEW CLASS - Dimensions
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
    this.weight = 0,
    this.length = 0,
    this.width = 0,
    this.height = 0,
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

// NEW CLASS - Warranty
class Warranty {
  final String warrantyUnit;
  final int period;
  final int returnPolicy;

  Warranty({
    this.warrantyUnit = '',
    this.period = 0,
    this.returnPolicy = 0,
  });

  factory Warranty.fromJson(Map<String, dynamic> json) {
    return Warranty(
      warrantyUnit: json["warrantyUnit"] ?? '',
      period: json["period"] ?? 0,
      returnPolicy: json["returnPolicy"] ?? 0,
    );
  }
}

// NEW CLASS - ReviewStats
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

// NEW CLASS - AspectRatings
class AspectRatings {
  final double quality;
  final double valueForMoney;
  final double delivery;
  final double accuracy;

  AspectRatings({
    this.quality = 0,
    this.valueForMoney = 0,
    this.delivery = 0,
    this.accuracy = 0,
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

// NEW CLASS - Seo
class Seo {
  final String metaTitle;
  final String metaDescription;
  final List<dynamic> keywords;

  Seo({
    this.metaTitle = '',
    this.metaDescription = '',
    this.keywords = const [],
  });

  factory Seo.fromJson(Map<String, dynamic> json) {
    return Seo(
      metaTitle: json["metaTitle"] ?? '',
      metaDescription: json["metaDescription"] ?? '',
      keywords: json["keywords"] ?? [],
    );
  }
}

// NEW CLASS - SellerInfo
class SellerInfo {
  final String? storeName;
  final double? rating;
  final bool isVerified;

  SellerInfo({
    this.storeName,
    this.rating,
    this.isVerified = false,
  });

  factory SellerInfo.fromJson(Map<String, dynamic> json) {
    return SellerInfo(
      storeName: json["storeName"],
      rating: json["rating"]?.toDouble(),
      isVerified: json["isVerified"] ?? false,
    );
  }
}

// NEW CLASS - PaymentPlan
class PaymentPlan {
  final bool enabled;
  final int? minDownPayment;
  final int? maxDownPayment;
  final double interestRate;
  final String id;

  PaymentPlan({
    required this.enabled,
    this.minDownPayment,
    this.maxDownPayment,
    this.interestRate = 0,
    this.id = '',
  });

  factory PaymentPlan.fromJson(Map<String, dynamic> json) {
    return PaymentPlan(
      enabled: json["enabled"] ?? false,
      minDownPayment: json["minDownPayment"],
      maxDownPayment: json["maxDownPayment"],
      interestRate: (json["interestRate"] ?? 0).toDouble(),
      id: json["_id"] ?? "",
    );
  }
}

// NEW CLASS - Plan
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

// NEW CLASS - ReferralBonus
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

// NEW CLASS - RegionalPricing
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

// NEW CLASS - RegionalSeo
class RegionalSeo {
  RegionalSeo();

  factory RegionalSeo.fromJson(Map<String, dynamic> json) {
    return RegionalSeo();
  }
}

// NEW CLASS - RegionalAvailability
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

// NEW CLASS - RelatedProduct
class RelatedProduct {
  RelatedProduct();

  factory RelatedProduct.fromJson(Map<String, dynamic> json) {
    return RelatedProduct();
  }
}

// UPDATED Variant class
class Variant {
  final List<dynamic> attributes;
  final String variantId;
  final String sku;
  final int price;
  final int salePrice;
  final int stock;
  final PaymentPlan? paymentPlan;
  final List<ProductImage> images;
  final bool isActive;
  final String id;

  Variant({
    required this.attributes,
    required this.variantId,
    required this.sku,
    required this.price,
    required this.salePrice,
    required this.stock,
    this.paymentPlan,
    this.images = const [],
    this.isActive = false,
    this.id = '',
  });

  factory Variant.fromJson(Map<String, dynamic> json) {
    return Variant(
      attributes: json["attributes"] ?? [],
      variantId: json["variantId"] ?? "",
      sku: json["sku"] ?? "",
      price: (json["price"] is num) ? (json["price"] as num).round() : 0,
      salePrice: (json["salePrice"] is num) ? (json["salePrice"] as num).round() : 0,
      stock: json["stock"] ?? 0,
      paymentPlan: json["paymentPlan"] != null
          ? PaymentPlan.fromJson(json["paymentPlan"])
          : null,
      images: (json["images"] as List? ?? [])
          .map((e) => ProductImage.fromJson(e))
          .toList(),
      isActive: json["isActive"] ?? false,
      id: json["_id"] ?? "",
    );
  }
}

// UPDATED ProductImage class
class ProductImage {
  final String url;
  final bool isPrimary;
  final String? altText; // NEW FIELD
  final int? order; // NEW FIELD
  final String? id; // NEW FIELD

  ProductImage({
    required this.url,
    required this.isPrimary,
    this.altText,
    this.order,
    this.id,
  });

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      url: json["url"] ?? "",
      isPrimary: json["isPrimary"] ?? false,
      altText: json["altText"],
      order: json["order"],
      id: json["_id"],
    );
  }
}

// Pagination class remains the same
class Pagination {
  final int current;
  final int pages;
  final int total;
  final int limit; // NEW FIELD
  final bool hasNext;
  final bool hasPrev;

  Pagination({
    required this.current,
    required this.pages,
    required this.total,
    required this.limit,
    required this.hasNext,
    required this.hasPrev,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    final current = json["current"] ?? 1;
    final pages = json["pages"] ?? 1;

    return Pagination(
      current: current,
      pages: pages,
      total: json["total"] ?? 0,
      limit: json["limit"] ?? 10,
      hasNext: current < pages,
      hasPrev: current > 1,
    );
  }

  /// Fallback when API does NOT send pagination
  factory Pagination.empty() {
    return Pagination(
      current: 1,
      pages: 1,
      total: 0,
      limit: 10,
      hasNext: false,
      hasPrev: false,
    );
  }
}


