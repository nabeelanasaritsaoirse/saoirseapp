class Product {
  final String name;
  final String image;
  final double price;
  final bool isFavorite;
  final bool hasDiscount;

  Product({
    required this.name,
    required this.image,
    required this.price,
    this.isFavorite = false,
    this.hasDiscount = false,
  });
}