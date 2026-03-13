import 'dart:developer';

import 'package:get/get.dart';

import '../../models/review_resposne.dart';
import '../../services/product_service.dart';

class AllReviewsController extends GetxController {
  final String productId;

  AllReviewsController({required this.productId});

  final ProductService productService = ProductService();

  RxBool isLoading = true.obs;

  RxDouble averageRating = 0.0.obs;
  RxInt totalRatings = 0.obs;

  /// images shown at top
  RxList<String> reviewImages = <String>[].obs;

  /// full review list
  RxList<Review> reviews = <Review>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllReviews();
  }

  Future<void> fetchAllReviews() async {
    try {
      isLoading(true);

      final ReviewResponse? response = await productService.fetchProductReviews(
        productId: productId, // PRODxxxxx
        page: 1,
        limit: 50,
        sort: "newest",
      );

      if (response == null) return;

      /// stats
      averageRating.value = response.data.ratingStats.averageRating;
      totalRatings.value = response.data.ratingStats.totalReviews;

      /// reviews
      reviews.assignAll(response.data.reviews);

      /// collect images (top row)
      final images = response.data.reviews
          .expand((r) => r.images)
          .map((img) => img.url)
          .where((url) => url.isNotEmpty)
          .toList();

      reviewImages.assignAll(images);

      for (final r in response.data.reviews) {
        log("REVIEW IMAGES COUNT: ${r.images.length}");
      }
    } finally {
      isLoading(false);
    }
  }
}
