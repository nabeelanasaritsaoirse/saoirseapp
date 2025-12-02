import 'dart:io';
import 'dart:developer';
import 'package:http/http.dart' as http;

class S3UploadService {
  static const String uploadUrl = "http://13.127.15.87:8080/api/kyc/submit"; 
  // Replace with your actual upload URL

  static Future<String?> uploadFile(File file) async {
    try {
      final request = http.MultipartRequest("POST", Uri.parse(uploadUrl));

      request.files.add(
        await http.MultipartFile.fromPath(
          "file",
          file.path,
        ),
      );

      final response = await request.send();

      if (response.statusCode == 200) {
        final res = await response.stream.bytesToString();
        log("S3 Upload Response: $res");
        return res; // Return your final file URL
      } else {
        log("❌ Upload failed with status: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      log("❌ S3 Upload Error: $e");
      return null;
    }
  }
}
