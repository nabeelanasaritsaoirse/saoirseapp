import 'dart:developer';
import '../constants/app_constant.dart';
import '../constants/app_urls.dart';
import '../main.dart';
import '../services/api_service.dart';

class WithdrawalService {
  /// Submit Withdrawal Request
  static Future<Map<String, dynamic>?> submitWithdrawal(
      Map<String, dynamic> body) async {
    try {
      final token = await storage.read(AppConst.ACCESS_TOKEN);

      log("🔐 Token: $token");
      log("📤 Withdrawal Body: $body");

      return await APIService.postRequest<Map<String, dynamic>>(
        url: AppURLs.WITHDRAWAL_API,
        body: body,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        onSuccess: (data) {
          log("✔️ Withdrawal Success Response: $data");
          return data;
        },
      );
    } catch (e) {
      log("❌ Withdrawal API Error: $e");
      return null; 
    }
  }
}
