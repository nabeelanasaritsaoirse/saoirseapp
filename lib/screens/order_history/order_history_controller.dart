import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/order_history_model.dart';
import '../../services/order_history_service.dart';

class OrderHistoryController extends GetxController {
  final OrderHistoryService service = OrderHistoryService();

  RxBool isLoading = false.obs;
  RxList<OrderHistoryItem> orders = <OrderHistoryItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrderHistory();
  }

  //---------FETCH ORDER HISTORY----------------//

  Future<void> fetchOrderHistory() async {
    try {
      isLoading.value = true;

      final response = await service.fetchOrders();

      if (response != null && response.success) {
        orders.value = response.orders;
      }
    } catch (e) {
      debugPrint("Error fetching order history: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
