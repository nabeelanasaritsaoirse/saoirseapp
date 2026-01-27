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
      // pagination is NOT sent by new API → fallback safely
      pagination: json["pagination"] != null
          ? Pagination.fromJson(json["pagination"])
          : Pagination.empty(),
    );
  }
}

class Product {
  final String id;
  final String productId;
  final String? variantId;
  final String name;
  final String brand;
  final String sku;

  final Description description;
  final Category category;
  final Availability availability;
  final Pricing pricing;

  final bool hasVariants;
  final List<Variant> variants;
  final List<ProductImage> images;

  Product({
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
    required this.hasVariants,
    required this.variants,
    required this.images,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json["_id"] ?? "",
      productId: json["productId"] ?? "",
      variantId: json["variantId"],
      name: json["name"] ?? "",
      brand: json["brand"] ?? "",
      sku: json["sku"] ?? "",
      description: Description.fromJson(json["description"] ?? {}),
      category: Category.fromJson(json["category"] ?? {}),
      availability: Availability.fromJson(json["availability"] ?? {}),
      pricing: Pricing.fromJson(json["pricing"] ?? {}),
      hasVariants: json["hasVariants"] ?? false,
      variants: (json["variants"] as List? ?? [])
          .map((e) => Variant.fromJson(e))
          .toList(),
      images: (json["images"] as List? ?? [])
          .map((e) => ProductImage.fromJson(e))
          .toList(),
    );
  }
}

class Description {
  final String short;
  final String long;

  Description({
    required this.short,
    required this.long,
  });

  factory Description.fromJson(Map<String, dynamic> json) {
    return Description(
      short: json["short"] ?? "",
      long: json["long"] ?? "",
    );
  }
}

class Category {
  final String mainCategoryId;
  final String mainCategoryName;

  Category({
    required this.mainCategoryId,
    required this.mainCategoryName,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      mainCategoryId: json["mainCategoryId"] ?? "",
      mainCategoryName: json["mainCategoryName"] ?? "",
    );
  }
}

class Availability {
  final bool isAvailable;
  final int stockQuantity;

  Availability({
    required this.isAvailable,
    required this.stockQuantity,
  });

  factory Availability.fromJson(Map<String, dynamic> json) {
    return Availability(
      isAvailable: json["isAvailable"] ?? false,
      stockQuantity: json["stockQuantity"] ?? 0,
    );
  }
}

class Pricing {
  final int regularPrice;
  final int salePrice;
  final int finalPrice;
  final String currency;

  Pricing({
    required this.regularPrice,
    required this.salePrice,
    required this.finalPrice,
    required this.currency,
  });

  factory Pricing.fromJson(Map<String, dynamic> json) {
    return Pricing(
      regularPrice: (json["regularPrice"] is num)
          ? (json["regularPrice"] as num).round()
          : 0,
      salePrice: (json["salePrice"] is num)
          ? (json["salePrice"] as num).round()
          : 0,
      finalPrice: (json["finalPrice"] is num)
          ? (json["finalPrice"] as num).round()
          : 0,
      currency: json["currency"] ?? "INR",
    );
  }
}

class Variant {
  final Map<String, dynamic> attributes;
  final String variantId;
  final String sku;
  final int price;
  final int salePrice;
  final int stock;

  Variant({
    required this.attributes,
    required this.variantId,
    required this.sku,
    required this.price,
    required this.salePrice,
    required this.stock,
  });

  factory Variant.fromJson(Map<String, dynamic> json) {
    return Variant(
      attributes: json["attributes"] ?? {},
      variantId: json["variantId"] ?? "",
      sku: json["sku"] ?? "",
      price: (json["price"] is num) ? (json["price"] as num).round() : 0,
      salePrice:
          (json["salePrice"] is num) ? (json["salePrice"] as num).round() : 0,
      stock: json["stock"] ?? 0,
    );
  }
}

class ProductImage {
  final String url;
  final bool isPrimary;

  ProductImage({
    required this.url,
    required this.isPrimary,
  });

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      url: json["url"] ?? "",
      isPrimary: json["isPrimary"] ?? false,
    );
  }
}

class Pagination {
  final int current;
  final int pages;
  final int total;
  final bool hasNext;
  final bool hasPrev;

  Pagination({
    required this.current,
    required this.pages,
    required this.total,
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
      hasNext: false,
      hasPrev: false,
    );
  }
}



