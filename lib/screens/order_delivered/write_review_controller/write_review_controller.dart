import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:saoirse_app/models/review_image_upload_response.dart';
import 'package:saoirse_app/services/review_service.dart';

class WriteReviewController extends GetxController {
  final String productId;

  WriteReviewController({required this.productId});

  final ImagePicker _picker = ImagePicker();
  final ReviewService reviewService = ReviewService();

  // ================== REVIEW FORM STATE ==================
  RxInt reviewRating = 0.obs;
  RxString reviewText = "".obs;

  // ================== IMAGE SELECTION ==================
  RxList<XFile> reviewImages = <XFile>[].obs;
  static const int maxImages = 5;

  // ================== IMAGE UPLOAD STATE ==================
  RxBool isUploadingImages = false.obs;

  /// Uploaded S3 images (after upload)
  RxList<ReviewImage> uploadedImages = <ReviewImage>[].obs;

  final List<String> reviewRatingLabels = [
    "Terrible",
    "Bad",
    "Okay",
    "Good",
    "Great",
  ];

  // ================== RATING ==================
  void setReviewRating(int value) {
    reviewRating.value = value;
  }

  // ================== PICK IMAGES ==================
  Future<void> pickReviewImages() async {
    final remaining = maxImages - reviewImages.length;
    if (remaining <= 0) return;

    final picked = await _picker.pickMultiImage(imageQuality: 70);
    if (picked.isEmpty) return;

    reviewImages.addAll(picked.take(remaining));
  }

  // ================== REMOVE IMAGE ==================
  void removeReviewImage(int index) {
    reviewImages.removeAt(index);
  }

  // ================== REVIEW TEXT ==================
  void updateReviewText(String text) {
    reviewText.value = text;
  }

  // ================== RESET FORM ==================
  void resetReviewForm() {
    reviewRating.value = 0;
    reviewText.value = "";
    reviewImages.clear();
    uploadedImages.clear();
    isUploadingImages.value = false;
  }

  // ======================================================
  // STEP 1️⃣ UPLOAD IMAGES (S3)
  // ======================================================
  Future<bool> uploadImagesIfNeeded() async {
    if (reviewImages.isEmpty) return true;

    isUploadingImages.value = true;

    try {
      // Convert XFile → File
      final files = reviewImages.map((x) => File(x.path)).toList();

      final result = await reviewService.uploadReviewImages(files);
      uploadedImages.assignAll(result);
      return true;
    } catch (e) {
      Get.snackbar(
        "Upload Failed",
        e.toString().replaceAll("Exception:", ""),
      );
      return false;
    } finally {
      isUploadingImages.value = false;
    }
  }

  // ======================================================
  // STEP 2️⃣ SUBMIT REVIEW
  // ======================================================
  Future<bool> submitReview() async {
    // ================= VALIDATION =================
    if (reviewRating.value == 0) {
      Get.snackbar("Rating required", "Please select a star rating");
      return false;
    }

    if (reviewText.value.trim().isEmpty) {
      Get.snackbar("Review required", "Please write your feedback");
      return false;
    }

    if (reviewText.value.length > 2000) {
      Get.snackbar("Too long", "Review cannot exceed 2000 characters");
      return false;
    }

    // ================= STEP 1️⃣ UPLOAD IMAGES =================
    final uploaded = await uploadImagesIfNeeded();
    if (!uploaded) return false;

    // ================= STEP 2️⃣ CREATE REVIEW =================
    final response = await reviewService.createReview(
      productId: productId,
      rating: reviewRating.value,
      title: _generateTitleFromRating(),
      comment: reviewText.value.trim(),

      /// ✅ IMPORTANT: pass ReviewImage models
      images: uploadedImages.toList(),

      detailedRatings: {
        "quality": reviewRating.value,
        "valueForMoney": reviewRating.value,
        "delivery": reviewRating.value,
        "accuracy": reviewRating.value,
      },
    );

    if (response == null || response.success != true) {
      Get.snackbar(
        "Failed",
        response?.message ?? "Failed to submit review",
      );
      return false;
    }

    // ================= STEP 3️⃣ AUTO-MODERATION =================
    if (response.autoModeration?.isFlagged == true) {
      Get.snackbar(
        "Review Submitted",
        response.autoModeration!.message ??
            "Your review is under moderation",
      );
    } else {
      Get.snackbar("Success", "Review posted successfully");
    }

    resetReviewForm();
    return true;
  }

  // ================== TITLE GENERATOR ==================
  String _generateTitleFromRating() {
    switch (reviewRating.value) {
      case 5:
        return "Excellent product!";
      case 4:
        return "Very good";
      case 3:
        return "Good";
      case 2:
        return "Not great";
      default:
        return "Poor experience";
    }
  }
}
