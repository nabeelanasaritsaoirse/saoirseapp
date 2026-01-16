import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../models/bank_account_model.dart';
import '../../services/add_account_service.dart';
import '../../widgets/app_toast.dart';
import 'add_account.dart';

class SelectAccountController extends GetxController {
  /// FORM CONTROLLERS
  final nameController = TextEditingController();
  final accController = TextEditingController();
  final confirmAccController = TextEditingController();
  final ifscController = TextEditingController();
  final bankNameController = TextEditingController();
  final branchNameController = TextEditingController();
  final RxList<BankAccountModel> accountList = <BankAccountModel>[].obs;
  final RxInt selectedIndex = 0.obs;
  final RxBool isLoading = false.obs;
  final RxBool isEditMode = false.obs;
  Completer<void>? _saveAccountLock;

  int? editingIndex;
  @override
  void onInit() {
    super.onInit();
    fetchAccounts();
  }

  // ---------------- TOGGLE MODE
  void toggleEditMode() {
    isEditMode.toggle();
  }

  /// SELECT ACCOUNT
  void selectAccount(int index) {
    selectedIndex.value = index;
  }

  /// ================== FETCH ACCOUNTS ==================
  Future<void> fetchAccounts() async {
    try {
      isLoading.value = true;

      final accounts = await BankAccountService.getBankAccounts();
      accountList.assignAll(accounts);
    } catch (e) {
      appToast(title: "Error", content: "Failed to load accounts");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveAccount() async {
    if (_saveAccountLock != null) {
      debugPrint("⛔ saveAccount already running, ignored");
      return;
    }

    _saveAccountLock = Completer<void>();

    try {
      final account = BankAccountModel(
        id: editingIndex != null ? accountList[editingIndex!].id : null,
        accountHolderName: nameController.text.trim(),
        accountNumber: accController.text.trim(),
        ifscCode: ifscController.text.trim(),
        bankName: bankNameController.text.trim(),
        branchName: branchNameController.text.trim(),
        isDefault: false,
      );

      if (editingIndex != null) {
        final updated = await BankAccountService.updateBankAccount(
          bankId: account.id!,
          account: account,
        );

        if (updated != null) {
          accountList[editingIndex!] = updated;
          accountList.refresh();
        }

        editingIndex = null;
      } else {
        final created =
            await BankAccountService.addBankAccount(account: account);

        if (created != null) {
          accountList.add(created);
        }
      }

      clearForm();

      await fetchAccounts();

      Get.back();
    } catch (e) {
      appToast(title: "Error", content: "Failed to save account");
    } finally {
      _saveAccountLock?.complete();
      _saveAccountLock = null;
    }
  }

  // ---------------- EDIT
  void startEdit(int index) {
    final acc = accountList[index];
    editingIndex = index;

    nameController.text = acc.accountHolderName;
    accController.text = acc.accountNumber;
    confirmAccController.text = acc.accountNumber;
    ifscController.text = acc.ifscCode;
    bankNameController.text = acc.bankName!;
    branchNameController.text = acc.branchName!;
    Get.to(() => AddAccountScreen());
  }

  /// ---------------- DELETE (local for now)
  /// ================== DELETE ==================
  Future<void> deleteAccount(int index) async {
    try {
      isLoading.value = true;

      final bankId = accountList[index].id;

      final success = await BankAccountService.deleteBankAccount(bankId!);

      if (success) {
        accountList.removeAt(index);
        appToast(title: "Deleted", content: "Account deleted successfully");
      }
    } catch (e) {
      appToast(title: "Error", content: "Delete failed");
    } finally {
      isLoading.value = false;
    }
  }

  void clearForm() {
    nameController.clear();
    accController.clear();
    confirmAccController.clear();
    ifscController.clear();
    bankNameController.clear(); // ✅
    branchNameController.clear();
  }

  @override
  void onClose() {
    nameController.dispose();
    accController.dispose();
    confirmAccController.dispose();
    ifscController.dispose();
    bankNameController.dispose(); // ✅
    branchNameController.dispose();
    super.onClose();
  }
}
