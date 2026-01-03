import 'dart:developer';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import '../../models/LoginAuth/kyc_model.dart';
import '../../widgets/app_toast.dart';
import '../../services/kyc_service.dart';

class KycController extends GetxController {
  @override
  void onClose() {
    resetKycForm();
    super.onClose();
  }

  void resetKycForm() {
    // Clear text fields
    log("Resetting KYC form...");
    aadhaarNumberController.clear();
    panNumberController.clear();

    // Clear images
    selfieImage.value = null;
    aadhaarFront.value = null;
    aadhaarBack.value = null;
    panFront.value = null;

    // Reset selections
    aadhaarSelected.value = false;
    panSelected.value = false;
  }

  final KycServices kycServices = KycServices();

  final aadhaarNumberController = TextEditingController();
  final panNumberController = TextEditingController();

  final RxBool aadhaarSelected = false.obs;
  final RxBool panSelected = false.obs;

  final Rx<File?> selfieImage = Rx<File?>(null);
  final Rx<File?> aadhaarFront = Rx<File?>(null);
  final Rx<File?> aadhaarBack = Rx<File?>(null);
  final Rx<File?> panFront = Rx<File?>(null);

  final RxBool isLoading = false.obs;
  final Rxn<KycModel> kyc = Rxn<KycModel>();
  final RxString errorMessage = ''.obs;

  final picker = ImagePicker();

  @override
  void onInit() {
    fetchKycData();
    super.onInit();
  }

  // =====================================================================
  // FETCH KYC DATA
  // =====================================================================
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

  // ===================== PICKERS =====================
  Future<void> pickImage(ImageSource source, Rx<File?> target) async {
    final picked = await picker.pickImage(source: source, imageQuality: 70);
    if (picked != null) {
      target.value = await compressImage(File(picked.path));
    }
  }

  // ===================== VALIDATION =====================
  bool validate() {
    if (selfieImage.value == null) {
      appToast(content: "Upload selfie", error: true);
      return false;
    }

    if (!aadhaarSelected.value && !panSelected.value) {
      appToast(content: "Select Aadhaar or PAN", error: true);
      return false;
    }

    if (aadhaarSelected.value) {
      if (aadhaarFront.value == null || aadhaarBack.value == null) {
        appToast(content: "Upload Aadhaar images", error: true);
        return false;
      }
      if (aadhaarNumberController.text.isEmpty) {
        appToast(content: "Enter Aadhaar number", error: true);
        return false;
      }
    }

    if (panSelected.value) {
      if (panFront.value == null) {
        appToast(content: "Upload PAN image", error: true);
        return false;
      }
      if (panNumberController.text.isEmpty) {
        appToast(content: "Enter PAN number", error: true);
        return false;
      }
    }

    return true;
  }

  // ===================== SUBMIT =====================
  Future<void> uploadDocuments() async {
    if (!validate()) return;

    isLoading(true);

    try {
      final selfieUrl = (await kycServices.uploadKycImage(
        imageFile: selfieImage.value!,
        type: "selfie",
        side: "front",
      ))["url"];

      final documents = [
        {"type": "selfie", "frontUrl": selfieUrl}
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
      // appToast(content: "KYC submission failed", error: true);
    } finally {
      isLoading(false);
    }
  }

  // ===================== COMPRESS =====================
  Future<File> compressImage(File file) async {
    final dir = await getTemporaryDirectory();
    final target = "${dir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg";

    final result = await FlutterImageCompress.compressAndGetFile(
      file.path,
      target,
      quality: 60,
    );

    return File(result!.path);
  }
}
