import '../constants/app_constant.dart';
import '../constants/app_urls.dart';
import '../main.dart';
import '../models/LoginAuth/cart_count_response.dart';
import '../models/add_to_cart_response.dart';
import '../models/cart_response_model.dart';
import '../models/remove_cart_response.dart';
import 'api_service.dart';

class CartService {
  // Fetch cart details

  final token = storage.read(AppConst.ACCESS_TOKEN);

  Future<CartResponse?> fetchCart() async {
    final url = AppURLs.GET_FULL_CART;
    try {
      final response = await APIService.getRequest(
        url: url,
        onSuccess: (json) => json,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
      );

      if (response == null) return null;

      return CartResponse.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  // Add item to cart
  Future<AddToCartResponse?> addToCart({
    required String productId,
    required String? variantId,
    // required int totalDays,
    // required double dailyAmount,
    int quantity = 1,
  }) async {
    try {
      final url = "${AppURLs.ADD_TO_CART}$productId";

      final body = {
        "quantity": quantity,
        "variantId": variantId,
      };

      final response = await APIService.postRequest(
        url: url,
        body: body,
        onSuccess: (json) => json,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response == null) return null;

      return AddToCartResponse.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  // Clear cart
  Future<bool> clearCart() async {
    try {
      final response = await APIService.deleteRequest(
        url: AppURLs.CLEAR_CART,
        onSuccess: (json) => json,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response == null) return false;

      return response['success'] ?? false;
    } catch (e) {
      return false;
    }
  }

  // Remove item from cart
  Future<RemoveCartItemResponse?> removeItemCart(String productId) async {
    try {
      final url = "${AppURLs.REMOVE_FROM_CART}$productId";

      final response = await APIService.deleteRequest(
        url: url,
        onSuccess: (json) => json,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response == null) return null;

      return RemoveCartItemResponse.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  // Get cart item count
  Future<CartCountResponse?> getCartCount() async {
    try {
      final response = await APIService.getRequest(
        url: AppURLs.GET_CART_COUNT,
        onSuccess: (json) => json,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response == null) return null;

      return CartCountResponse.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  // Update cart item quantity
  Future<dynamic> updateCartQty(String productId, int qty) async {
    final url = AppURLs.UPDATE_CART + productId;

    try {
      final response = await APIService.putRequest(
        url: url,
        onSuccess: (json) => json,
        body: {
          "quantity": qty,
        },
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      return response;
    } catch (e) {
      return null;
    }
  }
}
