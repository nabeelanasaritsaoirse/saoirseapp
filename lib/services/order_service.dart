import '../constants/app_constant.dart';
import '../constants/app_urls.dart';
import '../main.dart';
import '../models/enable_autopay_response.dart';
import '../services/api_service.dart';

class OrderService {
  static Future<Map<String, dynamic>?> createOrder(
      Map<String, dynamic> body) async {
    final token = await storage.read(AppConst.ACCESS_TOKEN);

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
  // ---------------- ENABLE AUTOPAY ----------------

  static Future<EnableAutoPayResponse?> enableAutoPay({
    required String orderId,
  }) async {
    try {
      final token = await storage.read(AppConst.ACCESS_TOKEN);
      final response = await APIService.postRequest(
        url: "${AppURLs.ENABLE_AUTOPAY}/$orderId",
        body: {
          "priority": 1,
        },
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        onSuccess: (json) => json,
      );

      if (response != null) {
        return EnableAutoPayResponse.fromJson(response);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // ---------------- CREATE BULK ORDER ----------------
  static Future<Map<String, dynamic>?> createBulkOrder(
      Map<String, dynamic> body) async {
    try {
      final token = await storage.read(AppConst.ACCESS_TOKEN);

      return await APIService.postRequest<Map<String, dynamic>>(
        url: AppURLs.CREATE_BULK_ORDER_API,
        body: body,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        onSuccess: (data) {
          return data;
        },
      );
    } catch (e) {
      return null;
    }
  }

  // ---------------- ORDER PREVIEW (INSTALLMENT) ----------------

static Future<Map<String, dynamic>?> previewInstallmentOrder(
    Map<String, dynamic> body) async {
  try {
    final token = await storage.read(AppConst.ACCESS_TOKEN);

    return await APIService.postRequest<Map<String, dynamic>>(
      url: AppURLs.INSTALLMENT_ORDER_PREVIEW_API,
      body: body,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      onSuccess: (data) {
        return data;
      },
    );
  } catch (e) {
    return null;
  }
}

// ---------------- BULK ORDER PREVIEW ----------------

static Future<Map<String, dynamic>?> bulkOrderPreview(
    Map<String, dynamic> body,
) async {
  try {
    final token = await storage.read(AppConst.ACCESS_TOKEN);

    return await APIService.postRequest<Map<String, dynamic>>(
      url: AppURLs.BULK_ORDER_PREVIEW, 
      body: body,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      onSuccess: (data) {
        return data;
      },
    );
  } catch (e) {
    return null;
  }
}


}
