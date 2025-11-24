import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:saoirse_app/models/order_history_model.dart';
import 'package:saoirse_app/services/order_history_service.dart';

class OrderDeliveredController extends GetxController {
  final OrderHistoryService service = OrderHistoryService();

  RxBool isLoading = false.obs;
  RxList<OrderHistoryItem> orders = <OrderHistoryItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllDeliveredOrders();
  }

  //----------FETCH ALL DELIVERED ORDERS----------------//

  Future<void> fetchAllDeliveredOrders() async {
    try {
         isLoading.value = true;
      final response = await service.fetchDeliveredOrders();
      
      if (response != null && response.success) {
        orders.value = response.orders;
      }
    } catch (e) {
      debugPrint("Error in fetching delivered orders: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
