import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saoirse_app/constants/app_strings.dart';

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
  TextEditingController bankNameController = TextEditingController();

  var isLoading = false.obs;
  var showSuffix = false.obs;

  var canWithdraw = true.obs;
  var withdrawalMessage = ''.obs;
  var isCheckingStatus = false.obs;

  Future<void> submitWithdrawal() async {
    try {
      isLoading.value = true;

      final body = {
        "amount": int.tryParse(amountController.text) ?? 0,
        "paymentMethod": "bank_transfer",
        "bankName": bankNameController.text.trim(),
        "accountNumber": accController.text.trim(),
        "ifscCode": ifscController.text.trim(),
        "accountHolderName": nameController.text.trim(),
      };
      debugPrint("📤 Withdrawal Request Body: $body");

      /// 🔹 GETX LOG
      final res = await WithdrawalService.submitWithdrawal(body);

      isLoading.value = false;

      if (res != null) {
        appToaster(content: AppStrings.withdrawal_request_submitted_s);
        Get.off(WalletScreen());
      } else {
        appToast(
            title: AppStrings.error,
            content: AppStrings.something_went_wrong_1);
      }
    } catch (e) {
      isLoading.value = false;
      appToast(title: AppStrings.error, content: e.toString());
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
        title: AppStrings.error,
        content: AppStrings.failed_to_verify_kyc_status,
      );
      return false;
    } finally {
      isLoading.value = false;
      debugPrint("🔵 [KYC] Loading finished");
    }
  }

  Future<void> fetchWithdrawalStatus() async {
    try {
      isCheckingStatus.value = true;

      final response = await WithdrawalService.getWalletWithdrawalStatus();

      if (response != null) {
        canWithdraw.value = response.canWithdraw;
        withdrawalMessage.value = response.message;
      }
    } catch (e) {
      debugPrint("❌ Withdrawal status error: $e");
    } finally {
      isCheckingStatus.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    bankNameController.dispose();
    accController.dispose();
    confirmAccController.dispose();
    ifscController.dispose();
    amountController.dispose();
    super.onClose();
  }
}
