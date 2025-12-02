import 'dart:developer';
import 'dart:io';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import 'package:saoirse_app/models/LoginAuth/kycModel.dart';
import 'package:saoirse_app/services/kyc_service.dart';

import 'package:saoirse_app/constants/app_urls.dart';
import 'package:saoirse_app/constants/app_constant.dart';

class KycController extends GetxController {
  final KycServices kycServices = KycServices();

  // Observables
  final Rxn<KycModel> kyc = Rxn<KycModel>();
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // Selected Doc Type
  final Rxn<DocumentType> selectedDocType = Rxn<DocumentType>();

  // Image Files
  final Rx<File?> frontImage = Rx<File?>(null);
  final Rx<File?> backImage = Rx<File?>(null);

  final ImagePicker picker = ImagePicker();

  @override
  void onInit() {
    fetchKycData();
    super.onInit();
  }

  // ------------------------------------------------------------
  // FETCH KYC
  // ------------------------------------------------------------
  Future<void> fetchKycData() async {
    try {
      isLoading(true);
      final data = await kycServices.getKyc();
      kyc.value = data;
    } catch (e) {
      errorMessage.value = "KYC Fetch Error: $e";
    } finally {
      isLoading(false);
    }
  }

  // ------------------------------------------------------------
  // PICK IMAGES
  // ------------------------------------------------------------
  Future<void> pickFrontImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) frontImage.value = File(picked.path);
  }

  Future<void> pickBackImage() async {
    if (selectedDocType.value == DocumentType.pan) {
      Get.snackbar("Info", "PAN does not require a back image");
      return;
    }

    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) backImage.value = File(picked.path);
  }

  // ------------------------------------------------------------
  // VALIDATION
  // ------------------------------------------------------------
  bool validateDocuments() {
    if (selectedDocType.value == null) {
      Get.snackbar("Missing", "Please select a document type");
      return false;
    }

    if (frontImage.value == null) {
      Get.snackbar("Missing", "Please upload front image");
      return false;
    }

    if (selectedDocType.value == DocumentType.aadhaar &&
        backImage.value == null) {
      Get.snackbar("Missing", "Aadhaar requires back image");
      return false;
    }

    return true;
  }

  // ------------------------------------------------------------
  // UPLOAD DOCUMENTS (MULTIPART USING uploadImageRequest)
  // ------------------------------------------------------------
  Future<void> uploadDocuments() async {
    if (!validateDocuments()) return;

    isLoading(true);

    try {
      final token = Get.find<GetStorage>().read(AppConst.ACCESS_TOKEN);

      log("📤 UPLOADING DOCUMENTS VIA uploadImageRequest()");

      // --------------------
      // FRONT FILE
      // --------------------
      final frontMultipart = await http.MultipartFile.fromPath(
        "front",
        frontImage.value!.path,
      );

      // --------------------
      // BACK FILE (AADHAAR ONLY)
      // --------------------
      http.MultipartFile? backMultipart;
      if (selectedDocType.value == DocumentType.aadhaar) {
        backMultipart = await http.MultipartFile.fromPath(
          "back",
          backImage.value!.path,
        );
      }

      // --------------------
      // BODY FIELDS
      // --------------------
      final Map<String, String> fields = {
        "type": selectedDocType.value!.name,
      };

      // --------------------
      // HEADERS
      // --------------------
      final headers = {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      };

      // --------------------
      // FIRST → Upload front image request.
      // But your API accepts all files in 1 request.
      // So we send MULTIPLE files manually.
      // --------------------

      var request = http.MultipartRequest("POST", Uri.parse(AppURLs.KYC_POST_API));
      request.headers.addAll(headers);
      request.fields.addAll(fields);

      // ADD FILES
      request.files.add(frontMultipart);
      if (backMultipart != null) request.files.add(backMultipart);

      // SEND
      var streamed = await request.send();
      var response = await http.Response.fromStream(streamed);

      log("📥 RESPONSE CODE: ${response.statusCode}");
      log("📥 RESPONSE BODY: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar("Success", "KYC submitted successfully!");
        fetchKycData(); // refresh
      } else {
        Get.snackbar("Error", "KYC failed: ${response.body}");
      }
    } catch (e, s) {
      log("❌ KYC UPLOAD ERROR: $e");
      log(s.toString());
      Get.snackbar("Error", "Upload failed: $e");
    } finally {
      isLoading(false);
    }
  }
}




// import 'dart:developer';
// import 'dart:io';

// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';

// import 'package:saoirse_app/models/LoginAuth/kycModel.dart';
// import 'package:saoirse_app/services/kyc_service.dart';

// class KycController extends GetxController {
//   final KycServices kycServices = KycServices();

//   // Observables
//   final Rxn<KycModel> kyc = Rxn<KycModel>();
//   final RxBool isLoading = false.obs;
//   final RxString errorMessage = ''.obs;

//   // Selected KYC Document Type
//   final Rxn<DocumentType> selectedDocType = Rxn<DocumentType>();

//   // Picked Images
//   final Rx<File?> frontImage = Rx<File?>(null);
//   final Rx<File?> backImage = Rx<File?>(null);

//   final ImagePicker picker = ImagePicker();

//   @override
//   void onInit() {
//     fetchKycData();
//     super.onInit();
//   }

//   // -------------------------------------------------------------------
//   // FETCH KYC STATUS
//   // -------------------------------------------------------------------
//   Future<void> fetchKycData() async {
//     try {
//       isLoading(true);
//       final data = await kycServices.getKyc();
//       kyc.value = data;
//     } catch (e) {
//       errorMessage.value = "Failed to fetch KYC: $e";
//     } finally {
//       isLoading(false);
//     }
//   }

//   // -------------------------------------------------------------------
//   // IMAGE PICKERS
//   // -------------------------------------------------------------------
//   Future<void> pickFrontImage() async {
//     final picked = await picker.pickImage(source: ImageSource.gallery);
//     if (picked != null) {
//       frontImage.value = File(picked.path);
//     }
//   }

//   Future<void> pickBackImage() async {
//     if (selectedDocType.value == DocumentType.pan) {
//       Get.snackbar("Info", "PAN card does not require a back image.");
//       return;
//     }

//     final picked = await picker.pickImage(source: ImageSource.gallery);
//     if (picked != null) {
//       backImage.value = File(picked.path);
//     }
//   }

//   // -------------------------------------------------------------------
//   // VALIDATION
//   // -------------------------------------------------------------------
//   bool validateDocuments() {
//     if (selectedDocType.value == null) {
//       Get.snackbar("Missing", "Please select document type.");
//       return false;
//     }

//     if (frontImage.value == null) {
//       Get.snackbar("Missing", "Please upload the front image.");
//       return false;
//     }

//     if (selectedDocType.value == DocumentType.aadhaar &&
//         backImage.value == null) {
//       Get.snackbar("Missing", "Aadhaar requires a back image.");
//       return false;
//     }

//     return true;
//   }

//   // -------------------------------------------------------------------
//   // SUBMIT DOCUMENTS (MULTIPART REQUEST)
//   // -------------------------------------------------------------------
//   Future<void> uploadDocuments() async {
//     if (!validateDocuments()) return;

//     isLoading(true);

//     try {
//       log("📌 Preparing multipart form-data...");

//       final formData = FormData({
//         "type": selectedDocType.value!.name,
//         "front": MultipartFile(
//           frontImage.value!,
//           filename: "front_${DateTime.now().millisecondsSinceEpoch}.jpg",
//         ),
//         if (selectedDocType.value == DocumentType.aadhaar)
//           "back": MultipartFile(
//             backImage.value!,
//             filename: "back_${DateTime.now().millisecondsSinceEpoch}.jpg",
//           ),
//       });

//       log("📤 Sending to KYC POST API...");

//       final success = await kycServices.submitKyc(formData);

//       if (success) {
//         Get.snackbar("Success", "KYC submitted successfully!");
//         await fetchKycData(); // refresh UI
//       } else {
//         Get.snackbar("Error", "KYC submission failed.");
//       }
//     } catch (e, s) {
//       log("❌ ERROR uploadDocuments(): $e");
//       log("STACKTRACE: $s");
//       Get.snackbar("Error", "Upload failed: $e");
//     } finally {
//       isLoading(false);
//     }
//   }
// }




