import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
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


  /// ================= CONVERT ANY IMAGE TO JPEG =================
  /// Uses flutter_image_compress to ensure valid JPEG output
  Future<File> _ensureJpeg(File imageFile) async {
    try {
      final dir = await getTemporaryDirectory();
      final fileName = path.basenameWithoutExtension(imageFile.path);
      final targetPath =
          '${dir.path}/${fileName}_${DateTime.now().millisecondsSinceEpoch}.jpg';

      

      // Compress and convert to JPEG
      final result = await FlutterImageCompress.compressAndGetFile(
        imageFile.absolute.path,
        targetPath,
        quality: 85, // High quality JPEG
        format: CompressFormat.jpeg, // Force JPEG format
      );

      if (result == null) {
        
        return imageFile;
      }

      final resultFile = File(result.path);
      // final originalSize = imageFile.lengthSync();
      // final compressedSize = resultFile.lengthSync();

      // log("✓ Converted to JPEG:");
      // log("  Original: ${(originalSize / 1024 / 1024).toStringAsFixed(2)} MB");
      // log("  Compressed: ${(compressedSize / 1024 / 1024).toStringAsFixed(2)} MB");
      // log("  Saved: ${((1 - compressedSize / originalSize) * 100).toStringAsFixed(1)}%");

      return resultFile;
    } catch (e) {
      log("JPEG conversion failed: $e");
      log("Using original file");
      return imageFile;
    }
  }

  /// ================= UPLOAD REVIEW IMAGES (ONE AT A TIME) =================
  Future<List<ReviewImage>> uploadReviewImages(
    List<File> images, {
    Function(int current, int total)? onProgress,
  }) async {
    final token = await _token();
    final uploadedImages = <ReviewImage>[];

    log("Starting upload of ${images.length} images (one at a time)");

    for (int i = 0; i < images.length; i++) {
      try {
        // ✅ CRITICAL: Convert to JPEG first
        final jpegFile = await _ensureJpeg(images[i]);

        final bytes = jpegFile.lengthSync();
        final mb = (bytes / 1024 / 1024).toStringAsFixed(2);
        log("Uploading image ${i + 1}/${images.length} ($mb MB)");

        // Notify progress
        if (onProgress != null) {
          onProgress(i + 1, images.length);
        }

        // Create multipart file with JPEG MIME type
        final file = await http.MultipartFile.fromPath(
          'images',
          jpegFile.path,
          contentType: http.MediaType('image', 'jpeg'),
        );

        log("Sending file: ${path.basename(jpegFile.path)} as image/jpeg");

        // Upload
        final response = await APIService.uploadMultiImagesRequest(
          url: AppURLs.UPLOAD_REVIEW_IMAGES_API,
          files: [file],
          headers: {
            'Authorization': 'Bearer $token',
          },
          timeoutSeconds: 60,
        );

        if (response == null) {
          throw Exception(
            'Failed to upload image ${i + 1}/${images.length}. Please check your connection.',
          );
        }

        log("Response status: ${response.statusCode}");

        if (response.statusCode == 200) {
          final decoded = jsonDecode(response.body);
          final uploadResponse = ReviewImageUploadResponse.fromJson(decoded);

          if (uploadResponse.images.isNotEmpty) {
            uploadedImages.addAll(uploadResponse.images);
            log(" Image ${i + 1}/${images.length} uploaded successfully");
          } else {
            throw Exception('No image data returned for image ${i + 1}');
          }
        } else if (response.statusCode == 401) {
          throw Exception('Session expired. Please login again.');
        } else if (response.statusCode == 413) {
          throw Exception(
            'Image ${i + 1} is too large. Please select a smaller image.',
          );
        } else if (response.statusCode == 400 || response.statusCode == 500) {
          final decoded = jsonDecode(response.body);
          final errorMsg =
              decoded['error'] ?? decoded['message'] ?? 'Unknown error';
          log("Response body: ${response.body}");
          throw Exception('Image ${i + 1}: $errorMsg');
        } else {
          final decoded = jsonDecode(response.body);
          throw Exception(
            decoded['message'] ??
                'Upload failed for image ${i + 1} (Status: ${response.statusCode})',
          );
        }
      } catch (e) {
        log("Failed to upload image ${i + 1}: $e");
        rethrow;
      }
    }

    log(" All ${images.length} images uploaded successfully");
    return uploadedImages;
  }

  

  Future<CreateReviewResponse?> createReview({
    required String productId,
    required int rating,
    required String title,
    required String comment,
    List<ReviewImage>? images,
    Map<String, int>? detailedRatings,
  }) async {
    try {
      final token = await _token();

      // Token safety check
      if (token == null || token.isEmpty) {
        log("CREATE REVIEW ERROR: Token is null or empty");
        throw Exception("User not authenticated");
      }

      final body = {
        "productId": productId,
        "rating": rating,
        "title": title,
        "comment": comment,
      };

      // ✅ Add images if present
      if (images != null && images.isNotEmpty) {
        body["images"] = images
            .map((img) => {
                  "url": img.url,
                  "caption": img.caption,
                })
            .toList();
      }

      // ✅ Add detailed ratings if present
      if (detailedRatings != null) {
        body["detailedRatings"] = detailedRatings;
      }

      // 🪵 Debug logs
      log("CREATE REVIEW TOKEN: $token");
      log("CREATE REVIEW URL: ${AppURLs.CREATE_REVIEW_API}");
      log("CREATE REVIEW BODY: ${jsonEncode(body)}");

      final response = await APIService.postRequest<CreateReviewResponse>(
        url: AppURLs.CREATE_REVIEW_API,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: body,
        onSuccess: (data) {
          log("CREATE REVIEW SUCCESS RESPONSE: $data");
          return CreateReviewResponse.fromJson(data);
        },
      );

      if (response == null) {
        log(" CREATE REVIEW FAILED: API returned null");
      }

      return response;
    } catch (e, stack) {
      log("CREATE REVIEW EXCEPTION: $e");
      log(stack.toString());
      return null;
    }
  }
}
