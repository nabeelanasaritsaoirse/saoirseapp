import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saoirse_app/screens/my_wallet/my_wallet.dart';
import 'package:saoirse_app/services/withdrawal_service.dart';
import '../../widgets/app_toast.dart';

class WithdrawController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController accController = TextEditingController();
  TextEditingController confirmAccController = TextEditingController();
  TextEditingController ifscController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  var isLoading = false.obs;
  var showSuffix = false.obs;

  Future<void> submitWithdrawal() async {
    try {
      isLoading.value = true;

      final body = {
        "amount": int.tryParse(amountController.text) ?? 0,
        "paymentMethod": "bank_transfer",
        "bankName": "HDFC Bank",
        "accountNumber": accController.text.trim(),
        "ifscCode": ifscController.text.trim(),
        "accountHolderName": nameController.text.trim(),
      };

      final res = await WithdrawalService.submitWithdrawal(body);

      isLoading.value = false;

      if (res != null) {
        appToast(title: "Success", content: "Withdrawal request submitted successfully!");
        Get.off(WalletScreen());
      } else {
        appToast(title: "Error", content: "Something went wrong");
      }
    } catch (e) {
      isLoading.value = false;
      appToast(title: "Error", content: e.toString());
    }
  }

  void onAmountChanged(String value) {
    showSuffix.value = value.isNotEmpty;
  }

  @override
  void onClose() {
    nameController.dispose();
    accController.dispose();
    confirmAccController.dispose();
    ifscController.dispose();
    amountController.dispose();
    super.onClose();
  }
}
