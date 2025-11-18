import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '/constants/app_colors.dart';
import '/widgets/app_button.dart';
import '/widgets/app_text.dart';

class MyWallet extends StatefulWidget {
  const MyWallet({super.key});

  @override
  State<MyWallet> createState() => _MyWalletState();
}

class _MyWalletState extends State<MyWallet> {
  @override
  Widget build(BuildContext context) {
    final history = [
      {
        "title": "Investment P1",
        "date": "Today 12:32",
        "amount": "- ₹100",
        "isCredit": false,
        "icon": "💰",
      },
      {
        "title": "Commission",
        "date": "Yesterday 02:12",
        "amount": "+ ₹299",
        "isCredit": true,
        "icon": "📈",
      },
      {
        "title": "Referral Bonus",
        "date": "Yesterday 13:53",
        "amount": "+ ₹1200",
        "isCredit": true,
        "icon": "🎁",
      },
    ];
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        leading: GestureDetector(
          child: Icon(
            Icons.arrow_back_ios,
            color: AppColors.white,
            size: 30.sp,
          ),
          onTap: () => Navigator.pop(context),
        ),
        title: appText("My Wallet",
            color: AppColors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20.sp),
        actions: [
          GestureDetector(
            child: Container(
                margin: EdgeInsets.only(right: 16.w),
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(25.r),
                ),
                child: appText(
                  "Add Money",
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                )),
            onTap: () {
              //
              //             ADD MONEY BUTTON FUNCTION
              //
            },
          ),
        ],
      ),
      body: Column(
        children: [
          walletCard(),
          SizedBox(height: 8.h),
          Center(
              child: appText(
            "Wallet History",
            color: AppColors.black,
            fontWeight: FontWeight.w600,
            fontSize: 16.sp,
          )),
          SizedBox(height: 8.h),
          Expanded(
              child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            itemCount: history.length,
            itemBuilder: (context, index) {
              final item = history[index];

              return Container(
                margin: EdgeInsets.only(bottom: 16.h),
                child: Row(
                  children: [
                    Container(
                        padding: EdgeInsets.all(12.r),
                        decoration: BoxDecoration(
                          color: AppColors.blueshade,
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                        child: appText(
                          "${item["icon"]!}",
                          fontSize: 30.sp,
                        )),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          appText(
                            "${item["title"]!}",
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w700,
                          ),
                          SizedBox(height: 3.h),
                          appText(
                            "${item["date"]!}",
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ],
                      ),
                    ),
                    appText(
                      " ${item["amount"]!}",
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color:
                          item["isCredit"] == true ? Colors.green : Colors.red,
                    ),
                  ],
                ),
              );
            },
          )),
          Padding(
            padding: EdgeInsetsGeometry.all(10),
            child: appButton(
              buttonColor: AppColors.primaryColor,
              child: Center(
                child: appText(
                  "Withdraw",
                  color: AppColors.white,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                //
                //    WITHDRAW BUTTON FUNCTION
                //
              },
            ),
          ),
          SizedBox(height: 5.h),
        ],
      ),
    );
  }

  Widget walletCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        gradient: const LinearGradient(
          colors: [
            AppColors.mediumBlue,
            AppColors.primaryColor,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          appText("Main balance",
              color: AppColors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.w500),
          SizedBox(height: 2.h),
          appText("₹12,560",
              color: AppColors.white,
              fontSize: 30.sp,
              fontWeight: FontWeight.w500),
          SizedBox(height: 15.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              balanceColumn("13850", "Total Balance"),
              divider(),
              balanceColumn("1280", "Referral Bonus"),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              balanceColumn("13850", "Hold Balance"),
              divider(),
              balanceColumn("1280", "10% Invest Daily"),
            ],
          ),
        ],
      ),
    );
  }

  Widget balanceColumn(String value, String label) {
    return Column(
      children: [
        appText(
          "₹ $value",
          color: AppColors.white,
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
        ),
        SizedBox(height: 5.h),
        appText(label, color: AppColors.white, fontSize: 13.sp),
      ],
    );
  }

  Widget divider() {
    return Container(
      width: 1.w,
      height: 40.h,
      color: AppColors.grey,
    );
  }
}
