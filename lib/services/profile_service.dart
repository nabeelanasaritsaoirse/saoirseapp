// ignore_for_file: avoid_print

import 'dart:io';

import 'package:http/http.dart';

import '../constants/app_constant.dart';
import '../constants/app_urls.dart';
import '../main.dart';
import '../models/profile_response.dart';
import 'api_service.dart';

import 'package:http/http.dart' as http;

class ProfileService {
  final token = storage.read(AppConst.ACCESS_TOKEN);

  // ------- Fetch Profile ---------
  // Future<UserProfileModel?> fetchProfile() async {
  //   try {
  //     final url = AppURLs.MY_PROFILE;

  //     print("==========================================");
  //     print(" PROFILE API CALL");
  //     print("URL        : $url");
  //     print("TOKEN      : $token");
  //     print("==========================================");

  //     final response = await APIService.getRequest(
  //       url: url,
  //       headers: {
  //         "Authorization": "Bearer $token",
  //       },
  //       onSuccess: (data) => data,
  //     );

  //     print(" RAW RESPONSE: $response");

  //     if (response == null) {
  //       print(" RESPONSE IS NULL");
  //       return null;
  //     }

  //     final parsed = UserProfileModel.fromJson(response);

  //     print(" PARSED SUCCESS:");
  //     print("User Name  : ${parsed.user.name}");
  //     print("Email      : ${parsed.user.email}");
  //     print("Phone      : ${parsed.user.phoneNumber}");
  //     print("==========================================");

  //     return parsed;
  //   } catch (e) {
  //     print(" Profile fetch error: $e");
  //     return null;
  //   }
  // }

      Future<UserProfileModel?> fetchProfile() async {
    try {
      final url = AppURLs.MY_PROFILE;

      print("Calling PROFILE API...");
      print("TOKEN: $token");

      final response = await APIService.getRequest<UserProfileModel>(
        url: url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },

        // ⬇️ THIS maps JSON → UserProfileModel
        onSuccess: (json) {
          print("PROFILE DATA RECEIVED");
          return UserProfileModel.fromJson(json);
        },
      );

      return response;
    } catch (e) {
      print("Profile fetch error: $e");
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

  // ----------------UPDATE PROFILE NAME (ONLY)----------------
  Future<bool> updateUserName(String userId, String name) async {
    try {
      final token = storage.read(AppConst.ACCESS_TOKEN);

      final response = await APIService.putRequest(
        url: AppURLs.USER_UPDATE_API + userId,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: {
          "name": name,
        },
        onSuccess: (data) => data,
      );

      if (response != null && response["success"] == true) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> logout() async {
    try {
      final token = storage.read(AppConst.ACCESS_TOKEN);

      final response = await APIService.postRequest(
        url: AppURLs.LOGOUT_API, // /api/auth/logout
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        // No body required
        body: {},
        onSuccess: (json) => json,
      );

      print("LOGOUT RESPONSE: $response");

      if (response == null) return false;

      return response["success"] == true;
    } catch (e) {
      print("Logout Error: $e");
      return false;
    }
  }
}
