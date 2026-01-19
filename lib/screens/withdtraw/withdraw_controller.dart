import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/withdrawal_service.dart';
import '../../widgets/app_toast.dart';
import '../../widgets/warning_dialog.dart';
import '../my_wallet/my_wallet.dart';

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
        appToast(
            title: "Success",
            content: "Withdrawal request submitted successfully!");
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

  Future<bool> checkWithdrawalEligibility() async {
    try {
      debugPrint("🔵 [KYC] Checking withdrawal eligibility...");
      isLoading.value = true;

      final response = await WithdrawalService.getKycWithdrawalStatus();

      debugPrint("🟡 [KYC] API response received: $response");

      if (response == null) {
        debugPrint("🔴 [KYC] Response is NULL");
        return false;
      }

      debugPrint(
        "🟢 [KYC] isEligibleForWithdrawal: ${response.isEligibleForWithdrawal}",
      );

      if (response.isEligibleForWithdrawal) {
        debugPrint("✅ [KYC] User is eligible for withdrawal");
        return true;
      }

      debugPrint("⚠️ [KYC] User NOT eligible → Showing KYC dialog");
      KycRequiredDialog.show();

      return false;
    } catch (e, stack) {
      debugPrint("❌ [KYC] Exception occurred: $e");
      debugPrint("📌 StackTrace: $stack");

      appToast(
        title: "Error",
        content: "Failed to verify KYC status",
      );
      return false;
    } finally {
      isLoading.value = false;
      debugPrint("🔵 [KYC] Loading finished");
    }
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
