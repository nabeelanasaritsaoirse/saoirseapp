class CategoryGroup {
  final String id;
  final String categoryId;
  final String name;
  final String? description;
  final String slug;
  final bool isActive;
  final int displayOrder;

  //  single image for parent category
  final CategoryImage? image;

  // sub categories
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
    this.image,
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

      // 🔹 only this one image used for UI
      image: json['image'] != null
          ? CategoryImage.fromJson(json['image'] as Map<String, dynamic>)
          : null,

      subCategories: (json['subCategories'] as List<dynamic>? ?? [])
          .map((e) => SubCategory.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class SubCategory {
  final String id;
  final String categoryId;
  final String name;
  final String slug;
  final int displayOrder;

  //  single image for subcategory
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
      image: json['image'] != null
          ? CategoryImage.fromJson(json['image'] as Map<String, dynamic>)
          : null,
    );
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
