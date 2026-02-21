import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:saoirse_app/screens/product_details/product_details_controller.dart';

import '../screens/product_details/product_details_screen.dart';
import 'appsflyer_service.dart';

class DeepLinkNavigationService {
  static bool _navigating = false;

  static void handleProductNavigation() {
    if (_navigating) return;

    final productId = AppsFlyerService.instance.consumePendingProduct();

    if (productId == null) return;

    if (Get.currentRoute.contains("ProductDetailsScreen")) {
    return;
    }

    _navigating = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      
      Get.put(
        ProductDetailsController(productId: productId),
        tag: productId,
      );

      Get.to(() => ProductDetailsScreen(productId: productId));
      _navigating = false;
    });
  }
}
