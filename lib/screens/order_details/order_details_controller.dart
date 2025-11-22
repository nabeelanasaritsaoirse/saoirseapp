import 'package:get/get.dart';

import '../../services/order_service.dart';
import '../../widgets/app_loader.dart';
import '../../widgets/app_snackbar.dart';
import '../booking_confirmation/booking_confirmation_screen.dart';

class OrderDetailsController extends GetxController {
  Future<void> placeOrder({
    required String productId,
    required int totalDays,
    required Map<String, dynamic> deliveryAddress,
  }) async {
    final body = {
      "productId": productId,
      "totalDays": totalDays,
      "paymentMethod": "WALLET",
      "deliveryAddress": deliveryAddress,
    };

    appLoader();

    final response = await OrderService.createOrder(body);

    Get.back();

    if (response != null) {
      Get.to(() => BookingConfirmationScreen());
    } else {
      appSnackbar(
          error: true,
          title: "Error",
          content: "Failed to update data. please try again!");
    }
  }
}
