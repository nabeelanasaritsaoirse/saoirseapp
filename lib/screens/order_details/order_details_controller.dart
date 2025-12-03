import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saoirse_app/models/coupon_model.dart';
import 'package:saoirse_app/models/coupon_validation_model.dart';
import 'package:saoirse_app/services/coupon_service.dart';

import '../../models/order_response_model.dart';
import '../../services/order_service.dart';
import '../../widgets/app_loader.dart';
import '../../widgets/app_toast.dart';
import '../razorpay/razorpay_controller.dart';

class OrderDetailsController extends GetxController {
  RxInt selectedDays = 0.obs;
  RxDouble selectedAmount = 0.0.obs;
  String orderid = "";

  // ------------------------- COUPONS -----------------------------------------
  RxList<Coupon> coupons = <Coupon>[].obs;
  Rx<Coupon?> selectedCoupon = Rx<Coupon?>(null);
  // store the last validation response (null if none)
  Rx<CouponValidationResponse?> couponValidation = Rx<CouponValidationResponse?>(null);

  // store last applied coupon code (string) for display
  RxString appliedCouponCode = "".obs;

  @override
  void onInit() {
    super.onInit();
    fetchCoupons();
  }

  Future<void> fetchCoupons() async {
    final all = await CouponService.fetchCoupons();

    // filter only INSTANT & REDUCE_DAYS
    coupons.value = all.where((c) => c.couponType == "INSTANT" || c.couponType == "REDUCE_DAYS").toList();
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
    // Basic validation
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
      appToast(error: true, content: "Failed to validate coupon. Try again.");
      return;
    }

    // Save the validation response for UI to display
    couponValidation.value = response;
    appliedCouponCode.value = couponCode.trim();

    // Update order amounts/days based on server response so UI displays live changes:
    // - For INSTANT: pricing.finalPrice may change and installment.dailyAmount stays as provided by server.
    // - For REDUCE_DAYS: installment.reducedDays may be provided; we still use installment.dailyAmount & totalDays from response.
    final inst = response.installment;
    selectedAmount.value = inst.dailyAmount;
    selectedDays.value = inst.totalDays;

    // Optional: you might want to show a toast message with the savings message
    if (response.benefits.savingsMessage.isNotEmpty) {
      appToast(title: "Coupon Applied", content: response.benefits.savingsMessage);
    } else {
      appToast(title: "Coupon Applied", content: "Coupon applied successfully");
    }

    // Log for debugging
    log("Coupon applied → code: $couponCode | type: ${response.coupon.type}");
    log("Pricing: original ${response.pricing.originalPrice} discount ${response.pricing.discountAmount} final ${response.pricing.finalPrice}");
    log("Installment: days ${inst.totalDays} daily ${inst.dailyAmount} freeDays ${inst.freeDays} reducedDays ${inst.reducedDays}");
  }

  //----------------------------COUPONS END-------------------------------------

  Future<void> placeOrder({
    required String productId,
    String variantId = "",
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
      "variantId": variantId,
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
}
