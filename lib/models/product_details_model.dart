
import 'package:flutter/material.dart';


class ProductDetailsModel {
  final String name;
  final String brand;
  final double price;
  final double originalPrice;
  final String discount;
  final List<String> images;
  final List<ProductColor> colors;
  final List<String> storageOptions;
  final List<OfferPlan> offerPlans;
  final String description;
  final double rating;
  final int reviewCount;

  ProductDetailsModel({
    required this.name,
    required this.brand,
    required this.price,
    required this.originalPrice,
    required this.discount,
    required this.images,
    required this.colors,
    required this.storageOptions,
    required this.offerPlans,
    required this.description,
    required this.rating,
    required this.reviewCount,
  });
}

class ProductColor {
  final String name;
  final Color color;
  final String image;

  ProductColor({
    required this.name,
    required this.color,
    required this.image,
  });
}

class OfferPlan {
  final String image;
  final String discount;
  final Color bgColor;

  OfferPlan({
    required this.image,
    required this.discount,
    required this.bgColor,
  });
}
