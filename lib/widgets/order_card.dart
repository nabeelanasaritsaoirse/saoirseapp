import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_assets.dart';
import '../constants/app_colors.dart';
import '../models/order_history_model.dart';
import 'app_dateformatter.dart';
import 'app_text.dart';

class OrderCard extends StatelessWidget {
  final OrderHistoryItem order;

  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    //----------chekking order status for dynamic color---------
    final statusLower = order.status.toLowerCase();
    Color statusColor;

    if (statusLower == 'delivered' || statusLower == 'completed') {
      statusColor = Colors.green[700]!;
    } else if (statusLower == 'cancelled') {
      statusColor = Colors.red[700]!;
    } else {
      statusColor = Colors.orange[700]!;
    }
    //-----------------------------------------------------------
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 20.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 12.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //---------image container ---------
                Container(
                  width: 74.w,
                  height: 72.h,
                  decoration: BoxDecoration(
                    color: AppColors.lightGrey,
                    image: DecorationImage(
                      image: AssetImage(AppAssets.mobile),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                SizedBox(width: 12.w),
                //-------- middle column with name, specs, price-----------
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        appText(order.name,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textBlack,
                            maxLines: 2,
                            textAlign: TextAlign.start),
                        SizedBox(height: 4.h),
                        appText(
                          order.color,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textBlack,
                        ),
                        SizedBox(height: 4.h),
                        appText(
                          order.storage,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textBlack,
                        ),
                        const SizedBox(height: 6),
                        appText(
                          '${order.currency} ${order.price.toString()}',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textBlack,
                        ),
                      ],
                    ),
                  ),
                ),

                //--------end column with QTY---------
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _textSpan('QTY : ', order.qty.toString()),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 14.h),

            //--------- bottom row with order details ---------
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // left column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _textSpan('Daily SIP : ', order.dailyPlan),
                      SizedBox(height: 8.h),
                      _textSpan('Order ID : ', order.id),
                      SizedBox(height: 8.h),
                      _textSpan(
                          'Invested : ', '${order.currency} ${order.invested}'),
                    ],
                  ),
                ),

                // ------------ right column -----------
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // (Status with dynamic color)
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                              text: 'Status : ',
                              style: TextStyle(
                                  fontSize: 15.sp,
                                  color: AppColors.textGray,
                                  fontWeight: FontWeight.w500)),
                          TextSpan(
                              text: order.status,
                              style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w500,
                                  color: statusColor)),
                        ],
                      ),
                    ),
                    SizedBox(height: 8.h),
                    _textSpan('Open : ', DateFormatter.format(order.openDate)),
                    SizedBox(height: 8.h),
                    _textSpan(
                        'Close : ', DateFormatter.format(order.closeDate)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --------- reusable label-value widget ---------
  Widget _textSpan(String label, String value, {int maxLines = 1}) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
              text: label,
              style: TextStyle(
                  fontSize: 15.sp,
                  color: AppColors.textGray,
                  fontWeight: FontWeight.w500)),
          TextSpan(
              text: value,
              style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textBlack)),
        ],
      ),
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.start,
    );
  }
}
