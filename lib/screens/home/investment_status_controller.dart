import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../constants/app_constant.dart';
import '../../main.dart';
import '../../models/investment_status_card_model.dart';
import '../../services/investment_status_service.dart';

class InvestmentStatusController extends GetxController {
  final InvestmentStatusService service = InvestmentStatusService();

  RxBool isLoading = false.obs;

  Rx<InvestmentOverview> overview = InvestmentOverview(
    totalOrders: 0,
    totalAmount: 0,
    totalPaidAmount: 0,
    totalRemainingAmount: 0,
    totalDays: 0,
    remainingDays: 0,
    progressPercent: 0,
  ).obs;
  @override
  void onReady() {
    super.onReady();
    _initWhenTokenReady();
  }

  Future<void> _initWhenTokenReady() async {
    debugPrint("⏳ [INVESTMENT] Waiting for token...");

    String? token;
    int retry = 0;

    while (
        (token = storage.read(AppConst.ACCESS_TOKEN)) == null && retry < 10) {
      await Future.delayed(const Duration(milliseconds: 300));
      retry++;
    }

    if (token == null) {
      debugPrint(" [INVESTMENT] Token not found");
      return;
    }

    debugPrint(" [INVESTMENT] Token found, fetching status");
    await fetchInvestmentStatus();
  }

  Future<void> fetchInvestmentStatus() async {
    try {
      isLoading.value = true;

      final response = await service.fetchInvestmentStatus();

      if (response != null && response.success) {
        overview.value = response.overview;
      }
    } finally {
      isLoading.value = false;
    }
  }
}
