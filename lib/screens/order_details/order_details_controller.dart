// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/payment_methods.dart';
import '../../models/coupon_model.dart';
import '../../models/coupon_validation_model.dart';
import '../../models/order_preview_model.dart';
import '../../models/order_response_model.dart';
import '../../services/coupon_service.dart';
import '../../services/notification_service.dart';
import '../../services/order_service.dart';
import '../../widgets/app_loader.dart';
import '../../widgets/app_toast.dart';
import '../booking_confirmation/booking_confirmation_screen.dart';
import '../my_wallet/my_wallet_controller.dart';
import '../razorpay/razorpay_controller.dart';

class OrderDetailsController extends GetxController {
  final walletController = Get.find<MyWalletController>();
  NotificationService notificationService = NotificationService();
  RxInt selectedDays = 0.obs;
  RxDouble selectedAmount = 0.0.obs;
  RxBool enableAutoPay = true.obs;
  RxBool showWalletAutoPay = false.obs;
  RxBool isPlacingOrder = false.obs;
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
  RxBool isLoading = false.obs;

  RxString appliedCouponCode = "".obs;

  // RxString selectedPaymentMethod = PaymentMethod.razorpay.obs;
  RxString selectedPaymentMethod = "".obs;

  // storing first values for remove coupon
  double originalAmount = 0.0;
  int originalDays = 0;

  // ORDER PREVIEW STATE
  Rx<OrderPreviewData?> orderPreview = Rx<OrderPreviewData?>(null);
  RxBool isPreviewLoading = false.obs;

// -------- ORDER PREVIEW CONTEXT (CACHED) --------
  String _previewProductId = '';
  String _previewVariantId = '';
  Map<String, dynamic> _previewAddress = {};

  @override
  void onInit() {
    super.onInit();
    selectedPaymentMethod.value = PaymentMethod.razorpay;
    enableAutoPay.value = true;
    fetchCoupons();
  }

  void startLoading() {
    isLoading.value = true;
  }

  void stopLoading() {
    isLoading.value = false;
  }

  // -------- PUBLIC GETTERS FOR PREVIEW CONTEXT --------
  Map<String, dynamic> get previewAddress => _previewAddress;
  String get previewProductId => _previewProductId;
  String get previewVariantId => _previewVariantId;

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

  void initPreviewContext({
    required String productId,
    String variantId = "",
    required Map<String, dynamic> deliveryAddress,
  }) {
    _previewProductId = productId;
    _previewVariantId = variantId;
    _previewAddress = deliveryAddress;
  }

  Future<void> fetchOrderPreview({
    required String productId,
    String variantId = "",
    required int quantity,
    required int totalDays,
    String couponCode = "",
    required Map<String, dynamic> deliveryAddress,
  }) async {
    startLoading();

    try {
      final body = {
        "productId": productId,
        "quantity": quantity,
        "totalDays": totalDays,
        if (variantId.isNotEmpty) "variantId": variantId,
        if (couponCode.isNotEmpty) "couponCode": couponCode,
        "deliveryAddress": deliveryAddress,
      };

      final response = await OrderService.previewInstallmentOrder(body);

      final model = OrderPreviewModel.fromJson(response!);

      orderPreview.value = model.data;

      // 🔥 SYNC EXISTING CONTROLLER VALUES
      selectedAmount.value = model.data.installment.dailyAmount;
      selectedDays.value = model.data.installment.totalDays;
      totalAmount.value = model.data.pricing.finalProductPrice;
    } catch (e) {
      appToaster(
        error: true,
        content: e.toString().replaceAll("Exception:", "").trim(),
      );
    } finally {
      stopLoading();
    }
  }

  Future<void> refreshOrderPreview() async {
    await fetchOrderPreview(
      productId: _previewProductId,
      variantId: _previewVariantId,
      quantity: quantity.value,
      totalDays: selectedDays.value,
      couponCode: appliedCouponCode.value,
      deliveryAddress: _previewAddress,
    );
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
    startLoading();

    final body = {
      "couponCode": couponCode.trim(),
      "productId": productId,
      "totalDays": totalDays,
      "dailyAmount": dailyAmount,
      if (variantId.isNotEmpty) "variantId": variantId,
      if (quantity > 0) "quantity": quantity,
    };

    try {
      final response = await CouponService.validateCoupon(body);

      if (Get.isDialogOpen ?? false) Get.back();

      appliedCouponCode.value = couponCode.trim();

      appToaster(
        content: response.benefits.savingsMessage.isNotEmpty
            ? response.benefits.savingsMessage
            : "Coupon applied successfully",
      );

      await fetchOrderPreview(
        productId: productId,
        variantId: variantId,
        quantity: quantity,
        totalDays: totalDays,
        couponCode: couponCode.trim(),
        deliveryAddress: _previewAddress,
      );
    } catch (e) {
      if (Get.isDialogOpen ?? false) Get.back();

      appToaster(
        error: true,
        content: e.toString().replaceAll("Exception:", "").trim(),
      );
    } finally {
      stopLoading();
    }
  }

  Future<void> removeCoupon(TextEditingController controller) async {
    startLoading();

    try {
      appliedCouponCode.value = "";
      selectedCoupon.value = null;
      controller.clear();

      await refreshOrderPreview();
    } finally {
      stopLoading();
    }
  }

  // ------------------------- PLACE ORDER FOR SINGLE PRODUCT-------------------------------------
  Future<void> placeOrder({
    required String productId,
    String variantId = "",
    required int totalDays,
    String couponCode = "",
    required Map<String, dynamic> deliveryAddress,
  }) async {
    // 🔒 PREVENT MULTIPLE CALLS
    if (isPlacingOrder.value) {
      debugPrint("⛔ [ORDER] placeOrder ignored (already in progress)");
      return;
    }

    isPlacingOrder.value = true;
    debugPrint("🔒 [ORDER] placeOrder LOCKED");

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

    debugPrint("📤 [ORDER] Request body: $body");

    Get.dialog(appLoader(), barrierDismissible: false);

    try {
      final response = await OrderService.createOrder(body);
      debugPrint("📥 [ORDER] API response: $response");

      if (response == null) {
        appToast(error: true, content: "Failed to place order");
        return;
      }

      final data = response['data'];
      if (data == null || data is! Map<String, dynamic>) {
        appToast(error: true, content: "Invalid payment response");
        return;
      }

      final payment = OrderResponseModel.fromJson(data);

      // ---------------- WALLET FLOW ----------------
      if (selectedPaymentMethod.value == PaymentMethod.wallet) {
        debugPrint("💰 [ORDER] Wallet flow");

        final String orderId = payment.order.id;

        if (enableAutoPay.value && orderId.isNotEmpty) {
          final autoPayResponse =
              await OrderService.enableAutoPay(orderId: orderId);

          if (autoPayResponse?.success == true) {
            await notificationService.sendCustomNotification(
              title: "Autopay Enabled",
              message:
                  "Your payments will now be made automatically from your wallet.",
              sendPush: true,
              sendInApp: true,
            );
          }
        }

        await walletController.fetchWallet(forceRefresh: true);
        Get.off(() => BookingConfirmationScreen());
        return;
      }

      // ---------------- RAZORPAY FLOW ----------------
      final razorpayOrderId = payment.payment.razorpayOrderId;

      debugPrint("🟣 [RAZORPAY] OrderId: $razorpayOrderId");

      if (razorpayOrderId.isEmpty) {
        appToast(error: true, content: "Invalid Razorpay Order ID");
        return;
      }

      Get.find<RazorpayController>().openCheckout(
        razorpayOrderId: razorpayOrderId,
        orderId: payment.order.id,
        amount: payment.payment.amount,
      );
    } catch (e, stack) {
      debugPrint("❌ [ORDER] Exception: $e");
      debugPrint("📌 [ORDER] StackTrace: $stack");

      appToast(error: true, content: "Payment initialization failed");
    } finally {
      isPlacingOrder.value = false; // 🔓 UNLOCK
      debugPrint("🔓 [ORDER] placeOrder UNLOCKED");

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

    if (method == PaymentMethod.wallet) {
      showWalletAutoPay.value = true;
    } else {
      showWalletAutoPay.value = false;
    }
  }

  // ------------------------- QUANTITY ----------------------------------------
  void increaseQty() {
    quantity.value++;
    refreshOrderPreview();
  }

  void decreaseQty() {
    if (quantity.value <= 1) {
      appToaster(content: "Minimum quantity is 1", error: true);
      return;
    }
    quantity.value--;
    refreshOrderPreview();
  }
}
