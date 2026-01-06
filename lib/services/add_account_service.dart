import 'package:get_storage/get_storage.dart';
import 'package:saoirse_app/constants/app_urls.dart';
import 'package:saoirse_app/services/api_service.dart';

import '../constants/app_constant.dart';
import '../models/bank_account_model.dart';

class BankAccountService {
  static String get _token => GetStorage().read(AppConst.ACCESS_TOKEN);
  static String get _userId => GetStorage().read(AppConst.USER_ID);

  static Future<BankAccountModel?> addBankAccount({
    required BankAccountModel account,
  }) async {
    final token = GetStorage().read(AppConst.ACCESS_TOKEN);
    final userId = GetStorage().read(AppConst.USER_ID);

    print("➕ POST add bank account");
    print("📦 Payload: ${account.toJson()}");

    final res = await APIService.postRequest(
      url: "${AppURLs.BASE_API}api/users/$userId/bank-details",
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: account.toJson(),
      onSuccess: (json) {
        print("🧾 RAW API JSON: $json");

        // ignore: unnecessary_type_check
        if (json is Map<String, dynamic>) {
          final data = json["bankDetails"];

          // ✅ CASE 1: bankDetails is LIST
          if (data is List && data.isNotEmpty) {
            print("✅ bankDetails is List");
            return BankAccountModel.fromJson(
              data.last as Map<String, dynamic>,
            );
          }

          // ✅ CASE 2: bankDetails is SINGLE OBJECT
          if (data is Map<String, dynamic>) {
            print("✅ bankDetails is Map");
            return BankAccountModel.fromJson(data);
          }
        }

        print("❌ Invalid API response format");
        return null;
      },
    );

    return res;
  }

  /// ================== GET ALL ACCOUNTS ==================
  static Future<List<BankAccountModel>> getBankAccounts() async {
    print("📡 GET bank accounts");

    final res = await APIService.getRequest(
      url: "${AppURLs.BASE_API}api/users/$_userId/bank-details",
      headers: {
        "Authorization": "Bearer $_token",
      },
      onSuccess: (json) {
        print("✅ Bank accounts fetched: ${json['bankDetails'].length}");
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
    print("✏️ PUT update bank account: $bankId");

    final res = await APIService.putRequest(
      url: "${AppURLs.BASE_API}api/users/$_userId/bank-details/$bankId",
      headers: {
        "Authorization": "Bearer $_token",
        "Content-Type": "application/json",
      },
      body: account.toJson(),
      onSuccess: (json) {
        print("✅ Bank account updated");
        return BankAccountModel.fromJson(json['bankDetails']);
      },
    );

    return res;
  }

  /// ================== DELETE ACCOUNT ==================
  static Future<bool> deleteBankAccount(String bankId) async {
    print("🗑 DELETE bank account: $bankId");

    final res = await APIService.deleteRequest(
      url: "${AppURLs.BASE_API}api/users/$_userId/bank-details/$bankId",
      headers: {
        "Authorization": "Bearer $_token",
      },
      onSuccess: (_) {
        print("✅ Bank account deleted");
        return true;
      },
    );

    return res ?? false;
  }
}
