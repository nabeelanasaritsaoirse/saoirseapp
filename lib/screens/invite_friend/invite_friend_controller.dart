import 'dart:developer';

import 'package:get/get.dart';

import '../../models/friend_details_response.dart';
import '../../models/product_detiails_response.dart';
import '../../services/refferal_service.dart';

class InviteFriendController extends GetxController {
  final String userId;

  InviteFriendController(this.userId);

  final ReferralService _referralService = ReferralService();

  final friendDetails = Rxn<FriendDetails>();
  final isProductLoading = false.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchFriendDetails();
  }

  // ---------------------------------------------------------------------------
  // Fetch referred friend details
  // ---------------------------------------------------------------------------
  Future<void> fetchFriendDetails() async {
    try {
      isLoading.value = true;

      final response = await _referralService.fetchFriendDetails(userId);

      if (response != null && response.success) {
        friendDetails.value = response.friendDetails;
      }
    } catch (e) {
      log("Error fetching friend details: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // ---------------------------------------------------------------------------
  // Fetch product details using friendId + productId
  // ---------------------------------------------------------------------------
  Future<ProductDetails?> getProductDetails(String productId) async {
    try {
      isProductLoading.value = true;

      final response = await _referralService.fetchProductDetails(
        userId,
        productId,
      );

      if (response != null && response.success) {
        return response.productDetails;
      }
    } catch (e) {
      log("Product details fetch error: $e");
    } finally {
      isProductLoading.value = false;
    }

    return null;
  }
}
