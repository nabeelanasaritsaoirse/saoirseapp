import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../constants/app_strings.dart';
import '../../models/wallet_transcation_model.dart';
import '../../widgets/app_loader.dart';
import '../../widgets/custom_appbar.dart';
import '../my_wallet/my_wallet_controller.dart';
import '/constants/app_colors.dart';
import '/widgets/app_text.dart';

class TransactionHistory extends StatefulWidget {
  const TransactionHistory({super.key});

  @override
  State<TransactionHistory> createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistory> {
  final MyWalletController controller = Get.find<MyWalletController>();

  @override
  void initState() {
    controller.refreshAll();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paperColor,
      appBar: CustomAppBar(
        title: AppStrings.transaction_history_label,
        showBack: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: appLoader());
        }
        if (controller.transactions.isEmpty) {
          return const Center(
            child: Text("No transactions found"),
          );
        }
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: RefreshIndicator(
            onRefresh: controller.refreshAll,
            child: ListView.builder(
              itemCount: controller.transactions.length,
              itemBuilder: (context, index) {
                final item = controller.transactions[index];
                return _transactionCard(item);
              },
            ),
          ),
        );
      }),
    );
  }

  Widget _transactionCard(WalletTransaction item) {
    final String productName = item.product?.name ??
        (item.description.isNotEmpty ? item.description : "Unknown Product");

    final String status = item.status;

    Color statusColor;
    if (status.toLowerCase() == "pending") {
      statusColor = AppColors.orange;
    } else if (status.toLowerCase() == "completed") {
      statusColor = AppColors.green;
    } else if (status.toLowerCase() == "failed") {
      statusColor = AppColors.red;
    } else {
      statusColor = AppColors.yellow;
    }

    final String amount = "₹${item.amount.toStringAsFixed(2)}";
    final String date =
        "${item.createdAt.day}/${item.createdAt.month}/${item.createdAt.year}";

    return Container(
      margin: EdgeInsets.only(bottom: 15.h),
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: AppColors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 7,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: appText(productName,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start),
              ),
              SizedBox(width: 15.w),
              appText(
                date,
                color: AppColors.grey,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              // STATUS
              Expanded(
                child: Row(
                  children: [
                    appText(
                      "Status : ",
                      color: AppColors.mediumGray,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    Flexible(
                      child: appText(
                        status.capitalizeFirst!,
                        color: statusColor,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),

              // AMOUNT
              Flexible(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    appText(
                      "Amount : ",
                      color: AppColors.black54,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    Flexible(
                      child: appText(
                        amount,
                        color: AppColors.primaryColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
