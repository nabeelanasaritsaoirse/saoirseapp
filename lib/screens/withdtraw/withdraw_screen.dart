import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../constants/app_colors.dart';
import '../../models/bank_account_model.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/app_toast.dart';
import '../../widgets/custom_appbar.dart';
import '../select_account/select_account_controller.dart';
import 'withdraw_controller.dart';
import '/widgets/app_button.dart';
import '/widgets/app_text.dart';

class WithdrawScreen extends StatefulWidget {
  final BankAccountModel account;
  const WithdrawScreen({super.key, required this.account});

  @override
  State<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  final _formKey = GlobalKey<FormState>();
  final selectAccountController = Get.find<SelectAccountController>();
  final WithdrawController withdrawController = Get.find<WithdrawController>();

  @override
  void initState() {
    super.initState();

    // 🔥 PREFILL ACCOUNT DETAILS
    withdrawController.nameController.text = widget.account.accountHolderName;

    withdrawController.accController.text = widget.account.accountNumber;

    withdrawController.confirmAccController.text = widget.account.accountNumber;

    withdrawController.ifscController.text = widget.account.ifscCode;

    withdrawController.bankNameController.text = widget.account.bankName!;
  }

  @override
  Widget build(BuildContext context) {
    final selectedAccount = selectAccountController
        .accountList[selectAccountController.selectedIndex.value];

    // Optional: sync to withdraw controller (for API use)
    withdrawController.nameController.text = selectedAccount.accountHolderName;
    withdrawController.accController.text = selectedAccount.accountNumber;
    withdrawController.ifscController.text = selectedAccount.ifscCode;
    withdrawController.bankNameController.text = selectedAccount.bankName!;
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: CustomAppBar(
        title: "Withdraw",
        showBack: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              appText("Enter the account details",
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                  fontSize: 16.sp),
              SizedBox(height: 15.h),

              // NAME
              appText("Account holder name",
                  color: AppColors.grey, fontSize: 15.sp),
              SizedBox(
                height: 6.h,
              ),
              appTextField(
                controller: withdrawController.nameController,
                hintText: "Name",
                contentPadding:
                    EdgeInsets.symmetric(vertical: 13.h, horizontal: 10.w),
                textInputType: TextInputType.name,
                hintColor: AppColors.grey,
                textColor: AppColors.black,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Name is required";
                  }
                  return null;
                },
              ),
              SizedBox(height: 15.h),

              // ACCOUNT NUMBER
              appText("Account number", color: AppColors.grey, fontSize: 15.sp),
              SizedBox(
                height: 6.h,
              ),
              appTextField(
                controller: withdrawController.accController,
                hintText: "Account number",
                contentPadding:
                    EdgeInsets.symmetric(vertical: 13.h, horizontal: 10.w),
                hintColor: AppColors.grey,
                textColor: AppColors.black,
                textInputType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Account number is required";
                  } else if (value.length < 6) {
                    return "Enter valid account number";
                  }
                  return null;
                },
              ),
              SizedBox(height: 15.h),

              // CONFIRM ACCOUNT NUMBER
              appText("Confirm account number",
                  color: AppColors.grey, fontSize: 15.sp),
              SizedBox(
                height: 6.h,
              ),
              appTextField(
                controller: withdrawController.confirmAccController,
                hintText: "Account number",
                hintColor: AppColors.grey,
                textColor: AppColors.black,
                textInputType: TextInputType.number,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 13.h, horizontal: 10.w),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please confirm account number";
                  } else if (value != withdrawController.accController.text) {
                    return "Account numbers do not match";
                  }
                  return null;
                },
              ),
              SizedBox(height: 15.h),

              // IFSC
              appText("IFSC code", color: AppColors.grey, fontSize: 15.sp),
              SizedBox(
                height: 6.h,
              ),
              appTextField(
                controller: withdrawController.ifscController,
                hintText: "IFSC code",
                hintColor: AppColors.grey,
                textColor: AppColors.black,
                textInputType: TextInputType.text,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 13.h, horizontal: 10.w),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "IFSC code is required";
                  } else if (!RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$')
                      .hasMatch(value.toUpperCase())) {
                    return "Enter valid IFSC code";
                  }
                  return null;
                },
              ),
              // accountDetailsCard(selectedAccount),
              SizedBox(height: 30.h),

              /// 🔥 NEW ENTER AMOUNT UI (FULLY FUNCTIONAL)
              Padding(
                padding: EdgeInsets.only(top: 10.h, bottom: 30.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    appText(
                      "Enter Amount",
                      fontSize: 17.sp,
                      color: AppColors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        appText(
                          "₹",
                          fontSize: 38.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.black87,
                        ),
                        SizedBox(width: 8.w),

                        /// ---- AMOUNT TEXTFIELD ----
                        Flexible(
                          child: IntrinsicWidth(
                            child: Obx(() {
                              return TextField(
                                controller: withdrawController.amountController,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d+\.?\d{0,2}'),
                                  ),
                                ],
                                onChanged: withdrawController.onAmountChanged,
                                style: TextStyle(
                                  fontSize: 38.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.black87,
                                ),
                                decoration: InputDecoration(
                                  hintText: withdrawController.showSuffix.value
                                      ? ''
                                      : '0.00',
                                  hintStyle: TextStyle(
                                    fontSize: 38.sp,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.black26,
                                  ),
                                  border: InputBorder.none,
                                  suffixText:
                                      withdrawController.showSuffix.value
                                          ? ".00"
                                          : null,
                                  suffixStyle: TextStyle(
                                    fontSize: 38.sp,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.black,
                                  ),
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                ),
                                textAlign: TextAlign.left,
                                autofocus: true,
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      height: 2.h,
                      width: 180.w,
                      color: AppColors.shadowColor,
                    ),
                  ],
                ),
              ),

              SizedBox(height: 40.h),

              // TRANSFER BUTTON
              Obx(() => appButton(
                    child: withdrawController.isLoading.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : appText(
                            "Transfer",
                            color: AppColors.white,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                          ),
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        /// ❗ Validate amount
                        if (withdrawController.amountController.text
                                .trim()
                                .isEmpty ||
                            (int.tryParse(withdrawController
                                        .amountController.text) ??
                                    0) <=
                                0) {
                          appToast(
                              title: "Error",
                              content: "Please enter a valid amount");
                          return;
                        }

                        /// 🔍 SERVER-DRIVEN KYC + BANK CHECK
                        final eligible = await withdrawController
                            .checkWithdrawalEligibility();

                        if (!eligible) return;

                        /// 🚀 CALL WITHDRAW API HERE
                        withdrawController.submitWithdrawal();
                      }
                    },
                    buttonColor: AppColors.primaryColor,
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Widget accountDetailsCard(BankAccountModel account) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          appText("Selected Account",
              fontSize: 16.sp, fontWeight: FontWeight.w700),
          SizedBox(height: 12.h),
          detailRow("Account Holder", account.accountHolderName),
          detailRow("Account Number", account.accountNumber),
          detailRow("IFSC Code", account.ifscCode),
        ],
      ),
    );
  }

  Widget detailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: appText(label,
                color: AppColors.grey,
                fontSize: 13.sp,
                textAlign: TextAlign.left),
          ),
          Expanded(
            flex: 5,
            child: appText(value,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                textAlign: TextAlign.left),
          ),
        ],
      ),
    );
  }
}
