
class CategoryGroup {
  final String id;          
  final String categoryId;   
  final String name;        
  final String description;  
  final String slug;         
  final bool isActive;       
  final int displayOrder;   
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
  });

  factory CategoryGroup.fromJson(Map<String, dynamic> json) {
    return CategoryGroup(
      id: json['_id'] ?? '',
      categoryId: json['categoryId'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      slug: json['slug'] ?? '',
      isActive: json['isActive'] ?? false,
      displayOrder: json['displayOrder'] ?? 0,
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

  SubCategory({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.slug,
    required this.displayOrder,
  });

  factory SubCategory.fromJson(Map<String, dynamic> json) {
    return SubCategory(
      id: json['_id'] ?? '',
      categoryId: json['categoryId'] ?? '',
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      displayOrder: json['displayOrder'] ?? 0,
    );
  }
}
