import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../constants/app_constant.dart';
import '../../main.dart';
import '../../models/wallet_transcation_model.dart';
import '/services/wallet_service.dart';

import '../../models/wallet_response.dart' hide WalletTransaction;

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
    _waitForTokenAndLoad();
  }

  Future<void> _waitForTokenAndLoad() async {
    while (true) {
      final token = storage.read(AppConst.ACCESS_TOKEN);

      if (token != null && token.isNotEmpty) {
        debugPrint("🟢 Token detected → loading wallet");
        await fetchWallet();
        await fetchWalletTransactions();
        break;
      }

      debugPrint("⏳ Waiting for token...");
      await Future.delayed(const Duration(milliseconds: 500));
    }
  }

  Future<void> refreshAll() async {
    errorMessage.value = '';
    isLoading.value = true;

    try {
      await fetchWallet(forceRefresh: true);
      await fetchWalletTransactions();
    } catch (e) {
      errorMessage.value = "Failed to refresh wallet";
    } finally {
      isLoading.value = false;
    }
  }

  /// -------------------- WALLET API --------------------
  Future<void> fetchWallet({bool forceRefresh = false}) async {
    try {
      // Avoid unnecessary API calls
      if (!forceRefresh && wallet.value != null) {
        return;
      }

      _startLoading();
      errorMessage.value = '';

      final data = await serviceData.fetchWallet();

      if (data == null) {
        errorMessage.value = 'Unable to load wallet data';

        return;
      }

      wallet.value = data;

      // Debug logs
    } catch (e) {
      errorMessage.value = 'Something went wrong while fetching wallet';
    } finally {
      _stopLoading();
    }
  }

  /// -------------------- WALLET TRANSACTIONS --------------------
  Future<void> fetchWalletTransactions() async {
    try {
      debugPrint("📡 fetchWalletTransactions() called");
      _startLoading();
      errorMessage.value = '';

      final response = await serviceData.fetchTransactions();
      debugPrint("📥 API response received: ${response != null}");
      if (response == null) {
        debugPrint("❌ Response is NULL");
        errorMessage.value = 'Failed to load transactions';
        return;
      }

      debugPrint("✅ API success flag: ${response.success}");
      debugPrint(
          "📊 Transactions count from API: ${response.transactions.length}");

      if (response.success != true) {
        errorMessage.value = 'Failed to load transactions';
        return;
      }

      transactions.assignAll(response.transactions);
      summary.value = response.summary;
      debugPrint(
          "🎉 Transactions updated in controller: ${transactions.length}");
    } catch (e) {
      errorMessage.value = 'Something went wrong while fetching transactions';
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
