import '../models/wallet_transcation_model.dart';
import '/constants/app_constant.dart';
import '/constants/app_urls.dart';
import '/main.dart';
import '../models/wallet_response.dart';
import '/services/api_service.dart';

class WalletService {
  final token = storage.read(AppConst.ACCESS_TOKEN);
  Future<WalletModels?> fetchWallet() async {
    try {
      final url = AppURLs.Wallet;

      if (token == null || token.isEmpty) {
        return null;
      }

      return await APIService.getRequest<WalletModels>(
        url: url,
        headers: {
          'Authorization': 'Bearer $token', // FIXED
          'Content-Type': 'application/json',
        },
        onSuccess: (json) {
          return WalletModels.fromJson(json);
        },
      );
    } catch (e) {
      return null;
    }
  }

  Future<WalletTransactionsResponse?> fetchTransactions() async {
    final url = AppURLs.WALLET_TRANSACTIONS;

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
