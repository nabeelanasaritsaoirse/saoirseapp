import 'package:get_storage/get_storage.dart';
import 'package:saoirse_app/models/wallet_withdrawal_response.dart';

import '../constants/app_constant.dart';
import '../constants/app_urls.dart';
import '../main.dart';
import '../models/kyc_status_response.dart';
import '../services/api_service.dart';

class WithdrawalService {
  /// Submit Withdrawal Request
  static Future<Map<String, dynamic>?> submitWithdrawal(
      Map<String, dynamic> body) async {
    try {
      final token = await storage.read(AppConst.ACCESS_TOKEN);

      return await APIService.postRequest<Map<String, dynamic>>(
        url: AppURLs.WITHDRAWAL_API,
        body: body,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        onSuccess: (data) {
          return data;
        },
      );
    } catch (e) {
      return null;
    }
  }

  static Future<KycWithdrawalStatusResponse?> getKycWithdrawalStatus() async {
    final token = GetStorage().read(AppConst.ACCESS_TOKEN);
    final userId = GetStorage().read(AppConst.USER_ID);

    final url = "${AppURLs.BASE_API}api/users/$userId/kyc-withdrawal-status";

    final res = await APIService.getRequest(
      url: url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      onSuccess: (json) {
        return KycWithdrawalStatusResponse.fromJson(json);
      },
    );
    return res;
  }


  static Future<WalletWithdrawalStatusResponse?> 
    getWalletWithdrawalStatus() async {
  try {
    final token = GetStorage().read(AppConst.ACCESS_TOKEN);
    final url = AppURLs.WITHDRAWAL_STATUS_API;

    final res = await APIService.getRequest(
      url: url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      onSuccess: (json) {
        return WalletWithdrawalStatusResponse.fromJson(json);
      },
    );

    return res;
  } catch (e) {
    return null;
  }
}

}
