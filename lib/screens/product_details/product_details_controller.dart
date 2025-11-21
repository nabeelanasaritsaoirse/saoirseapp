// FILE: lib/controllers/product_details_controller.dart
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/product_details_model.dart';
import '../../services/product_service.dart';
import '../../services/wishlist_service.dart';
import '../../widgets/app_snackbar.dart';

class ProductDetailsController extends GetxController {
  final String productId;
  final String id;

  ProductDetailsController(this.productId, this.id);

  final WishlistService wishlistService = WishlistService();
  final ProductService productService = ProductService();

  RxBool isLoading = true.obs;
  Rx<ProductDetailsData?> product = Rx<ProductDetailsData?>(null);

  RxInt currentImageIndex = 0.obs;
  RxBool isFavorite = false.obs;
  RxInt selectedPlanIndex = (-1).obs;

  RxBool showBottomButtons = false.obs;
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_scrollListener);
    fetchProductDetails();
    checkIfInWishlist();
  }

  // ----------------------------------------------------------
  // FETCH PRODUCT DETAILS
  // ----------------------------------------------------------
  Future<void> fetchProductDetails() async {
    try {
      isLoading(true);
      final result = await productService.fetchProductDetails(productId);
      product.value = result;
    } catch (e) {
      log("ERROR FETCHING PRODUCT DETAILS: $e");
      appSnackbar(content: "Failed to load product details");
    } finally {
      isLoading(false);
    }
  }

  // ----------------------------------------------------------
  // CHECK IF PRODUCT IS IN WISHLIST
  // ----------------------------------------------------------
  Future<void> checkIfInWishlist() async {
    final exists = await wishlistService.checkWishlist(id);
    isFavorite.value = exists;
  }

// TOGGLE WISHLIST (ADD OR REMOVE)
// ----------------------------------------------------------
  Future<void> toggleFavorite() async {
    final productData = product.value;

    if (productData == null) {
      appSnackbar(content: "Product not loaded");
      return;
    }

    // If currently favorite → remove it
    if (isFavorite.value) {
      final removed = await wishlistService.removeFromWishlist(id);

      if (removed) {
        isFavorite(false);
        appSnackbar(content: "Removed from wishlist");
      } else {
        appSnackbar(content: "Failed to remove from wishlist", error: true);
      }

      return;
    }

    // If NOT favorite → add it
    final added = await wishlistService.addToWishlist(id);

    if (added) {
      isFavorite(true);
      appSnackbar(content: "Added to wishlist");
    } else {
      appSnackbar(content: "Failed to add wishlist", error: true);
    }
  }

  // ----------------------------------------------------------
  // SCROLL LISTENER (BOTTOM BUTTON ANIMATION)
  // ----------------------------------------------------------
  void _scrollListener() {
    if (!scrollController.hasClients) return;

    final maxScroll = scrollController.position.maxScrollExtent;
    final current = scrollController.position.pixels;

    if (maxScroll <= 0) return;

    final percent = (current / maxScroll) * 100;

    showBottomButtons.value = percent >= 60;
  }

  // ----------------------------------------------------------
  // IMAGE INDICATOR
  // ----------------------------------------------------------
  void updateImageIndex(int index) {
    currentImageIndex.value = index;
  }

  // ----------------------------------------------------------
  // PLAN SELECT
  // ----------------------------------------------------------
  void openSelectPlanSheet() {
    Get.bottomSheet(
      Container(
        height: 300,
        color: Colors.white,
        child: const Center(
          child: Text('Select plan sheet'),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
  }

  void selectPlan(int index) {
    selectedPlanIndex.value = index;
  }
}
