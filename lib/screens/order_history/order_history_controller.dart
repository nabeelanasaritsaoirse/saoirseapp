import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/order_history_model.dart';
import '../../services/order_history_service.dart';

class OrderHistoryController extends GetxController {
  final OrderHistoryService service = OrderHistoryService();

  RxBool isLoading = false.obs;
  RxList<OrderHistoryItem> orders = <OrderHistoryItem>[].obs;
  final ScrollController scrollController = ScrollController();

  int _page = 1;
  final int _limit = 10;
  bool _hasMore = true;
  RxBool isPageLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrderHistory();
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 100) {
        fetchOrderHistory(loadMore: true);
      }
    });
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  //---------FETCH ORDER HISTORY----------------//

  Future<void> fetchOrderHistory({bool loadMore = false}) async {
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

      final response = await service.fetchOrders(
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
    } catch (e) {
      debugPrint("Error fetching order history: $e");
    } finally {
      isLoading.value = false;
      isPageLoading.value = false;
    }
  }
}
