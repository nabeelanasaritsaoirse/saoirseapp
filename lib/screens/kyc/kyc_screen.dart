import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../models/LoginAuth/kyc_model.dart';
import '/constants/app_strings.dart';
import '/widgets/custom_appbar.dart';
import '/widgets/app_loader.dart';
import '/constants/app_colors.dart';
import '/screens/kyc/kyc_controller.dart';
import '/widgets/app_button.dart';
import '/widgets/app_text.dart';

class KycScreen extends StatelessWidget {
  KycScreen({super.key});

  final controller = Get.find<KycController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: CustomAppBar(
        showBack: true,
        title: AppStrings.KycTitle,
      ),
      body: Obx(() {
        if (controller.isLoading.value) return appLoader();

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

//==========================================================================
//                 NOT SUBMITTED UI
//==========================================================================

class NotSubmittedUI extends StatelessWidget {
  const NotSubmittedUI({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<KycController>();

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.info_outline, size: 70.sp, color: AppColors.orange),
          SizedBox(height: 8.h),

          appText("KYC Not Submitted",
              fontSize: 18.sp, fontWeight: FontWeight.bold),
          SizedBox(height: 20.h),

          // ============================
          //      SELFIE (Required)
          // ============================
          appText("Upload Selfie (Required)",
              fontSize: 16.sp, fontWeight: FontWeight.w600),
          SizedBox(height: 10.h),

          Obx(() => GestureDetector(
                onTap: controller.pickSelfie,
                child: Container(
                  height: 150.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.grey),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: controller.selfieImage.value == null
                      ? Center(child: appText("Tap to capture/upload selfie"))
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(12.r),
                          child: Image.file(
                            controller.selfieImage.value!,
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
              )),
          SizedBox(height: 25.h),

          // =======================================================================
          //      DOCUMENT SELECTION
          // =======================================================================
          appText("Upload Document",
              fontSize: 16.sp, fontWeight: FontWeight.w600),
          SizedBox(height: 12.h),

          // Aadhaar checkbox
          Obx(() => GestureDetector(
                onTap: () => controller.aadhaarSelected.toggle(),
                child: Container(
                  padding: EdgeInsets.all(12.r),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(
                        color: controller.aadhaarSelected.value
                            ? AppColors.primaryColor
                            : AppColors.grey),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.document_scanner_outlined),
                      SizedBox(width: 10.w),
                      Expanded(child: appText("Aadhaar Card")),
                      Checkbox(
                          value: controller.aadhaarSelected.value,
                          onChanged: (_) =>
                              controller.aadhaarSelected.toggle()),
                    ],
                  ),
                ),
              )),
          SizedBox(height: 10.h),
//=================================================================
          // PAN checkbox
//=================================================================
          Obx(() => GestureDetector(
                onTap: () => controller.panSelected.toggle(),
                child: Container(
                  padding: EdgeInsets.all(12.r),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(
                        color: controller.panSelected.value
                            ? AppColors.primaryColor
                            : AppColors.grey),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.document_scanner_outlined),
                      SizedBox(width: 10.w),
                      Expanded(child: appText("PAN Card")),
                      Checkbox(
                          value: controller.panSelected.value,
                          onChanged: (_) => controller.panSelected.toggle()),
                    ],
                  ),
                ),
              )),
          SizedBox(height: 20.h),

// ==========================================================================
//      AADHAAR UPLOADS
// ==========================================================================
          Obx(() => controller.aadhaarSelected.value
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    appText("Aadhaar Front Image",
                        fontSize: 16.sp, fontWeight: FontWeight.w600),
                    SizedBox(height: 10.h),
                    GestureDetector(
                      onTap: controller.pickAadhaarFront,
                      child: Container(
                        height: 150.h,
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.grey),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: controller.aadhaarFront.value == null
                            ? Center(child: appText("Tap to upload front"))
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(12.r),
                                child: Image.file(
                                  controller.aadhaarFront.value!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    appText("Aadhaar Back Image",
                        fontSize: 16.sp, fontWeight: FontWeight.w600),
                    SizedBox(height: 10.h),
                    GestureDetector(
                      onTap: controller.pickAadhaarBack,
                      child: Container(
                        height: 150.h,
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.grey),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: controller.aadhaarBack.value == null
                            ? Center(child: appText("Tap to upload back"))
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(12.r),
                                child: Image.file(
                                  controller.aadhaarBack.value!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ),
                    ),
                    SizedBox(height: 25.h),
                  ],
                )
              : SizedBox()),

// ==============================================================================
//     PAN UPLOADS
// ==============================================================================

          Obx(() => controller.panSelected.value
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    appText("PAN Front Image",
                        fontSize: 16.sp, fontWeight: FontWeight.w600),
                    SizedBox(height: 10.h),

                    GestureDetector(
                      onTap: controller.pickPanFront,
                      child: Container(
                        height: 150.h,
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.grey),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: controller.panFront.value == null
                            ? Center(child: appText("Tap to upload front"))
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(12.r),
                                child: Image.file(
                                  controller.panFront.value!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // 🔥 PAN BACK IMAGE (NEW)

                    appText("PAN Back Image",
                        fontSize: 16.sp, fontWeight: FontWeight.w600),
                    SizedBox(height: 10.h),

                    GestureDetector(
                      onTap: controller.pickPanBack,
                      child: Container(
                        height: 150.h,
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.grey),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: controller.panBack.value == null
                            ? Center(child: appText("Tap to upload back"))
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(12.r),
                                child: Image.file(
                                  controller.panBack.value!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ),
                    ),
                    SizedBox(height: 25.h),
                  ],
                )
              : SizedBox()),
          // ============================
          //      SUBMIT BUTTON
          // ============================
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
}

//===============================================
//     PENDING UI
//===============================================
class PendingUI extends StatelessWidget {
  const PendingUI({super.key});

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
            SizedBox(height: 8.h),
            appText("Your documents are under review.",
                fontSize: 15.sp, fontWeight: FontWeight.w500),
          ],
        ),
      ),
    );
  }
}

//=============================================================
//     APPROVED UI
//=============================================================
class ApprovedUI extends StatelessWidget {
  final bool isAuto;
  const ApprovedUI({super.key, required this.isAuto});

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

//======================================================
//     REJECTED UI
//======================================================
class RejectedUI extends StatelessWidget {
  const RejectedUI({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<KycController>();
    final note = controller.kyc.value?.rejectionNote ?? "No reason provided";

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

            ///  SHOW REJECTION NOTE
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                appText("Reason:",
                    fontSize: 15.sp, fontWeight: FontWeight.bold),
                SizedBox(height: 10.sp),
                SizedBox(
                  width: 4.sp,
                ),
                appText(
                  note, // <-- backend reason shown here
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.red,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            SizedBox(height: 20.sp),

            appButton(
              buttonText: "Resubmit KYC",
              buttonColor: AppColors.primaryColor,
              onTap: () {
                controller.selfieImage.value = null;
                controller.aadhaarFront.value = null;
                controller.aadhaarBack.value = null;
                controller.panFront.value = null;
                controller.panBack.value = null;

                controller.aadhaarSelected.value = false;
                controller.panSelected.value = false;

                // SWITCH TO NOT SUBMITTED UI
                controller.kyc.value = KycModel(
                  kycExists: false,
                  status: "not_submitted",
                );

                controller.update();
              },
            ),
          ],
        ),
      ),
    );
  }
}
