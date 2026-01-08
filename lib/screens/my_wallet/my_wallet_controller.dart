import 'package:get/get.dart';

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
      _startLoading();
      errorMessage.value = '';

      final response = await serviceData.fetchTransactions();

      if (response == null || response.success != true) {
        errorMessage.value = 'Failed to load transactions';
        return;
      }

      transactions.assignAll(response.transactions);
      summary.value = response.summary;
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
