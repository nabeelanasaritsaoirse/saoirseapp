
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/payment_methods.dart';
import '../../models/coupon_model.dart';
import '../../models/coupon_validation_model.dart';
import '../../models/order_response_model.dart';
import '../../services/coupon_service.dart';
import '../../services/order_service.dart';
import '../../widgets/app_loader.dart';
import '../../widgets/app_toast.dart';
import '../booking_confirmation/booking_confirmation_screen.dart';
import '../my_wallet/my_wallet_controller.dart';
import '../razorpay/razorpay_controller.dart';

class OrderDetailsController extends GetxController {
  final walletController = Get.find<MyWalletController>();
  RxInt selectedDays = 0.obs;
  RxDouble selectedAmount = 0.0.obs;

  var quantity = 1.obs;
  String orderid = "";

  // ------------------------- BASE PRICING (per 1 qty) -------------------------
  double baseFinalPrice = 0.0;
  double baseDailyAmount = 0.0;
  int baseDays = 0;
  RxDouble totalAmount = 0.0.obs;

  // ------------------------- COUPONS -----------------------------------------
  RxList<Coupon> coupons = <Coupon>[].obs;
  Rx<Coupon?> selectedCoupon = Rx<Coupon?>(null);

  Rx<CouponValidationResponse?> couponValidation =
      Rx<CouponValidationResponse?>(null);

  RxString appliedCouponCode = "".obs;

  RxString selectedPaymentMethod = PaymentMethod.razorpay.obs;

  // storing first values for remove coupon
  double originalAmount = 0.0;
  int originalDays = 0;

  @override
  void onInit() {
    super.onInit();
    fetchCoupons();
  }

  // ------------------------- INITIAL PRODUCT PRICING -------------------------
  void initProductPricing({
    required double finalPrice,
    required double dailyAmount,
    required int days,
  }) {
    baseFinalPrice = finalPrice;
    baseDailyAmount = dailyAmount;
    baseDays = days;

    originalAmount = dailyAmount;
    originalDays = days;

    selectedAmount.value = dailyAmount;
    selectedDays.value = days;

    totalAmount.value = finalPrice;
  }

  // ------------------------- CENTRAL RECALCULATION ---------------------------
  void recalculatePricing() {
    final qty = quantity.value;

    if (baseDailyAmount == 0 || baseDays == 0) return;

    // ✅ COUPON APPLIED
    if (couponValidation.value != null) {
      final v = couponValidation.value!;
      final inst = v.installment;
      final pricing = v.pricing;

      selectedAmount.value = roundToInt(inst.dailyAmount * qty);
      selectedDays.value = inst.totalDays;

      // 🔥 TOTAL AMOUNT FROM SERVER × QTY
      totalAmount.value = roundToInt(pricing.finalPrice * qty);

      return;
    }

    // ✅ NO COUPON
    selectedAmount.value = roundToInt(baseDailyAmount * qty);
    selectedDays.value = baseDays;

    // 🔥 TOTAL AMOUNT = PRODUCT PRICE × QTY
    totalAmount.value = roundToInt(baseFinalPrice * qty);
  }

  double roundToInt(double value) {
    return value.roundToDouble(); // 193.2 → 193
  }

  // ------------------------- FETCH COUPONS -----------------------------------
  Future<void> fetchCoupons() async {
    final all = await CouponService.fetchCoupons();

    coupons.value = all
        .where(
            (c) => c.couponType == "INSTANT" || c.couponType == "REDUCE_DAYS")
        .toList();
  }

  void selectCoupon(Coupon coupon, TextEditingController controller) {
    selectedCoupon.value = coupon;
    controller.text = coupon.couponCode;
  }

  // ------------------------- APPLY COUPON ------------------------------------
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

    if (Get.isDialogOpen ?? false) Get.back();

    if (response == null) {
      appToast(error: true, content: "Invalid coupon");
      return;
    }

    couponValidation.value = response;
    appliedCouponCode.value = couponCode.trim();

    final inst = response.installment;
    final pricing = response.pricing;

    selectedAmount.value = roundToInt(inst.dailyAmount * this.quantity.value);

    selectedDays.value = inst.totalDays;

    totalAmount.value = roundToInt(pricing.finalPrice * this.quantity.value);

    if (response.benefits.savingsMessage.isNotEmpty) {
      appToast(
          title: "Coupon Applied", content: response.benefits.savingsMessage);
    } else {
      appToast(title: "Coupon Applied", content: "Coupon applied successfully");
    }
  }

  void removeCoupon(TextEditingController controller) {
    couponValidation.value = null;
    appliedCouponCode.value = "";
    selectedCoupon.value = null;

    recalculatePricing();
    recalculatePricing();
    controller.clear();
  }

  // ------------------------- PLACE ORDER -------------------------------------
  Future<void> placeOrder({
    required String productId,
    String variantId = "",
    required int totalDays,
    String couponCode = "",
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

    final Map<String, dynamic> body = {
      "productId": productId,
      "quantity": quantity.value,
      "totalDays": totalDays,
      "paymentMethod": selectedPaymentMethod.value,
      "deliveryAddress": delivery,
    };

    if (variantId.trim().isNotEmpty) {
      body["variantId"] = variantId.trim();
    }

    if (couponCode.trim().isNotEmpty) {
      body["couponCode"] = couponCode.trim();
    }

   

    appLoader();

    try {
      final response = await OrderService.createOrder(body);

      if (response == null) {
        appToast(
          error: true,
          content: "Failed to place order. Please try again!",
        );
        return;
      }

      if (selectedPaymentMethod.value == PaymentMethod.wallet) {
        Get.dialog(
          appLoader(),
          barrierDismissible: false,
        );

        await Future.delayed(const Duration(seconds: 2));

        if (Get.isDialogOpen ?? false) Get.back();

        await walletController.fetchWallet(forceRefresh: true);

        Get.off(() => BookingConfirmationScreen());

        return;
      }

      final data = response['data'];

      if (data == null || data is! Map<String, dynamic>) {
        appToast(
          error: true,
          content: "Invalid payment response from server",
        );
        return;
      }

      final payment = OrderResponseModel.fromJson(data);

      if (payment.payment.razorpayOrderId.isEmpty) {
        appToast(
          error: true,
          content: "Invalid Razorpay Order ID!",
        );
        return;
      }

     

      Get.find<RazorpayController>().openCheckout(
        razorpayOrderId: payment.payment.razorpayOrderId,
        orderId: payment.order.id,
        amount: payment.payment.amount,
      );
    } catch (e) {
     
      appToast(
        error: true,
        content: "Payment initialization failed",
      );
    } finally {
      if (Get.isDialogOpen ?? false) Get.back();
    }
  }

  // ------------------------- PAYMENT -----------------------------------------
  void setCustomPlan(int days, double amount) {
    selectedDays.value = days;
    selectedAmount.value = amount;
  
  }

  void selectPaymentMethod(String method) {
    selectedPaymentMethod.value = method;
  }

  // ------------------------- QUANTITY ----------------------------------------
  void increaseQty() {
    quantity.value++;
    recalculatePricing();
  }

  void decreaseQty() {
    if (quantity.value <= 1) {
      appToaster(content: "Minimum quantity is 1", error: true);
      return;
    }
    quantity.value--;
    recalculatePricing();
  }
}
