// FILE: lib/controllers/product_details_controller.dart

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:saoirse_app/models/product_details_model.dart';
import 'package:saoirse_app/services/product_service.dart';
import 'package:saoirse_app/services/wishlist_service.dart';
import 'package:saoirse_app/widgets/app_snackbar.dart';
import 'package:saoirse_app/widgets/select_plan_sheet.dart';

class ProductDetailsController extends GetxController {
  final String productId;
  final String id;

  ProductDetailsController(this.productId, this.id);

  final WishlistService wishlistService = WishlistService();
  final ProductService productService = ProductService();
  bool isUpdating = false;


  RxBool isLoading = true.obs;
  Rx<ProductDetailsData?> product = Rx<ProductDetailsData?>(null);

  RxInt currentImageIndex = 0.obs;
  RxBool isFavorite = false.obs;
  RxInt selectedPlanIndex = (-1).obs;

  /// Custom plan values
  RxInt customDays = 0.obs;
  RxDouble customAmount = 0.0.obs;

  RxBool showBottomButtons = false.obs;
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_scrollListener);
    fetchProductDetails();
    checkIfInWishlist();
  }

  // FETCH PRODUCT DETAILS
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

  // CHECK IF PRODUCT IS IN WISHLIST
  Future<void> checkIfInWishlist() async {
    final exists = await wishlistService.checkWishlist(id);
    isFavorite.value = exists;
  }

  // TOGGLE WISHLIST
  Future<void> toggleFavorite() async {
    final productData = product.value;

    if (productData == null) {
      appSnackbar(content: "Product not loaded");
      return;
    }

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

    final added = await wishlistService.addToWishlist(id);

    if (added) {
      isFavorite(true);
      appSnackbar(content: "Added to wishlist");
    } else {
      appSnackbar(content: "Failed to add wishlist", error: true);
    }
  }

  // SCROLL LISTENER
  void _scrollListener() {
    if (!scrollController.hasClients) return;

    final maxScroll = scrollController.position.maxScrollExtent;
    final current = scrollController.position.pixels;

    if (maxScroll <= 0) return;

    final percent = (current / maxScroll) * 100;

    showBottomButtons.value = percent >= 60;
  }


  void updateImageIndex(int index) {
    currentImageIndex.value = index;
  }

  void openSelectPlanSheet() {
    Get.bottomSheet(
      const SelectPlanSheet(),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

 
 void updateAmountFromDays(
  TextEditingController daysController,
  TextEditingController amountController,
) {
  if (isUpdating) return;
  isUpdating = true;

  final data = product.value;
  if (data == null) {
    isUpdating = false;
    return;
  }

  final double totalPrice = data.pricing.finalPrice; 
  final int days = int.tryParse(daysController.text.trim()) ?? 0;

  if (days <= 0) {
    amountController.text = "";
    isUpdating = false;
    return;
  }

 
  final double perDayAmount = totalPrice / days;

  amountController.text = perDayAmount.toStringAsFixed(2);

  isUpdating = false;
}



 void updateDaysFromAmount(
  TextEditingController daysController,
  TextEditingController amountController,
) {
  if (isUpdating) return;
  isUpdating = true;

  final data = product.value;
  if (data == null) {
    isUpdating = false;
    return;
  }

  final double totalPrice = data.pricing.finalPrice; 
  final double perDayAmount = double.tryParse(amountController.text.trim()) ?? 0;

  if (perDayAmount <= 0) {
    daysController.text = "";
    isUpdating = false;
    return;
  }

  final int days = (totalPrice / perDayAmount).round();

  daysController.text = days.toString();

  isUpdating = false;
}




  void setCustomPlan(int days, double amount) {
    customDays.value = days;
    customAmount.value = amount;

    selectedPlanIndex.value = -1;

    Get.back(); 
  }
}










