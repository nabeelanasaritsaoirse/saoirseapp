import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:saoirse_app/screens/add_money/add_money_screen.dart';

import '../../constants/app_strings.dart';
import '../../widgets/app_loader.dart';
import '../../widgets/custom_appbar.dart';
import '../withdtraw/withdraw_screen.dart';
import '/constants/app_colors.dart';
import '/widgets/app_button.dart';
import '/widgets/app_text.dart';
import 'my_wallet_controller.dart';

class WalletScreen extends StatelessWidget {
  WalletScreen({super.key});

  final controller = Get.put(MyWalletController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: CustomAppBar(
        title: AppStrings.wallet_title,
        showBack: true,
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
              ),
            ),
            onTap: () {
               Get.to(AddMoneyScreen());
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.errorMessage.isNotEmpty) {
          return Center(child: Text(controller.errorMessage.value));
        }

        if (controller.isLoading.value) {
          return appLoader();
        }

        final walletData = controller.wallet.value;

        if (walletData == null) {
          return Center(
            child: appText(
              "Failed to load wallet...!",
              color: AppColors.black,
              fontWeight: FontWeight.w400,
              fontSize: 16.sp,
            ),
          );
        }

        return Column(
          children: [
            // WALLET CARD WITH API DATA
            walletCard(
              mainBalance: walletData.walletBalance,
              totalBalance: walletData.totalBalance,
              referralBonus: walletData.referralBonus,
              holdBalance: walletData.holdBalance,
              investDaily: walletData.totalBalance,
            ),

            SizedBox(height: 8.h),

            Center(
              child: appText(
                "Wallet History",
                color: AppColors.black,
                fontWeight: FontWeight.w600,
                fontSize: 16.sp,
              ),
            ),

            SizedBox(height: 8.h),

            // TRANSACTION LIST FROM API
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                itemCount: walletData.transactions.length,
                itemBuilder: (context, index) {
                  final item = walletData.transactions[index];

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
                          child: Text("💸", style: TextStyle(fontSize: 30.sp)),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              appText(
                                item.type.toUpperCase(),
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w700,
                              ),
                              SizedBox(height: 3.h),
                              appText(
                                item.status,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ],
                          ),
                        ),
                        appText(
                          "₹ ${item.amount}",
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: item.amount > 0 ? Colors.green : Colors.red,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(10),
              child: appButton(
                buttonColor: AppColors.primaryColor,
                onTap: () => Get.to(WithdrawScreen()),
                child: Center(
                  child: appText(
                    "Withdraw",
                    color: AppColors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 5.h),
          ],
        );
      }),
    );
  }

  // WALLET CARD UI (Now uses API values)
  Widget walletCard({
    required int mainBalance,
    required int totalBalance,
    required int referralBonus,
    required int holdBalance,
    required int investDaily,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        gradient: const LinearGradient(
          colors: [AppColors.mediumBlue, AppColors.primaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          appText("Main Balance", color: AppColors.white, fontSize: 18.sp),
          SizedBox(height: 2.h),
          appText("₹ $mainBalance",
              color: AppColors.white,
              fontSize: 30.sp,
              fontWeight: FontWeight.w500),
          SizedBox(height: 15.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              balanceColumn(totalBalance, "Total Balance"),
              divider(),
              balanceColumn(referralBonus, "Referral Bonus"),
            ],
          ),
          SizedBox(height: 14.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              balanceColumn(holdBalance, "Hold Balance"),
              divider(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 7.w),
                child: balanceColumn(investDaily, "Invest Daily"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget balanceColumn(int value, String label) {
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
