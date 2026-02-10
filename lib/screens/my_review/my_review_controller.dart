import 'package:get/get.dart';
import 'package:saoirse_app/models/own_review_resposne_model.dart';
import '../../services/review_service.dart';

class MyReviewController extends GetxController {
  final ReviewService _reviewService = ReviewService();

  var isLoading = false.obs;
  var reviews = <Review>[].obs;

  @override
  void onInit() {
    fetchMyReviews();
    super.onInit();
  }

  Future<void> fetchMyReviews() async {
    try {
      isLoading.value = true;

      final response = await _reviewService.getMyReviews();

      if (response != null) {
        reviews.assignAll(response.data.reviews);
      }
    } finally {
      isLoading.value = false;
    }
  }

  int remainingEdits(Review review) {
    return 3 - review.editCount;
  }

  bool canEdit(Review review) {
    return review.editCount < 3;
  }
}
