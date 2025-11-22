import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';

import '../../services/order_service.dart';
import '../../widgets/app_loader.dart';
import '../../widgets/app_snackbar.dart';
import '../booking_confirmation/booking_confirmation_screen.dart';

class OrderDetailsController extends GetxController {
 Future<void> placeOrder({
  required String productId,
  required String paymentOption,
  required int totalDays,
  required Map<String, dynamic> deliveryAddress,
}) async {
final delivery = {
  "name": (deliveryAddress["name"] ?? "").toString().trim(),
  "phoneNumber": (deliveryAddress["phoneNumber"] ?? "").toString().trim(),
  "addressLine1": (deliveryAddress["addressLine1"] ?? "").toString().trim(),
  "city": (deliveryAddress["city"] ?? "").toString().trim(),
  "state": (deliveryAddress["state"] ?? "").toString().trim(),
  "pincode": (deliveryAddress["pincode"] ?? "").toString().trim(),
};


  final body = {
    "productId": productId,
    "paymentOption": paymentOption,
    "paymentDetails": {
      "totalDays": totalDays,
    },
    "deliveryAddress": delivery,
  };

  log("📦 FINAL JSON = ${jsonEncode(body)}");

  appLoader();

  final response = await OrderService.createOrder(body);

  Get.back();

  if (response != null) {
    Get.to(() => BookingConfirmationScreen());
    // i need to call the razorpay here 
  } else {
    appSnackbar(
      error: true,
      title: "Error",
      content: "Failed to place order. Please try again!",
    );
  }
}

}
