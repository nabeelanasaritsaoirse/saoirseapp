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


  // For add money For Wallet 
  static Future<Map<String, dynamic>?> addMoney(Map<String, dynamic> body) async {
  try {
    final token = await storage.read(AppConst.ACCESS_TOKEN);

    final response = await APIService.postRequest<Map<String, dynamic>>(
      url: AppURLs.ADD_MONEY_WALLET,
      body: body,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      onSuccess: (data) => data,
    );

    return response;
  } catch (e) {
    log("Add Money Error: $e");
    return null;
  }
}


// STEP 2: Verify Wallet Add Money Payment
static Future<Map<String, dynamic>?> verifyWalletPayment(Map<String, dynamic> body) async {
  try {
    final token = await storage.read(AppConst.ACCESS_TOKEN);

    return await APIService.postRequest<Map<String, dynamic>>(
      url: "",
      body: body,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      onSuccess: (data) => data,
    );
  } catch (e) {
    log("Wallet Verify Payment Error: $e");
    return null;
  }
}

}
