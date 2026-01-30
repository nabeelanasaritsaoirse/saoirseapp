import 'package:get/get.dart';

class AllReviewsController extends GetxController {
  RxBool isReviewImageLoading = true.obs;

  RxDouble averageRating = 4.9.obs;
  RxInt totalRatings = 83.obs;
  RxList<String> reviewImages = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchReviewImages();
  }

  Future<void> fetchReviewImages() async {
    try {
      isReviewImageLoading(true);

      await Future.delayed(const Duration(seconds: 1));

      reviewImages.assignAll([
        "https://images.unsplash.com/photo-1523275335684-37898b6baf30",
        "https://images.unsplash.com/photo-1526170375885-4d8ecf77b99f",
        "https://images.unsplash.com/photo-1611048219784-ca687f9fe55d",
        "https://images.unsplash.com/photo-1491933382434-500287f9b54b?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTl8fHByb2R1Y3RzfGVufDB8fDB8fHww",
      ]);
    } finally {
      isReviewImageLoading(false);
    }
  }

  final RxList<Map<String, dynamic>> reviews = <Map<String, dynamic>>[
    {
      "rating": 4,
      "title": "Good",
      "message": "Iphone Since forever 😍\nBest Camera",
      "time": "1 months ago",
    },
    {
      "rating": 5,
      "title": "Excellent",
      "message":
          "Amazing phone! Super smooth performance, excellent camera quality, and premium design. Battery life is good and iOS works perfectly. Totally worth the price.",
      "time": "1 months ago",
    },
    {
      "rating": 1,
      "title": "Bad",
      "message":
          "Not satisfied at all. Battery life is poor, phone heats up, and the price is too high for what it offers. Would not recommend.",
      "time": "1 months ago",
    },
    {
      "rating": 3,
      "title": "Okay",
      "message":
          "Decent phone with good build quality and camera, but battery drains fast and price feels high for the features.",
      "time": "2 months ago",
    },
  ].obs;
}
