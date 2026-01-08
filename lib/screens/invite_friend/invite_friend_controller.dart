import 'package:get/get.dart';

import '../../models/friend_details_response.dart';
import '../../models/product_detiails_response.dart';
import '../../services/converstion_service.dart';
import '../../services/refferal_service.dart';
import '../message/message_screen.dart';

class InviteFriendController extends GetxController {
  final String userId;

  InviteFriendController(this.userId);

  final ReferralService _referralService = ReferralService();
  final ConversationService chatService = ConversationService();

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
    } finally {
      isProductLoading.value = false;
    }

    return null;
  }

  // ---------------- MESSAGE BUTTON ACTION ----------------
// ---------------- MESSAGE BUTTON ACTION ----------------
  Future<void> openChat({required String name}) async {
    isLoading.value = true;

    final chat = await chatService.createIndividualChat(userId);

    isLoading.value = false;

    if (chat == null) {
      return;
    }

    await Future.delayed(Duration(milliseconds: 100));
    // Navigate to chat screen

    Get.to(
        () => PaymentMessageScreen(
              conversationId: chat.conversationId,
              participants: chat.participants,
              showProfileButton: false,
              name: name,
            ),
        transition: Transition.rightToLeft);
  }

  String formatAmount(double value) {
    final formatted = value.toStringAsFixed(2);
    return formatted.replaceAll(RegExp(r'\.?0+$'), '');
  }
}
