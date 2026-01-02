import 'dart:developer';

import '../constants/app_constant.dart';
import '../constants/app_urls.dart';
import '../main.dart';
import '../services/api_service.dart';

class OrderService {
  static Future<Map<String, dynamic>?> createOrder(
      Map<String, dynamic> body) async {
    final token = await storage.read(AppConst.ACCESS_TOKEN);

    log(" Access Token = $token"); // <--- PRINT HERE

    return await APIService.postRequest<Map<String, dynamic>>(
      url: AppURLs.CREATE_ORDER_API,
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
