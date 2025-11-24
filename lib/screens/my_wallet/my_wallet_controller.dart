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

  Future<void> fetchWallet() async {
    try {
      isLoading(true);
      errorMessage('');

      final data = await serviceData.fetchWallet();

      log(" Wallet API Parsed Response: $data");
      log(" Wallet Balance: ${data?.walletBalance}");
      log("Total Earnings: ${data?.totalEarnings}");
      log("Transactions: ${data?.transactions}");

      if (data == null) {
        errorMessage('Unable to load wallet data');
      } else {
        wallet.value = data;
      }
    } catch (e) {
      errorMessage('Something went wrong: $e');
    } finally {
      isLoading(false);
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
