// ignore_for_file: library_prefixes

import 'package:get/get.dart';

import '../../constants/app_assets.dart';
import '../../models/product_model.dart';

class HomeController extends GetxController {
  RxBool loading = false.obs;
  RxInt currentCarouselIndex = 0.obs;
  RxInt currentBottomCarouselIndex = 0.obs;
  // Fot the custom  images
  final RxList<String> carouselImages = <String>[
    'https://images.unsplash.com/photo-1441984904996-e0b6ba687e04?w=800',
    'https://images.unsplash.com/photo-1483985988355-763728e1935b?w=800',
    'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=800',
  ].obs;

  final RxList<String> successImages = <String>[
    AppAssets.success_image_1,
    AppAssets.success_image_2,
    AppAssets.success_image_3,
  ].obs;

  final RxList<Product> mostPopularProducts = <Product>[
    Product(
      name: 'Modern Chair',
      image: "assets/images/chair.png",
      price: 12500,
      hasDiscount: true,
    ),
    Product(
      name: 'Sony Ear Buds',
      image: 'assets/images/product_image_2.png',
      price: 69999,
      isFavorite: true,
      hasDiscount: true,
    ),
    Product(
      name: 'Modern Chair',
      image: "assets/images/chair.png",
      price: 12500,
      hasDiscount: true,
    ),
    Product(
      name: 'Sony Ear Buds',
      image: 'assets/images/product_image_2.png',
      price: 69999,
      isFavorite: true,
      hasDiscount: true,
    ),
  ].obs;

  final RxList<Product> bestSellerProducts = <Product>[
    Product(
      name: 'Marine Crystal Bag',
      image: "assets/images/bag.png",
      price: 7999,
    ),
    Product(
      name: 'Black Cotton dress',
      image: 'assets/images/dress.png',
      price: 24999,
    ),
  ].obs;

  final RxList<Product> trendingProducts = <Product>[
    Product(
      name: 'Iphone 16',
      image: "assets/images/phone.png",
      price: 669999,
      hasDiscount: true,
    ),
    Product(
      name: 'Pixel Watch',
      image: "assets/images/watch.png",
      price: 96999,
      hasDiscount: true,
    ),
    Product(
      name: 'Iphone 16',
      image: "assets/images/phone.png",
      price: 669999,
      hasDiscount: true,
    ),
    Product(
      name: 'Pixel Watch',
      image: "assets/images/watch.png",
      price: 96999,
      hasDiscount: true,
    ),
  ].obs;
}
