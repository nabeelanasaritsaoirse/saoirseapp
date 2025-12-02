import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '/constants/app_colors.dart';
import '/screens/kyc/kyc_controller.dart';
import '/widgets/app_button.dart';
import '/widgets/app_text.dart';
import '/widgets/app_text_field.dart';

class kycScreen extends StatefulWidget {
   final String kycStatus;
  // Options: "not_submitted", "pending", "approved", "auto_approved", "rejected"

 const  kycScreen({super.key, required this.kycStatus});

  @override
  State<kycScreen> createState() => _kycScreenState();
}

class _kycScreenState extends State<kycScreen> {
  kyc_controller controller = Get.put(kyc_controller());

  @override
  Widget build(BuildContext context) {
    Widget body;

    switch (widget.kycStatus) {
      case "not_submitted":
        body = NotSubmittedUI();
        break;
      case "pending":
        body = const PendingUI();
        break;
      case "approved":
        body = const ApprovedUI(isAuto: false);
        break;
      case "auto_approved":
        body = const ApprovedUI(isAuto: true);
        break;
      case "rejected":
        body = const RejectedUI();
        break;
      default:
        body = const Center(child: Text("Unknown state"));
    }

    return Scaffold(
      appBar: AppBar(
          leading: GestureDetector(
            child: Icon(
              Icons.arrow_back_ios,
              size: 25.sp,
              color: AppColors.white,
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: AppColors.primaryColor,
          title:
              appText("KYC Status", color: AppColors.white, fontSize: 25.sp)),
      body: body,
    );
  }
}

//
// 
//                 NOT SUBMITTED UI
// 
//
class NotSubmittedUI extends StatefulWidget {
  const NotSubmittedUI();

  @override
  State<NotSubmittedUI> createState() => _NotSubmittedUIState();
}

class _NotSubmittedUIState extends State<NotSubmittedUI> {
  List<Map<String, String>> docs = [
    {"type": "", "frontUrl": "", "backUrl": ""},
  ];

  void addDoc() {
    setState(() {
      docs.add({"type": "", "frontUrl": "", "backUrl": ""});
    });
  }

  void removeDoc(int index) {
    if (docs.length == 1) return;
    setState(() {
      docs.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    String? aadhaarError;

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.r),
      child: Column(
        children: [
          Icon(Icons.info_outline, size: 70.sp, color: AppColors.orange),
          SizedBox(height: 8.h),
          appText("KYC Not Submitted",
              fontSize: 18.sp, fontWeight: FontWeight.bold),
          SizedBox(height: 4.h),
          appText("Please add your documents to continue.",
              fontSize: 14.sp, fontWeight: FontWeight.w500),
          SizedBox(height: 15.h),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 3,
                margin: EdgeInsets.symmetric(vertical: 10.h),
                child: Padding(
                  padding: EdgeInsets.all(15.r),
                  child: Row(
                    children: [
                      Expanded(
                          child: appTextField(
                        controller: kyc_controller().AadhaarController,
                        hintText: "Aadhaar / PAN",
                        hintColor: AppColors.black,
                      )),
                      SizedBox(
                        width: 4.w,
                      ),
                      GestureDetector(
                        child: Icon(
                          Icons.delete_outline,
                          size: 30.sp,
                        ),
                        onTap: () => removeDoc(index),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 10.h),
          appButton(
              buttonText: "+ Add Document",
              onTap: addDoc,
              buttonColor: AppColors.primaryColor),
          SizedBox(
            height: 20.h,
          ),
          appButton(
              buttonText: "Submit KYC",
              onTap: addDoc,
              buttonColor: AppColors.primaryColor),
        ],
      ),
    );
  }
}

// // ElevatedButton.icon(

// 
// 2️⃣ PENDING UI
// 
//
class PendingUI extends StatelessWidget {
  const PendingUI();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(20.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.hourglass_bottom, size: 70.sp, color: AppColors.orange),
            SizedBox(height: 15.h),
            appText("KYC Pending",
                fontSize: 22.sp, fontWeight: FontWeight.bold),
            SizedBox(height: 10),
            appText("Your documents are under review.",
                fontSize: 15.sp, fontWeight: FontWeight.w500),
          ],
        ),
      ),
    );
  }
}

//
// 
//         APPROVED & AUTO APPROVED UI
// 
//
class ApprovedUI extends StatelessWidget {
  final bool isAuto;
  const ApprovedUI({required this.isAuto});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(20.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, size: 100.sp, color: AppColors.green),
            SizedBox(height: 15.sp),
            appText(isAuto ? "KYC Auto Approved" : "KYC Approved",
                fontSize: 20.sp, fontWeight: FontWeight.bold),
            SizedBox(height: 8.h),
            appText("You can continue using all features.",
                fontSize: 16.sp, fontWeight: FontWeight.w500),
          ],
        ),
      ),
    );
  }
}

//
//
//             REJECTED UI
//
//
class RejectedUI extends StatelessWidget {
  const RejectedUI();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(20.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cancel, size: 100.sp, color: AppColors.red),
            SizedBox(height: 12.sp),
            appText("KYC Rejected",
                fontSize: 20.sp, fontWeight: FontWeight.bold),
            SizedBox(height: 10.sp),
            appText("Please check your details and try again.",
                fontSize: 16.sp, fontWeight: FontWeight.w500),
            SizedBox(height: 20.h),
            appButton(
              buttonText: "Resubmit KYC",
              buttonColor: AppColors.primaryColor,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
