import 'package:get_storage/get_storage.dart';

import '../constants/app_constant.dart';
import '../constants/app_urls.dart';
import '../models/bank_account_model.dart';
import 'api_service.dart';

class BankAccountService {
  static String get _token => GetStorage().read(AppConst.ACCESS_TOKEN);
  static String get _userId => GetStorage().read(AppConst.USER_ID);

  static Future<BankAccountModel?> addBankAccount({
    required BankAccountModel account,
  }) async {
    final token = GetStorage().read(AppConst.ACCESS_TOKEN);
    final userId = GetStorage().read(AppConst.USER_ID);

    final res = await APIService.postRequest(
      url: "${AppURLs.BASE_API}api/users/$userId/bank-details",
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: account.toJson(),
      onSuccess: (json) {
        // ignore: unnecessary_type_check
        if (json is Map<String, dynamic>) {
          final data = json["bankDetails"];

          // ✅ CASE 1: bankDetails is LIST
          if (data is List && data.isNotEmpty) {
            return BankAccountModel.fromJson(
              data.last as Map<String, dynamic>,
            );
          }

          // ✅ CASE 2: bankDetails is SINGLE OBJECT
          if (data is Map<String, dynamic>) {
            return BankAccountModel.fromJson(data);
          }
        }

        return null;
      },
    );

    return res;
  }

  /// ================== GET ALL ACCOUNTS ==================
  static Future<List<BankAccountModel>> getBankAccounts() async {
    final res = await APIService.getRequest(
      url: "${AppURLs.BASE_API}api/users/$_userId/bank-details",
      headers: {
        "Authorization": "Bearer $_token",
      },
      onSuccess: (json) {
        return (json['bankDetails'] as List)
            .map((e) => BankAccountModel.fromJson(e))
            .toList();
      },
    );

    return res ?? [];
  }

  /// ================== UPDATE ACCOUNT ==================
  static Future<BankAccountModel?> updateBankAccount({
    required String bankId,
    required BankAccountModel account,
  }) async {
    final res = await APIService.putRequest(
      url: "${AppURLs.BASE_API}api/users/$_userId/bank-details/$bankId",
      headers: {
        "Authorization": "Bearer $_token",
        "Content-Type": "application/json",
      },
      body: account.toJson(),
      onSuccess: (json) {
        return BankAccountModel.fromJson(json['bankDetails']);
      },
    );

    return res;
  }

  /// ================== DELETE ACCOUNT ==================
  static Future<bool> deleteBankAccount(String bankId) async {
    final res = await APIService.deleteRequest(
      url: "${AppURLs.BASE_API}api/users/$_userId/bank-details/$bankId",
      headers: {
        "Authorization": "Bearer $_token",
      },
      onSuccess: (_) {
        return true;
      },
    );

    return res ?? false;
  }
}
