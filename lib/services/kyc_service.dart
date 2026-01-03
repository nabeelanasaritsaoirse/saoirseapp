import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../constants/app_urls.dart';
import '../constants/app_constant.dart';
import '../models/LoginAuth/kyc_model.dart';
import 'package:path/path.dart' as path;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

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

    log(' Uploading file: ${imageFile.path}');
    log(' File size bytes: ${bytes.length}');
    log(' type field: $type, side field: $side');

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

    log("UPLOAD ${response.statusCode} → ${response.body}");

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
    final uri = Uri.parse(AppURLs.KYC_SUBMIT_API);

    final Map<String, dynamic> body = {
      "documents": documents,
    };

    if (aadhaarNumber != null) {
      body["aadhaarNumber"] = aadhaarNumber;
    }

    if (panNumber != null) {
      body["panNumber"] = panNumber;
    }

    final response = await http.post(
      uri,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode(body),
    );
    log(" SUBMIT DOCS → ${jsonEncode({"documents": documents})}");
    log(" SUBMIT RESPONSE (${response.statusCode}) → ${response.body}");
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw "KYC submit failed (${response.statusCode}): ${response.body}";
    }
  }

  // ===================== GET KYC =====================
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
    log("📥 GET KYC STATUS → ${response.statusCode}");
    log("📥 ${response.body}");

    if (response.statusCode == 200) {
      return kycModelFromJson(response.body);
    } else {
      throw "Failed to fetch KYC status (${response.statusCode}): ${response.body}";
    }
  }
}
