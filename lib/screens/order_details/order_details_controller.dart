import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:saoirse_app/models/payment_model.dart';

import '../../services/order_service.dart';
import '../../widgets/app_loader.dart';
import '../../widgets/app_snackbar.dart';
import '../razorpay/razorpay_controller.dart';

class OrderDetailsController extends GetxController {
  Future<void> placeOrder({
    required String productId,
    required String paymentOption,
    required int totalDays,
    required Map<String, dynamic> deliveryAddress,
  }) async {
    // Clean delivery address
    final delivery = {
      "name": (deliveryAddress["name"] ?? "").toString().trim(),
      "phoneNumber": (deliveryAddress["phoneNumber"] ?? "").toString().trim(),
      "addressLine1": (deliveryAddress["addressLine1"] ?? "").toString().trim(),
      "city": (deliveryAddress["city"] ?? "").toString().trim(),
      "state": (deliveryAddress["state"] ?? "").toString().trim(),
      "pincode": (deliveryAddress["pincode"] ?? "").toString().trim(),
    };

    // Final body
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

    if (Get.isDialogOpen ?? false) Get.back();

    if (response == null) {
      appSnackbar(
        error: true,
        title: "Error",
        content: "Failed to place order. Please try again!",
      );
      return;
    }

    log("ORDER API SUCCESS: $response");

    final paymentJson = response["payment"];

    if (paymentJson == null) {
      appSnackbar(
        error: true,
        content: "Payment info missing from server!",
      );
      return;
    }

    final payment = PaymentModel.fromJson(paymentJson);

    // Validate
    if (payment.orderId.isEmpty || payment.amount == 0) {
      appSnackbar(
        error: true,
        content: "Invalid payment details!",
      );
      return;
    }

    // Open Razorpay
    Get.find<RazorpayController>().openCheckout(
      orderId: payment.orderId,
      amount: payment.amount,
      key: payment.keyId,
    );
  }
}


