import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:saoirse_app/models/review_image_upload_response.dart';
import 'package:saoirse_app/services/review_service.dart';

import '../../../models/own_review_resposne_model.dart'
    show Review, ReviewImages;
import '../../../my_review/my_review_controller.dart';

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

  RxInt currentUploadIndex = 0.obs;
  RxInt totalUploadCount = 0.obs;

  /// ================== EDIT MODE ==================
  var isEditMode = false.obs;
  String? editingReviewId;

  RxList<ReviewImages> existingImages = <ReviewImages>[].obs;
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

  // ================== LOAD EXISTING REVIEW ==================
  void loadExistingReview(Review review) {
    isEditMode.value = true;
    editingReviewId = review.id;

    /// Set rating
    reviewRating.value = review.rating;

    /// Set comment
    reviewTextController.text = review.comment;

    /// Clear picked images
    reviewImages.clear();
    uploadedImages.clear();

    /// Load existing images
    existingImages.assignAll(review.images);
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

  void removeExistingImage(int index) {
    existingImages.removeAt(index);
  }

  // ================== REVIEW TEXT ==================
  void updateReviewText(String text) {
    reviewText.value = text;
  }

  // ================== RESET FORM ==================
  void resetReviewForm() {
    reviewRating.value = 0;

    reviewTextController.clear();
    reviewImages.clear();
    uploadedImages.clear();
    existingImages.clear();

    isUploadingImages.value = false;
    currentUploadIndex.value = 0;
    totalUploadCount.value = 0;

    isEditMode.value = false;
    editingReviewId = null;
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
  // STEP 2️⃣ SUBMIT REVIEW (CREATE OR UPDATE)
  // ======================================================

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

    log("STEP 4: deciding create or update");

    bool success = false;

    if (isEditMode.value && editingReviewId != null) {
      /// Convert uploaded images to ReviewImages model
      // final convertedUploadedImages = uploadedImages
      //     .map(
      //       (e) => ReviewImages(
      //         url: e.url,
      //         thumbnail: e.thumbnail,
      //         caption: e.caption,
      //         isProcessed: true,
      //         uploadedAt: DateTime.now(),
      //       ),
      //     )
      //     .toList();

      // /// ================= UPDATE REVIEW =================
      // final response = await reviewService.updateReview(
      //   reviewId: editingReviewId!,
      //   rating: reviewRating.value,
      //   title: _generateTitleFromRating(),
      //   comment: text,
      //   images: [
      //     ...existingImages,
      //     ...convertedUploadedImages,
      //   ],
      //   detailedRatings: {
      //     "quality": reviewRating.value,
      //     "valueForMoney": reviewRating.value,
      //     "delivery": reviewRating.value,
      //     "accuracy": reviewRating.value,
      //   },
      // );

      /// Convert existing images → ReviewImage
      final convertedExistingImages = existingImages
          .map(
            (e) => ReviewImage(
              url: e.url,
              thumbnail: e.thumbnail,
              caption: e.caption,
            ),
          )
          .toList();

      /// Convert uploaded images → ReviewImage
      final convertedUploadedImages = uploadedImages
          .map(
            (e) => ReviewImage(
              url: e.url,
              thumbnail: e.thumbnail,
              caption: e.caption,
            ),
          )
          .toList();

      final response = await reviewService.updateReview(
        reviewId: editingReviewId!,
        rating: reviewRating.value,
        title: _generateTitleFromRating(),
        comment: text,
        images: [
          ...convertedExistingImages,
          ...convertedUploadedImages,
        ],
        detailedRatings: {
          "quality": reviewRating.value,
          "valueForMoney": reviewRating.value,
          "delivery": reviewRating.value,
          "accuracy": reviewRating.value,
        },
      );

      log("STEP 5: updateReview response = $response");

      success = response != null && response.success == true;
    } else {
      /// ================= CREATE REVIEW =================
      final response = await reviewService.createReview(
        productId: productId,
        rating: reviewRating.value,
        title: _generateTitleFromRating(),
        comment: text,
        images: uploadedImages.toList(),
        detailedRatings: {
          "quality": reviewRating.value,
          "valueForMoney": reviewRating.value,
          "delivery": reviewRating.value,
          "accuracy": reviewRating.value,
        },
      );

      log("STEP 5: createReview response = $response");

      success = response != null && response.success == true;
    }

    if (!success) {
      Get.snackbar("Failed", "Failed to submit review");
      return false;
    }

    /// Reset form
    resetReviewForm();

    /// Close dialog
    if (Get.isDialogOpen == true) {
      Get.back(result: true);
    }

    /// Refresh My Reviews screen if open
    if (Get.isRegistered<MyReviewController>()) {
      Get.find<MyReviewController>().fetchMyReviews();
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











// import 'dart:developer';
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:saoirse_app/models/review_image_upload_response.dart';
// import 'package:saoirse_app/services/review_service.dart';

// import '../../../models/own_review_resposne_model.dart'
//     show Review;
// import '../../../my_review/my_review_controller.dart';

// class WriteReviewController extends GetxController {
//   final String productId;

//   WriteReviewController({required this.productId});

//   final ImagePicker _picker = ImagePicker();
//   final ReviewService reviewService = ReviewService();

//   // ================== REVIEW FORM STATE ==================
//   RxInt reviewRating = 0.obs;
//   RxString reviewText = "".obs;
//   final TextEditingController reviewTextController = TextEditingController();

//   // ================== IMAGE SELECTION ==================
//   RxList<XFile> reviewImages = <XFile>[].obs;
//   static const int maxImages = 5;

//   // ================== IMAGE UPLOAD STATE ==================
//   RxBool isUploadingImages = false.obs;

//   RxInt currentUploadIndex = 0.obs;
//   RxInt totalUploadCount = 0.obs;

//   /// ================== EDIT MODE ==================
//   var isEditMode = false.obs;
//   String? editingReviewId;

//   /// Existing images from API (for edit mode)
//   RxList<ReviewImage> existingImages = <ReviewImage>[].obs;

//   /// Uploaded S3 images (after upload)
//   RxList<ReviewImage> uploadedImages = <ReviewImage>[].obs;

//   final List<String> reviewRatingLabels = [
//     "Terrible",
//     "Bad",
//     "Okay",
//     "Good",
//     "Great",
//   ];

//   // ================== RATING ==================
//   void setReviewRating(int value) {
//     reviewRating.value = value;
//   }

//   // ================== LOAD EXISTING REVIEW ==================
//   void loadExistingReview(Review review) {
//     isEditMode.value = true;
//     editingReviewId = review.id;

//     /// Set rating
//     reviewRating.value = review.rating;

//     /// Set comment
//     reviewTextController.text = review.comment;

//     /// Clear picked images
//     reviewImages.clear();
//     uploadedImages.clear();

//     /// Load existing images
//     existingImages.assignAll(review.images);
//   }

//   // ================== PICK IMAGES ==================
//   Future<void> pickReviewImages() async {
//     final remaining = maxImages - reviewImages.length;
//     if (remaining <= 0) return;

//     final picked = await _picker.pickMultiImage(imageQuality: 50);
//     if (picked.isEmpty) return;

//     reviewImages.addAll(picked.take(remaining));
//   }

//   // ================== REMOVE IMAGE ==================
//   void removeReviewImage(int index) {
//     reviewImages.removeAt(index);
//   }

//   void removeExistingImage(int index) {
//     existingImages.removeAt(index);
//   }

//   // ================== REVIEW TEXT ==================
//   void updateReviewText(String text) {
//     reviewText.value = text;
//   }

//   // ================== RESET FORM ==================
//   void resetReviewForm() {
//     reviewRating.value = 0;

//     reviewTextController.clear();
//     reviewImages.clear();
//     uploadedImages.clear();
//     existingImages.clear();

//     isUploadingImages.value = false;
//     currentUploadIndex.value = 0;
//     totalUploadCount.value = 0;

//     isEditMode.value = false;
//     editingReviewId = null;
//   }

//   // ======================================================
//   // STEP 1️⃣ UPLOAD IMAGES (S3)
//   // ======================================================

//   Future<bool> uploadImagesIfNeeded() async {
//     if (reviewImages.isEmpty) return true;

//     isUploadingImages.value = true;
//     totalUploadCount.value = reviewImages.length;
//     currentUploadIndex.value = 0;

//     try {
//       final files = reviewImages.map((x) => File(x.path)).toList();

//       final result = await reviewService.uploadReviewImages(
//         files,
//         onProgress: (current, total) {
//           currentUploadIndex.value = current;
//           totalUploadCount.value = total;
//         },
//       );

//       uploadedImages.assignAll(result);
//       return true;
//     } catch (e) {
//       Get.snackbar(
//         "Upload Failed",
//         e.toString().replaceAll("Exception:", "").replaceAll("Exception: ", ""),
//         duration: const Duration(seconds: 5),
//       );
//       return false;
//     } finally {
//       isUploadingImages.value = false;
//       currentUploadIndex.value = 0;
//       totalUploadCount.value = 0;
//     }
//   }

//   // ======================================================
//   // STEP 2️⃣ SUBMIT REVIEW (CREATE OR UPDATE)
//   // ======================================================

//   Future<bool> submitReview() async {
//     log("STEP 1: submitReview started");

//     if (reviewRating.value == 0) {
//       Get.snackbar("Rating required", "Please select a star rating");
//       return false;
//     }

//     final text = reviewTextController.text.trim();

//     if (text.isEmpty) {
//       Get.snackbar("Review required", "Please write your feedback");
//       return false;
//     }

//     log("STEP 2: validation passed");

//     final uploaded = await uploadImagesIfNeeded();
//     log("STEP 3: uploadImagesIfNeeded result = $uploaded");

//     if (!uploaded) return false;

//     log("STEP 4: deciding create or update");

//     bool success = false;

//     if (isEditMode.value && editingReviewId != null) {
//       /// ================= UPDATE REVIEW =================
//       final response = await reviewService.updateReview(
//         reviewId: editingReviewId!,
//         rating: reviewRating.value,
//         title: _generateTitleFromRating(),
//         comment: text,
//         images: [
//           ...existingImages,
//           ...uploadedImages,
//         ],
//         detailedRatings: {
//           "quality": reviewRating.value,
//           "valueForMoney": reviewRating.value,
//           "delivery": reviewRating.value,
//           "accuracy": reviewRating.value,
//         },
//       );

//       log("STEP 5: updateReview response = $response");

//       success = response != null && response.success == true;
//     } else {
//       /// ================= CREATE REVIEW =================
//       final response = await reviewService.createReview(
//         productId: productId,
//         rating: reviewRating.value,
//         title: _generateTitleFromRating(),
//         comment: text,
//         images: uploadedImages.toList(),
//         detailedRatings: {
//           "quality": reviewRating.value,
//           "valueForMoney": reviewRating.value,
//           "delivery": reviewRating.value,
//           "accuracy": reviewRating.value,
//         },
//       );

//       log("STEP 5: createReview response = $response");

//       success = response != null && response.success == true;
//     }

//     if (!success) {
//       Get.snackbar("Failed", "Failed to submit review");
//       return false;
//     }

//     /// Reset form
//     resetReviewForm();

//     /// Close dialog
//     if (Get.isDialogOpen == true) {
//       Get.back(result: true);
//     }

//     /// Refresh My Reviews screen if open
//     if (Get.isRegistered<MyReviewController>()) {
//       Get.find<MyReviewController>().fetchMyReviews();
//     }

//     return true;
//   }

//   // ================== TITLE GENERATOR ==================
//   String _generateTitleFromRating() {
//     switch (reviewRating.value) {
//       case 5:
//         return "Excellent product!";
//       case 4:
//         return "Very good";
//       case 3:
//         return "Good";
//       case 2:
//         return "Not great";
//       default:
//         return "Poor experience";
//     }
//   }
// }









// import 'dart:developer';
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:saoirse_app/models/review_image_upload_response.dart';
// import 'package:saoirse_app/services/review_service.dart';

// import '../../../models/own_review_resposne_model.dart' show Review;

// class WriteReviewController extends GetxController {
//   final String productId;

//   WriteReviewController({required this.productId});

//   final ImagePicker _picker = ImagePicker();
//   final ReviewService reviewService = ReviewService();

//   // ================== REVIEW FORM STATE ==================
//   RxInt reviewRating = 0.obs;
//   RxString reviewText = "".obs;
//   final TextEditingController reviewTextController = TextEditingController();

//   // ================== IMAGE SELECTION ==================
//   RxList<XFile> reviewImages = <XFile>[].obs;
//   static const int maxImages = 5;

//   // ================== IMAGE UPLOAD STATE ==================
//   RxBool isUploadingImages = false.obs;

//   RxInt currentUploadIndex = 0.obs; // Which image is being uploaded (1-5)
//   RxInt totalUploadCount = 0.obs;

//   var isEditMode = false.obs;
//   String? editingReviewId;

//   /// Uploaded S3 images (after upload)
//   RxList<ReviewImage> uploadedImages = <ReviewImage>[].obs;

//   final List<String> reviewRatingLabels = [
//     "Terrible",
//     "Bad",
//     "Okay",
//     "Good",
//     "Great",
//   ];

//   // ================== RATING ==================
//   void setReviewRating(int value) {
//     reviewRating.value = value;
//   }

//   void loadExistingReview(Review review) {
//   isEditMode.value = true;
//   editingReviewId = review.id;

//   /// Set rating
//   reviewRating.value = review.rating;

//   /// Set comment
//   reviewTextController.text = review.comment;

//   /// Clear picked images
//   reviewImages.clear();

//   /// NOTE:
//   /// Existing images will be shown from network
//   /// No need to convert them to local files
// }


//   // ================== PICK IMAGES ==================
//   Future<void> pickReviewImages() async {
//     final remaining = maxImages - reviewImages.length;
//     if (remaining <= 0) return;

//     final picked = await _picker.pickMultiImage(imageQuality: 50);
//     if (picked.isEmpty) return;

//     reviewImages.addAll(picked.take(remaining));
//   }

//   // ================== REMOVE IMAGE ==================
//   void removeReviewImage(int index) {
//     reviewImages.removeAt(index);
//   }

//   // ================== REVIEW TEXT ==================
//   void updateReviewText(String text) {
//     reviewText.value = text;
//   }

//   // ================== RESET FORM ==================
//   // void resetReviewForm() {
//   //   reviewRating.value = 0;
  
//   //   reviewTextController.clear(); // clear text input
//   //   reviewImages.clear();
//   //   uploadedImages.clear();
//   //   isUploadingImages.value = false;
//   //   currentUploadIndex.value = 0;
//   //   totalUploadCount.value = 0;
//   // }

//   void resetReviewForm() {
//   reviewRating.value = 0;

//   reviewTextController.clear(); // clear text input
//   reviewImages.clear();
//   uploadedImages.clear();

//   isUploadingImages.value = false;
//   currentUploadIndex.value = 0;
//   totalUploadCount.value = 0;

//   /// Reset edit mode
//   isEditMode.value = false;
//   editingReviewId = null;
// }


//   // ======================================================
//   // STEP 1️⃣ UPLOAD IMAGES (S3)
//   // ======================================================

//   Future<bool> uploadImagesIfNeeded() async {
//     if (reviewImages.isEmpty) return true;

//     isUploadingImages.value = true;
//     totalUploadCount.value = reviewImages.length;
//     currentUploadIndex.value = 0;

//     try {
//       final files = reviewImages.map((x) => File(x.path)).toList();

//       // ✅ Upload with progress callback
//       final result = await reviewService.uploadReviewImages(
//         files,
//         onProgress: (current, total) {
//           currentUploadIndex.value = current;
//           totalUploadCount.value = total;
//         },
//       );

//       uploadedImages.assignAll(result);
//       return true;
//     } catch (e) {
//       Get.snackbar(
//         "Upload Failed",
//         e.toString().replaceAll("Exception:", "").replaceAll("Exception: ", ""),
//         duration: const Duration(seconds: 5),
//       );
//       return false;
//     } finally {
//       isUploadingImages.value = false;
//       currentUploadIndex.value = 0;
//       totalUploadCount.value = 0;
//     }
//   }

//   // ======================================================
//   // STEP 2️⃣ SUBMIT REVIEW
//   // ======================================================
//   //

//   Future<bool> submitReview() async {
//     log("STEP 1: submitReview started");

//     if (reviewRating.value == 0) {
//       Get.snackbar("Rating required", "Please select a star rating");
//       return false;
//     }

//     final text = reviewTextController.text.trim();

//     if (text.isEmpty) {
//       Get.snackbar("Review required", "Please write your feedback");
//       return false;
//     }

//     log("STEP 2: validation passed");

//     final uploaded = await uploadImagesIfNeeded();
//     log("STEP 3: uploadImagesIfNeeded result = $uploaded");

//     if (!uploaded) return false;

//     log("STEP 4: calling createReview API");

//     final response = await reviewService.createReview(
//       productId: productId,
//       rating: reviewRating.value,
//       title: _generateTitleFromRating(),
//       comment: text, // ✅ FIXED
//       images: uploadedImages.toList(),
//       detailedRatings: {
//         "quality": reviewRating.value,
//         "valueForMoney": reviewRating.value,
//         "delivery": reviewRating.value,
//         "accuracy": reviewRating.value,
//       },
//     );

//     log("STEP 5: createReview response = $response");

//     if (response == null || response.success != true) {
//       Get.snackbar(
//         "Failed",
//         response?.message ?? "Failed to submit review",
//       );
//       return false;
//     }

//     resetReviewForm();

//     if (Get.isDialogOpen == true) {
//       Get.back(result: true);
//     }

//     return true;
//   }

//   // ================== TITLE GENERATOR ==================
//   String _generateTitleFromRating() {
//     switch (reviewRating.value) {
//       case 5:
//         return "Excellent product!";
//       case 4:
//         return "Very good";
//       case 3:
//         return "Good";
//       case 2:
//         return "Not great";
//       default:
//         return "Poor experience";
//     }
//   }
  
// }
