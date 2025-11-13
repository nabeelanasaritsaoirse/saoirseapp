import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/app_assets.dart';
import '../../models/product_details_model.dart';
import '../../models/product_model.dart';
import '../../widgets/select_plan_sheet.dart';


class ProductDetailsController extends GetxController {
  // UI States
  final RxInt currentImageIndex = 0.obs;
  final RxInt selectedColorIndex = 0.obs;
  final RxInt selectedStorageIndex = 0.obs;
  final RxBool isFavorite = false.obs;
  final RxInt selectedPlanIndex = (-1).obs;

  // Bottom buttons visibility
  final RxBool showBottomButtons = false.obs;
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    // Calculate scroll percentage
    final maxScroll = scrollController.position.maxScrollExtent;
    final currentScroll = scrollController.position.pixels;
    final scrollPercentage = (currentScroll / maxScroll * 100);

    // Show buttons when scrolled 60% or more
    if (scrollPercentage >= 60) {
      if (!showBottomButtons.value) {
        showBottomButtons.value = true;
      }
    } else {
      if (showBottomButtons.value) {
        showBottomButtons.value = false;
      }
    }
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  // 🧾 Product list for "Most Popular"
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

  // 🧠 Product details data
  final ProductDetailsModel product = ProductDetailsModel(
    name: 'iPhone 14',
    brand: 'Apple',
    price: 55399,
    originalPrice: 59999,
    discount: '20% OFF',
    images: [
      AppAssets.iphone,
      AppAssets.iphoneRed,
      AppAssets.iphoneYellow,
      AppAssets.iphoneblack,
    ],
    colors: [
      ProductColor(
        name: 'Purple',
        color: Color(0xFFE6D5F5),
        image: AppAssets.iphone,
      ),
      ProductColor(
        name: 'Red',
        color: Color(0xFFFF6B6B),
        image: AppAssets.iphoneRed,
      ),
      ProductColor(
        name: 'Yellow',
        color: Color(0xFFFFF59D),
        image: AppAssets.iphoneYellow,
      ),
      ProductColor(
        name: 'Green',
        color: Color(0xFF4CAF50),
        image: AppAssets.iphoneblack,
      ),
    ],
    storageOptions: ['500 GB', '1 TB', '2 TB'],
    offerPlans: [
      OfferPlan(
        image: AppAssets.upiImage,
        discount: '₹50 off',
        bgColor: Color(0xFFE3F2FD),
      ),
      OfferPlan(
        image: AppAssets.paytmImage,
        discount: '₹15 off',
        bgColor: Color(0xFFE3F2FD),
      ),
      OfferPlan(
        image: AppAssets.paypalImage,
        discount: '₹10 off',
        bgColor: Color(0xFFE3F2FD),
      ),
    ],
    description:
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
    rating: 4.9,
    reviewCount: 47,
  );

  // 🖼️ Handlers
  void updateImageIndex(int index) {
    currentImageIndex.value = index;
  }

  void selectColor(int index) {
    selectedColorIndex.value = index;
  }

  void selectStorage(int index) {
    selectedStorageIndex.value = index;
  }

  void toggleFavorite() {
    isFavorite.value = !isFavorite.value;
  }

  // 🛒 Button Actions
  // void handleSelectPlan() {
  //   // TODO: Implement plan selection logic
  //   Get.snackbar(
  //     'Select Plan',
  //     'Plan selection feature coming soon',
  //     snackPosition: SnackPosition.BOTTOM,
  //     duration: Duration(seconds: 2),
  //   );
  // }
  void openSelectPlanSheet() {
  Get.bottomSheet(
    SelectPlanSheet(),
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
  );
}



  void handleCheckout() {
   
    Get.snackbar(
      'Checkout',
      'Proceeding to checkout',
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: 2),
    );
  }
}
