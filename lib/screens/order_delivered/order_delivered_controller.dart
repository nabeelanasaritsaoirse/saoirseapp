import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/order_history_model.dart';
import '../../services/order_history_service.dart';
import '../../models/review_eligibility_response.dart';
import '../../services/review_service.dart';

class OrderDeliveredController extends GetxController {
  final OrderHistoryService service = OrderHistoryService();
  final ReviewService reviewService = ReviewService();

  RxBool isLoading = false.obs;
  RxBool isPageLoading = false.obs;

  RxList<OrderHistoryItem> orders = <OrderHistoryItem>[].obs;

  /// productId → eligibility
  RxMap<String, ReviewEligibilityData> reviewEligibility =
      <String, ReviewEligibilityData>{}.obs;

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

  // ================= FETCH DELIVERED ORDERS =================
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
        reviewEligibility.clear();
      }

      final response = await service.fetchDeliveredOrders(
        page: _page,
        limit: _limit,
      );

      if (response != null && response.success) {
        orders.addAll(response.orders);

        /// 🔥 CHECK ELIGIBILITY AFTER ORDERS LOAD
        for (final order in response.orders) {
          _checkEligibilityForProduct(order.productId);
        }

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

  // ================= CHECK REVIEW ELIGIBILITY =================
  Future<void> _checkEligibilityForProduct(String productId) async {
    if (reviewEligibility.containsKey(productId)) return;

    final response = await reviewService.checkReviewEligibility(productId);

    if (response != null) {
      reviewEligibility[productId] = response.data;

      debugPrint(
        "REVIEW ELIGIBILITY [$productId] => canReview: ${response.data.canReview}",
      );
    }
  }
}
