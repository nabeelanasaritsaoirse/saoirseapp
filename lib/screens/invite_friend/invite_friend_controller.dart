import 'dart:developer';

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

  // ---------------- MESSAGE BUTTON ACTION ----------------
// ---------------- MESSAGE BUTTON ACTION ----------------
  Future<void> openChat({required String name}) async {
    log("\n================ OPEN CHAT =================");
    log("UserId used to create chat: $userId");
    log("============================================");

    isLoading.value = true;

    final chat = await chatService.createIndividualChat(userId);

    isLoading.value = false;

    if (chat == null) {
      log("❌ Chat creation failed → chat == null");
      return;
    }

    log("\n========== CHAT CREATED SUCCESSFULLY ==========");
    log("Conversation ID: ${chat.conversationId}");
    log("New conversation?  ${chat.isNewConversation}");
    log("Participants:");
    for (var p in chat.participants) {
      log(" - ${p.name} (${p.id})");
    }
    log("===============================================\n");
    await Future.delayed(Duration(milliseconds: 100));
    // Navigate to chat screen
    log("➡️ Navigating to PaymentMessageScreen...");
    Get.to(
        () => PaymentMessageScreen(
              conversationId: chat.conversationId,
              participants: chat.participants,
              showProfileButton: false,
              name: name,
            ),
        transition: Transition.rightToLeft);
  }
}
