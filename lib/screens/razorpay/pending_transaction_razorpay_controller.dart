import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:saoirse_app/constants/app_strings.dart';

import '../../services/pending_transaction_service.dart';
import '../../widgets/app_loader.dart';
import '../../widgets/app_toast.dart';
import '../../models/razorpay_payment_response.dart';
import '../booking_confirmation/pending_payment_confirmation_screen.dart';
import '../pending_transaction/pending_transaction_controller.dart';

class PendingTransactionRazorpayController extends GetxController {
  late Razorpay razorpay;

  List<String> selectedOrders = [];
  String apiRazorpayOrderId = "";
  int apiAmount = 0;
  String apiKeyId = "";

  @override
  void onInit() {
    super.onInit();

    razorpay = Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void startCombinedPayment({
    required Map<String, dynamic> createResponse,
    required List<String> selectedOrders,
  }) {
    try {
      this.selectedOrders = selectedOrders;

      apiRazorpayOrderId = createResponse['razorpayOrderId'] ?? "";
      apiAmount = (createResponse['amount'] is int)
          ? createResponse['amount'] as int
          : int.tryParse(createResponse['amount']?.toString() ?? "0") ?? 0;
      apiKeyId = createResponse['keyId'] ??
          createResponse['key'] ??
          dotenv.env['RAZORPAY_KEY_ID'] ??
          "";

      if (apiRazorpayOrderId.isEmpty || apiAmount == 0 || apiKeyId.isEmpty) {
        appToast(
            error: true, content: AppStrings.invalid_payment_data_from_serv);

        return;
      }

      _openCheckout(
          razorpayOrderId: apiRazorpayOrderId,
          amount: apiAmount,
          keyId: apiKeyId);
    } catch (e) {
      appToast(error: true, content: AppStrings.could_not_start_payment);
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

      razorpay.open(options);
    } catch (e) {
      appToast(error: true, content: AppStrings.could_not_open_payment_window);
    }
  }

  // -------------------- CALLBACKS ----------------------
  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    appToast(content: "Payment Success: ${response.paymentId}");

    final paymentData = RazorpayPaymentResponse(
      orderId: response.orderId ?? "",
      paymentId: response.paymentId ?? "",
      signature: response.signature ?? "",
    );

    await _finalizeCombinedPayment(paymentData);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    appToast(error: true, content: AppStrings.pending_payment_failed);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
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

      final response = await PendingTransactionService.payDailySelected(body);

      if (Get.isDialogOpen ?? false) Get.back();

      if (response != null &&
          (response['success'] == true || response['status'] == 'success')) {
        final pendingController = Get.find<PendingTransactionController>();
        pendingController.removePaidOrders(selectedOrders);

        appToast(content: AppStrings.payment_processed_successfully);

        Get.to(() => PendingPaymentConfirmationScreen());
      }
    } catch (e) {
      if (Get.isDialogOpen ?? false) Get.back();
      appToast(error: true, content: AppStrings.payment_verification_error);
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
