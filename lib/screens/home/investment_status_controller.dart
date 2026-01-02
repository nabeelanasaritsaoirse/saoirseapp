import 'package:get/get.dart';

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
  void onInit() {
    super.onInit();
    fetchInvestmentStatus();
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
