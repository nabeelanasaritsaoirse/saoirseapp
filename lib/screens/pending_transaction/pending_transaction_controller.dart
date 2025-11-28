import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../models/pending_transaction_model.dart';
import '../../services/pending_transaction_service.dart';

class PendingTransactionController extends GetxController {
  final PendingTransactionService service = PendingTransactionService();

  RxBool isLoading = false.obs;

  // API payments
  RxList<PendingPayment> transactions = <PendingPayment>[].obs;

  // For radio selection in UI
  RxList<RxBool> selectedList = <RxBool>[].obs;

  // For bottom "Total Amount"
  RxInt totalAmount = 0.obs;

  // Selected Order IDs
  RxList<String> selectedOrderIds = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    getPendingTransactions();
  }

  // ----------------------- fetch pending transactions -----------------------------------
  Future<void> getPendingTransactions() async {
    isLoading.value = true;

    final response = await service.fetchPendingTransactions();

    if (response != null && response.success) {
      transactions.value = response.data.payments;

      // default: all selected (static data)
      selectedList.value =
          List<RxBool>.generate(transactions.length, (_) => true.obs);

      //adding all ids to order id list
      selectedOrderIds.value = transactions.map((t) => t.orderId).toList();

      _recalculateTotal();
    }

    isLoading.value = false;
  }

  // -------------------------Toggle Selection---------------------------------
  void toggleSelection(int index) {
    if (index < 0 || index >= selectedList.length) return;

    selectedList[index].value = !selectedList[index].value;

    final orderId = transactions[index].orderId;
    if (selectedList[index].value) {
      selectedOrderIds.add(orderId);
    } else {
      selectedOrderIds.remove(orderId);
    }

    _recalculateTotal();
  }

  void _recalculateTotal() {
    int sum = 0;

    for (int i = 0; i < transactions.length; i++) {
      if (i < selectedList.length && selectedList[i].value) {
        sum += transactions[i].amount;
      }
    }

    totalAmount.value = sum;
  }

  //------------------------------------Tranaction API Methods and All---------------------------------------------------

  Future<void> payNow() async {
    if (selectedOrderIds.isEmpty) {
      return;
    }

    final response = await service.createCombinedRazorpayOrder(
      selectedOrderIds.toList(),
    );

    if (response != null) {
      debugPrint("✅ API RESPONSE:");
      debugPrint(response.toString());
    } else {
      debugPrint("❌ API returned null");
    }
  }
}
