import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/app_colors.dart';
import '../../widgets/app_text.dart';
import '../../widgets/custom_appbar.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(
        title: "Terms & Conditions",
        showBack: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            appText(
              "By downloading, accessing, or using epi, you agree to the following Terms & Conditions. If you do not agree, please stop using the app.\n",
              fontSize: 14.sp,
              color: AppColors.textBlack,
              textAlign: TextAlign.start,
            ),

            sectionTitle("1. Use of the App"),
            bulletList([
              "You must be at least 18 years old to use the app.",
              "You agree to provide accurate information while registering or ordering.",
              "You are responsible for maintaining the confidentiality of your account.",
            ]),

            sectionTitle("2. Products & Pricing"),
            bulletList([
              "We try our best to display accurate product details and prices.",
              "Prices, availability, and discounts may change without notice.",
              "In case of pricing errors, we may cancel or modify the order.",
            ]),

            sectionTitle("3. Orders & Payments"),
            bulletList([
              "By placing an order, you agree to pay the total amount shown at checkout.",
              "Payments are processed securely via third-party payment gateways.",
              "Orders may be canceled by us due to stock issues, fraud detection, or incorrect pricing.",
            ]),

            sectionTitle("4. Shipping & Delivery"),
            bulletList([
              "Delivery times shown are estimates.",
              "Delays may occur due to weather, holidays, courier service, or unforeseen events.",
              "You must provide a valid and complete delivery address.",
            ]),

            sectionTitle("5. Returns, Refunds & Cancellations"),
            bulletList([
              "Policies depend on product type—refer to the app’s Return/Refund Policy section.",
              "Refunds will be processed to the original payment method.",
              "We reserve the right to approve or reject refund requests.",
            ]),

            sectionTitle("6. User Conduct"),
            bulletList([
              "Misuse the app or attempt unauthorized access",
              "Post harmful, illegal, or abusive content",
              "Engage in fraudulent activities",
              "Copy, modify, or distribute app content",
            ]),

            sectionTitle("7. Intellectual Property"),
            appText(
              "All images, logos, text, and content within the app belong to epi and cannot be copied or reproduced without permission.\n",
              fontSize: 14.sp,
              textAlign: TextAlign.start,
              color: AppColors.textBlack,
            ),

            sectionTitle("8. Limitation of Liability"),
            bulletList([
              "Losses resulting from improper use of the app",
              "Third-party service issues (payment gateways, delivery partners)",
              "Delays or failures outside our control",
            ]),
            appText(
              "\nYou agree to use the app at your own risk.\n",
              fontSize: 14.sp,
              color: AppColors.textBlack,
              textAlign: TextAlign.start,
            ),

            sectionTitle("9. Account Termination"),
            bulletList([
              "We reserve the right to suspend or terminate accounts that violate these Terms.",
              "We may cancel orders suspected of fraud.",
            ]),

            sectionTitle("10. Changes to These Terms"),
            appText(
              "We may update these Terms & Conditions anytime. Continued use of the app means you accept the changes.\n",
              fontSize: 14.sp,
              textAlign: TextAlign.start,
              color: AppColors.textBlack,
            ),
          ],
        ),
      ),
    );
  }

  /// ---- Helper UI Widgets ----

  Widget sectionTitle(String text) {
    return Padding(
      padding: EdgeInsets.only(top: 12.h, bottom: 6.h),
      child: appText(
        text,
        fontSize: 16.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.textBlack,
        textAlign: TextAlign.start,
      ),
    );
  }

  Widget bulletList(List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.map((item) {
        return Padding(
          padding: EdgeInsets.only(bottom: 6.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              appText("•  ",
                  fontSize: 14.sp,
                  color: AppColors.textBlack,
                  textAlign: TextAlign.start),
              Expanded(
                child: appText(
                  item,
                  fontSize: 14.sp,
                  color: AppColors.textBlack,
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
