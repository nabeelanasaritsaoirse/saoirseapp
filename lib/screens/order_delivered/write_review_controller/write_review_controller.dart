import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
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
  final TextEditingController reviewTextController = TextEditingController();

  // ================== IMAGE SELECTION ==================
  RxList<XFile> reviewImages = <XFile>[].obs;
  static const int maxImages = 5;

  // ================== IMAGE UPLOAD STATE ==================
  RxBool isUploadingImages = false.obs;

  RxInt currentUploadIndex = 0.obs; // Which image is being uploaded (1-5)
  RxInt totalUploadCount = 0.obs;

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

    final picked = await _picker.pickMultiImage(imageQuality: 50);
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
    reviewTextController.clear(); // clear text input
    reviewImages.clear();
    uploadedImages.clear();
    isUploadingImages.value = false;
    currentUploadIndex.value = 0;
    totalUploadCount.value = 0;
  }

  // ======================================================
  // STEP 1️⃣ UPLOAD IMAGES (S3)
  // ======================================================
  

  Future<bool> uploadImagesIfNeeded() async {
    if (reviewImages.isEmpty) return true;

    isUploadingImages.value = true;
    totalUploadCount.value = reviewImages.length;
    currentUploadIndex.value = 0;

    try {
      final files = reviewImages.map((x) => File(x.path)).toList();

      // ✅ Upload with progress callback
      final result = await reviewService.uploadReviewImages(
        files,
        onProgress: (current, total) {
          currentUploadIndex.value = current;
          totalUploadCount.value = total;
        },
      );

      uploadedImages.assignAll(result);
      return true;
    } catch (e) {
      Get.snackbar(
        "Upload Failed",
        e.toString().replaceAll("Exception:", "").replaceAll("Exception: ", ""),
        duration: const Duration(seconds: 5),
      );
      return false;
    } finally {
      isUploadingImages.value = false;
      currentUploadIndex.value = 0;
      totalUploadCount.value = 0;
    }
  }

  // ======================================================
  // STEP 2️⃣ SUBMIT REVIEW
  // ======================================================
  //


  Future<bool> submitReview() async {
    log("STEP 1: submitReview started");

    if (reviewRating.value == 0) {
      Get.snackbar("Rating required", "Please select a star rating");
      return false;
    }

    final text = reviewTextController.text.trim();

    if (text.isEmpty) {
      Get.snackbar("Review required", "Please write your feedback");
      return false;
    }

    log("STEP 2: validation passed");

    final uploaded = await uploadImagesIfNeeded();
    log("STEP 3: uploadImagesIfNeeded result = $uploaded");

    if (!uploaded) return false;

    log("STEP 4: calling createReview API");

    final response = await reviewService.createReview(
      productId: productId,
      rating: reviewRating.value,
      title: _generateTitleFromRating(),
      comment: text, // ✅ FIXED
      images: uploadedImages.toList(),
      detailedRatings: {
        "quality": reviewRating.value,
        "valueForMoney": reviewRating.value,
        "delivery": reviewRating.value,
        "accuracy": reviewRating.value,
      },
    );

    log("STEP 5: createReview response = $response");

    if (response == null || response.success != true) {
      Get.snackbar(
        "Failed",
        response?.message ?? "Failed to submit review",
      );
      return false;
    }

   
    resetReviewForm();

    if (Get.isDialogOpen == true) {
      Get.back(result: true);
    }

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
