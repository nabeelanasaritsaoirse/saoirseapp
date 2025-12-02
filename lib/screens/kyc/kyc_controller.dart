import 'dart:developer';
import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:saoirse_app/models/LoginAuth/kycModel.dart';
import 'package:saoirse_app/services/kyc_service.dart';

enum DocumentType { aadhaar, pan }

class KycController extends GetxController {
  final KycServices kycServices = KycServices();

  var kyc = Rxn<KycModel>();
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  // User-selected document type
  var selectedDocType = Rxn<DocumentType>();

  // Images
  Rx<File?> frontImage = Rx<File?>(null);
  Rx<File?> backImage = Rx<File?>(null);

  final ImagePicker picker = ImagePicker();

  @override
  void onInit() {
    fetchKycData();
    super.onInit();
  }

  Future<void> fetchKycData() async {
    try {
      isLoading(true);
      final result = await kycServices.getKyc();
      kyc.value = result;
    } catch (e) {
      errorMessage.value = "KYC Fetch Error: $e";
    } finally {
      isLoading(false);
    }
  }

  Future<void> pickFrontImage() async {
    final img = await picker.pickImage(source: ImageSource.gallery);
    if (img != null) frontImage.value = File(img.path);
  }

  Future<void> pickBackImage() async {
    if (selectedDocType.value == DocumentType.pan) {
      Get.snackbar("Not Required", "PAN card does not require back image");
      return;
    }

    final img = await picker.pickImage(source: ImageSource.gallery);
    if (img != null) backImage.value = File(img.path);
  }

  bool validateDocuments() {
    if (selectedDocType.value == null) {
      Get.snackbar("Missing", "Select a document type");
      return false;
    }

    if (frontImage.value == null) {
      Get.snackbar("Missing", "Upload front image");
      return false;
    }

    if (selectedDocType.value == DocumentType.aadhaar &&
        backImage.value == null) {
      Get.snackbar("Missing", "Upload back image for Aadhaar");
      return false;
    }

    return true;
  }

  Future<void> uploadDocuments() async {
    if (!validateDocuments()) return;
    log("$selectedDocType");
    try {
      isLoading(true);

      final success = await kycServices.uploadDocument(
        docType: selectedDocType.value!,
        front: frontImage.value!,
        back: selectedDocType.value == DocumentType.aadhaar
            ? backImage.value
            : null,
      );
      log("KYC   $success");

      if (success) {
        Get.snackbar("Success", "Document uploaded successfully");
      } else {
        Get.snackbar("Error", "Failed to upload document");
      }
    } catch (e) {
      Get.snackbar("Error", "Upload failed: $e");
    } finally {
      isLoading(false);
    }
  }
}
