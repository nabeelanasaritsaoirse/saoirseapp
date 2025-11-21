import 'dart:developer';

import 'package:get/get.dart';
import '/models/WalletResponse.dart';
import '/services/wallet_service.dart';

class MyWalletController extends GetxController {
  final WalletService serviceData = WalletService();

  var wallet = Rxn<WalletmModels>();
  var isLoading = true.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    fetchWallet();
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

}
