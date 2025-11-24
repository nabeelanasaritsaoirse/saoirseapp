import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';

import '../../models/order_response_model.dart';
import '../../services/order_service.dart';
import '../../widgets/app_loader.dart';
import '../../widgets/app_snackbar.dart';
import '../razorpay/razorpay_controller.dart';

class OrderDetailsController extends GetxController {
  RxInt selectedDays = 0.obs;
  RxDouble selectedAmount = 0.0.obs;
  String orderid = "";

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

    // final paymentJson = response["payment"];
    final paymentOrder = response["order"];

    if (paymentOrder == null) {
      appSnackbar(
        error: true,
        content: "Payment info missing from server!",
      );
      return;
    }

    final payment = OrderResponseModel.fromJson(response);

    // Validate
    if (payment.order.id.isEmpty) {
      appSnackbar(
        error: true,
        content: "Invalid payment details!",
      );
      return;
    }
    if (payment.payment.orderId.isEmpty) {
      appSnackbar(
        error: true,
        content: "Invalid Razorpay Order ID!",
      );
      return;
    }

    orderid = payment.order.id;
    log("orderid is : $orderid");

    // Open Razorpay
    Get.find<RazorpayController>().openCheckout(
      razorpayOrderId: payment.payment.orderId,
      orderId: payment.order.id,
      amount: payment.payment.amount,
      key: payment.payment.keyId,
    );
  }

  void setCustomPlan(int days, double amount) {
    selectedDays.value = days;
    selectedAmount.value = amount;
    log("CUSTOM PLAN SELECTED → $days Days | ₹$amount");
  }
}
