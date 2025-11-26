// home_controller.dart
import 'dart:developer';
import 'package:get/get.dart';
import 'package:saoirse_app/models/success_story_banner_model.dart';
import 'package:saoirse_app/services/success_story_banner_service.dart';
import '../../models/product_model.dart';
import '../../services/home_service.dart';

class HomeController extends GetxController {
  RxBool loading = false.obs;
  RxBool popularLoading = false.obs;
  RxBool bestSellerLoading = false.obs;
  RxBool trendingLoading = false.obs;
  RxBool successLoading = false.obs;

  RxInt currentCarouselIndex = 0.obs;
  RxInt currentBottomCarouselIndex = 0.obs;

  // For the custom images
  final RxList<String> carouselImages = <String>[
    'https://images.unsplash.com/photo-1441984904996-e0b6ba687e04?w=800',
    'https://images.unsplash.com/photo-1483985988355-763728e1935b?w=800',
    'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=800',
  ].obs;

  final SuccessStoryService successService = SuccessStoryService();

  final RxList<Product> mostPopularProducts = <Product>[].obs;
  final RxList<Product> bestSellerProducts = <Product>[].obs;
  final RxList<Product> trendingProducts = <Product>[].obs;
  RxList<SuccessStoryItem> successStories = <SuccessStoryItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllProducts();
  }

  // Fetch all products
  Future<void> fetchAllProducts() async {
    await Future.wait([
      fetchPopularProducts(),
      fetchBestSellerProducts(),
      fetchTrendingProducts(),
      fetchSuccessStories(),
    ]);
  }

  // Fetch Popular Products
  Future<void> fetchPopularProducts() async {
    try {
      popularLoading.value = true;
      final products =
          await HomeService.fetchPopularProducts(page: 1, limit: 10);

      if (products != null && products.isNotEmpty) {
        mostPopularProducts.value = products;
      }
    } catch (e) {
      log('Error fetching popular products: $e');
    } finally {
      popularLoading.value = false;
    }
  }

  // // Fetch Best Seller Products
  Future<void> fetchBestSellerProducts() async {
    try {
      bestSellerLoading.value = true;
      final products =
          await HomeService.fetchBestSellerProducts(page: 1, limit: 10);

      if (products != null && products.isNotEmpty) {
        bestSellerProducts.value = products;
      }
    } catch (e) {
      log('Error fetching best seller products: $e');
    } finally {
      bestSellerLoading.value = false;
    }
  }

  // Fetch Trending Products
  Future<void> fetchTrendingProducts() async {
    try {
      trendingLoading.value = true;
      final products =
          await HomeService.fetchTrendingProducts(page: 1, limit: 10);

      if (products != null && products.isNotEmpty) {
        trendingProducts.value = products;
      }
    } catch (e) {
      log('Error fetching trending products: $e');
    } finally {
      trendingLoading.value = false;
    }
  }

  // Fetch Success Stories
Future<void> fetchSuccessStories() async {
  try {
    successLoading.value = true;

    final result = await successService.fetchSuccessStories();

    result.sort((a, b) => a.displayOrder.compareTo(b.displayOrder));

    successStories.value = result;

  } catch (e) {
    log("Error fetching success story: $e");
  } finally {
    successLoading.value = false;
  }
}

  // Refresh all data
  Future<void> refreshAllData() async {
    await fetchAllProducts();
  }
}
