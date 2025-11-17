import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '/constants/app_colors.dart';
import '/widgets/app_text.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> notifications = [
      {
        'title': 'product out Of Delivery',
        'date': '11/12/2025',
        'message':
            'product has been out of deliverd dont forget to cojjibhsfhhjsskjhjsh',
      },
      {
        'title': 'Alert',
        'date': '18/11/2025',
        'message': 'Your payment hasbeen done succsessfullyghjgfghggjhgj',
      },
      {
        'title': 'withdraw',
        'date': '25/10/2025',
        'message':
            'dont forget to witdraw your amount skkjsvjvhgsdgdhgghgffxgfxfghffgxh',
      },
      {
        'title': 'Account',
        'date': '15/08/2025',
        'message': 'please complete your acoount detiedzbbcjsvhdgvhjagvjv',
      },
      {
        'title': 'offer ',
        'date': '08/10/2025',
        'message':
            'diwali offer id running so didnt foeger the offer ghjkcvghjdfghg',
      },
    ];
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 1,
        title: appText("Notifications",
            color: AppColors.white, fontSize: 20.sp, fontFamily: "poppins"),
        leading: GestureDetector(
          child: Icon(
            Icons.arrow_back,
            color: AppColors.white,
            size: 35.sp,
          ),
          onTap: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16.r),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final item = notifications[index];
          return Container(
            margin: EdgeInsets.only(bottom: 14.h),
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(14.r),
              boxShadow: [
                BoxShadow(
                  color: AppColors.grey,
                  spreadRadius: 1,
                  blurRadius: 7,
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      appText(
                        item["title"],
                        overflow: TextOverflow.ellipsis,
                        color: AppColors.black,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      const SizedBox(height: 4),
                      appText(
                        item["message"],
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        color: AppColors.darkGray,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                ),
                appText(
                  item["date"],
                  color: AppColors.darkGray,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
