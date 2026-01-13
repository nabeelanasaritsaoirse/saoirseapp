import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saoirse_app/main.dart';

import '../../constants/app_constant.dart';
import '../../models/cart_response_model.dart';
import '../../models/plan_model.dart';
import '../../models/product_details_model.dart';
import '../../services/cart_service.dart';
import '../../services/product_service.dart';
import '../../widgets/app_toast.dart';

class CartController extends GetxController {
  final CartService service = CartService();

  var cartData = Rxn<CartData>();
  var isLoading = false.obs;

  var errorMessage = ''.obs;
  // double get totalAmount => cartData.value?.totalPrice ?? 0;
  var cartCount = 0.obs;
  // inside CartController
  RxBool isCartPlanApplied = false.obs;
  RxBool isAddToCartLoading = false.obs;

  /// Custom plan values
  RxInt customDays = 0.obs;
  RxDouble customAmount = 0.0.obs;
  RxList<PlanModel> plans = <PlanModel>[].obs;
  RxInt selectedPlanIndex = (-1).obs;

  /// Cart plan config
  final int minimumDays = 5;
  bool isUpdating = false;

  @override
  void onInit() {
    fetchCart();
    fetchCartCount();
    super.onInit();
  }

  // Fetch cart from API
  Future<void> fetchCart() async {
    try {
      isLoading(true);
      errorMessage('');

      final response = await service.fetchCart();

      if (response == null || response.success == false) {
        errorMessage("Failed to load cart");
        return;
      }

      cartData.value = response.data;

      // 🔥 REAPPLY PLAN IF EXISTS
      reapplyCartPlanIfNeeded();
    } catch (e) {
      errorMessage("Error: $e");
    } finally {
      isLoading(false);
    }
  }

  // -------------------- QUANTITY --------------------

  void increaseQty(int index) async {
    final product = cartData.value!.products[index];
    final newQty = product.quantity + 1;

    final response = await service.updateCartQty(product.productId, newQty);

    if (response == null) {
      appToast(content: "Unable to update quantity", error: true);
      return;
    }

    if (response['success'] == true) {
      product.quantity = newQty;
      cartData.refresh();
      fetchCartCount();

      // 🔥 IMMEDIATELY RECALCULATE PLAN
      reapplyCartPlanIfNeeded();
    } else {
      appToast(content: response["message"], error: true);
    }
  }

// Decrease quantity and update API
  void decreaseQty(int index) async {
    final product = cartData.value!.products[index];
    final newQty = product.quantity - 1;

    if (newQty < 1) {
      await removeCartItem(product.productId);
      return;
    }

    final response = await service.updateCartQty(product.productId, newQty);

    if (response == null) {
      appToast(content: "Unable to update quantity", error: true);
      return;
    }

    if (response['success'] == true) {
      product.quantity = newQty;
      cartData.refresh();
      fetchCartCount();

      // 🔥 IMMEDIATELY RECALCULATE PLAN
      reapplyCartPlanIfNeeded();
    } else {
      appToast(content: response["message"], error: true);
    }
  }

  // -------------------- ADD TO CART --------------------
  // Future<void> addProductToCart({
  //   required String productId,
  //   required String? variantId,
  //   // required int days,
  //   // required double dailyAmount,
  // }) async {
  //    if (isAddToCartLoading.value) return;
  //   try {
  //         isAddToCartLoading(true);

  //     final response = await service.addToCart(
  //       productId: productId,
  //       variantId: variantId,
  //       // totalDays: days,
  //       // dailyAmount: dailyAmount,
  //       quantity: 1,
  //     );

  //     if (response == null) {
  //       appToast(content: "Failed to add to cart", error: true);
  //       return;
  //     }

  //     if (response.success) {
  //       appToaster(content: response.message);
  //       fetchCart();
  //       fetchCartCount();
  //     } else {
  //       appToast(content: response.message, error: true);
  //     }
  //   } catch (e) {
  //     appToast(content: "Error: $e", error: true);
  //   } finally {
  //      isAddToCartLoading(false);
  //   }
  // }

  Future<void> addProductToCart({
    required String productId,
    required String? variantId,
  }) async {
    if (isAddToCartLoading.value) return;

    try {
      final token = storage.read(AppConst.ACCESS_TOKEN);

      if (token == null || token.isEmpty) {
        appToast(content: "Please login to add items to cart", error: true);
        return;
      }

      isAddToCartLoading(true);

      debugPrint("ADD TO CART API CALLING...");

      final response = await service.addToCart(
        productId: productId,
        variantId: variantId,
        quantity: 1,
      );

      if (response == null) {
        appToast(content: "Failed to add to cart", error: true);
        return;
      }

      if (response.success) {
        appToaster(content: response.message);
        await fetchCart();
        await fetchCartCount();
      } else {
        appToast(content: response.message, error: true);
      }
    } catch (e) {
      appToast(content: "Error: $e", error: true);
    } finally {
      isAddToCartLoading(false);
    }
  }

  // -------------------- CLEAR CART --------------------
  Future<void> clearCartItems() async {
    try {
      if (cartData.value == null || cartData.value!.products.isEmpty) {
        appToast(content: "No items to clear", error: true);
        return;
      }

      isLoading(true);

      final success = await service.clearCart();

      if (success) {
        // Reset entire cart object
        cartData.value = CartData(
          products: [],
          totalItems: 0,
          totalPrice: 0.0,
          subtotal: 0.0,
        );
        fetchCartCount();
        cartCount.value = 0; // Reset badge count
        cartData.refresh();

        appToast(content: "Cart cleared successfully");
      } else {
        appToast(content: "Failed to clear cart", error: true);
      }
    } catch (e) {
      appToast(content: "Error: $e", error: true);
    } finally {
      isLoading(false);
    }
  }

  // -------------------- REMOVE ITEM --------------------
  Future<void> removeCartItem(String productId) async {
    try {
      isLoading(true);

      final response = await service.removeItemCart(productId);

      if (response == null) {
        appToast(content: "Failed to remove item", error: true);
        return;
      }

      if (response.success) {
        // Remove it from UI list
        cartData.value?.products.removeWhere((p) => p.productId == productId);
        cartData.refresh();

        appToast(content: "Item is removed from cart");

        // Re-fetch cart if needed
        fetchCart();
        fetchCartCount();
      } else {
        appToast(content: response.message, error: true);
      }
    } catch (e) {
      appToast(content: "Error: $e", error: true);
    } finally {
      isLoading(false);
    }
  }

  // -------------------- CART COUNT --------------------//
  Future<void> fetchCartCount() async {
    final response = await service.getCartCount();

    if (response != null && response.success) {
      cartCount.value = response.count;
    } else {}
  }

  // -------------------- TOTAL AMOUNT --------------------
  double get totalAmount {
    if (cartData.value == null) return 0;

    return cartData.value!.products.fold(
      0,
      (sum, item) => sum + (item.finalPrice * item.quantity),
    );
  }

  // -------------------- LOAD PRODUCT PLANS --------------------
  Future loadPlans(String productId) async {
    isLoading.value = true;
    final result = await ProductService().fetchProductPlans(productId);
    plans.assignAll(result);
    isLoading.value = false;
  }

  void selectApiPlan(int index) {
    selectedPlanIndex.value = index;
    final plan = plans[index];
    customDays.value = plan.days;
    customAmount.value = plan.perDayAmount;
  }

  void resetPlanSelection() {
    selectedPlanIndex.value = -1;
    customDays.value = 0;
    customAmount.value = 0.0;
  }

  Map<String, dynamic> getSelectedPlan() {
    if (selectedPlanIndex.value != -1) {
      final plan = plans[selectedPlanIndex.value];
      return {
        "days": plan.days,
        "amount": plan.perDayAmount,
      };
    }

    return {
      "days": customDays.value,
      "amount": customAmount.value,
    };
  }

  void setCustomPlan(int days, double amount) {
    customDays.value = days;
    customAmount.value = amount;
    selectedPlanIndex.value = -1;
  }

  // ===================== CART PLAN CORE LOGIC =====================

  void updateCartAmountFromDays(
    TextEditingController daysController,
    TextEditingController amountController,
  ) {
    if (isUpdating) return;
    isUpdating = true;

    final int days = int.tryParse(daysController.text.trim()) ?? 0;

    if (days <= 0) {
      amountController.text = "";
      isUpdating = false;
      return;
    }

    final double perDay = totalAmount / days;
    amountController.text = perDay.toStringAsFixed(2);

    isUpdating = false;
  }

  void updateCartDaysFromAmount(
    TextEditingController daysController,
    TextEditingController amountController,
  ) {
    if (isUpdating) return;
    isUpdating = true;

    final double perDay = double.tryParse(amountController.text.trim()) ?? 0;

    if (perDay <= 0) {
      daysController.text = "";
      isUpdating = false;
      return;
    }

    final int days = (totalAmount / perDay).round();
    daysController.text = days.toString();

    isUpdating = false;
  }

  void applyCartPlan(double perDayAmount) {
    customAmount.value = perDayAmount;
    isCartPlanApplied.value = true;

    // ✅ CART-LEVEL DAYS (always ceil + minDays)
    int cartDays = (totalAmount / perDayAmount).ceil();
    if (cartDays < minimumDays) {
      cartDays = minimumDays;
    }
    customDays.value = cartDays;

    final products = cartData.value!.products;

    for (int i = 0; i < products.length; i++) {
      final product = products[i];

      // 🔥 USE PRICE * QUANTITY
      final double productTotal = product.finalPrice * product.quantity;

      int days = (productTotal / perDayAmount).ceil();
      if (days < minimumDays) {
        days = minimumDays;
      }

      final double adjustedPerDay = productTotal / days;

      products[i] = product.copyWith(
        installmentPlan: InstallmentPlan(
          totalDays: days,
          dailyAmount: adjustedPerDay,
          totalAmount: productTotal,
        ),
      );
    }

    cartData.refresh();
  }

  void reapplyCartPlanIfNeeded() {
    if (!isCartPlanApplied.value || customAmount.value <= 0) return;

    applyCartPlan(customAmount.value);
  }

  ProductDetailsData convertCartToProductDetails(CartProduct item) {
    return ProductDetailsData(
      id: item.productId,
      productId: item.productId,
      variantId: item.variant?.variantId ?? "",
      name: item.name,
      brand: item.brand,
      sku: "",
      description: Description(short: "", long: "", features: []),
      category: Category(
        mainCategoryId: "",
        mainCategoryName: "",
        subCategoryId: "",
        subCategoryName: "",
      ),
      availability: Availability(
        isAvailable: true,
        stockQuantity: item.stock,
        lowStockLevel: 0,
        stockStatus: item.stock > 0 ? "in_stock" : "out_of_stock",
      ),
      pricing: Pricing(
        regularPrice: item.price,
        salePrice: item.finalPrice,
        finalPrice: item.finalPrice,
        currency: "INR",
      ),
      seo: Seo(keywords: []),
      warranty: Warranty(period: 0),
      images: item.images
          .map((img) => ImageData(
                url: img.url,
                altText: img.altText,
                isPrimary: img.isPrimary,
                id: img.id,
              ))
          .toList(),
      isPopular: false,
      isBestSeller: false,
      isTrending: false,
      status: "active",
      hasVariants: item.variant != null,
      regionalPricing: [],
      regionalSeo: [],
      regionalAvailability: [],
      relatedProducts: [],
      variants: [],
      plans: [],
      createdAt: "",
      updatedAt: "",
      v: 0,
    );
  }
}
