import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saoirse_app/constants/app_strings.dart';

import '../../services/payment_service.dart';
import '../../widgets/app_toast.dart';
import '../razorpay/razorpay_wallet_controller.dart';

class AddMoneyController extends GetxController {
  final TextEditingController amountController = TextEditingController();
  var showSuffix = false.obs;
  RxBool isAddingMoney = false.obs;
  void onAmountChanged(String value) {
    showSuffix.value = value.isNotEmpty;
  }

  bool validateAmount() {
    String raw = amountController.text.replaceAll(".00", "");

    if (raw.isEmpty || raw == "0") {
      appToast(
          title: AppStrings.error,
          content: AppStrings.please_enter_an_amount,
          error: true);
      return false;
    }

    return true;
  }

  void addMoney() async {
    // 🔒 PREVENT MULTIPLE TAPS
    if (isAddingMoney.value) {
      debugPrint("⛔ [ADD MONEY] Already in progress, ignored");
      return;
    }

    if (!validateAmount()) return;

    isAddingMoney.value = true;
    debugPrint("🔒 [ADD MONEY] LOCKED");

    try {
      final rawText = amountController.text.trim();
      final enteredAmount = double.tryParse(rawText) ?? 0;

      final body = {
        "amount": enteredAmount,
      };

      appToast(
        title: AppStrings.processing,
        content: "Sending ₹${enteredAmount.toStringAsFixed(2)}",
      );

      /// API CALL
      final order = await PaymentService.addMoney(body);

      if (order == null || !order.success) {
        appToast(
          title: AppStrings.error,
          content: AppStrings.unable_to_create_order_please,
          error: true,
        );
        return;
      }

      if (order.orderId.isEmpty ||
          order.transactionId.isEmpty ||
          order.amount == 0) {
        appToast(
          title: AppStrings.error,
          content: AppStrings.invalid_order_details_received,
          error: true,
        );
        return;
      }

      /// ✅ OPEN RAZORPAY ONCE
      final razorWallet = Get.put(
        RazorpayWalletController(),
        permanent: true,
      );

      razorWallet.startWalletPayment(
        internalOrderId: order.transactionId,
        rpOrderId: order.orderId,
        amount: order.amount,
      );
    } catch (e, stack) {
      debugPrint("❌ [ADD MONEY] Error: $e");
      debugPrint("📌 StackTrace: $stack");

      appToast(
        title: AppStrings.error,
        content: AppStrings.unexpected_error_occurred_plea,
        error: true,
      );
    } finally {
      // ❗ DO NOT UNLOCK HERE
      // Unlock ONLY after Razorpay success / failure
      debugPrint("🟡 [ADD MONEY] Waiting for Razorpay callback");
    }
  }

  @override
  void onClose() {
    amountController.dispose();
    super.onClose();
  }
}
