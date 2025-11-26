import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:saoirse_app/main.dart' show storage;

import '../constants/app_constant.dart';
import '../constants/app_urls.dart';
import '../models/profile_response.dart';
import 'api_service.dart';

class ProfileService {
  final token = storage.read(AppConst.ACCESS_TOKEN);

  // ------- Fetch Profile ---------
  Future<UserProfileModel?> fetchProfile() async {
    try {
      final url = AppURLs.MY_PROFILE;

      print("==========================================");
      print(" PROFILE API CALL");
      print("URL        : $url");
      print("TOKEN      : $token");
      print("==========================================");

      final response = await APIService.getRequest(
        url: url,
        headers: {
          "Authorization": "Bearer $token",
        },
        onSuccess: (data) => data,
      );

      print(" RAW RESPONSE: $response");

      if (response == null) {
        print(" RESPONSE IS NULL");
        return null;
      }

      final parsed = UserProfileModel.fromJson(response);

      print(" PARSED SUCCESS:");
      print("User Name  : ${parsed.user.name}");
      print("Email      : ${parsed.user.email}");
      print("Phone      : ${parsed.user.phoneNumber}");
      print("==========================================");

      return parsed;
    } catch (e) {
      print(" Profile fetch error: $e");
      return null;
    }
  }

  // -------- UPDATE PROFILE PICTURE --------
  Future<bool> updateProfilePicture(String userId, String imagePath) async {
    try {
      final url = "${AppURLs.BASE_API}api/users/$userId/profile-picture";

      print("============================================");
      print(" UPLOADING PROFILE IMAGE");
      print("URL         : $url");
      print("User ID     : $userId");
      print("TOKEN       : $token");
      print("IMAGE PATH  : $imagePath");
      print("============================================");

      // ---- FORCE NEW FILE NAME WITH .jpg ----
      final originalFile = File(imagePath);
      final tempDir = Directory.systemTemp;
      final newPath =
          "${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg";

      final newFile = await originalFile.copy(newPath);

      print("NEW FILE PATH: $newPath");

      // ---- Convert to MultipartFile ----
      final multipart = await http.MultipartFile.fromPath(
        "image", // FIXED FIELD NAME
        newFile.path,
        contentType: MediaType("image", "jpeg"), //FORCE JPEG
      );

      final response = await APIService.uploadImageRequest(
        url: url,
        method: "PUT",
        file: multipart,
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      if (response == null) {
        print(" NULL RESPONSE");
        return false;
      }

      print("STATUS: ${response.statusCode}");
      print("BODY: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        print(" IMAGE UPLOADED SUCCESSFULLY");
        return true;
      }

      print(" IMAGE UPLOAD FAILED");
      return false;
    } catch (e) {
      print(" Exception during image upload: $e");
      return false;
    }
  }
}
