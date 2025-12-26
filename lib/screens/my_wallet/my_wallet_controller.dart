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
  var wallet = Rxn<WalletModels>();

  /// Shared loader (kept because UI already uses it)
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  /// Internal counters to avoid loader flicker
  int _apiCallCount = 0;

  @override
  void onInit() {
    super.onInit();
    fetchWallet();
    fetchWalletTransactions();
  }


  Future<void> refreshAll() async {
  if (isLoading.value) return; // prevent double refresh

  try {
    isLoading.value = true;
    errorMessage.value = '';

    await Future.wait([
      fetchWallet(forceRefresh: true),
      fetchWalletTransactions(),
    ]);

    log("✅ Wallet refreshed successfully");
  } catch (e, s) {
    errorMessage.value = "Failed to refresh wallet";
    log("❌ Wallet refresh error: $e");
    log("StackTrace: $s");
  } finally {
    isLoading.value = false;
  }
}


  /// -------------------- WALLET API --------------------
  Future<void> fetchWallet({bool forceRefresh = false}) async {
    try {
      // Avoid unnecessary API calls
      if (!forceRefresh && wallet.value != null) {
        log("✅ Wallet already available. Skipping API call.");
        return;
      }

      _startLoading();
      errorMessage.value = '';

      log("📡 Calling wallet API");

      final data = await serviceData.fetchWallet();

      if (data == null) {
        errorMessage.value = 'Unable to load wallet data';
        log("❌ Wallet API returned null");
        return;
      }

      wallet.value = data;

      // Debug logs
      log("✅ Wallet API Parsed Successfully");
      log("Wallet Balance: ${data.walletBalance}");
      log("Total Earnings: ${data.totalEarnings}");
      log("Transactions Count: ${data.transactions?.length ?? 0}");
    } catch (e, s) {
      errorMessage.value = 'Something went wrong while fetching wallet';
      log("❌ Wallet API Exception: $e");
      log("StackTrace: $s");
    } finally {
      _stopLoading();
    }
  }

  /// -------------------- WALLET TRANSACTIONS --------------------
  Future<void> fetchWalletTransactions() async {
    try {
      _startLoading();
      errorMessage.value = '';

      log("📡 Fetching wallet transactions...");

      final response = await serviceData.fetchTransactions();

      if (response == null || response.success != true) {
        errorMessage.value = 'Failed to load transactions';
        log("❌ Transactions API failed");
        return;
      }

      transactions.assignAll(response.transactions);
      summary.value = response.summary;

      log("✅ Transactions loaded: ${transactions.length}");
    } catch (e, s) {
      errorMessage.value = 'Something went wrong while fetching transactions';
      log("❌ Wallet transaction error: $e");
      log("StackTrace: $s");
    } finally {
      _stopLoading();
    }
  }

  /// -------------------- LOADING HANDLER --------------------
  void _startLoading() {
    _apiCallCount++;
    isLoading.value = true;
  }

  void _stopLoading() {
    _apiCallCount--;
    if (_apiCallCount <= 0) {
      _apiCallCount = 0;
      isLoading.value = false;
    }
  }
}





