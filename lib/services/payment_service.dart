import 'dart:developer';

import '../constants/app_urls.dart';
import '../services/api_service.dart';
import '../main.dart';
import '../constants/app_constant.dart';

class PaymentService {
  static Future<Map<String, dynamic>?> processPayment(
      Map<String, dynamic> body) async {
    try {
      final token = await storage.read(AppConst.ACCESS_TOKEN);

      log("Processing Payment => $body");

      final response = await APIService.postRequest<Map<String, dynamic>>(
        url: AppURLs.PAYMENT_PROCESS_API,
        body: body,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        onSuccess: (data) => data,
      );

      return response;
    } catch (e) {
      log("Payment Process Error: $e");
      return null;
    }
  }
}
