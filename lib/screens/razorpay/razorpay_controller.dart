import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../models/razorpay_payment_response.dart';
import '../../services/payment_service.dart';
import '../../widgets/app_loader.dart';
import '../../widgets/app_snackbar.dart';
import '../booking_confirmation/booking_confirmation_screen.dart';

class RazorpayController extends GetxController {
  late Razorpay razorpay;
  String orderId = "";

  @override
  void onInit() {
    super.onInit();

    try {
      log("RazorpayController initialized");
      log("OrderId ======== : $orderId");
      razorpay = Razorpay();

      razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
      razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
      razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

      log("Razorpay event listeners attached");
    } catch (e, s) {
      log("ERROR initializing Razorpay: $e");
      log("STACKTRACE: $s");
    }
  }

  //  Use this for REAL PAYMENT (orderId, amount, key from API)
  void openCheckout({
    required String orderId,
    required String razorpayOrderId,
    required int amount,
  }) {
    this.orderId = orderId;
    try {
      log("Opening Razorpay Checkout with Order ID: $orderId");

      final options = {
        'key': dotenv.env['RAZORPAY_KEY_ID'],
        'amount': amount,
        'order_id': razorpayOrderId,
        'currency': 'INR',
      };

      //  final options = {
      //   'key': '',
      //   'amount': '',
      //   "order_id": "",
      //   'currency': 'INR',
      //   'name': 'Test Payment',
      //   'description': 'Testing Razorpay Integration',
      //   'prefill': {
      //     'contact': '9876543210',
      //     'email': 'test@gmail.com',
      //   },
      // };

      // log("Razorpay Options = $options");

      razorpay.open(options);
    } catch (e, s) {
      log("ERROR opening Razorpay: $e");
      log("STACKTRACE: $s");
      appToast(error: true, content: "Could not open payment window");
    }
  }

  // -------------------- CALLBACKS ----------------------

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    log("PAYMENT SUCCESS");

    log("Payment ID: ${response.paymentId}");
    log("Order ID: ${response.orderId}");
    log("Signature: ${response.signature}");

    appToast(content: "Payment Success: ${response.paymentId}");

    final paymentData = RazorpayPaymentResponse(
      orderId: response.orderId ?? "",
      paymentId: response.paymentId ?? "",
      signature: response.signature ?? "",
    );
    log("Orderid ======> $orderId");
    _verifyPayment(paymentData);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    log("PAYMENT FAILED");
    log("Code: ${response.code}");
    log("Message: ${response.message}");

    appToast(
      error: true,
      content: "Payment Failed. Code: ${response.code}",
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    log("EXTERNAL WALLET SELECTED: ${response.walletName}");

    appToast(
      content: "Wallet Selected: ${response.walletName}",
    );
  }

  Future<void> _verifyPayment(RazorpayPaymentResponse data) async {
    try {
      appLoader();

      final body = {
        "orderId": orderId,
        "paymentMethod": "RAZORPAY",
        "razorpayOrderId": data.orderId,
        "razorpayPaymentId": data.paymentId,
        "razorpaySignature": data.signature,
      };

      log("VERIFY PAYMENT BODY => $body");

      final response = await PaymentService.processPayment(body);

      if (Get.isDialogOpen ?? false) Get.back();

      if (response != null &&
          (response["success"] == true || response["status"] == "success")) {
        // Payment is verified
        Get.to(BookingConfirmationScreen());
      } else {
        appToast(
            error: true,
            content: response?["message"] ??
                "Payment verification failed! Please contact support.");
      }
    } catch (e, s) {
      if (Get.isDialogOpen ?? false) Get.back();
      log("Verify Payment Error: $e\n$s");
      appToast(
          error: true, content: "Payment verification failed unexpectedly!");
    }
  }

  @override
  void onClose() {
    razorpay.clear();
    log("Razorpay cleared and controller closed");
    super.onClose();
  }
}
