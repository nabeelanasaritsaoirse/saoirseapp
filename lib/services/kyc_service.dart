import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:get_storage/get_storage.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

import '../constants/app_urls.dart';
import '../constants/app_constant.dart';
import '../models/LoginAuth/kyc_model.dart';

import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;

class KycServices {
  final box = GetStorage();
  // ================================================================
  // 1️⃣ UPLOAD SINGLE KYC IMAGE (PUT /api/kyc/upload)
  // ================================================================
  Future<Map<String, dynamic>> uploadKycImage({
    required File imageFile,
    required String type,
    required String side,
  }) async {
    final token = box.read(AppConst.ACCESS_TOKEN);
    final uri = Uri.parse(AppURLs.KYC_UPLOAD_API);

    final bytes = await imageFile.readAsBytes();

    final detectedMime =
        lookupMimeType(imageFile.path, headerBytes: bytes.take(16).toList()) ??
            'application/octet-stream';
    final mimeParts = detectedMime.split('/');

    var request = http.MultipartRequest("PUT", uri);
    request.headers["Authorization"] = "Bearer $token";

    // text fields
    request.fields["type"] = type; // selfie / aadhaar / pan / ...
    request.fields["side"] = side; // front / back

    final filename = path.basename(imageFile.path);
    final multipartFile = http.MultipartFile.fromBytes(
      "image",
      bytes,
      filename: filename,
      contentType: MediaType(mimeParts[0], mimeParts[1]),
    );
    request.files.add(multipartFile);

    final streamed = await request.send().timeout(
          const Duration(seconds: 60),
          onTimeout: () => throw TimeoutException('Upload took too long'),
        );

    final resp = await http.Response.fromStream(streamed);

    if (resp.statusCode == 200 || resp.statusCode == 201) {
      return jsonDecode(resp.body);
    } else {
      throw "Upload failed (${resp.statusCode}): ${resp.body}";
    }
  }

  // =====================================================================
  // 2️⃣ SUBMIT KYC (POST /api/kyc/submit)
  // =====================================================================
  Future<Map<String, dynamic>> submitKyc({
    required List<Map<String, dynamic>> documents,
  }) async {
    final token = box.read(AppConst.ACCESS_TOKEN);
    final uri = Uri.parse(AppURLs.KYC_SUBMIT_API);

    final response = await http.post(
      uri,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({"documents": documents}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw "KYC submit failed (${response.statusCode}): ${response.body}";
    }
  }

  // =====================================================================
  // 3️⃣ GET KYC STATUS (GET /api/kyc/status)
  // =====================================================================
  Future<KycModel> getKyc() async {
    final token = box.read(AppConst.ACCESS_TOKEN);
    final uri = Uri.parse(AppURLs.KYC_API);

    final response = await http.get(
      uri,
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
    );

    if (response.statusCode == 200) {
      return kycModelFromJson(response.body);
    } else {
      throw "Failed to fetch KYC status (${response.statusCode}): ${response.body}";
    }
  }
}
