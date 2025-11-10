
// Model
class CategoryGroup {
  final String name;
  final String icon;
  final List<SubCategory> subCategories;

  CategoryGroup({
    required this.name,
    required this.icon,
    required this.subCategories,
  });
}

class SubCategory {
  final String name;
  final String image;

  SubCategory({required this.name, required this.image});
}