// ignore_for_file: avoid_print

import 'dart:developer';

import 'package:get/get.dart';
import '../../models/wallet_response.dart' hide WalletTransaction;
import '../../models/wallet_transcation_model.dart';
import '/services/wallet_service.dart';

class MyWalletController extends GetxController {
  final WalletService serviceData = WalletService();

  var transactions = <WalletTransaction>[].obs;
  var summary = Rxn<WalletSummary>();
  var wallet = Rxn<WalletmModels>();
  var isLoading = true.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    fetchWallet();
    fetchWalletTransactions();
    super.onInit();
  }

  Future<void> fetchWallet({bool forceRefresh = false}) async {
    try {
      //  Avoid unnecessary API calls
      if (!forceRefresh && wallet.value != null) {
        log("Wallet data already available. Skipping API call.");
        return;
      }
      log("Calling wallet api");
      isLoading.value = true;
      errorMessage.value = '';

      final data = await serviceData.fetchWallet();

      if (data == null) {
        errorMessage.value = 'Unable to load wallet data';
        log("Wallet API returned null response");
        return;
      }

      wallet.value = data;

      // 🔍 Debug logs
      log("Wallet API Parsed Response: $data");
      log("Wallet Balance: ${data.walletBalance}");
      log("Total Earnings: ${data.totalEarnings}");
      log("Transactions Count: ${data.transactions.length}");
    } catch (e, s) {
      errorMessage.value = 'Something went wrong while fetching wallet';
      log("Wallet API Exception: $e");
      log("StackTrace: $s");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchWalletTransactions() async {
    try {
      isLoading(true);
      errorMessage("");

      print("🔄 Fetching wallet transactions...");

      final response = await serviceData.fetchTransactions();

      if (response == null || !response.success) {
        errorMessage("Failed to load transactions");
        return;
      }

      transactions.assignAll(response.transactions);
      summary.value = response.summary;

      print("✅ Loaded transactions: ${transactions.length}");
    } catch (e) {
      errorMessage("Something went wrong: $e");
      print("❌ Wallet transaction error: $e");
    } finally {
      isLoading(false);
    }
  }
}
