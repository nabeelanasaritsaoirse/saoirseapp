import 'dart:developer';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import '../../models/LoginAuth/kyc_model.dart';
import '../../services/kyc_service.dart';
import '../../widgets/app_toast.dart';

class KycController extends GetxController {
  // ==========================================================
  // SERVICES
  // ==========================================================
  final KycServices kycServices = KycServices();
  final ImagePicker picker = ImagePicker();

  // ==========================================================
  // TEXT CONTROLLERS
  // ==========================================================
  final aadhaarNumberController = TextEditingController();
  final panNumberController = TextEditingController();

  // ==========================================================
  // SELECTION FLAGS
  // ==========================================================
  RxBool aadhaarSelected = false.obs;
  RxBool panSelected = false.obs;

  // ==========================================================
  // IMAGE FILES
  // ==========================================================
  Rx<File?> selfieImage = Rx<File?>(null);
  Rx<File?> aadhaarFront = Rx<File?>(null);
  Rx<File?> aadhaarBack = Rx<File?>(null);
  Rx<File?> panFront = Rx<File?>(null);

  // ==========================================================
  // ERROR FLAGS (FOR RED BORDERS)
  // ==========================================================
  RxBool selfieError = false.obs;

  RxBool aadhaarError = false.obs;
  RxBool aadhaarFrontError = false.obs;
  RxBool aadhaarBackError = false.obs;
  RxBool aadhaarNumberError = false.obs;

  RxBool panError = false.obs;
  RxBool panFrontError = false.obs;
  RxBool panNumberError = false.obs;

  // ==========================================================
  // STATE
  // ==========================================================
  RxBool isLoading = false.obs;
  Rxn<KycModel> kyc = Rxn<KycModel>();
  RxString errorMessage = ''.obs;

  @override
  void onInit() {
    fetchKycData();
    super.onInit();
  }

  @override
  void onClose() {
    resetKycForm();
    super.onClose();
  }

  // ==========================================================
  // RESET FORM (To reset when we cick backbutton from KYC screen)
  // ==========================================================
  void resetKycForm() {
    log("Resetting KYC form...");

    // Text fields
    aadhaarNumberController.clear();
    panNumberController.clear();

    // Images
    selfieImage.value = null;
    aadhaarFront.value = null;
    aadhaarBack.value = null;
    panFront.value = null;

    // Selections
    aadhaarSelected.value = false;
    panSelected.value = false;

    // Error flags
    selfieError.value = false;
    aadhaarError.value = false;
    aadhaarFrontError.value = false;
    aadhaarBackError.value = false;
    aadhaarNumberError.value = false;

    panError.value = false;
    panFrontError.value = false;
    panNumberError.value = false;
  }

  // ==========================================================
  // FETCH KYC DATA
  // ==========================================================
  Future<void> fetchKycData() async {
    try {
      isLoading(true);
      final data = await kycServices.getKyc();
      kyc.value = data;
    } catch (e) {
      errorMessage.value = "Error fetching KYC: $e";
    } finally {
      isLoading(false);
    }
  }

  // ==========================================================
  // IMAGE PICKER
  // ==========================================================
  Future<void> pickImage(
    ImageSource source,
    Rx<File?> target, {
    RxBool? errorFlag,
  }) async {
    final picked = await picker.pickImage(source: source, imageQuality: 70);
    if (picked != null) {
      target.value = await compressImage(File(picked.path));
      errorFlag?.value = false; // clear error once image selected
    }
  }

  // ==========================================================
  // VALIDATION (TEXT + IMAGE)
  // ==========================================================
  bool validateKyc() {
    bool isValid = true;

    // reset errors
    selfieError.value = false;
    aadhaarError.value = false;
    aadhaarFrontError.value = false;
    aadhaarBackError.value = false;
    aadhaarNumberError.value = false;
    panError.value = false;
    panFrontError.value = false;
    panNumberError.value = false;

    // ---------------- SELFIE ----------------
    if (selfieImage.value == null) {
      selfieError.value = true;
      appToast(content: "Upload selfie", error: true);
      isValid = false;
    }

    // ---------------- AT LEAST ONE DOC ----------------
    if (!aadhaarSelected.value && !panSelected.value) {
      aadhaarError.value = true;
      panError.value = true;
      appToast(content: "Select Aadhaar or PAN", error: true);
      isValid = false;
    }

    // ---------------- AADHAAR ----------------
    if (aadhaarSelected.value) {
      if (aadhaarNumberController.text.trim().length != 12) {
        aadhaarNumberError.value = true;
        appToast(content: "Enter valid Aadhaar number", error: true);
        isValid = false;
      }

      if (aadhaarFront.value == null) {
        aadhaarFrontError.value = true;
        appToast(content: "Upload Aadhaar front image", error: true);
        isValid = false;
      }

      if (aadhaarBack.value == null) {
        aadhaarBackError.value = true;
        appToast(content: "Upload Aadhaar back image", error: true);
        isValid = false;
      }
    }

    // ---------------- PAN ----------------
    if (panSelected.value) {
      final panRegex = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]$');
      if (!panRegex.hasMatch(panNumberController.text.trim().toUpperCase())) {
        panNumberError.value = true;
        appToast(content: "Enter valid PAN number", error: true);
        isValid = false;
      }

      if (panFront.value == null) {
        panFrontError.value = true;
        appToast(content: "Upload PAN image", error: true);
        isValid = false;
      }
    }

    return isValid;
  }

  // ==========================================================
  // SUBMIT KYC
  // ==========================================================
  Future<void> uploadDocuments() async {
    if (!validateKyc()) return;

    isLoading(true);

    try {
      final selfieUrl = (await kycServices.uploadKycImage(
        imageFile: selfieImage.value!,
        type: "selfie",
        side: "front",
      ))["url"];

      final List<Map<String, dynamic>> documents = [
        {
          "type": "selfie",
          "frontUrl": selfieUrl,
        }
      ];

      if (aadhaarSelected.value) {
        final frontUrl = (await kycServices.uploadKycImage(
          imageFile: aadhaarFront.value!,
          type: "aadhaar",
          side: "front",
        ))["url"];

        final backUrl = (await kycServices.uploadKycImage(
          imageFile: aadhaarBack.value!,
          type: "aadhaar",
          side: "back",
        ))["url"];

        documents.add({
          "type": "aadhaar",
          "frontUrl": frontUrl,
          "backUrl": backUrl,
        });
      }

      if (panSelected.value) {
        final panUrl = (await kycServices.uploadKycImage(
          imageFile: panFront.value!,
          type: "pan",
          side: "front",
        ))["url"];

        documents.add({
          "type": "pan",
          "frontUrl": panUrl,
        });
      }

      await kycServices.submitKyc(
        aadhaarNumber: aadhaarSelected.value
            ? aadhaarNumberController.text.replaceAll(" ", "")
            : null,
        panNumber:
            panSelected.value ? panNumberController.text.toUpperCase() : null,
        documents: documents,
      );
// Get.snackbar("Success", "KYC submitted");
      fetchKycData();
    } catch (e) {
      log(e.toString());
      //   appToast(content: "KYC submission failed", error: true);
    } finally {
      isLoading(false);
    }
  }

  // ==========================================================
  // IMAGE COMPRESSION
  // ==========================================================
  Future<File> compressImage(File file) async {
    final dir = await getTemporaryDirectory();
    final targetPath =
        "${dir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg";

    final result = await FlutterImageCompress.compressAndGetFile(
      file.path,
      targetPath,
      quality: 60,
    );

    return File(result!.path);
  }
}
