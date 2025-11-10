import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saoirse_app/dummy/dummy_assets.dart';
import 'package:saoirse_app/models/category_model.dart';

class CategoryController extends GetxController {
  final selectedIndex = 0.obs;
  final scrollController = Rxn<ScrollController>();

  final categoryGroups = <CategoryGroup>[
    CategoryGroup(
      name: 'Mobile &\nElectronics',
      icon: DummyAssets.electronics,
      subCategories: [
        SubCategory(name: 'Mobile & Electronics', image: DummyAssets.electronics),
        SubCategory(name: 'Mobiles', image: DummyAssets.mobile),
        SubCategory(name: 'Laptops', image: DummyAssets.laptops),
        SubCategory(name: 'Tablets', image: DummyAssets.tablets),
        SubCategory(name: 'Cameras', image: DummyAssets.cameras),
        SubCategory(name: 'Televisions', image: DummyAssets.televisions),
        SubCategory(name: 'Fridges', image: DummyAssets.fridges),
        SubCategory(name: 'AC', image: DummyAssets.ac),
        SubCategory(name: 'Washing Machine', image: DummyAssets.washingMachine),
      ],
    ),
    CategoryGroup(
      name: 'Fashion',
      icon: DummyAssets.fashion,
      subCategories: [
        SubCategory(name: 'Fashion', image: DummyAssets.fashion),
        SubCategory(name: 'Men\'s Clothing', image: DummyAssets.grinder),
        SubCategory(name: 'Women\'s Clothing', image: DummyAssets.mobile),
        SubCategory(name: 'Kids Wear', image: DummyAssets.laptops),
      ],
    ),
    CategoryGroup(
      name: 'Furniture',
      icon: DummyAssets.furniture,
      subCategories: [
        SubCategory(name: 'Furniture', image: DummyAssets.furniture),
        SubCategory(name: 'Living Room', image: DummyAssets.cameras),
        SubCategory(name: 'Bedroom', image: DummyAssets.mobile),
      ],
    ),
    CategoryGroup(
      name: 'Sports &\nFitness',
      icon: DummyAssets.sports,
      subCategories: [
        SubCategory(name: 'Sports & Fitness', image: DummyAssets.sports),
        SubCategory(name: 'Exercise Equipment', image: DummyAssets.cameras),
        SubCategory(name: 'Sports Accessories', image: DummyAssets.fridges),
      ],
    ),
    CategoryGroup(
      name: 'Books',
      icon: DummyAssets.books,
      subCategories: [
        SubCategory(name: 'Books', image: DummyAssets.books),
        SubCategory(name: 'Fiction', image: DummyAssets.cameras),
        SubCategory(name: 'Non-Fiction', image: DummyAssets.mobile),
      ],
    ),
  ].obs;

  @override
  void onInit() {
    super.onInit();
    scrollController.value = ScrollController();
  }

  void selectCategory(int index) {
    selectedIndex.value = index;

    // Smooth scroll to selected category (optional)
    final controller = scrollController.value;
    if (controller != null && controller.hasClients) {
      controller.animateTo(
        index * 90.0, // adjust to match item height
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  List<SubCategory> get selectedSubCategories =>
      categoryGroups[selectedIndex.value].subCategories;
}








// import 'package:get/get.dart';

// import 'package:saoirse_app/dummy/dummy_assets.dart';
// import 'package:saoirse_app/models/category_model.dart';

// class CategoryController extends GetxController {
//   final selectedIndex = 0.obs;

//   final categoryGroups = <CategoryGroup>[
//     CategoryGroup(
//       name: 'Mobile &\nElectronics',
//       icon: DummyAssets.electronics,
//       subCategories: [
//         SubCategory(name: 'Mobile & Electronics', image: DummyAssets.electronics),
//         SubCategory(name: 'Mobiles', image: DummyAssets.mobile),
//         SubCategory(name: 'Laptops', image: DummyAssets.laptops),
//         SubCategory(name: 'Tablets', image: DummyAssets.tablets),
//         SubCategory(name: 'Cameras', image: DummyAssets.cameras),
//         SubCategory(name: 'Televisions', image: DummyAssets.televisions),
//         SubCategory(name: 'Fridges', image: DummyAssets.fridges),
//         SubCategory(name: 'AC', image: DummyAssets.ac),
//         SubCategory(name: 'Washing Machine', image: DummyAssets.washingMachine),
//       ],
//     ),
//     CategoryGroup(
//       name: 'Fashion',
//       icon: DummyAssets.fashion,
//       subCategories: [
//         SubCategory(name: 'Fashion', image: DummyAssets.fashion),
//         SubCategory(name: 'Men\'s Clothing', image: DummyAssets.grinder),
//         SubCategory(name: 'Women\'s Clothing', image: DummyAssets.mobile),
//         SubCategory(name: 'Kids Wear', image: DummyAssets.laptops),
//       ],
//     ),
//     CategoryGroup(
//       name: 'Furniture',
//       icon:  DummyAssets.furniture,
//       subCategories: [
//         SubCategory(name: 'Furniture', image: DummyAssets.furniture),
//         SubCategory(name: 'Living Room', image: DummyAssets.cameras),
//         SubCategory(name: 'Bedroom', image: DummyAssets.mobile),
//       ],
//     ),
//     CategoryGroup(
//       name: 'Sports &\nFitness',
//       icon: DummyAssets.sports,
//       subCategories: [
//         SubCategory(name: 'Sports & Fitness', image: DummyAssets.sports),
//         SubCategory(name: 'Exercise Equipment', image: DummyAssets.cameras),
//         SubCategory(name: 'Sports Accessories', image: DummyAssets.fridges),
//       ],
//     ),
//     CategoryGroup(
//       name: 'Books',
//       icon: DummyAssets.books,
//       subCategories: [
//         SubCategory(name: 'Books', image: DummyAssets.books),
//         SubCategory(name: 'Fiction', image: DummyAssets.cameras),
//         SubCategory(name: 'Non-Fiction', image: DummyAssets.mobile),
//       ],
//     ),
//   ].obs;

//   void selectCategory(int index) {
//     selectedIndex.value = index;
//       update();
//   }

//   List<SubCategory> get selectedSubCategories =>
//       categoryGroups[selectedIndex.value].subCategories;
// }
