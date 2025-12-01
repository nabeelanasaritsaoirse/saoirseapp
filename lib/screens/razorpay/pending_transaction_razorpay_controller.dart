import 'dart:developer';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:saoirse_app/services/pending_transaction_service.dart';
import '../../widgets/app_loader.dart';
import '../../widgets/app_toast.dart';
import '../booking_confirmation/booking_confirmation_screen.dart';
import '../../models/razorpay_payment_response.dart';

class PendingTransactionRazorpayController extends GetxController {
  late Razorpay razorpay;

 
  List<String> selectedOrders = [];
  String apiRazorpayOrderId = "";
  int apiAmount = 0; 
  String apiKeyId = "";

  @override
  void onInit() {
    super.onInit();
    try {
      razorpay = Razorpay();
      razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
      razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
      razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
      log("CombinedRazorpayController initialized");
    } catch (e, s) {
      log("Error initializing CombinedRazorpayController: $e\n$s");
    }
  }


  void startCombinedPayment({
    required Map<String, dynamic> createResponse,
    required List<String> selectedOrders,
  }) {
    try {
      this.selectedOrders = selectedOrders;

      apiRazorpayOrderId = createResponse['razorpayOrderId'] ?? "";
      apiAmount =
          (createResponse['amount'] is int) ? createResponse['amount'] as int : int.tryParse(createResponse['amount']?.toString() ?? "0") ?? 0;
      apiKeyId = createResponse['keyId'] ?? createResponse['key'] ?? dotenv.env['RAZORPAY_KEY_ID'] ?? "";

      if (apiRazorpayOrderId.isEmpty || apiAmount == 0 || apiKeyId.isEmpty) {
        appToast(error: true, content: "Invalid payment data from server.");
        log("Invalid create-combined response: $createResponse");
        return;
      }

      _openCheckout(razorpayOrderId: apiRazorpayOrderId, amount: apiAmount, keyId: apiKeyId);
    } catch (e, s) {
      log("startCombinedPayment error: $e\n$s");
      appToast(error: true, content: "Could not start payment.");
    }
  }
  

  void _openCheckout({
    required String razorpayOrderId,
    required int amount,
    required String keyId,
  }) {
    try {
      final options = {
        'key': keyId,
        'amount': amount,
        'order_id': razorpayOrderId,
        'currency': 'INR',
      };

      log("Opening Razorpay with options: $options");
      razorpay.open(options);
    } catch (e, s) {
      log("Error opening Razorpay: $e\n$s");
      appToast(error: true, content: "Could not open payment window");
    }
  }
  

  // -------------------- CALLBACKS ----------------------
  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    log("Combined payment success: ${response.paymentId}");
    appToast(content: "Payment Success: ${response.paymentId}");

    final paymentData = RazorpayPaymentResponse(
      orderId: response.orderId ?? "",
      paymentId: response.paymentId ?? "",
      signature: response.signature ?? "",
    );

    await _finalizeCombinedPayment(paymentData);
  }


  void _handlePaymentError(PaymentFailureResponse response) {
    log("Combined payment failed: ${response.code} ${response.message}");
    appToast(error: true, content: "Pending Payment Failed");
  }


  void _handleExternalWallet(ExternalWalletResponse response) {
    log("External wallet selected: ${response.walletName}");
    appToast(content: "Wallet Selected: ${response.walletName}");
  }


  Future<void> _finalizeCombinedPayment(RazorpayPaymentResponse data) async {
    try {
      appLoader();

      final body = {
        "selectedOrders": selectedOrders,
        "paymentMethod": "RAZORPAY",
        "razorpayOrderId": data.orderId,
        "razorpayPaymentId": data.paymentId,
        "razorpaySignature": data.signature,
      };

      log("Finalizing combined payment with body: $body");

      final response = await PendingTransactionService.payDailySelected(body);

      if (Get.isDialogOpen ?? false) Get.back();

      if (response != null && (response['success'] == true || response['status'] == 'success')) {
        appToast(content: "Payment processed successfully");
        // navigate to confirmation or refresh orders
        Get.to(() => BookingConfirmationScreen());
      } else {
        final msg = response?['message'] ?? 'Payment verification failed. Contact support.';
        appToast(error: true, content: msg);
        log("payDailySelected failed response: $response");
      }
    } catch (e, s) {
      if (Get.isDialogOpen ?? false) Get.back();
      log("Error finalizing combined payment: $e\n$s");
      appToast(error: true, content: "Payment verification error!");
    }
  }



  @override
  void onClose() {
    try {
      razorpay.clear();
    } catch (_) {}
    super.onClose();
  }
}
