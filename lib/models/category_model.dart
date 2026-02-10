class CategoryGroup {
  final String id;
  final String categoryId;
  final String name;
  final String? description;
  final String slug;
  final bool isActive;
  final int displayOrder;

  /// 🔹 Home screen image (illustration)
  final CategoryImage? illustrationImage;

  /// 🔹 Category screen image (normal UI image)
  final CategoryImage? categoryImage;

  final List<SubCategory> subCategories;

  CategoryGroup({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.description,
    required this.slug,
    required this.isActive,
    required this.displayOrder,
    required this.subCategories,
    this.illustrationImage,
    this.categoryImage,
  });

  factory CategoryGroup.fromJson(Map<String, dynamic> json) {
    return CategoryGroup(
      id: json['_id'] ?? '',
      categoryId: json['categoryId'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      slug: json['slug'] ?? '',
      isActive: json['isActive'] ?? false,
      displayOrder: json['displayOrder'] ?? 0,

      /// ✅ HOME SCREEN
      illustrationImage: json['illustrationImage'] != null
          ? CategoryImage.fromJson(json['illustrationImage'])
          : null,

      /// ✅ CATEGORY SCREEN
      categoryImage: _resolveCategoryImage(json),

      subCategories: (json['subCategories'] as List<dynamic>? ?? [])
          .map((e) => SubCategory.fromJson(e)) // ✅ use subcategory json
          .toList(),
    );
  }
}

CategoryImage? _resolveCategoryImage(Map<String, dynamic> json) {
  if (json['iconImage'] != null) {
    return CategoryImage.fromJson(json['iconImage']);
  }
  if (json['mainImage'] != null) {
    return CategoryImage.fromJson(json['mainImage']);
  }
  if (json['image'] != null) {
    return CategoryImage.fromJson(json['image']);
  }
  return null;
}

class SubCategory {
  final String id;
  final String categoryId;
  final String name;
  final String slug;
  final int displayOrder;

  /// ✅ Each subcategory has its OWN image
  final CategoryImage? image;

  SubCategory({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.slug,
    required this.displayOrder,
    this.image,
  });

  factory SubCategory.fromJson(Map<String, dynamic> json) {
    return SubCategory(
      id: json['_id'] ?? '',
      categoryId: json['categoryId'] ?? '',
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      displayOrder: json['displayOrder'] ?? 0,

      /// ✅ IMPORTANT: resolve from SUBCATEGORY JSON ONLY
      image: _resolveSubCategoryImage(json),
    );
  }

  static CategoryImage? _resolveSubCategoryImage(Map<String, dynamic> json) {
    // ✅ 1. REAL subcategory image (MOST IMPORTANT)
    if (json['image'] != null) {
      return CategoryImage.fromJson(json['image']);
    }

    // ✅ 2. Optional icon image
    if (json['iconImage'] != null) {
      return CategoryImage.fromJson(json['iconImage']);
    }

    // ✅ 3. Fallback only (generic image)
    if (json['mainImage'] != null) {
      return CategoryImage.fromJson(json['mainImage']);
    }

    return null;
  }
}

class CategoryImage {
  final String url;
  final String altText;

  CategoryImage({
    required this.url,
    required this.altText,
  });

  factory CategoryImage.fromJson(Map<String, dynamic> json) {
    return CategoryImage(
      url: json['url'] ?? '',
      altText: json['altText'] ?? '',
    );
  }
}
