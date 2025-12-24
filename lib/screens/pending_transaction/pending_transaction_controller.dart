// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:saoirse_app/constants/app_colors.dart';
// import 'package:saoirse_app/screens/booking_confirmation/booking_confirmation_screen.dart';
import 'package:saoirse_app/screens/my_wallet/my_wallet_controller.dart';
import 'package:saoirse_app/screens/razorpay/pending_transaction_razorpay_controller.dart';
import 'package:saoirse_app/widgets/app_button.dart';
import 'package:saoirse_app/widgets/app_loader.dart';
import 'package:saoirse_app/widgets/app_text.dart';
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

  RxString selectedPaymentMethod = "RAZORPAY".obs;

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
      selectedList.value = List<RxBool>.generate(transactions.length, (_) => true.obs);

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

//   Future<void> payNow() async {
//   if (selectedOrderIds.isEmpty) {
//     appToast(error: true, content: "Please select at least one order to pay.");
//     return;
//   }

//   // call backend to create combined razorpay order response
//   final response = await service.createCombinedRazorpayOrder(
//     selectedOrderIds.toList(),
//   );

//   if (response == null) {
//     appToast(error: true, content: "Server error. Try again.");
//     return;
//   }

//   // response is the full JSON returned by postRequest
//   // Check success and get the `data` map
//   final bool success = response['success'] == true;
//   if (!success) {
//     final msg = response['message'] ?? 'Failed to create order';
//     appToast(error: true, content: msg);
//     return;
//   }

//   final Map<String, dynamic>? data =
//       (response['data'] is Map) ? Map<String, dynamic>.from(response['data']) : null;

//   if (data == null) {
//     appToast(error: true, content: "Invalid server response.");
//     return;
//   }

//   // Put/initialize the razorpay controller and start payment
//   final PendingTransactionRazorpayController razorController =
//       Get.put(PendingTransactionRazorpayController());

//   razorController.startCombinedPayment(
//     createResponse: data,
//     selectedOrders: selectedOrderIds.toList(),
//   );
// }

  Future<void> payNow() async {
    if (selectedOrderIds.isEmpty) {
      appToast(error: true, content: "Please select at least one order to pay.");
      return;
    }

    // ================= WALLET FLOW =================
    if (selectedPaymentMethod.value == "WALLET") {
      final walletBalance = Get.find<MyWalletController>().wallet.value?.walletBalance ?? 0;

      if (walletBalance < totalAmount.value) {
        appToast(error: true, content: "Insufficient wallet balance");
        return;
      }

      appLoader();

      final response = await PendingTransactionService.payDailySelected({
        "selectedOrders": selectedOrderIds.toList(),
        "paymentMethod": "WALLET",
      });

      if (Get.isDialogOpen ?? false) Get.back();

      if (response != null && response['success'] == true) {
        appToast(content: "Payment Completed Successfully");
        Get.back();
      } else {
        appToast(
          error: true,
          content: response?['message'] ?? "Wallet payment failed",
        );
      }

      return;
    }

    // ================= RAZORPAY FLOW =================
    final response = await service.createCombinedRazorpayOrder(
      selectedOrderIds.toList(),
    );

    if (response == null || response['success'] != true) {
      appToast(error: true, content: "Failed to create order");
      return;
    }

    final razorController = Get.put(PendingTransactionRazorpayController());

    razorController.startCombinedPayment(
      createResponse: response['data'],
      selectedOrders: selectedOrderIds.toList(),
    );
  }






  ///------------------------DROP DOWN------------------
  void showPaymentMethodSheet() {
    final walletBalance = Get.find<MyWalletController>().wallet.value?.walletBalance ?? 0.0;
    final bool isWalletEnabled = walletBalance > 0;

    Get.bottomSheet(
      Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 25.h),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.r),
            topRight: Radius.circular(24.r),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------------- HEADER ----------------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                appText(
                  "Select Payment Method",
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryColor,
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: Icon(Icons.close, size: 24.sp),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),

            SizedBox(height: 15.h),

            // ================= WALLET OPTION =================
           Obx(() => GestureDetector(
      onTap: isWalletEnabled
          ? () {
              selectedPaymentMethod.value = "WALLET";
            }
          : null,
      child: Opacity(
        opacity: isWalletEnabled ? 1.0 : 0.5, 
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: selectedPaymentMethod.value == "WALLET"
                ? AppColors.primaryColor.withOpacity(0.08)
                : AppColors.white,
            border: Border.all(
              color: isWalletEnabled
                  ? (selectedPaymentMethod.value == "WALLET"
                      ? AppColors.primaryColor
                      : AppColors.grey.withOpacity(0.5))
                  : AppColors.grey.withOpacity(0.3),
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            children: [
              // Icon container
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  Icons.account_balance_wallet_rounded,
                  color: AppColors.primaryColor,
                  size: 24.sp,
                ),
              ),

              SizedBox(width: 12.w),

              // Text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Wallet Payment",
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      isWalletEnabled
                          ? "Balance: ₹${walletBalance.toStringAsFixed(1)}"
                          : "Wallet balance is 0",
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: AppColors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              // this Show check only if wallet is enabled
              if (isWalletEnabled)
                _buildCheckIndicator(
                    selectedPaymentMethod.value == "WALLET"),
            ],
          ),
        ),
      ),
    )),

            SizedBox(height: 12.h),

            // ================= RAZORPAY OPTION =================
            Obx(() => GestureDetector(
                  onTap: () {
                    selectedPaymentMethod.value = "RAZORPAY";
                  },
                  child: Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: selectedPaymentMethod.value == "RAZORPAY" ? AppColors.primaryColor.withOpacity(0.08) : AppColors.white,
                      border: Border.all(
                        color: selectedPaymentMethod.value == "RAZORPAY" ? AppColors.primaryColor : AppColors.grey.withOpacity(0.5),
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      children: [
                        // Icon container
                        Container(
                          padding: EdgeInsets.all(10.w),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Icon(
                            Icons.payment_rounded,
                            color: AppColors.primaryColor,
                            size: 24.sp,
                          ),
                        ),

                        SizedBox(width: 12.w),

                        // Text
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Razorpay Payment",
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                "UPI, Card, Net Banking & More",
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: AppColors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Check indicator
                        _buildCheckIndicator(selectedPaymentMethod.value == "RAZORPAY"),
                      ],
                    ),
                  ),
                )),

            SizedBox(height: 20.h),

            // ---------------- PAY NOW ----------------
            appButton(
              onTap: () {
                Get.back();
                payNow(); 
              },
              width: double.infinity,
              height: 45.h,
              buttonColor: AppColors.mediumAmber,
              child: Center(
                child: appText(
                  "Pay Now",
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.white,
                ),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
    );
  }


  Widget _buildCheckIndicator(bool selected) {
  return Container(
    width: 24.w,
    height: 24.w,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(
        color: selected
            ? AppColors.primaryColor
            : AppColors.grey.withOpacity(0.5),
        width: 2,
      ),
      color: selected ? AppColors.primaryColor : Colors.transparent,
    ),
    child: selected
        ? Icon(
            Icons.check,
            size: 16.sp,
            color: Colors.white,
          )
        : null,
  );
}

}
