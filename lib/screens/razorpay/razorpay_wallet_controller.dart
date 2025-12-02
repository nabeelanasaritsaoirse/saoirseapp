import 'dart:developer';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:saoirse_app/screens/transaction_succsess/transactionSuccsess.dart';

import '../../models/razorpay_payment_response.dart';
import '../../services/payment_service.dart';
import '../../widgets/app_loader.dart';
import '../../widgets/app_toast.dart';

class RazorpayWalletController extends GetxController {
  late Razorpay razorpay;

  // Wallet-specific order ID (internal order)
  String transactionId = "";

  @override
  void onInit() {
    super.onInit();

    razorpay = Razorpay();

    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    log("Wallet RazorpayController Initialized");
  }

  // ---------------------------------------------------------
  // 🔥 START WALLET PAYMENT
  // ---------------------------------------------------------
  void startWalletPayment({
    required String internalOrderId,
    required String rpOrderId,
    required int amount,
  }) {
    transactionId = internalOrderId;
   log("Transaction id ===================> $internalOrderId");
    openCheckout(
      razorpayOrderId: rpOrderId,
      amount: amount,
    );
  }

  // ---------------------------------------------------------
  // 🔥 OPEN CHECKOUT (WALLET)
  // ---------------------------------------------------------
  void openCheckout({
    required String razorpayOrderId,
    required int amount,
  }) {
    try {
      final options = {
        'key': dotenv.env['RAZORPAY_KEY_ID'],
        'amount': amount,
        'order_id': razorpayOrderId,
        'currency': 'INR',
      };

      log("Opening WALLET Razorpay Checkout => $options");

      razorpay.open(options);
    } catch (e, s) {
      log("ERROR Opening Razorpay Wallet: $e\n$s");
      appToast(error: true, content: "Could not open payment window");
    }
  }

  // ---------------------------------------------------------
  // 🔥 CALLBACKS (SUCCESS / FAILURE)
  // ---------------------------------------------------------

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    log("WALLET PAYMENT SUCCESS");
    log("Payment ID: ${response.paymentId}");
    log("Order ID: ${response.orderId}");
    log("Signature: ${response.signature}");

    appToast(content: "Wallet Payment Success!");

    final paymentData = RazorpayPaymentResponse(
      orderId: response.orderId ?? "",
      paymentId: response.paymentId ?? "",
      signature: response.signature ?? "",
    );

    _verifyWalletPayment(paymentData);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    log("WALLET PAYMENT FAILED");
    appToast(error: true, content: "Wallet Payment Failed");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    log("WALLET SELECTED: ${response.walletName}");
    appToast(content: "External Wallet: ${response.walletName}");
  }

  // ---------------------------------------------------------
  // 🔥 VERIFY WALLET PAYMENT
  // ---------------------------------------------------------

  Future<void> _verifyWalletPayment(RazorpayPaymentResponse data) async {
    try {
      appLoader();

      final body = {
        
        "razorpay_order_id": data.orderId,
        "razorpay_payment_id": data.paymentId,
        "razorpay_signature": data.signature,
        "transaction_id": transactionId,
      };

      log("Verify Wallet Payment Body => $body");

      final response = await PaymentService.verifyWalletPayment(body);

      if (Get.isDialogOpen ?? false) Get.back();

      if (response != null && response["success"] == true) {
        appToast(content: "Money Added to Wallet Successfully!");

        // Optionally: refresh wallet screen
        Get.to(Transactionsuccsess());

        // Close Add Money Screen
      } else {
        appToast(
          error: true,
          content:
              response?["message"] ?? "Wallet Payment Verification Failed!",
        );
      }
    } catch (e, s) {
      if (Get.isDialogOpen ?? false) Get.back();
      log("Wallet Verify Error: $e\n$s");
      appToast(error: true, content: "Unexpected Wallet Payment Error!");
    }
  }

  @override
  void onClose() {
    razorpay.clear();
    log("Wallet RazorpayController Closed");
    super.onClose();
  }
}
