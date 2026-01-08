import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../services/payment_service.dart';
import '../../widgets/app_loader.dart';
import '../../widgets/app_toast.dart';
import '../booking_confirmation/booking_confirmation_screen.dart';
import '../cart/cart_controller.dart';

class RazorpayCartController extends GetxController {
  late Razorpay razorpay;
  final CartController cartController = Get.find<CartController>();

  /// Used for verification
  String bulkOrderId = "";

  @override
  void onInit() {
    super.onInit();
    log("🔥 RazorpayCartController INITIALIZED");
    razorpay = Razorpay();

    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  // ================= OPEN RAZORPAY =================
  void openCheckout({
    required String bulkOrderId,
    required String razorpayOrderId,
  }) {
    this.bulkOrderId = bulkOrderId;

    log("Razorpay Order ID: $razorpayOrderId");

    /// 🔥 Delay until UI is ready
    Future.delayed(const Duration(milliseconds: 300), () {
      try {
        final options = {
          'key': dotenv.env['RAZORPAY_KEY_ID'],
          'order_id': razorpayOrderId,
          'currency': 'INR',
        };

        razorpay.open(options);
      } catch (e) {
        appToast(error: true, content: "Could not open payment window");
      }
    });
  }

  // ================= CALLBACKS =================

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    log("✅ RAZORPAY PAYMENT SUCCESS");
    log("➡️ orderId        : ${response.orderId}");
    log("➡️ paymentId      : ${response.paymentId}");
    log("➡️ signature      : ${response.signature}");

    // Optional: log whole object (debug only)
    log("➡️ full response  : ${response.toString()}");

    final razorpayOrderId = response.orderId ?? "";
    final razorpayPaymentId = response.paymentId ?? "";
    final razorpaySignature = response.signature ?? "";

    if (razorpayOrderId.isEmpty ||
        razorpayPaymentId.isEmpty ||
        razorpaySignature.isEmpty) {
      appToast(error: true, content: "Invalid payment response");
      return;
    }

    _verifyBulkPayment(
      razorpayOrderId: razorpayOrderId,
      razorpayPaymentId: razorpayPaymentId,
      razorpaySignature: razorpaySignature,
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    log("❌ RAZORPAY PAYMENT FAILED");
    log("➡️ code    : ${response.code}");
    log("➡️ message : ${response.message}");
    log("➡️ details : ${response.error?.toString()}");
    appToast(
      error: true,
      content: "Payment Failed. Code: ${response.code}",
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    appToast(
      content: "Wallet Selected: ${response.walletName}",
    );
  }

  // ================= VERIFY BULK PAYMENT =================

  Future<void> _verifyBulkPayment({
    required String razorpayOrderId,
    required String razorpayPaymentId,
    required String razorpaySignature,
  }) async {
    try {
      appLoader();

      final body = {
        "bulkOrderId": bulkOrderId,
        "razorpayOrderId": razorpayOrderId,
        "razorpayPaymentId": razorpayPaymentId,
        "razorpaySignature": razorpaySignature,
      };

      log("Verify payment body====> :$body");

      final response = await PaymentService.verifyBulkOrderPayment(body);

      if (Get.isDialogOpen ?? false) Get.back();

      if (response != null &&
          (response["success"] == true || response["status"] == "success")) {
        await cartController.clearCartItems();
        Get.off(() => BookingConfirmationScreen());
      } else {
        appToast(
          error: true,
          content: response?["message"] ?? "Bulk payment verification failed",
        );
      }
    } catch (e) {
      if (Get.isDialogOpen ?? false) Get.back();

      appToast(
        error: true,
        content: "Bulk payment verification failed unexpectedly",
      );
    }
  }

  @override
  void onClose() {
    razorpay.clear();
    super.onClose();
  }
}
