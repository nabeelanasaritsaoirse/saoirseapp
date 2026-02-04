import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:saoirse_app/models/create_review_response.dart';
import 'package:saoirse_app/models/review_image_upload_response.dart';
import 'package:http/http.dart' as http;

import '../constants/app_constant.dart';
import '../constants/app_urls.dart';
import '../main.dart';
import '../services/api_service.dart';
import '../models/review_eligibility_response.dart';

class ReviewService {
  Future<String?> _token() async {
    return storage.read(AppConst.ACCESS_TOKEN);
  }

  /// ================= CHECK REVIEW ELIGIBILITY =================
  Future<ReviewEligibilityResponse?> checkReviewEligibility(
    String productId,
  ) async {
    final token = await _token();

    final url = "${AppURLs.CAN_REVIEW_API}$productId";

    return APIService.getRequest<ReviewEligibilityResponse?>(
      url: url,
      headers: {
        "Authorization": "Bearer $token",
      },
      onSuccess: (data) {
        if (data["success"] == true) {
          return ReviewEligibilityResponse.fromJson(data);
        }
        return null;
      },
    );
  }






  /// ================= UPLOAD REVIEW IMAGES =================
  Future<List<ReviewImage>> uploadReviewImages(List<File> images) async {
  final token = await _token();

  final files = await Future.wait(
    images.map(
      (image) => http.MultipartFile.fromPath(
        'images', // 👈 backend expects THIS key
        image.path,
      ),
    ),
  );

   log("Uploading ${files.length} images");

  final response = await APIService.uploadMultiImagesRequest(
    url: AppURLs.UPLOAD_REVIEW_IMAGES_API,
    files: files,
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  if (response == null) {
    throw Exception('Image upload failed');
  }

  if (response.statusCode == 200) {
    final decoded = jsonDecode(response.body);
    final uploadResponse =
        ReviewImageUploadResponse.fromJson(decoded);

    return uploadResponse.images;
  } else {
    final decoded = jsonDecode(response.body);
    throw Exception(decoded['message'] ?? 'Upload failed');
  }
}




/// ================= CREATE REVIEW =================
// Future<CreateReviewResponse?> createReview({
//   required String productId,
//   required int rating,
//   required String title,
//   required String comment,
//   required List<ReviewImage> images,
// }) async {
//   final token = await _token();

//   final body = {
//     "productId": productId,
//     "rating": rating,
//     "title": title,
//     "comment": comment,
//     "images": images
//         .map((img) => {
//               "url": img.url,
//               "caption": img.caption,
//             })
//         .toList(),
//     "detailedRatings": {
//       "quality": rating,
//       "valueForMoney": rating,
//       "delivery": rating,
//       "accuracy": rating,
//     },
//   };

//   return APIService.postRequest<CreateReviewResponse>(
//     url: AppURLs.CREATE_REVIEW_API,
//     headers: {
//       "Authorization": "Bearer $token",
//       "Content-Type": "application/json",
//     },
//     body: body,
//     onSuccess: (json) {
//       // ✅ backend already sends { success, message, data }
//       if (json["success"] != true) {
//         throw Exception(json["message"] ?? "Failed to create review");
//       }
//       return CreateReviewResponse.fromJson(json);
//     },
//   );
// }

Future<CreateReviewResponse?> createReview({
  required String productId,
  required int rating,
  required String title,
  required String comment,
  List<ReviewImage>? images,
  Map<String, int>? detailedRatings, // ✅ ADD THIS
}) async {
  final token = await _token();

  final body = {
    "productId": productId,
    "rating": rating,
    "title": title,
    "comment": comment,
  };

  if (images != null && images.isNotEmpty) {
    body["images"] = images
        .map((img) => {
              "url": img.url,
              "caption": img.caption,
            })
        .toList();
  }

  if (detailedRatings != null) {
    body["detailedRatings"] = detailedRatings;
  }

  return APIService.postRequest<CreateReviewResponse>(
    url: AppURLs.CREATE_REVIEW_API,
    headers: {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    },
    body: body,
    onSuccess: (data) => CreateReviewResponse.fromJson(data),
  );
}



}


