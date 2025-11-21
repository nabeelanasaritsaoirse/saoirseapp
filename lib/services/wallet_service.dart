import 'dart:developer';
import '/constants/app_constant.dart';
import '/constants/app_urls.dart';
import '/main.dart';
import '/models/WalletResponse.dart';
import '/services/api_service.dart';

class WalletService {
  Future<WalletmModels?> fetchWallet() async {
    try {
      final url = AppURLs.Wallet;
      final token = storage.read(AppConst.ACCESS_TOKEN);
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
}
