// home_controller.dart
import 'dart:developer';
import 'package:get/get.dart';

import '../../models/product_model.dart';
import '../../models/success_story_banner_model.dart';
import '../../services/home_banner_top_service.dart';
import '../../services/home_service.dart';
import '../../services/success_story_banner_service.dart';

class HomeController extends GetxController {
  RxBool loading = false.obs;
  RxBool popularLoading = false.obs;
  RxBool bestSellerLoading = false.obs;
  RxBool trendingLoading = false.obs;
  RxBool successLoading = false.obs;
  RxBool bannerLoading = false.obs;

  RxInt currentCarouselIndex = 0.obs;
  RxInt currentBottomCarouselIndex = 0.obs;

  RxList<String> carouselImages = <String>[].obs;

  final SuccessStoryService successService = SuccessStoryService();
  final HomeBannerService bannerService = HomeBannerService();

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
      fetchHomeBanners(),
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

  // Fetch Home Banners Top
  Future<void> fetchHomeBanners() async {
    try {
      bannerLoading.value = true;

      final banners = await bannerService.fetchHomeBanners();

      if (banners.isNotEmpty) {
        banners.sort((a, b) => a.displayOrder.compareTo(b.displayOrder));

        carouselImages.value = banners.map((e) => e.imageUrl).toList();
      }
    } catch (e) {
      log("Error fetching home banners: $e");
    } finally {
      bannerLoading.value = false;
    }
  }

  // Refresh all data
  Future<void> refreshAllData() async {
    await fetchAllProducts();
  }
}
