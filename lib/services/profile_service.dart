import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart';

import '../constants/app_constant.dart';
import '../constants/app_urls.dart';
import '../main.dart';
import '../models/delete_acc_model.dart';
import '../models/profile_response.dart';
import 'api_service.dart';

import 'package:http/http.dart' as http;

class ProfileService {
  final token = storage.read(AppConst.ACCESS_TOKEN);

  Future<UserProfileModel?> fetchProfile() async {
    try {
      final url = AppURLs.MY_PROFILE;

      final response = await APIService.getRequest<UserProfileModel>(
        url: url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },

        // ⬇️ THIS maps JSON → UserProfileModel
        onSuccess: (json) {
          return UserProfileModel.fromJson(json);
        },
      );

      return response;
    } catch (e) {
      return null;
    }
  }

  // -------- UPDATE PROFILE PICTURE --------
  Future<bool> updateProfilePicture(String userId, String imagePath) async {
    try {
      final url = "${AppURLs.BASE_API}api/users/$userId/profile-picture";

      // ---- FORCE NEW FILE NAME WITH .jpg ----
      final originalFile = File(imagePath);
      final tempDir = Directory.systemTemp;
      final newPath =
          "${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg";

      final newFile = await originalFile.copy(newPath);

      // ---- Convert to MultipartFile ----
      final multipart = await http.MultipartFile.fromPath(
        "file", // FIXED FIELD NAME
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
        return false;
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }

      return false;
    } catch (e) {
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

      if (response == null) return false;

      return response["success"] == true;
    } catch (e) {
      return false;
    }
  }

 //     Delete Account 

Future<Map<String, dynamic>?> requestAccountDeletion(String userId) async {
  try {
    final token = storage.read(AppConst.ACCESS_TOKEN);
    final url = "${AppURLs.BASE_API}api/users/$userId/request-deletion";

    return await APIService.postRequest(
      url: url,
      headers: {
        "Authorization": "Bearer $token",
       
      },
      body: {
        "reason": "User requested account deletion"
      },
      onSuccess: (json) => json,
    );
  } catch (e) {
    log("Delete account error: $e");
    return null;
  }
}


  Future<DeleteAccountModel> getDeleteInfo() async {
    final token = storage.read(AppConst.ACCESS_TOKEN);
    final userId = storage.read(AppConst.USER_ID);

    final uri = Uri.parse(
      "${AppURLs.BASE_API}api/users/$userId/deletion-info",
    );

  

    final response = await http.get(
      uri,
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      return DeleteAccountModel.fromJson(
        jsonDecode(response.body),
      );
    } else {
      throw Exception(
        "Failed to load DELETE INFO (${response.statusCode})",
      );
    }
  }
}
