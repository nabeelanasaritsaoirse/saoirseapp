import 'package:get/get.dart';
import 'package:saoirse_app/screens/booking_confirmation/booking_confirmation_screen.dart';
import 'package:saoirse_app/services/order_service.dart';
import 'package:saoirse_app/widgets/app_loader.dart';
import 'package:saoirse_app/widgets/app_snackbar.dart';


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
      appSnackbar(error: true, title: "Error", content: "Failed to update data. please try again!");
    }
  }
}
