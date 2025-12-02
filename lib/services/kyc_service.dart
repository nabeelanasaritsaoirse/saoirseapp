import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'package:saoirse_app/screens/kyc/kyc_controller.dart';

import '/constants/app_constant.dart';
import '/constants/app_urls.dart';

import '/main.dart';
import '/models/LoginAuth/kycModel.dart';
import '/services/api_service.dart';

class KycServices {
  Future<KycModel?> getKyc() async {
    final token = storage.read(AppConst.ACCESS_TOKEN);

    try {
      final url = AppURLs.KYC_API;

      log("KYC API URL: $url");
      log("TOKEN: $token");

      if (token == null || token.isEmpty) {
        log("NO TOKEN FOUND IN STORAGE");
        return null;
      }

      KycModel? model;

      await APIService.getRequest(
        url: url,
        headers: {
          'Authorization': 'Bearer $token', // FIXED
          'Content-Type': 'application/json',
        },
        onSuccess: (json) {
          log("KYC JSON: $json");
          model = KycModel.fromJson(json);
        },
      );

      return model;
    } catch (e) {
      log("KYC API ERROR: $e");
      return null;
    }
  }

  Future<bool> uploadDocument({
    required DocumentType docType,
    required File front,
    File? back,
  }) async {
    final token = storage.read(AppConst.ACCESS_TOKEN);
    final url = AppURLs.KYC_POST_API;

    if (token == null || token.isEmpty) {
      log("uploadDocument: no token found");
      return false;
    }

    try {
      log("uploadDocument -> url: $url");
      log("uploadDocument -> docType: $docType");
      log("uploadDocument -> front path: ${front.path} (${await front.length()} bytes)");
      if (back != null) {
        log("uploadDocument -> back path: ${back.path} (${await back.length()} bytes)");
      }

      final request = http.MultipartRequest("POST", Uri.parse(url));

      // Required headers (don't set content-type yourself for MultipartRequest)
      request.headers['Authorization'] = 'Bearer $token';
      log("KYC API POST $token ");

      // Fields (use the names expected by your backend)
      // If your backend expects 'document_type' use that; adjust if needed.
      request.fields['document_type'] =
          docType == DocumentType.aadhaar ? 'aadhaar' : 'pan';

      // Attach files — use field names your backend expects. I used "front_image"/"back_image".
      request.files
          .add(await http.MultipartFile.fromPath('front_image', front.path));

      if (docType == DocumentType.aadhaar && back != null) {
        request.files
            .add(await http.MultipartFile.fromPath('back_image', back.path));
      }

      final streamedResp = await request.send();

      // Read response body fully (important to debug)
      final respStr = await streamedResp.stream.bytesToString();
      log("uploadDocument -> status: ${streamedResp.statusCode}");
      log("uploadDocument -> body: $respStr");

      // Try to parse JSON body if present to inspect server message
      try {
        final parsed = json.decode(respStr);
        log("uploadDocument -> parsedResponse: $parsed");
      } catch (_) {
        // Not JSON — ignore parse error (we already logged the raw body)
      }

      // treat any 2xx as success
      if (streamedResp.statusCode >= 200 && streamedResp.statusCode < 300) {
        return true;
      } else {
        return false;
      }
    } catch (e, st) {
      log("uploadDocument EXCEPTION: $e\n$st");
      return false;
    }
  }
}
