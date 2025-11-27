import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saoirse_app/screens/razorpay/razorpay_wallet_controller.dart';
import 'package:saoirse_app/services/payment_service.dart';
import 'package:saoirse_app/widgets/app_snackbar.dart';

class AddMoneyController extends GetxController {
  final TextEditingController amountController = TextEditingController();
  var showSuffix = false.obs;

  void onAmountChanged(String value) {
    showSuffix.value = value.isNotEmpty;
  }



  bool validateAmount() {
    String raw = amountController.text.replaceAll(".00", "");

    if (raw.isEmpty || raw == "0") {
      appSnackbar(
          title: "Error", content: "Please enter an amount", error: true);
      return false;
    }

    return true;
  }

 void addMoney() async {
  if (!validateAmount()) return;

  final rawText = amountController.text.trim();

 
  final enteredAmount = double.tryParse(rawText) ?? 0;


  final amountInPaise = (enteredAmount * 100).round();


  final body = {
    "amount": amountInPaise,
  };

  appSnackbar(
    title: "Processing",
    content: "Sending ₹${enteredAmount.toStringAsFixed(2)}",
  );

  final response = await PaymentService.addMoney(body);

  if (response != null) {
    appSnackbar(title: "Success", content: "Order Created Successfully!");
  } else {
    appSnackbar(title: "Error", content: "Something went wrong!", error: true);
  }


  final razorWallet = Get.put(RazorpayWalletController());

// razorWallet.startWalletPayment(
//   internalOrderId: response["orderId"],
//   rpOrderId: response["razorpayOrderId"],
//   amount: response["amount"],
// );
}


  @override
  void onClose() {
    amountController.dispose();
    super.onClose();
  }
}
