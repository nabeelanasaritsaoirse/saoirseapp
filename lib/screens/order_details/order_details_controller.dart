import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saoirse_app/models/coupon_model.dart';
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

  
  // ----------------- Coupon related -----------------
  /// All coupons from API (real-time GET)
  RxList<Coupon> coupons = <Coupon>[].obs;

  /// Loading state for coupons
  RxBool couponsLoading = false.obs;

  /// The currently selected coupon (from list or matched by code)
  Rxn<Coupon> selectedCoupon = Rxn<Coupon>();

  /// Text controller tied to UI coupon input field
  final TextEditingController couponTextController = TextEditingController();

  /// Calculated discount amount (INR)
  RxDouble couponDiscount = 0.0.obs;

  /// Whether a coupon is applied successfully
  RxBool couponApplied = false.obs;

   @override
  void onInit() {
    super.onInit();
    fetchCoupons();
  }

  /// Fetch coupons from API (GET). Keeps a reactive list that UI can observe.
  Future<void> fetchCoupons() async {
    try {
      couponsLoading.value = true;
      final fetched = await CouponService.fetchCoupons();
      if (fetched != null) {
        coupons.value = fetched;
      } else {
        coupons.value = [];
      }
    } catch (e) {
      coupons.value = [];
      log("fetchCoupons error: $e");
    } finally {
      couponsLoading.value = false;
    }
  }

  /// Called by UI when user taps a coupon item from the list.
  /// This will set the coupon code into couponTextController and mark selectedCoupon.
  void selectCoupon(Coupon coupon) {
    selectedCoupon.value = coupon;
    couponTextController.text = coupon.couponCode;
    // do not apply yet — wait for user to press Apply
    couponApplied.value = false;
    couponDiscount.value = 0.0;
    log("Coupon selected: ${coupon.couponCode}");
  }

  /// Compute discount for a given coupon against a given total amount.
  /// Returns discount amount (never negative).
  double computeDiscountAmount(Coupon coupon, double totalAmount) {
    double discount = 0.0;
    if (coupon.discountType.toLowerCase() == "percentage") {
      discount = (coupon.discountValue / 100.0) * totalAmount;
    } else {
      // assume "flat" or unknown equals flat rupee discount
      discount = coupon.discountValue;
    }
    if (discount < 0) discount = 0.0;
    return discount;
  }

  /// Apply coupon by code in couponTextController for the given totalAmount.
  ///
  /// NOTE: UI must pass the current total amount to validate minOrderValue.
  /// Example: controller.applyCoupon(totalAmount: pricing.finalPrice);
  Future<void> applyCoupon({required double totalAmount}) async {
    final code = couponTextController.text.trim();
    if (code.isEmpty) {
      appToast(error: true, content: "Please enter a coupon code");
      return;
    }

    // Try to find coupon in the currently fetched list first
    Coupon? coupon = coupons.firstWhereOrNull((c) => c.couponCode == code);

    // If not found in cached list, try fetching again and searching (keeps real-time)
    if (coupon == null) {
      await fetchCoupons();
      coupon = coupons.firstWhereOrNull((c) => c.couponCode == code);
    }

    if (coupon == null) {
      appToast(error: true, content: "Coupon not found");
      return;
    }

    // Validations: active
    if (!coupon.isActive) {
      appToast(error: true, content: "This coupon is inactive");
      return;
    }

    // Validations: expiry
    if (coupon.expiryDate != null) {
      final now = DateTime.now().toUtc();
      if (!coupon.expiryDate!.isAfter(now)) {
        appToast(error: true, content: "Coupon has expired");
        return;
      }
    }

    // Validations: min order value
    if (coupon.minOrderValue > 0 && totalAmount < coupon.minOrderValue) {
      appToast(
        error: true,
        content:
            "Coupon requires a minimum order value of ₹${coupon.minOrderValue.toStringAsFixed(0)}",
      );
      return;
    }

    // Passed validations → compute discount and apply
    final discount = computeDiscountAmount(coupon, totalAmount);
    if (discount <= 0) {
      appToast(error: true, content: "Coupon did not provide any discount");
      return;
    }

    selectedCoupon.value = coupon;
    couponDiscount.value = discount;
    couponApplied.value = true;

    appToast(error: false, content: "Coupon applied. You saved ₹${discount.toStringAsFixed(0)}");
    log("Coupon applied: ${coupon.couponCode} → discount ₹${discount.toStringAsFixed(0)}");
  }

  /// Remove currently applied coupon (clear input, reset values)
  void clearCoupon() {
    selectedCoupon.value = null;
    couponTextController.clear();
    couponDiscount.value = 0.0;
    couponApplied.value = false;
    log("Coupon cleared");
  }

//-----------------------------------------------------------------
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
