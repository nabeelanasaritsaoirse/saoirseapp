import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../models/razorpay_payment_response.dart';
import '../../services/payment_service.dart';
import '../../widgets/app_loader.dart';
import '../../widgets/app_toast.dart';
import '../transaction_succsess/transaction_succsess.dart';

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

      razorpay.open(options);
    } catch (e) {
      appToast(error: true, content: "Could not open payment window");
    }
  }

  // ---------------------------------------------------------
  // 🔥 CALLBACKS (SUCCESS / FAILURE)
  // ---------------------------------------------------------

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    appToast(content: "Wallet Payment Success!");

    final paymentData = RazorpayPaymentResponse(
      orderId: response.orderId ?? "",
      paymentId: response.paymentId ?? "",
      signature: response.signature ?? "",
    );

    _verifyWalletPayment(paymentData);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    appToast(error: true, content: "Wallet Payment Failed");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
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
    } catch (e) {
      if (Get.isDialogOpen ?? false) Get.back();

      appToast(error: true, content: "Unexpected Wallet Payment Error!");
    }
  }

  @override
  void onClose() {
    razorpay.clear();

    super.onClose();
  }
}
