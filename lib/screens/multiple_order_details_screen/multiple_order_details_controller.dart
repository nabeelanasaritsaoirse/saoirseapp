import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/payment_methods.dart';
import '../../models/bulk_order_response.dart';
import '../../models/cart_response_model.dart';
import '../../models/coupon_model.dart';
import '../../models/coupon_validation_model.dart';
import '../../services/coupon_service.dart';
import '../../services/notification_service.dart';
import '../../services/order_service.dart';
import '../../services/product_service.dart';
import '../../widgets/app_loader.dart';
import '../../widgets/app_toast.dart';
import '../../widgets/select_plansheet_for_cart.dart';
import '../booking_confirmation/booking_confirmation_screen.dart';
import '../cart/cart_controller.dart';
import '../my_wallet/my_wallet_controller.dart';
import '../razorpay/razorpay_cart_controller.dart';

class MultipleOrderDetailsController extends GetxController {
  final walletController = Get.find<MyWalletController>();
  NotificationService notificationService = NotificationService();
  final CartController cartController = Get.find<CartController>();

  RxList<CartProduct> products = <CartProduct>[].obs;
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

  /// 🔐 Stores original plan per product (before coupon)
  final Map<String, InstallmentPlan> originalPlans = {};

  Rx<CouponValidationResponse?> couponValidation =
      Rx<CouponValidationResponse?>(null);

  RxString appliedCouponCode = "".obs;

  // RxString selectedPaymentMethod = PaymentMethod.razorpay.obs;
  RxString selectedPaymentMethod = "".obs;

  // storing first values for remove coupon
  double originalAmount = 0.0;
  int originalDays = 0;

  @override
  void onInit() {
    super.onInit();
    selectedPaymentMethod.value = PaymentMethod.razorpay;
    enableAutoPay.value = true;
    fetchCoupons();
  }

  void updatePlan({
    required String productId,
    required int days,
    required double dailyAmount,
  }) {
    final index = products.indexWhere(
      (p) => p.productId == productId,
    );

    if (index == -1) return;

    final oldItem = products[index];

    final updatedPlan = oldItem.installmentPlan.copyWith(
      totalDays: days,
      dailyAmount: dailyAmount,
      totalAmount: days * dailyAmount,
    );

    final updatedItem = oldItem.copyWith(
      installmentPlan: updatedPlan,
      itemTotal: days * dailyAmount * oldItem.quantity, // 👈 IMPORTANT
    );

    products[index] = updatedItem; // 🔥 instant UI update
  }

  void openPlanEditor(CartProduct item) async {
    appLoader();

    final plans = await ProductService().fetchProductPlans(item.productId);

    if (Get.isDialogOpen ?? false) Get.back();

    Get.bottomSheet(
      SelectPlanSheetForCart(
        productId: item.productId,
        plans: plans,
        initialDays: item.installmentPlan.totalDays,
        initialAmount: item.installmentPlan.dailyAmount,
        totalProductAmount: item.installmentPlan.totalAmount,
        onPlanSelected: (days, amount) {
          updatePlan(
            productId: item.productId,
            days: days,
            dailyAmount: amount,
          );
        },
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
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

  // ------------------------- CENTRAL RECALCULATION----------------------
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

  // ------------------------- QUANTITY ----------------------------------------
  void increaseQty(CartProduct item) {
    final index = products.indexOf(item);
    if (index == -1) return;

    final updatedQty = item.quantity + 1;

    final updatedItem = item.copyWith(
      quantity: updatedQty,
      itemTotal: updatedQty *
          item.installmentPlan.dailyAmount *
          item.installmentPlan.totalDays,
    );

    products[index] = updatedItem; // 🔥 UI updates
  }

  void decreaseQty(CartProduct item) {
    if (item.quantity <= 1) {
      appToaster(content: "Minimum quantity should be 1", error: true);
      return;
    }

    final index = products.indexOf(item);
    if (index == -1) return;

    final updatedQty = item.quantity - 1;

    final updatedItem = item.copyWith(
      quantity: updatedQty,
      itemTotal: updatedQty *
          item.installmentPlan.dailyAmount *
          item.installmentPlan.totalDays,
    );

    products[index] = updatedItem; // 🔥 UI updates
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

  Future<void> applyCouponLoopWiseForAllProducts({
    required String couponCode,
  }) async {
    debugPrint("🟡 [COUPON] Apply clicked");

    if (couponCode.trim().isEmpty) {
      appToaster(error: true, content: "Please enter a coupon code");
      return;
    }

    if (products.isEmpty) {
      appToaster(error: true, content: "No products in cart");
      return;
    }

    final List<CartProduct> updatedProducts = [];

    try {
      for (final item in products) {
        final body = {
          "couponCode": couponCode.trim(),
          "productId": item.productId,
          "dailyAmount": item.installmentPlan.dailyAmount,
          "totalDays": item.installmentPlan.totalDays,
          "quantity": item.quantity,
        };

        final response = await CouponService.validateCoupon(body);

        final inst = response.installment;

        final updatedPlan = item.installmentPlan.copyWith(
          dailyAmount: inst.dailyAmount,
          totalDays: inst.totalDays,
          totalAmount: inst.dailyAmount * inst.totalDays,
        );

        final updatedItem = item.copyWith(
          installmentPlan: updatedPlan,
          itemTotal: inst.dailyAmount * inst.totalDays * item.quantity,
        );

        updatedProducts.add(updatedItem);
      }

      // ✅ APPLY ONLY IF ALL PRODUCTS ARE VALID
      products.assignAll(updatedProducts);

      totalAmount.value = products.fold(
        0.0,
        (sum, item) => sum + item.itemTotal,
      );

      appliedCouponCode.value = couponCode.trim();
    } catch (e) {
      // ✅ ONLY SHOW ERROR MESSAGE
      appToaster(
        error: true,
        content: e.toString().replaceAll("Exception:", "").trim(),
      );
    }
  }

  void removeCoupon(TextEditingController controller) {
    final List<CartProduct> restoredProducts = [];

    for (final item in products) {
      final originalPlan = originalPlans[item.productId];

      if (originalPlan == null) continue;

      restoredProducts.add(
        item.copyWith(
          installmentPlan: originalPlan,
          itemTotal:
              originalPlan.dailyAmount * originalPlan.totalDays * item.quantity,
        ),
      );
    }

    // 🔥 Restore all products
    products.assignAll(restoredProducts);

    // 🔥 Clear coupon state
    couponValidation.value = null;
    appliedCouponCode.value = "";
    selectedCoupon.value = null;

    // 🔥 Recalculate total amount
    totalAmount.value = products.fold(
      0.0,
      (sum, item) => sum + item.itemTotal,
    );

    // 🔥 Clear input
    controller.clear();

    appToast(
      title: "Coupon Removed",
      content: "Coupon removed from all products",
    );
  }

  double get subTotal {
    return products.fold(
      0.0,
      (sum, item) => sum + (item.finalPrice * item.quantity),
    );
  }

  double get discountAmount {
    final v = couponValidation.value;
    if (v == null) return 0.0;
    return v.pricing.discountAmount;
  }

  double get finalTotal {
    final v = couponValidation.value;
    if (v != null) {
      return v.pricing.finalPrice;
    }
    return subTotal;
  }

  /// 🧮 FULL ORDER TOTAL (after coupon if applied)
  double get orderTotalAmount {
    final v = couponValidation.value;
    if (v != null) {
      return v.pricing.finalPrice;
    }

    return products.fold(
      0.0,
      (sum, item) => sum + (item.finalPrice * item.quantity),
    );
  }

  /// 💳 PAY NOW (TOTAL DAILY AMOUNT FOR ALL PRODUCTS)
  double get totalPayNowAmount {
    return products.fold(
      0.0,
      (sum, item) => sum + (item.installmentPlan.dailyAmount * item.quantity),
    );
  }

  Future<void> enableAutoPayForOrder(String orderId) async {
    if (orderId.isEmpty) return;

    final autoPayResponse = await OrderService.enableAutoPay(orderId: orderId);

    if (autoPayResponse != null && autoPayResponse.success) {
      log("✅ Autopay enabled for order: $orderId");
    } else {
      log("⚠️ Failed to enable autopay for order: $orderId");
    }
  }

  List<Map<String, dynamic>> buildBulkItems() {
    return products.map((item) {
      final Map<String, dynamic> map = {
        "productId": item.productId,
        "quantity": item.quantity,
        "totalDays": item.installmentPlan.totalDays,
      };

      // ✅ Variant (only if exists)
      final variantId = item.variant?.variantId;
      if (variantId != null && variantId.isNotEmpty) {
        map["variantId"] = variantId;
      }

      // ✅ Coupon (optional)
      if (appliedCouponCode.value.isNotEmpty) {
        map["couponCode"] = appliedCouponCode.value;
      }

      return map;
    }).toList();
  }

// ------------------------- PLACE ORDER FOR MULTIPLE PRODUCT-------------------------------------
  Future<void> placeBulkOrder({
    required Map<String, dynamic> deliveryAddress,
  }) async {
    // 🔒 PREVENT MULTIPLE CALLS
    if (isPlacingOrder.value) {
      log("⛔ [BULK ORDER] Already processing, ignored");
      return;
    }

    isPlacingOrder.value = true;
    log("🔒 [BULK ORDER] LOCKED");

    final bool shouldEnableAutoPay = enableAutoPay.value;

    final body = {
      "items": buildBulkItems(),
      "paymentMethod": selectedPaymentMethod.value,
      "deliveryAddress": deliveryAddress,
    };

    log("📤 [BULK ORDER] Request body: $body");

    Get.dialog(appLoader(), barrierDismissible: false);

    try {
      final response = await OrderService.createBulkOrder(body);
      log("📥 [BULK ORDER] API response: $response");

      if (response == null || response["success"] != true) {
        appToast(error: true, content: "Bulk order failed");
        return;
      }

      final bulkResponse = BulkOrderResponse.fromJson(response);
      final data = bulkResponse.data;

      // ================= WALLET FLOW =================
      if (data.summary.paymentMethod == PaymentMethod.wallet) {
        log("💰 [BULK ORDER] Wallet flow");

        if (shouldEnableAutoPay) {
          for (final order in data.orders) {
            if (order.orderId.isNotEmpty) {
              await enableAutoPayForOrder(order.orderId);
            }
          }

          await notificationService.sendCustomNotification(
            title: "Autopay Enabled",
            message:
                "Your installment payments will now be made automatically from your wallet.",
            sendPush: true,
            sendInApp: true,
          );
        }

        enableAutoPay.value = false;

        await cartController.clearCartItems();
        await walletController.fetchWallet(forceRefresh: true);

        Get.off(() => BookingConfirmationScreen());
        return;
      }

      // ================= RAZORPAY FLOW =================
      final razorpayOrderId = data.payment?.razorpayOrderId ?? "";
      log("🟣 [BULK RAZORPAY] OrderId: $razorpayOrderId");

      if (razorpayOrderId.isEmpty) {
        appToast(error: true, content: "Invalid Razorpay order");
        return;
      }

      Get.find<RazorpayCartController>().openCheckout(
        bulkOrderId: data.bulkOrderId,
        razorpayOrderId: razorpayOrderId,
      );
    } catch (e, stack) {
      log("❌ [BULK ORDER] Exception: $e");
      log("📌 [BULK ORDER] StackTrace: $stack");

      appToast(error: true, content: "Payment initialization failed");
    } finally {
      isPlacingOrder.value = false; // 🔓 UNLOCK
      log("🔓 [BULK ORDER] UNLOCKED");

      if (Get.isDialogOpen ?? false) Get.back();
    }
  }

  void selectPaymentMethod(String method) {
    selectedPaymentMethod.value = method;

    if (method == PaymentMethod.wallet) {
      showWalletAutoPay.value = true;
    } else {
      showWalletAutoPay.value = false;
    }
  }
}
