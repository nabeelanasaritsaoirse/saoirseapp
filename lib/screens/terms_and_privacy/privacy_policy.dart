import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/app_colors.dart';
import '../../widgets/app_text.dart';
import '../../widgets/custom_appbar.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(
        title: "Privacy Policy",
        showBack: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            appText(
                "Welcome to epi (“we”, “our”, “us”). We are committed to protecting your personal information and your right to privacy. This Privacy Policy explains how we collect, use, and protect your data when you use our mobile application and services.\n",
                fontSize: 14.sp,
                color: AppColors.textBlack,
                textAlign: TextAlign.start),
            sectionTitle("1. Information We Collect"),
            subTitle("1.1 Personal Information"),
            bulletList([
              "Name",
              "Email address",
              "Phone number",
              "Delivery address",
              "Payment-related information (handled securely via third-party payment gateways; we do not store card details)",
            ]),
            subTitle("1.2 Automatically Collected Information"),
            bulletList([
              "Device information (model, OS, unique IDs)",
              "IP address",
              "App usage data",
              "Location (only if you grant permission)",
            ]),
            sectionTitle("2. How We Use Your Information"),
            bulletList([
              "Create and manage user accounts",
              "Process and deliver orders",
              "Send order updates, invoices & notifications",
              "Improve app performance & customer experience",
              "Provide customer support",
              "Prevent fraudulent activities",
              "Comply with legal obligations",
            ]),
            sectionTitle("3. Sharing Your Information"),
            bulletList([
              "Delivery partners",
              "Payment gateways (e.g., Razorpay, Stripe, Paytm)",
              "Service providers (hosting, analytics)",
            ]),
            appText(
              "\nWe do not sell or rent your data to any third party.\n",
              fontSize: 14.sp,
            ),
            sectionTitle("4. Data Security"),
            appText(
              "We use encryption and secure servers to protect your personal information. However, no digital method is 100% secure, and we cannot guarantee absolute security.\n",
              fontSize: 14.sp,
            ),
            sectionTitle("5. Cookies & Tracking"),
            bulletList([
              "Improve user experience",
              "Store preferences",
              "Analyze app performance",
            ]),
            sectionTitle("6. Your Rights"),
            bulletList([
              "Update your profile information",
              "Request deletion of your account",
              "Opt out of marketing notifications",
            ]),
            sectionTitle("7. Children’s Privacy"),
            appText(
              "Our app is not intended for children under 13, and we do not knowingly collect their data.\n",
              fontSize: 14.sp,
            ),
            sectionTitle("8. Changes to This Policy"),
            appText(
              "We may update this Privacy Policy from time to time and will notify you within the app.\n",
              fontSize: 14.sp,
            ),
            sectionTitle("9. Contact Us"),
            appText(
              "For any queries about this Privacy Policy, contact us.\n",
              fontSize: 14.sp,
            ),
          ],
        ),
      ),
    );
  }

  /// ---- Helper UI Widgets ----

  Widget sectionTitle(String text) {
    return Padding(
      padding: EdgeInsets.only(top: 12.h, bottom: 4.h),
      child: appText(
        text,
        fontSize: 16.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.textBlack,
      ),
    );
  }

  Widget subTitle(String text) {
    return Padding(
      padding: EdgeInsets.only(top: 8.h, bottom: 4.h),
      child: appText(
        textAlign: TextAlign.start,
        text,
        fontSize: 15.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.textBlack,
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
                child: appText(item,
                    fontSize: 14.sp,
                    color: AppColors.textBlack,
                    textAlign: TextAlign.start),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
