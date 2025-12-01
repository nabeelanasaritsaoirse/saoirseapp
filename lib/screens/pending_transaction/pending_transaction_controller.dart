import 'package:get/get.dart';
import 'package:saoirse_app/screens/razorpay/pending_transaction_razorpay_controller.dart';
import 'package:saoirse_app/widgets/app_toast.dart';

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
    appToast(error: true, content: "Please select at least one order to pay.");
    return;
  }

  // call backend to create combined razorpay order response
  final response = await service.createCombinedRazorpayOrder(
    selectedOrderIds.toList(),
  );

  if (response == null) {
    appToast(error: true, content: "Server error. Try again.");
    return;
  }

  // response is the full JSON returned by postRequest
  // Check success and get the `data` map
  final bool success = response['success'] == true;
  if (!success) {
    final msg = response['message'] ?? 'Failed to create order';
    appToast(error: true, content: msg);
    return;
  }

  final Map<String, dynamic>? data =
      (response['data'] is Map) ? Map<String, dynamic>.from(response['data']) : null;

  if (data == null) {
    appToast(error: true, content: "Invalid server response.");
    return;
  }

  // Put/initialize the razorpay controller and start payment
  final PendingTransactionRazorpayController razorController =
      Get.put(PendingTransactionRazorpayController());

  razorController.startCombinedPayment(
    createResponse: data,
    selectedOrders: selectedOrderIds.toList(),
  );
}



}
