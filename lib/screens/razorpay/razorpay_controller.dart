import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:saoirse_app/widgets/app_loader.dart';
import 'package:saoirse_app/widgets/app_snackbar.dart';

class RazorpayController extends GetxController {
  late Razorpay razorpay;

  @override
  void onInit() {
    super.onInit();

    try {
      log("RazorpayController initialized");

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

  Future<void> openTestCheckout() async {
    try {
      log("Opening Razorpay Checkout...");

      // Show loader
      appLoader();
      await Future.delayed(const Duration(milliseconds: 150));

      final options = {
        'key': 'rzp_live_rqOS9AG74ADgsB',
        'amount': 5000,
        "order_id": "order_Rin4b9mnKPURak",
        'currency': 'INR',
        'name': 'Test Payment',
        'description': 'Testing Razorpay Integration',
        'prefill': {
          'contact': '9876543210',
          'email': 'test@gmail.com',
        },
      };

      log("Razorpay Checkout Options: $options");

      WidgetsBinding.instance.addPostFrameCallback((_) {
        try {
          razorpay.open(options);
          log("Razorpay Checkout Opened Successfully");
        } catch (e, s) {
          log("ERROR opening Razorpay: $e");
          log("STACKTRACE: $s");
          appSnackbar(error: true, content: "Failed to open payment window");
        }
      });

      // Ensure loader closes after opening
      Future.delayed(const Duration(milliseconds: 700), () {
        if (Get.isDialogOpen ?? false) {
          Get.back();
          log("Loader closed");
        }
      });
    } catch (e, s) {
      log("Exception in openTestCheckout(): $e");
      log("STACKTRACE: $s");
      appSnackbar(
          error: true, content: "Something went wrong while starting payment.");
    }
  }

  // -------------------- CALLBACKS ----------------------

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    log("PAYMENT SUCCESS");
    log(response.data.toString());
    log("Payment ID: ${response.paymentId}");
    log("Order ID: ${response.orderId}");
    log("Signature: ${response.signature}");

    appSnackbar(
      content: "Payment Success: ${response.paymentId}",
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    log("PAYMENT FAILED");
    log("Code: ${response.code}");
    log("Message: ${response.message}");

    appSnackbar(
      error: true,
      content: "Payment Failed. Code: ${response.code}",
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    log("EXTERNAL WALLET SELECTED: ${response.walletName}");

    appSnackbar(
      content: "Wallet Selected: ${response.walletName}",
    );
  }

  @override
  void onClose() {
    razorpay.clear();
    log("Razorpay cleared and controller closed");
    super.onClose();
  }
}
