import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/coupon_model.dart';
import '../../models/coupon_validation_model.dart';
import '../../models/order_response_model.dart';
import '../../services/coupon_service.dart';
import '../../services/order_service.dart';
import '../../widgets/app_loader.dart';
import '../../widgets/app_toast.dart';
import '../razorpay/razorpay_controller.dart';

class OrderDetailsController extends GetxController {
  RxInt selectedDays = 0.obs;
  RxDouble selectedAmount = 0.0.obs;
  var selectedPaymentMethod = "razorpay".obs;
  var quantity = 1.obs;
  String orderid = "";

  // ------------------------- COUPONS -----------------------------------------
  RxList<Coupon> coupons = <Coupon>[].obs;
  Rx<Coupon?> selectedCoupon = Rx<Coupon?>(null);
  // store the last validation response (null if none)
  Rx<CouponValidationResponse?> couponValidation =
      Rx<CouponValidationResponse?>(null);

  // store last applied coupon code (string) for display
  RxString appliedCouponCode = "".obs;

  // storing first values for remove coupon
  double originalAmount = 0.0;
  int originalDays = 0;

  @override
  void onInit() {
    super.onInit();
    fetchCoupons();
  }

  Future<void> fetchCoupons() async {
    final all = await CouponService.fetchCoupons();

    // filter only INSTANT & REDUCE_DAYS
    coupons.value = all
        .where(
            (c) => c.couponType == "INSTANT" || c.couponType == "REDUCE_DAYS")
        .toList();
  }

  //selected coupon show text field
  void selectCoupon(Coupon coupon, TextEditingController controller) {
    selectedCoupon.value = coupon;
    controller.text = coupon.couponCode;
  }

  //-- Apply button tapped
  Future<void> applyCouponApi({
    required String couponCode,
    required String productId,
    required int totalDays,
    required double dailyAmount,
    String variantId = "",
    int quantity = 1,
  }) async {
    if (couponCode.trim().isEmpty) {
      appToast(error: true, content: "Please enter a coupon code");
      return;
    }

    final body = {
      "couponCode": couponCode.trim(),
      "productId": productId,
      "totalDays": totalDays,
      "dailyAmount": dailyAmount,
      if (variantId.isNotEmpty) "variantId": variantId,
      if (quantity > 0) "quantity": quantity,
    };

    appLoader();

    final response = await CouponService.validateCoupon(body);

    // hide loader
    if (Get.isDialogOpen ?? false) Get.back();

    if (response == null) {
      appToast(error: true, content: "Invalid coupon");
      return;
    }

    // Save the validation response for UI to display
    couponValidation.value = response;
    appliedCouponCode.value = couponCode.trim();

    // Update order amounts/days based on server response so UI displays live changes:
    // - For INSTANT: pricing.finalPrice may change and installment.dailyAmount stays as provided by server
    // - For REDUCE_DAYS: installment.reducedDays may be provided; we still use installment.dailyAmount & totalDays from response
    final inst = response.installment;
    selectedAmount.value = inst.dailyAmount;
    selectedDays.value = inst.totalDays;

    // Optional message
    if (response.benefits.savingsMessage.isNotEmpty) {
      appToast(
          title: "Coupon Applied", content: response.benefits.savingsMessage);
    } else {
      appToast(title: "Coupon Applied", content: "Coupon applied successfully");
    }
  }

  void removeCoupon(TextEditingController controller) {
    couponValidation.value = null; // remove server response
    appliedCouponCode.value = ""; // clear coupon code text
    selectedCoupon.value = null;
    selectedAmount.value = originalAmount; // restore original daily amount
    selectedDays.value = originalDays; // restore original days
    controller.clear(); // clear text field
  }

  //----------------------------COUPONS END-------------------------------------

  Future<void> placeOrder({
    required String productId,
    String variantId = "",
    required String paymentOption,
    required int totalDays,
    String couponCode = "",
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
      "variantId": variantId,
      "paymentOption": paymentOption,
      "paymentDetails": {
        "totalDays": totalDays,
      },
      "couponCode": couponCode,
      "deliveryAddress": delivery,
    };

    log("📦 FINAL JSON = ${jsonEncode(body)}");

    appLoader();

    final response = await OrderService.createOrder(body);

    if (Get.isDialogOpen ?? false) Get.back();

    if (response == null) {
      appToast(
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
      appToast(
        error: true,
        content: "Payment info missing from server!",
      );
      return;
    }

    final payment = OrderResponseModel.fromJson(response);

    // Validate
    if (payment.order.id.isEmpty) {
      appToast(
        error: true,
        content: "Invalid payment details!",
      );
      return;
    }
    if (payment.payment.orderId.isEmpty) {
      appToast(
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
    );
  }

  void setCustomPlan(int days, double amount) {
    selectedDays.value = days;
    selectedAmount.value = amount;
    log("CUSTOM PLAN SELECTED → $days Days | ₹$amount");
  }

  void selectPaymentMethod(String method) {
    selectedPaymentMethod.value = method;
  }

  void increaseQty() {
    if (quantity.value >= 10) {
      appToaster(content: "Maximum quantity is 10", error: true);
      return;
    }
    quantity.value++;
  }

  void decreaseQty() {
    if (quantity.value <= 1) {
      appToaster(content: "Minimum quantity is 1", error: true);
      return;
    }
    quantity.value--;
  }
}
