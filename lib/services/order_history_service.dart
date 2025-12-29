import '../constants/app_urls.dart';
import '../main.dart';
import '../constants/app_constant.dart';
import '../models/order_history_model.dart';
import '../services/api_service.dart';

class OrderHistoryService {
  Future<String?> _token() async => storage.read(AppConst.ACCESS_TOKEN);

  //----------FETCH ALL ORDERS----------------//

  Future<OrderHistoryResponse?> fetchOrders({
    required int page,
    required int limit,
  }) async {
    final token = await _token();

    final url = "${AppURLs.ORDER_HISTORY_API}?status=ACTIVE&limit=$limit&page=$page";

    return APIService.getRequest<OrderHistoryResponse>(
      url: url,
      headers: {"Authorization": "Bearer $token"},
      onSuccess: (json) => OrderHistoryResponse.fromJson(json),
    );
  }

  //----------FETCH DELIVERED ORDERS----------------//

  Future<OrderHistoryResponse?> fetchDeliveredOrders({
    required int page,
    required int limit,
  }) async {
    final token = await _token();

    final url = "${AppURLs.ORDER_HISTORY_API}?status=COMPLETE&limit=$limit&page=$page";

    return APIService.getRequest<OrderHistoryResponse>(
      url: url,
      headers: {"Authorization": "Bearer $token"},
      onSuccess: (json) => OrderHistoryResponse.fromJson(json),
    );
  }
}
