import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:get_storage/get_storage.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:saoirse_app/services/api_service.dart';

import '../constants/app_urls.dart';
import '../constants/app_constant.dart';
import '../models/LoginAuth/kyc_model.dart';

import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;

class KycServices {
  final box = GetStorage();

  // ===================== UPLOAD IMAGE =====================
  Future<Map<String, dynamic>> uploadKycImage({
    required File imageFile,
    required String type,
    required String side,
  }) async {
    final token = box.read(AppConst.ACCESS_TOKEN);
    final uri = Uri.parse(AppURLs.KYC_UPLOAD_API);

    final bytes = await imageFile.readAsBytes();
    final mime =
        lookupMimeType(imageFile.path, headerBytes: bytes.take(16).toList()) ??
            "image/jpeg";
    final mimeParts = mime.split('/');

    final request = http.MultipartRequest("PUT", uri);
    request.headers["Authorization"] = "Bearer $token";
    request.fields["type"] = type;
    request.fields["side"] = side;

    request.files.add(
      http.MultipartFile.fromBytes(
        "image",
        bytes,
        filename: path.basename(imageFile.path),
        contentType: MediaType(mimeParts[0], mimeParts[1]),
      ),
    );

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw response.body;
    }
  }

  // ===================== SUBMIT KYC =====================

  Future<Map<String, dynamic>> submitKyc({
  String? aadhaarNumber,
  String? panNumber,
  required List<Map<String, dynamic>> documents,
}) async {
  final token = box.read(AppConst.ACCESS_TOKEN);
  final uri = AppURLs.KYC_SUBMIT_API;

  final Map<String, dynamic> body = {
    "documents": documents,
  };

  if (aadhaarNumber != null) {
    body["aadhaarNumber"] = aadhaarNumber;
  }

  if (panNumber != null) {
    body["panNumber"] = panNumber;
  }

  final result = await APIService.postRequest<Map<String, dynamic>>(
    url: uri,
    body: body,
    headers: {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    },
    onSuccess: (data) {
      log("KYC_SUBMIT_SUCCESS: ${jsonEncode(data)}");
      return data;
    },
  );

  if (result == null) {
    throw "KYC submit failed";
  }

  return result;
}



Future<KycModel> getKyc() async {
  final token = box.read(AppConst.ACCESS_TOKEN);
  final uri = AppURLs.KYC_API;

  final result = await APIService.getRequest<KycModel>(
    url: uri,
    headers: {
      "Authorization": "Bearer $token",
      "Accept": "application/json",
    },
    onSuccess: (data) {
      log("KYC_GET_SUCCESS: ${jsonEncode(data)}");
      // Convert the map back to JSON string
      return kycModelFromJson(jsonEncode(data));
    },
  );

  if (result == null) {
    throw "Failed to fetch KYC status";
  }

  return result;
}
  
}
