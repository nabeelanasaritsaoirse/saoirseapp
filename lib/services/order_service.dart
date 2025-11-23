import 'dart:developer';

import '../constants/app_constant.dart';
import '../main.dart';
import '../services/api_service.dart';

class OrderService {
  static const String ordersUrl = "https://api.epielio.com/api/orders";

  static Future<Map<String, dynamic>?> createOrder(
      Map<String, dynamic> body) async {
    final token = await storage.read(AppConst.ACCESS_TOKEN);

    log("🔐 Access Token = $token"); // <--- PRINT HERE

    return await APIService.postRequest<Map<String, dynamic>>(
      url: ordersUrl,
      body: body,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      onSuccess: (data) {
        return data;
      },
    );
  }
}
