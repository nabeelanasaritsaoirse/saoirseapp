class Products {
  final String name;
  final String image;
  final int price;
  final bool hasDiscount;
  final bool isFavorite;

  Products({
    required this.name,
    required this.image,
    required this.price,
    this.hasDiscount = false,
    this.isFavorite = false,
  });

  // Optional: From JSON (if you fetch from API later)
  factory Products.fromJson(Map<String, dynamic> json) {
    return Products(
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      price: json['price'] ?? 0,
      hasDiscount: json['hasDiscount'] ?? false,
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  // Optional: To JSON (if needed)
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'image': image,
      'price': price,
      'hasDiscount': hasDiscount,
      'isFavorite': isFavorite,
    };
  }
}