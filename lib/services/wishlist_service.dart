import 'dart:developer';

import 'package:saoirse_app/constants/app_constant.dart';
import 'package:saoirse_app/constants/app_urls.dart';
import 'package:saoirse_app/main.dart';
import 'package:saoirse_app/models/wishlist_response_model.dart';
import 'package:saoirse_app/services/api_service.dart';

class WishlistService {
  Future<String?> _token() async => storage.read(AppConst.ACCESS_TOKEN);

  // ----------------------------------------------------------
  // GET /wishlist
  // ----------------------------------------------------------
  Future<WishlistResponse?> fetchWishlist() async {
    final token = await _token();
    final url = "https://api.epielio.com/api/wishlist";
    return APIService.getRequest<WishlistResponse>(
      url: url,
      headers: {"Authorization": "Bearer $token"},
      onSuccess: (json) => WishlistResponse.fromJson(json),
    );
  }

  // ----------------------------------------------------------
  // GET /wishlist/count
  // ----------------------------------------------------------
  Future<int?> getWishlistCount() async {
    final token = await _token();
    final url = AppURLs.GET_ITEM_COUNT;
    return APIService.getRequest<int>(
      url: url,
      headers: {"Authorization": "Bearer $token"},
      onSuccess: (json) => json["count"] ?? 0,
    );
  }

  // ----------------------------------------------------------
  // GET /wishlist/check/:productId
  // ----------------------------------------------------------
  Future<bool> checkWishlist(String productId) async {
    final token = await _token();
    final url = "${AppURLs.CHECK_IF_WISHLIST}/$productId";

    final result = await APIService.getRequest<bool>(
      url: url,
      headers: {"Authorization": "Bearer $token"},
      onSuccess: (json) {
        
        return json["data"]?["isInWishlist"] ?? false;
      },
    );

    return result ?? false;
  }

  // ----------------------------------------------------------
  // POST /wishlist/add/:productId
  // ----------------------------------------------------------
  Future<bool> addToWishlist(String productId) async {
    final token = await _token();
    final url = AppURLs.ADD_TO_WISH;
    final result = await APIService.postRequest<bool>(
      url: "$url/$productId",
      headers: {"Authorization": "Bearer $token"},
      body: {},
      onSuccess: (json) => (json["success"] ?? false) as bool,
    );

    return result ?? false;
  }

  // ----------------------------------------------------------
  // DELETE /wishlist/remove/:productId
  // ----------------------------------------------------------
  Future<bool> removeFromWishlist(String productId) async {
    final token = await _token();
    final url = AppURLs.DELETE_WISHLIST;
    final result = await APIService.deleteRequest<bool>(
      url: "$url/$productId",
      headers: {"Authorization": "Bearer $token"},
      onSuccess: (json) => (json["success"] ?? false) as bool,
    );

    return result ?? false;
  }

  // ----------------------------------------------------------
  // POST /wishlist/toggle/:productId
  // ----------------------------------------------------------
  Future<bool> toggleWishlist(String productId) async {
    final token = await _token();
    final url = AppURLs.TOGGLE_WISHLIST;
    final result = await APIService.postRequest<bool>(
      url: "$url/$productId",
      headers: {"Authorization": "Bearer $token"},
      body: {},
      onSuccess: (json) => (json["success"] ?? false) as bool,
    );

    return result ?? false;
  }

  // ----------------------------------------------------------
  // POST /wishlist/move-to-cart/:productId
  // ----------------------------------------------------------
  Future<bool> moveToCart(String productId) async {
    final token = await _token();
    final url = AppURLs.MOVE_TO_CART;
    final result = await APIService.postRequest<bool>(
      url: "$url/$productId",
      headers: {"Authorization": "Bearer $token"},
      body: {},
      onSuccess: (json) => (json["success"] ?? false) as bool,
    );

    return result ?? false;
  }

  // ----------------------------------------------------------
  // DELETE /wishlist/clear
  // ----------------------------------------------------------
  Future<bool> clearWishlist() async {
    final token = await _token();
    final url = AppURLs.CLEAR_CART_WISHLIST;
    final result = await APIService.deleteRequest<bool>(
      url: url,
      headers: {"Authorization": "Bearer $token"},
      onSuccess: (json) => (json["success"] ?? false) as bool,
    );

    return result ?? false;
  }
}
