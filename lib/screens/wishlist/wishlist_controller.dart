import 'package:get/get.dart';
import 'package:saoirse_app/models/wishlist_response_model.dart';
import 'package:saoirse_app/services/wishlist_service.dart';
import 'package:saoirse_app/widgets/app_snackbar.dart';

class WishlistController extends GetxController {
  final WishlistService wishlistService = WishlistService();

  RxBool isLoading = false.obs;

  // Corrected: use WishlistItem (not WishlistProduct)
  RxList<WishlistItem> wishlistProducts = <WishlistItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    getWishlist();
  }

  // ----------------------------------------------------------
  // FETCH ALL WISHLIST PRODUCTS
  // ----------------------------------------------------------
  Future<void> getWishlist() async {
    isLoading.value = true;

    final response = await wishlistService.fetchWishlist();

    if (response != null && response.success) {
      wishlistProducts.value = response.data; // List<WishlistItem>
    }

    isLoading.value = false;
  }

  // ----------------------------------------------------------
  // TOGGLE WISHLIST (ADD / REMOVE)
  // Removes product from UI instantly
  // ----------------------------------------------------------
  Future<void> toggleWishlistItem(String productId) async {
    final success = await wishlistService.toggleWishlist(productId);

    if (success) {
      wishlistProducts.removeWhere((item) => item.productId == productId);
    }
  }

  // ----------------------------------------------------------
  // REMOVE FROM WISHLIST → API expects productId, not itemId
  // ----------------------------------------------------------
  Future<void> removeItem(String productId) async {
    bool removed = await wishlistService.removeFromWishlist(productId);

    if (removed) {
      wishlistProducts.removeWhere((item) => item.productId == productId);
      wishlistProducts.refresh();
      
      appSnackbar(title: "Removed", content: "Item removed from wishlist");
    }
  }

  // ----------------------------------------------------------
  // CLEAR COMPLETE WISHLIST
  // ----------------------------------------------------------
  Future<void> clearWishlist() async {
    final success = await wishlistService.clearWishlist();

    if (success) {
      wishlistProducts.clear();
    }
  }
}

