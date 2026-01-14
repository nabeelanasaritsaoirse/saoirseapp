// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '/models/LoginAuth/kyc_model.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_loader.dart';
import '../../widgets/app_text.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/custom_appbar.dart';
import 'kyc_controller.dart';
import 'package:flutter/services.dart';

class AadhaarInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Remove non-digits
    String digits = newValue.text.replaceAll(RegExp(r'\D'), '');

    // Limit to 12 digits
    if (digits.length > 12) {
      digits = digits.substring(0, 12);
    }

    // Add space after every 4 digits
    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      buffer.write(digits[i]);
      if ((i + 1) % 4 == 0 && i != digits.length - 1) {
        buffer.write(' ');
      }
    }

    final formattedText = buffer.toString();

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}

class KycScreen extends StatelessWidget {
  KycScreen({super.key});

  final controller = Get.find<KycController>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          controller.resetKycForm();
          return true;
        },
        child: Scaffold(
          backgroundColor: AppColors.scaffoldColor,
          appBar: CustomAppBar(
            title: AppStrings.KycTitle,
            showBack: true,
          ),
          body: Obx(() {
            if (controller.isLoading.value) return appLoader();

            final status = controller.kyc.value?.status ?? "not_submitted";

            switch (status) {
              case "pending":
                return const PendingUI();
              case "approved":
              case "auto_approved":
                return const ApprovedUI();
              case "rejected":
                return const RejectedUI();
              default:
                return const NotSubmittedUI();
            }
          }),
        ));
  }
}

// ==========================================================
// NOT SUBMITTED UI
// ==========================================================
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
                onTap: () => controller.pickImage(
                    ImageSource.camera, controller.selfieImage),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: controller.selfieError.value
                          ? Colors.red
                          : AppColors.grey,
                      width: 1.5,
                    ),
                  ),
                  child: imagePicker(
                    image: controller.selfieImage,
                    onTap: () => controller.pickImage(
                        ImageSource.camera, controller.selfieImage),
                  ),
                ),
              )),

          SizedBox(height: 20.h),

          // ---------------- DOCUMENT SELECT ----------------
          appText("Upload Document",
              fontSize: 16.sp, fontWeight: FontWeight.w600),
          SizedBox(height: 12.h),
//=================================================================
          // Aadhaar checkbox
//=================================================================
          Obx(() => GestureDetector(
                onTap: () => controller.aadhaarSelected.toggle(),
                child: Container(
                  padding: EdgeInsets.all(12.r),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(
                        color: controller.aadhaarError.value
                            ? Colors.red
                            : controller.aadhaarSelected.value
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
                        color: controller.panError.value
                            ? Colors.red
                            : controller.panSelected.value
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

          // ---------------- AADHAAR ----------------
          Obx(() => controller.aadhaarSelected.value
              ? aadhaarSection(controller)
              : const SizedBox()),

          // ---------------- PAN ----------------
          Obx(() => controller.panSelected.value
              ? panSection(controller)
              : const SizedBox()),

          SizedBox(height: 10.h),

// ================= CONSENT CHECKBOXES =================
          Obx(() => Column(
                children: [
                  consentTile(
                    "I declare that the information and documents provided are true and correct.",
                    controller.consentInfoCorrect,
                    controller.consentError.value,
                  ),
                  consentTile(
                    "I consent to the use of my PAN and Aadhaar details for KYC verification.",
                    controller.consentUsePanAadhaar,
                    controller.consentError.value,
                  ),
                  consentTile(
                    "I have read and agree to the Terms and Conditions for KYC.",
                    controller.consentTerms,
                    controller.consentError.value,
                  ),
                ],
              )),

          SizedBox(height: 20.h),

          // ---------------- SUBMIT BUTTON ----------------

          Obx(() => appButton(
                buttonText:
                    controller.isLoading.value ? "Uploading..." : "Submit KYC",
                buttonColor: AppColors.primaryColor,
                onTap: () {
                  if (!controller.validateConsents()) return;
                  controller.uploadDocuments();
                },
              )),
        ],
      ),
    );
  }
}

// ==========================================================
// AADHAAR SECTION
// ==========================================================
Widget aadhaarSection(KycController controller) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      sectionTitle("Aadhaar Details"),
      appTextField(
        controller: controller.aadhaarNumberController,
        hintText: "XXXX XXXX XXXX",
        textInputType: TextInputType.number,
        textColor: AppColors.black,
        hintColor: AppColors.darkGray,
        validator: aadhaarValidator,
      ),
      SizedBox(height: 10.h),
      Obx(() => Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: controller.aadhaarBackError.value
                    ? Colors.red
                    : AppColors.grey,
              ),
            ),
            child: imagePicker(
              image: controller.aadhaarFront,
              onTap: () => controller.pickImage(
                ImageSource.gallery,
                controller.aadhaarFront,
                errorFlag: controller.aadhaarFrontError,
              ),
            ),
          )),
      SizedBox(height: 10.h),
      Obx(() => Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: controller.aadhaarBackError.value
                    ? Colors.red
                    : AppColors.grey,
              ),
            ),
            child: imagePicker(
              image: controller.aadhaarBack,
              onTap: () => controller.pickImage(
                ImageSource.gallery,
                controller.aadhaarBack,
                errorFlag: controller.aadhaarBackError,
              ),
            ),
          )),
      SizedBox(height: 20.h),
    ],
  );
}

// ==========================================================
// PAN SECTION (FRONT ONLY)
// ==========================================================
Widget panSection(KycController controller) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      sectionTitle("PAN Details"),
      appTextField(
        controller: controller.panNumberController,
        hintText: "ABCDE1234F",
        hintColor: AppColors.darkGray,
        textColor: AppColors.black,
        validator: panValidator,
        borderRadius: BorderRadius.all(
          Radius.circular(8.r),
        ),
      ),
      SizedBox(height: 10.h),
      Obx(() => Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: controller.panFrontError.value
                    ? Colors.red
                    : AppColors.grey,
              ),
            ),
            child: imagePicker(
              image: controller.panFront,
              onTap: () => controller.pickImage(
                ImageSource.gallery,
                controller.panFront,
                errorFlag: controller.panFrontError,
              ),
            ),
          )),
      SizedBox(height: 20.h),
    ],
  );
}

// ==========================================================
// COMMON IMAGE PICKER
// ==========================================================

Widget imagePicker({
  String label = "Tap to upload",
  required Rx<File?> image,
  required VoidCallback onTap,
}) {
  return Obx(() => GestureDetector(
        onTap: onTap,
        child: Container(
          height: 150.h,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.grey),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: image.value == null
              ? Center(child: appText(label))
              : ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: Image.file(image.value!, fit: BoxFit.cover),
                ),
        ),
      ));
}

// ==========================================================
// CHECKBOX TILE
// ==========================================================

Widget checkboxTile(String text, RxBool value) {
  return Obx(() => CheckboxListTile(
        value: value.value,
        title: appText(text),
        onChanged: (_) => value.toggle(),
        controlAffinity: ListTileControlAffinity.leading,
      ));
}

// ==========================================================
// SECTION TITLE
// ==========================================================

Widget sectionTitle(String title) {
  return Padding(
    padding: EdgeInsets.only(bottom: 8.h),
    child: appText(
      title,
      fontSize: 16.sp,
      fontWeight: FontWeight.w600,
    ),
  );
}

// ==========================================================
// Pending UI
// ==========================================================

class PendingUI extends StatelessWidget {
  const PendingUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.hourglass_bottom, size: 80.sp, color: AppColors.orange),
          SizedBox(height: 10.h),
          appText("KYC Pending", fontSize: 20.sp),
          appText("Documents under review"),
        ],
      ),
    );
  }
}

//======================================================
//     Approved UI
//======================================================
class ApprovedUI extends StatelessWidget {
  const ApprovedUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle, size: 90.sp, color: AppColors.green),
          SizedBox(height: 10.h),
          appText("KYC Approved", fontSize: 20.sp),
        ],
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
                  note,
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

//======================================================
//     AADHAAR VALIDATOR
//======================================================

String? aadhaarValidator(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Please enter Aadhaar number';
  }

  // Remove spaces
  value = value.replaceAll(' ', '');

  // Aadhaar must be 12 digits & start with 2–9
  if (!RegExp(r'^[2-9][0-9]{11}$').hasMatch(value)) {
    return 'Enter a valid 12-digit Aadhaar number';
  }

  if (!_verhoeffCheck(value)) {
    return 'Invalid Aadhaar number';
  }

  return null;
}

/* ------------ Verhoeff Algorithm ------------ */

const List<List<int>> _d = [
  [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
  [1, 2, 3, 4, 0, 6, 7, 8, 9, 5],
  [2, 3, 4, 0, 1, 7, 8, 9, 5, 6],
  [3, 4, 0, 1, 2, 8, 9, 5, 6, 7],
  [4, 0, 1, 2, 3, 9, 5, 6, 7, 8],
  [5, 9, 8, 7, 6, 0, 4, 3, 2, 1],
  [6, 5, 9, 8, 7, 1, 0, 4, 3, 2],
  [7, 6, 5, 9, 8, 2, 1, 0, 4, 3],
  [8, 7, 6, 5, 9, 3, 2, 1, 0, 4],
  [9, 8, 7, 6, 5, 4, 3, 2, 1, 0]
];

const List<List<int>> _p = [
  [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
  [1, 5, 7, 6, 2, 8, 3, 0, 9, 4],
  [5, 8, 0, 3, 7, 9, 6, 1, 4, 2],
  [8, 9, 1, 6, 0, 4, 3, 5, 2, 7],
  [9, 4, 5, 3, 1, 2, 6, 8, 7, 0],
  [4, 2, 8, 6, 5, 7, 3, 9, 0, 1],
  [2, 7, 9, 3, 8, 0, 6, 4, 1, 5],
  [7, 0, 4, 6, 9, 1, 3, 2, 5, 8]
];

bool _verhoeffCheck(String num) {
  int c = 0;
  final digits = num.split('').map(int.parse).toList().reversed.toList();

  for (int i = 0; i < digits.length; i++) {
    c = _d[c][_p[i % 8][digits[i]]];
  }
  return c == 0;
}
//======================================================
//     PAN VALIDATOR
//======================================================

String? panValidator(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Please enter PAN number';
  }

  // PAN must be 10 characters: 5 letters + 4 digits + 1 letter
  if (!RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]$').hasMatch(value)) {
    return 'Enter a valid PAN number (e.g., ABCDE1234F)';
  }

  return null;
}

// ==========================================================
// CONSENT CHECKBOX TILE WITH ERROR HIGHLIGHT
// ==========================================================

Widget consentTile(String text, RxBool value, bool showError) {
  return Obx(() => CheckboxListTile(
        value: value.value,
        onChanged: (_) => value.toggle(),
        title: appText(
          text,
          fontSize: 13.sp,
          color: showError && !value.value ? Colors.red : AppColors.black,
        ),
        controlAffinity: ListTileControlAffinity.leading,
        contentPadding: EdgeInsets.zero,
        dense: true,
      ));
}
