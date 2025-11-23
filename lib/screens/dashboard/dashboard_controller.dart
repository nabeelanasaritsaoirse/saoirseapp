import 'package:get/get.dart';
import 'package:saoirse_app/screens/profile/profile_controller.dart';

import '../cart/cart_controller.dart';

class DashboardController extends GetxController {
  // Observable index to track current tab
  var selectedIndex = 0.obs;

  // Function to change tab
  void changeTab(int index) {
    selectedIndex.value = index;

    /// If user goes to Cart tab → refresh cart
    if (index == 3) {
      Get.find<CartController>().fetchCart();
    }

    if(index == 4){
      Get.find<ProfileController>().fetchWishlistCount();
    }
  }
}
