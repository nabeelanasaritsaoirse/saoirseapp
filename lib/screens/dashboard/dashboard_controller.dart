import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/app_strings.dart';
import '../../services/deep_link_navigation_service.dart';
import '../../widgets/app_toast.dart';
import '../cart/cart_controller.dart';
import '../category/category_controller.dart';
import '../home/home_controller.dart';
import '../profile/profile_controller.dart';
import '../refferal/referral_controller.dart';

class DashboardController extends GetxController with WidgetsBindingObserver {
  DateTime? lastBackPressed;

//-----------------------ONLY FOR PRODUCT SHARING-------------------------
  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void onReady() {
    super.onReady();

    Get.find<CartController>().fetchCartCount();
    DeepLinkNavigationService.handleProductNavigation();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      DeepLinkNavigationService.handleProductNavigation();
    }
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }
  //-----------------------ONLY FOR PRODUCT SHARING (END)-------------------------

  // Observable index to track current tab
  var selectedIndex = 0.obs;

  // Function to change tab
  void changeTab(int index) {
    selectedIndex.value = index;

    if (index == 0) {
      // If user goes to Home tab → refresh home data
      final home = Get.find<HomeController>();
      home.fetchFeaturedLists();
      home.fetchAllProducts();
    }

    if (index == 1) {
      Get.find<ProfileController>().fetchWishlistCount();
      Get.find<CategoryController>().fetchCategories();
    }

    if (index == 2) {
      Get.find<ReferralController>().fetchReferralData();
    }

    /// If user goes to Cart tab → refresh cart
    if (index == 3) {
      Get.find<CartController>().fetchCart();
    }

    if (index == 4) {
      Get.find<ProfileController>().fetchWishlistCount();
      Get.find<ProfileController>().fetchUserProfile();
    }
  }

  bool handleBackPress() {
    if (selectedIndex.value != 0) {
      changeTab(0);
      return false;
    }

    final now = DateTime.now();

    if (lastBackPressed == null ||
        now.difference(lastBackPressed!) > const Duration(seconds: 2)) {
      lastBackPressed = now;

      appToaster(
        content: AppStrings.exit_message,
        error: true,
      );

      return false;
    }

    return true;
  }
}
