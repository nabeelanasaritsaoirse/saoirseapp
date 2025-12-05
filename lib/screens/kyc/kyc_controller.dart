import 'dart:developer';
import 'dart:io';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:saoirse_app/widgets/app_toast.dart';
import '../../models/LoginAuth/kyc_model.dart';
import '/screens/kyc/document_type.dart';
import '/services/kyc_service.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

class KycController extends GetxController {
  /// Storage & Services
  final box = Get.put(GetStorage());
  final KycServices kycServices = KycServices();

  /// Observables
  final Rxn<KycModel> kyc = Rxn<KycModel>();
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  /// Document selection (Aadhaar / PAN only)
  final Rxn<DocumentType> selectedDocType = Rxn<DocumentType>();

  /// Selected images
  final Rx<File?> frontImage = Rx<File?>(null);
  final Rx<File?> backImage = Rx<File?>(null);
  final Rx<File?> selfieImage = Rx<File?>(null);
  final Rx<File?> panBack = Rx<File?>(null);

  final RxBool aadhaarSelected = false.obs;
  final RxBool panSelected = false.obs;

  final Rx<File?> aadhaarFront = Rx<File?>(null);
  final Rx<File?> aadhaarBack = Rx<File?>(null);

  final Rx<File?> panFront = Rx<File?>(null);

  final ImagePicker picker = ImagePicker();

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
  
  // ======================================================================
  // IMAGE PICKERS
  // ======================================================================
  Future<void> pickSelfie() async {
    final picked = await picker.pickImage(
        source: ImageSource.camera, imageQuality: 70, maxWidth: 1280);
    if (picked != null) {
      final compressed = await compressImage(File(picked.path));
      selfieImage.value = compressed ?? File(picked.path);
    }
  }

  Future<void> pickAadhaarFront() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final compressed = await compressImage(File(picked.path));
      aadhaarFront.value = compressed ?? File(picked.path);
    }
  }

  Future<void> pickAadhaarBack() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final compressed = await compressImage(File(picked.path));
      aadhaarBack.value = compressed ?? File(picked.path);
    }
  }

  Future<void> pickPanFront() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final compressed = await compressImage(File(picked.path));
      panFront.value = compressed ?? File(picked.path);
    }
  }

  Future<void> pickPanBack() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final compressed = await compressImage(File(picked.path));
      panBack.value = compressed ?? File(picked.path);
    }
  }

  // =====================================================================
  // VALIDATION
  // =====================================================================

  bool validateDocuments() {
    if (selfieImage.value == null) {
      appToast(content: "Please upload selfie", error: true);
      return false;
    }

    if (!aadhaarSelected.value && !panSelected.value) {
      appToast(content: "Select at least one document", error: true);
      return false;
    }

    if (aadhaarSelected.value) {
      if (aadhaarFront.value == null || aadhaarBack.value == null) {
        appToast(content: "Please upload Aadhaar front and back", error: true);
        return false;
      }
    }

    if (panSelected.value) {
      if (panFront.value == null) {
        appToast(content: "Please upload PAN front image", error: true);
        return false;
      }
      if (panBack.value == null) {
        appToast(content: "Please upload PAN back image", error: true);
        return false;
      }
    }

    return true;
  }

  // =====================================================================
  // UPLOAD DOCUMENTS – EXACTLY MATCHES BACKEND DOCUMENTATION
  // =====================================================================

  Future<void> uploadDocuments() async {
    if (!validateDocuments()) return;

    isLoading(true);

    try {
      // --------------------------
      // 1️⃣ Upload Selfie (required)
      // --------------------------
      final selfieResp = await kycServices.uploadKycImage(
        imageFile: selfieImage.value!,
        type: "selfie",
        side: "front",
      );

      final selfieUrl = selfieResp["url"];

      // Prepare the final documents array
      List<Map<String, dynamic>> documents = [];

      // Add selfie
      documents.add({
        "type": "selfie",
        "frontUrl": selfieUrl,
      });

      // --------------------------
      // 2️⃣ Aadhaar (if selected)
      // --------------------------
      if (aadhaarSelected.value) {
        final frontResp = await kycServices.uploadKycImage(
          imageFile: aadhaarFront.value!,
          type: "aadhaar",
          side: "front",
        );
        final aadhaarFrontUrl = frontResp["url"];

        final backResp = await kycServices.uploadKycImage(
          imageFile: aadhaarBack.value!,
          type: "aadhaar",
          side: "back",
        );
        final aadhaarBackUrl = backResp["url"];

        documents.add({
          "type": "aadhaar",
          "frontUrl": aadhaarFrontUrl,
          "backUrl": aadhaarBackUrl,
        });
      }

      // --------------------------
      // 3️⃣ PAN (if selected)
      // --------------------------
      if (panSelected.value) {
        final panFrontResp = await kycServices.uploadKycImage(
          imageFile: panFront.value!,
          type: "pan",
          side: "front",
        );
        final panFrontUrl = panFrontResp["url"];

        final panBackResp = await kycServices.uploadKycImage(
          imageFile: panBack.value!,
          type: "pan",
          side: "back",
        );
        final panBackUrl = panBackResp["url"];

        documents.add({
          "type": "pan",
          "frontUrl": panFrontUrl,
          "backUrl": panBackUrl,
        });
      }

      final submitResponse = await kycServices.submitKyc(documents: documents);

      log("📥 SUBMIT RESPONSE → $submitResponse");

      Get.snackbar("Success", "KYC submitted successfully!");
      await fetchKycData();
    } catch (e) {
      log("❌ KYC SUBMISSION ERROR: $e");
      appToast(
          content: "KYC submission failed...! Upload AADHAAR and PAN ",
          error: true);
  
    } finally {
      isLoading(false);
    }
  }

  Future<File?> compressImage(File file) async {
    final dir = await getTemporaryDirectory();
    final targetPath =
        '${dir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';

    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 60,
      minWidth: 800,
      minHeight: 800,
    );

    return result != null ? File(result.path) : null;
  }
}
