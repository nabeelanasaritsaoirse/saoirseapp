

import 'dart:developer';
import 'package:get_storage/get_storage.dart';

import '/constants/app_constant.dart';
import '/constants/app_urls.dart';
import '/models/LoginAuth/kycModel.dart';
import '/services/api_service.dart';
import 'package:http/http.dart' as http;

enum DocumentType { aadhaar, pan }

class KycServices {
  final storage = GetStorage();

  /// ================================================================
  /// GET KYC STATUS
  /// ================================================================
  Future<KycModel?> getKyc() async {
    final token = storage.read(AppConst.ACCESS_TOKEN);

    if (token == null || token.isEmpty) {
      log("❌ No token found for GET KYC");
      return null;
    }

    log("📌 GET KYC → ${AppURLs.KYC_API}");

    try {
      KycModel? model;

      await APIService.getRequest(
        url: AppURLs.KYC_API,
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
        onSuccess: (json) {
          log("📥 KYC RESPONSE: $json");
          model = KycModel.fromJson(json);
        },
      );

      return model;
    } catch (e, s) {
      log("❌ KYC GET ERROR: $e");
      log(s.toString());
      return null;
    }
  }

  /// ================================================================
  /// SUBMIT KYC DOCUMENTS (MULTIPART FILES)
  /// ================================================================
  ///
  ///  This function matches the KycController:
  ///  
  ///   - type (aadhaar / pan)
  ///   - front (file)
  ///   - back (file? optional)
  ///
  Future<bool> submitKycMultipart({
    required String docType,
    required http.MultipartFile frontFile,
    http.MultipartFile? backFile,
  }) async {
    final token = storage.read(AppConst.ACCESS_TOKEN);

    if (token == null || token.isEmpty) {
      log("❌ No token found for POST KYC");
      return false;
    }

    log("📤 SUBMITTING KYC → ${AppURLs.KYC_POST_API}");

    try {
      var request = http.MultipartRequest(
        "POST",
        Uri.parse(AppURLs.KYC_POST_API),
      );

      // Headers
      request.headers.addAll({
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      });

      // Body fields
      request.fields["type"] = docType;

      // Files
      request.files.add(frontFile);
      if (backFile != null) request.files.add(backFile);

      // Send
      var streamed = await request.send();
      var response = await http.Response.fromStream(streamed);

      log("📥 RESPONSE CODE: ${response.statusCode}");
      log("📥 RESPONSE BODY: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }

      return false;
    } catch (e, s) {
      log("❌ KYC MULTIPART ERROR: $e");
      log(s.toString());
      return false;
    }
  }
}

