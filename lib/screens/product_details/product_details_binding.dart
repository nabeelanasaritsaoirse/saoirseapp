import 'package:get/get.dart';
import 'product_details_controller.dart';

class ProductDetailsBinding extends Bindings {
  final String productId;
  final String? id;

  ProductDetailsBinding({
    required this.productId,
    this.id,
  });

  @override
  void dependencies() {
    Get.put(
      ProductDetailsController(
        productId: productId,
        id: id,
      ),
    );
  }
}
