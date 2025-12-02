import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:saoirse_app/services/kyc_service.dart';

import '/constants/app_colors.dart';
import '/screens/kyc/kyc_controller.dart';
import '/widgets/app_button.dart';
import '/widgets/app_text.dart';

class KycScreen extends StatelessWidget {
  KycScreen({super.key});

  final controller = Get.put(KycController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appText("KYC Status", fontSize: 25, color: AppColors.white),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(child: Text(controller.errorMessage.value));
        }

        if (controller.kyc.value == null) {
          return const Center(child: Text("No KYC data found"));
        }

        final status = controller.kyc.value!.status;

        switch (status) {
          case "not_submitted":
            return const NotSubmittedUI();
          case "pending":
            return const PendingUI();
          case "approved":
            return const ApprovedUI(isAuto: false);
          case "auto_approved":
            return const ApprovedUI(isAuto: true);
          case "rejected":
            return const RejectedUI();
          default:
            return const Center(child: Text("Unknown KYC State"));
        }
      }),
    );
  }
}

//
//
//                 NOT SUBMITTED UI
//
//
class NotSubmittedUI extends StatelessWidget {
  const NotSubmittedUI({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<KycController>();

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, size: 70.sp, color: AppColors.orange),
          SizedBox(height: 8.h),

          appText("KYC Not Submitted",
              fontSize: 18.sp, fontWeight: FontWeight.bold),

          SizedBox(height: 20.h),

          //
          // 🔥 1. SELECT DOCUMENT TYPE (Aadhaar/PAN)
          //
          appText("Select Document Type",
              fontSize: 16.sp, fontWeight: FontWeight.w600),

          SizedBox(height: 12.h),

          Obx(() => Column(
                children: [
                  // Aadhaar CARD OPTION
                  _docTypeOption(
                    label: "Aadhaar Card",
                    selected: controller.selectedDocType.value ==
                        DocumentType.aadhaar,
                    onTap: () {
                      controller.selectedDocType.value = DocumentType.aadhaar;
                      controller.backImage.value = null; // reset
                    },
                  ),

                  SizedBox(height: 10.h),

                  // PAN CARD OPTION
                  _docTypeOption(
                    label: "PAN Card",
                    selected:
                        controller.selectedDocType.value == DocumentType.pan,
                    onTap: () {
                      controller.selectedDocType.value = DocumentType.pan;
                      controller.backImage.value = null; // remove back image
                    },
                  ),
                ],
              )),

          SizedBox(height: 25.h),

          //
          // 🔥 2. FRONT IMAGE UPLOAD
          //
          appText("Upload Front Image",
              fontSize: 16.sp, fontWeight: FontWeight.w600),

          SizedBox(height: 10.h),

          Obx(() => GestureDetector(
                onTap: controller.pickFrontImage,
                child: Container(
                  height: 150.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.grey),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: controller.frontImage.value == null
                      ? Center(child: appText("Tap to upload front image"))
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(12.r),
                          child: Image.file(
                            controller.frontImage.value!,
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
              )),

          SizedBox(height: 20.h),

          //
          // 🔥 3. BACK IMAGE ONLY IF DOCUMENT = AADHAAR
          //
          Obx(() => controller.selectedDocType.value == DocumentType.aadhaar
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    appText("Upload Back Image",
                        fontSize: 16.sp, fontWeight: FontWeight.w600),
                    SizedBox(height: 10.h),
                    GestureDetector(
                      onTap: controller.pickBackImage,
                      child: Container(
                        height: 150.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.grey),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: controller.backImage.value == null
                            ? Center(child: appText("Tap to upload back image"))
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(12.r),
                                child: Image.file(
                                  controller.backImage.value!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                  ],
                )
              : SizedBox()),

          SizedBox(height: 25.h),

          //
          // 🔥 4. SUBMIT BUTTON
          //
          Obx(() => appButton(
                buttonText:
                    controller.isLoading.value ? "Uploading..." : "Submit KYC",
                buttonColor: AppColors.primaryColor,
                onTap: controller.uploadDocuments,
              )),
        ],
      ),
    );
  }

  // REUSABLE UI COMPONENT
  Widget _docTypeOption({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(14.r),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: selected ? AppColors.primaryColor : AppColors.grey,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Icon(Icons.credit_card,
                color: selected ? AppColors.primaryColor : AppColors.black),
            SizedBox(width: 10.w),
            Expanded(child: appText(label, fontSize: 16.sp)),
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: selected ? AppColors.primaryColor : AppColors.grey,
            ),
          ],
        ),
      ),
    );
  }
}

//
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
