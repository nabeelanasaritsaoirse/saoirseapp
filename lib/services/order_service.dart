import 'package:saoirse_app/constants/app_constant.dart';
import 'package:saoirse_app/main.dart';

import '../services/api_service.dart'; 

class OrderService {
  static const String ordersUrl = "https://api.epielio.com/api/orders";

  static Future<Map<String, dynamic>?> createOrder(Map<String, dynamic> body) async {
    final token = await storage.read(AppConst.ACCESS_TOKEN);
    return await APIService.postRequest<Map<String, dynamic>>(
      url: ordersUrl,
      body: body,
      headers: {"Authorization": "Bearer $token"},
      onSuccess: (data) {
        return data;  
      },
    );
  }
}
