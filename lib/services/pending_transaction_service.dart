

import '../constants/app_constant.dart';
import '../constants/app_urls.dart';
import '../main.dart';
import '../services/api_service.dart';
import '../models/pending_transaction_model.dart';

class PendingTransactionService {
  Future<String?> _token() async => storage.read(AppConst.ACCESS_TOKEN);

  //--------------Pending Transaticon Data Fletching--------------------//

  Future<PendingTransactionResponse?> fetchPendingTransactions() async {
    final String url = AppURLs.PENDING_TRANSACTIONS_API;
    final token = await _token();

    return APIService.getRequest<PendingTransactionResponse>(
      url: url,
      headers: {"Authorization": "Bearer $token"},
      onSuccess: (json) => PendingTransactionResponse.fromJson(json),
    );
  }

  // ------------------ CREATE COMBINED RAZORPAY ORDER --------------------
  Future<Map<String, dynamic>?> createCombinedRazorpayOrder(
      List<String> orderIds) async {
    final token = await _token();
    final String url = AppURLs.PENDING_TRANSACTION_PAYMENT_RESPONSE;

    return APIService.postRequest<Map<String, dynamic>>(
      url: url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: {
        "selectedOrders": orderIds,
      },
      onSuccess: (json) {
        return json; // return full JSON
      },
    );
  }




  //-------------------------------------DAILY INSTALLMENT PAYMENT FUNCTION AFTER PAYMENT PROCESS----------------------------------------------//
  static Future<Map<String, dynamic>?> payDailySelected(
      Map<String, dynamic> body) async {
    try {
      final token = await storage.read(AppConst.ACCESS_TOKEN);

      final url = AppURLs.PENDING_TRANSACTION_PAY_DAILY_SELECTED;

      final response = await APIService.postRequest<Map<String, dynamic>>(
        url: url,
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

  
}
