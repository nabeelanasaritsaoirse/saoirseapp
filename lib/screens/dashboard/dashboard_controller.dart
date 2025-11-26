import 'package:get/get.dart';

import '../cart/cart_controller.dart';
import '../profile/profile_controller.dart';
import '../refferal/referral_controller.dart';

class DashboardController extends GetxController {
  // Observable index to track current tab
  var selectedIndex = 0.obs;

  // Function to change tab
  void changeTab(int index) {
    selectedIndex.value = index;

    if (index == 1) {
      Get.put(ProfileController()).fetchWishlistCount();
    }

    if (index == 2) {
      Get.put(ReferralController()).fetchReferralData();
    }

    /// If user goes to Cart tab → refresh cart
    if (index == 3) {
      Get.find<CartController>().fetchCart();
    }

    if (index == 4) {
      Get.put(ProfileController()).fetchWishlistCount();
    }
  }
}
