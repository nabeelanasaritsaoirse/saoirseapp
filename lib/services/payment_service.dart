

import 'package:saoirse_app/models/add_money_order_model.dart';

import '../constants/app_urls.dart';
import '../services/api_service.dart';
import '../main.dart';
import '../constants/app_constant.dart';

class PaymentService {
  static Future<Map<String, dynamic>?> processPayment(
      Map<String, dynamic> body) async {
    try {
      final token = await storage.read(AppConst.ACCESS_TOKEN);



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
 
      return null;
    }
  }

  // For add money For Wallet
 static Future<AddMoneyOrderModel?> addMoney(Map<String, dynamic> body) async {
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

    if (response == null) return null;

    return AddMoneyOrderModel.fromJson(response);

  } catch (e) {
  
    return null;
  }
}


// STEP 2: Verify Wallet Add Money Payment
  static Future<Map<String, dynamic>?> verifyWalletPayment(
      Map<String, dynamic> body) async {
    try {
      final token = await storage.read(AppConst.ACCESS_TOKEN);

      return await APIService.postRequest<Map<String, dynamic>>(
        url: "https://api.epielio.com/api/wallet/verify-payment",
        body: body,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        onSuccess: (data) => data,
      );
    } catch (e) {
    
      return null;
    }
  }
}
