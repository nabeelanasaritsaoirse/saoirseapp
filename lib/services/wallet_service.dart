// ignore_for_file: avoid_print

import 'dart:developer';

import '../models/wallet_transcation_model.dart';
import '/constants/app_constant.dart';
import '/constants/app_urls.dart';
import '/main.dart';
import '../models/wallet_response.dart';
import '/services/api_service.dart';

class WalletService {
  final token = storage.read(AppConst.ACCESS_TOKEN);
  Future<WalletmModels?> fetchWallet() async {
    try {
      final url = AppURLs.Wallet;

      log(" Calling Wallet API → $url");
      log("Token → $token");

      if (token == null || token.isEmpty) {
        log("No access token found in storage");
        return null;
      }

      log(" Calling Wallet API → $url");

      return await APIService.getRequest<WalletmModels>(
        url: url,
        headers: {
          'Authorization': 'Bearer $token', // FIXED
          'Content-Type': 'application/json',
        },
        onSuccess: (json) {
          log(" Wallet API Response: $json");
          return WalletmModels.fromJson(json);
        },
      );
    } catch (e) {
      log(" Wallet API Exception: $e");

      return null;
    }
  }

  Future<WalletTransactionsResponse?> fetchTransactions() async {
    final url = AppURLs.WALLET_TRANSACTIONS;

    print("📡 Fetching wallet transactions: $url");

    final response = await APIService.getRequest(
      url: url,
      headers: {
        "Authorization": "Bearer $token",
      },
      onSuccess: (data) => data,
    );

    if (response == null) return null;

    return WalletTransactionsResponse.fromJson(response);
  }
}
