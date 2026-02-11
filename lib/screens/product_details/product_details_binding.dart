import 'package:get/get.dart';

import 'product_details_controller.dart';

class ProductDetailsBinding extends Bindings {
  final String productId;

  ProductDetailsBinding({required this.productId});

  @override
  void dependencies() {
    Get.put<ProductDetailsController>(
      ProductDetailsController(productId: productId),
      tag: productId, // ⭐ VERY IMPORTANT
    );
  }
}
