import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/payment_methods.dart';
import '../../models/address_response.dart';
import '../../models/bulk_order_preview_response.dart';
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

  Rx<BulkOrderPreviewData?> previewData = Rx<BulkOrderPreviewData?>(null);

  RxBool isPreviewLoading = false.obs;

// ---------------- PREVIEW COUPON STATE ----------------
  RxBool isCouponApplied = false.obs;
  RxString previewCouponCode = "".obs;

  RxBool isInitialized = false.obs;

  Completer<void>? _placeOrderLock;

  @override
  void onInit() {
    super.onInit();
    selectedPaymentMethod.value = PaymentMethod.razorpay;
    enableAutoPay.value = true;
    initFromCartController();
    fetchCoupons();
  }

  void initCartOnce(List<CartProduct> initialProducts) {
    if (isInitialized.value) return;

    products.assignAll(initialProducts);

    for (final item in products) {
      originalPlans[item.productId] = item.installmentPlan;
    }

    isInitialized.value = true;
  }

  void initFromCartController() {
    if (products.isNotEmpty) return;

    products.assignAll(cartController.cartData.value!.products);

    for (final item in products) {
      originalPlans[item.productId] = item.installmentPlan;
    }
  }

// ---------------- PREVIEW ITEMS ----------------
  List<PreviewItem> get previewItems {
    return previewData.value?.items ?? [];
  }

// ---------------- PREVIEW ADDRESS (SAFE MAPPING) ----------------


  Address? get previewAddress {
    final data = previewData.value;
    if (data == null) return null;

    final a = data.deliveryAddress;

    return Address(
      id: "",
      name: a.name,
      phoneNumber: a.phoneNumber,
      addressLine1: a.addressLine1,
      addressLine2: a.addressLine2 ?? "",
      city: a.city,
      state: a.state,
      pincode: a.pincode,
      country: a.country,
      landmark: a.landmark ?? "",
      isDefault: false,
      addressType: "",
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  /* ===============================================================
     BULK ORDER PREVIEW
     =============================================================== */

  Future<void> fetchBulkOrderPreviewWithLoader({
  required Address deliveryAddress,
}) async {

  final oldPreview = previewData.value;   

  isPreviewLoading.value = true;

  try {

    final body = {
      "items": buildBulkItems(),
      "deliveryAddress": buildDeliveryAddress(deliveryAddress),
    };

    final response = await OrderService.bulkOrderPreview(body);

    if (response == null) {
      appToast(error: true, content: "Preview failed");

      previewData.value = oldPreview; 
      return;
    }

    final preview = BulkOrderPreviewResponse.fromJson(response);
    previewData.value = preview.data;

  } catch (e) {

    previewData.value = oldPreview;   

    appToast(error: true, content: "Unable to load order preview");

  } finally {

    isPreviewLoading.value = false; 
  }
}


  Map<String, dynamic> buildDeliveryAddress(Address address) {
    final map = {
      "name": address.name,
      "phoneNumber": address.phoneNumber,
      "addressLine1": address.addressLine1,
      "city": address.city,
      "state": address.state,
      "pincode": address.pincode,
      "country": address.country,
    };

    if (address.addressLine2.trim().isNotEmpty) {
      map["addressLine2"] = address.addressLine2;
    }

    if (address.landmark.trim().isNotEmpty) {
      map["landmark"] = address.landmark;
    }

    return map;
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
        onPlanSelected: (days, amount) async {
          // 🔥 1. UPDATE CART (SOURCE OF TRUTH)
          cartController.updateProductPlan(
            productId: item.productId,
            days: days,
            dailyAmount: amount,
          );

          // 🔥 2. SYNC LOCAL PRODUCTS LIST
          updatePlan(
            productId: item.productId,
            days: days,
            dailyAmount: amount,
          );

          // 🔥 3. REFRESH PREVIEW
          final address = previewAddress;
          if (address != null) {
            await fetchBulkOrderPreviewWithLoader(deliveryAddress: address);
          }
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

// ---------------- PREVIEW → CART QTY BRIDGE ----------------

  void increasePreviewQty(PreviewItem item, Address address) {
    final index = item.itemIndex;
    if (index < 0 || index >= products.length) return;

    final cartItem = products[index];
    final newQty = cartItem.quantity + 1;

    // 🔥 base per-day amount for 1 qty
    final basePerDay = cartItem.installmentPlan.dailyAmount / cartItem.quantity;

    final updatedPlan = cartItem.installmentPlan.copyWith(
      dailyAmount: basePerDay * newQty, // 🔥 SCALE
      totalAmount: basePerDay * newQty * cartItem.installmentPlan.totalDays,
    );

    // 🔥 UPDATE CART (SOURCE OF TRUTH)
    cartController.updateProductWithPlan(
      productId: cartItem.productId,
      quantity: newQty,
      plan: updatedPlan,
    );

    // 🔥 UPDATE LOCAL LIST
    products[index] = cartItem.copyWith(
      quantity: newQty,
      installmentPlan: updatedPlan,
    );

    // 🔁 REFRESH PREVIEW
    fetchBulkOrderPreviewWithLoader(deliveryAddress: address);
  }

  void decreasePreviewQty(PreviewItem item, Address address) {
    final index = item.itemIndex;
    if (index < 0 || index >= products.length) return;

    final cartItem = products[index];
    if (cartItem.quantity <= 1) {
      appToaster(content: "Minimum quantity should be 1", error: true);
      return;
    }

    final newQty = cartItem.quantity - 1;

    final basePerDay = cartItem.installmentPlan.dailyAmount / cartItem.quantity;

    final updatedPlan = cartItem.installmentPlan.copyWith(
      dailyAmount: basePerDay * newQty,
      totalAmount: basePerDay * newQty * cartItem.installmentPlan.totalDays,
    );

    cartController.updateProductWithPlan(
      productId: cartItem.productId,
      quantity: newQty,
      plan: updatedPlan,
    );

    products[index] = cartItem.copyWith(
      quantity: newQty,
      installmentPlan: updatedPlan,
    );

    fetchBulkOrderPreviewWithLoader(deliveryAddress: address);
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
    required Address deliveryAddress,
  }) async {
    if (couponCode.trim().isEmpty) {
      appToaster(error: true, content: "Please enter a coupon code");
      return;
    }

    if (products.isEmpty) {
      appToaster(error: true, content: "No products in cart");
      return;
    }

    try {
      for (final item in products) {
        final body = {
          "couponCode": couponCode.trim(),
          "productId": item.productId,
          "dailyAmount": item.installmentPlan.dailyAmount,
          "totalDays": item.installmentPlan.totalDays,
          "quantity": item.quantity,
        };

        await CouponService.validateCoupon(body);
      }

      previewCouponCode.value = couponCode.trim();
      isCouponApplied.value = true;

      await fetchBulkOrderPreviewWithLoader(
        deliveryAddress: deliveryAddress,
      );

      appToast(content: "Coupon applied successfully");
    } catch (e) {
      previewCouponCode.value = "";
      isCouponApplied.value = false;

      appToaster(
        error: true,
        content: e.toString().replaceAll("Exception:", "").trim(),
      );
    }
  }

  // ---------------- REMOVE COUPON (PREVIEW FLOW) ----------------
  Future<void> removePreviewCoupon({
    required Address deliveryAddress,
    TextEditingController? controller,
  }) async {
    //  Clear preview coupon state
    previewCouponCode.value = "";
    isCouponApplied.value = false;

    //  Reload preview WITHOUT coupon
    await fetchBulkOrderPreviewWithLoader(
      deliveryAddress: deliveryAddress,
    );

    //  Clear input if provided
    controller?.clear();

    appToast(
      title: "Coupon Removed",
      content: "Coupon removed from order preview",
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

  /// FULL ORDER TOTAL (after coupon if applied)
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
      final map = {
        "productId": item.productId,
        "quantity": item.quantity,
        "totalDays": item.installmentPlan.totalDays,
      };

      if (item.variant?.variantId.isNotEmpty == true) {
        map["variantId"] = item.variant!.variantId;
      }

      // ONLY add coupon if valid
      if (isCouponApplied.value && previewCouponCode.value.isNotEmpty) {
        map["couponCode"] = previewCouponCode.value;
      }

      return map;
    }).toList();
  }

// ------------------------- PLACE ORDER FOR MULTIPLE PRODUCT-------------------------------------
  Future<void> placeBulkOrder({
    required Map<String, dynamic> deliveryAddress,
  }) async {
    // ================= WALLET VALIDATION =================
    if (selectedPaymentMethod.value == PaymentMethod.wallet) {
      final walletBalance = walletController.wallet.value?.walletBalance ?? 0.0;

      final payNowAmount = previewData.value?.summary.totalFirstPayment ?? 0.0;

      log("💰 Wallet Balance: ₹$walletBalance");
      log("🧾 Pay Now Amount: ₹$payNowAmount");

      if (walletBalance < payNowAmount) {
        appToaster(
          error: true,
          content: "Insufficient wallet balance",
        );

        return; // 🚫 STOP ORDER CREATION
      }
    }
    // 🔒 PREVENT MULTIPLE CALLS
    if (_placeOrderLock != null) {
      log("⛔ [BULK ORDER] Already running — ignored");
      return;
    }
    _placeOrderLock = Completer<void>();

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
      log(" [BULK ORDER] Exception: $e");
      log(" [BULK ORDER] StackTrace: $stack");

      appToast(error: true, content: "Payment initialization failed");
    } finally {
      _placeOrderLock?.complete();
      _placeOrderLock = null;

      isPlacingOrder.value = false;
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
