import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/order_history_model.dart';
import '../../services/order_history_service.dart';

class OrderDeliveredController extends GetxController {
  final OrderHistoryService service = OrderHistoryService();

  RxBool isLoading = false.obs;
  RxBool isPageLoading = false.obs;
  RxList<OrderHistoryItem> orders = <OrderHistoryItem>[].obs;

  final ScrollController scrollController = ScrollController();

  int _page = 1;
  final int _limit = 10;
  bool _hasMore = true;

  @override
  void onInit() {
    super.onInit();
    fetchDeliveredOrders();

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 100) {
        fetchDeliveredOrders(loadMore: true);
      }
    });
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
  //----------FETCH ALL DELIVERED ORDERS----------------//

  Future<void> fetchDeliveredOrders({bool loadMore = false}) async {
    if (loadMore && !_hasMore) return;

    try {
      if (loadMore) {
        isPageLoading.value = true;
      } else {
        isLoading.value = true;
        _page = 1;
        _hasMore = true;
        orders.clear();
      }

      final response = await service.fetchDeliveredOrders(
        page: _page,
        limit: _limit,
      );

      if (response != null && response.success) {
        orders.addAll(response.orders);

        if (response.orders.length < _limit) {
          _hasMore = false;
        } else {
          _page++;
        }
      }
    } finally {
      isLoading.value = false;
      isPageLoading.value = false;
    }
  }
}
