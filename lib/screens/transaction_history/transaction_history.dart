import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/app_strings.dart';
import '../../widgets/custom_appbar.dart';
import '/constants/app_colors.dart';
import '/widgets/app_text.dart';

class TransactionHistory extends StatefulWidget {
  const TransactionHistory({super.key});

  @override
  State<TransactionHistory> createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistory> {
  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> data = [
      {
        "product": "GUCCI bag",
        "status": "Successfully",
        "amount": "₹45,599",
        "date": "30/10/2025"
      },
      {
        "product": "Boat wear",
        "status": "Successfully",
        "amount": "₹8,999",
        "date": "30/10/2025"
      },
      {
        "product": "Nike air",
        "status": "unsuccessfully",
        "amount": "₹12,500",
        "date": "29/10/2015"
      },
      {
        "product": "Sony Camera",
        "status": "unsuccessfully",
        "amount": "₹6,999",
        "date": "29/10/2025"
      },
      {
        "product": "BioGlow",
        "status": "Successfully",
        "amount": "₹999",
        "date": "29/10/2025"
      },
    ];
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: AppStrings.transaction_history_label,
        showBack: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            final item = data[index];
            return _transactionCard(
              item["product"],
              item["status"],
              item["amount"],
              item["date"],
            );
          },
        ),
      ),
    );
  }

  Widget _transactionCard(
      String product, String status, String amount, String date) {
    final bool isFailed = status.toLowerCase() == "unsuccessfully";

    return Container(
      margin: EdgeInsets.only(bottom: 15.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.grey,
            spreadRadius: 1,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              appText(
                product,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
              appText(
                date,
                color: AppColors.grey,
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// STATUS
              Row(
                children: [
                  appText(
                    "Status ",
                    color: AppColors.mediumGray,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  SizedBox(
                    width: 2.w,
                  ),
                  appText(
                    status,
                    color: isFailed ? AppColors.red : AppColors.green,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),

              /// AMOUNT
              Row(
                children: [
                  appText(
                    "Amount ",
                    color: AppColors.black54,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  appText(
                    amount,
                    color: AppColors.primaryColor,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
