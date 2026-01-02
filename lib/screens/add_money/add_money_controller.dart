

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saoirse_app/screens/razorpay/razorpay_wallet_controller.dart';

import '../../services/payment_service.dart';
import '../../widgets/app_toast.dart';

class AddMoneyController extends GetxController {
  final TextEditingController amountController = TextEditingController();
  var showSuffix = false.obs;

  void onAmountChanged(String value) {
    showSuffix.value = value.isNotEmpty;
  }

  bool validateAmount() {
    String raw = amountController.text.replaceAll(".00", "");

    if (raw.isEmpty || raw == "0") {
      appToast(title: "Error", content: "Please enter an amount", error: true);
      return false;
    }

    return true;
  }

  void addMoney() async {
  if (!validateAmount()) return;

  try {
    final rawText = amountController.text.trim();
    final enteredAmount = double.tryParse(rawText) ?? 0;

    // final amountInPaise = (enteredAmount * 100).round();

    final body = {
      "amount": enteredAmount,
    };

    appToast(
      title: "Processing",
      content: "Sending ₹${enteredAmount.toStringAsFixed(2)}",
    );

    /// API CALL
    final order = await PaymentService.addMoney(body);

    /// NULL response validation
    if (order == null) {
      appToast(
        title: "Error",
        content: "Unable to create order. Please try again.",
        error: true,
      );
      return;
    }

    /// SUCCESS validation
    if (!order.success) {
      appToast(
        title: "Failed",
        content: "Server could not process your request.",
        error: true,
      );
      return;
    }

    /// MISSING FIELDS validation
    if (order.orderId.isEmpty ||
        order.transactionId.isEmpty ||
        order.amount == 0) {
      appToast(
        title: "Error",
        content: "Invalid order details received. Please retry.",
        error: true,
      );
      return;
    }

    /// Start Razorpay Payment
    final razorWallet = Get.put(RazorpayWalletController());
    razorWallet.startWalletPayment(
      internalOrderId: order.transactionId,
      rpOrderId: order.orderId,
      amount: order.amount,
    );
  } catch (e) {
    /// Catch unexpected exceptions


    appToast(
      title: "Error",
      content: "Unexpected error occurred. Please try again.",
      error: true,
    );
  }
}


  @override
  void onClose() {
    amountController.dispose();
    super.onClose();
  }
}
