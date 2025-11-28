// ignore_for_file: avoid_print

import 'package:get/get.dart';

import '../../models/cart_response_model.dart';
import '../../services/cart_service.dart';
import '../../widgets/app_snackbar.dart';

class CartController extends GetxController {
  final CartService service = CartService();

  var cartData = Rxn<CartData>();
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  double get totalAmount => cartData.value?.totalPrice ?? 0;
  var cartCount = 0.obs;

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

      print("=== CART LOADED ===");
      print("Total Items: ${response.data.totalItems}");
      print("Total Price: ${response.data.totalPrice}");
    } catch (e) {
      errorMessage("Error: $e");
    } finally {
      isLoading(false);
    }
  }

  // Increase quantity and update API
  void increaseQty(int index) async {
    final product = cartData.value!.products[index];
    final newQty = product.quantity + 1;
    print("Increasing qty for: ${product.productId}");
    print("Old qty: ${product.quantity}, New qty: $newQty");

    final response = await service.updateCartQty(product.productId, newQty);
    print("API Response: $response");
    if (response == null) {
      appToast(content: "Unable to update quantity", error: true);
      return;
    }

    if (response['success'] == true) {
      product.quantity = newQty;
      cartData.refresh();
      fetchCart();
      fetchCartCount(); // refresh total
    } else {
      appToast(content: response["message"], error: true);
    }
  }

// Decrease quantity and update API
  void decreaseQty(int index) async {
    final product = cartData.value!.products[index];
    final newQty = product.quantity - 1;
    print("Decreasing qty for: ${product.productId}");
    print("Old qty: ${product.quantity}, New qty: $newQty");
    // If quantity becomes 0 → remove item
    if (newQty < 1) {
      print("Quantity reached 0 → Removing product from cart");
      // CALL REMOVE API
      await removeCartItem(product.productId);
      return;
    }

    final response = await service.updateCartQty(product.productId, newQty);
    print("API Response: $response");
    if (response == null) {
      appToast(content: "Unable to update quantity", error: true);
      return;
    }

    if (response['success'] == true) {
      product.quantity = newQty;
      cartData.refresh();
      fetchCart();
      fetchCartCount();
    } else {
      appToast(content: response["message"], error: true);
    }
  }

  // Add product to cart
  Future<void> addProductToCart(String productId) async {
    try {
      isLoading(true);

      final response = await service.addToCart(productId);

      if (response == null) {
        appToast(content: "Failed to add to cart", error: true);
        return;
      }

      if (response.success) {
        appToast(
          content: response.message,
        );

        // refresh cart after adding item
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

  // Clear cart
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

  // Remove item from cart
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

  // Fetch cart count
  Future<void> fetchCartCount() async {
    try {
      final response = await service.getCartCount();

      print("Fetching Cart Count...");

      if (response != null && response.success) {
        cartCount.value = response.count;

        print("Cart Count Updated: ${response.count}");
      } else {
        print(" Failed to fetch cart count!");
      }
    } catch (e) {
      print("Count fetch error: $e");
    }
  }
}
