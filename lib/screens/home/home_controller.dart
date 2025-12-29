// home_controller.dart
import 'dart:developer';
import 'package:get/get.dart';

import '../../models/category_model.dart';
import '../../models/product_model.dart';
import '../../models/success_story_banner_model.dart';
import '../../services/category_service.dart';
import '../../services/home_banner_top_service.dart';
import '../../services/home_service.dart';
import '../../services/success_story_banner_service.dart';

class HomeController extends GetxController {
  RxBool loading = false.obs;
  // RxBool popularLoading = false.obs;
  // RxBool bestSellerLoading = false.obs;
  // RxBool trendingLoading = false.obs;
  RxBool successLoading = false.obs;
  RxBool bannerLoading = false.obs;
  RxBool homeCategoryLoading = false.obs;

  RxInt currentCarouselIndex = 0.obs;
  RxInt currentBottomCarouselIndex = 0.obs;

  RxList<String> carouselImages = <String>[].obs; 

  final SuccessStoryService successService = SuccessStoryService();
  final HomeBannerService bannerService = HomeBannerService();

  // final Rxn<FeaturedList> popularList = Rxn<FeaturedList>();
  // final Rxn<FeaturedList> bestSellerList = Rxn<FeaturedList>();
  // final Rxn<FeaturedList> trendingList = Rxn<FeaturedList>();
  RxBool featuredLoading = false.obs;

  /// All featured lists (dynamic)
  final RxList<FeaturedList> featuredLists = <FeaturedList>[].obs;
  RxList<SuccessStoryItem> successStories = <SuccessStoryItem>[].obs;
  RxList<CategoryGroup> parentCategories = <CategoryGroup>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchFeaturedLists();
    fetchAllProducts();
  }

  // Fetch all products
  Future<void> fetchAllProducts() async {
    await Future.wait([
      // fetchPopularList(),
      // fetchBestSellerList(),
      // fetchTrendingList(),

      fetchSuccessStories(),
      fetchHomeBanners(),
      fetchParentCategories(),
    ]);
  }

  Future<void> fetchFeaturedLists() async {
    try {
      featuredLoading.value = true;
      log('CONTROLLER → FETCH FEATURED LISTS START');

      final lists = await HomeService.fetchFeaturedLists();

      log(' CONTROLLER → LISTS RECEIVED: $lists');
      log(' CONTROLLER → LIST COUNT: ${lists.length}');

      if (lists.isNotEmpty) {
        featuredLists.assignAll(lists);
        log(' FINAL FEATURED LISTS IN CONTROLLER: ${featuredLists.length}');
      } else {
        log(' CONTROLLER → LIST EMPTY');
      }
    } catch (e) {
      log(' CONTROLLER → ERROR: $e');
    } finally {
      featuredLoading.value = false;
      log(' CONTROLLER → LOADING FALSE');
    }
  }

  /// Helper: get list by slug if needed
  FeaturedList? getListBySlug(String slug) {
    try {
      return featuredLists.firstWhere((e) => e.slug == slug);
    } catch (_) {
      return null;
    }
  }

  // // Fetch Popular Products
  // Future<void> fetchPopularList() async {
  //   try {
  //     popularLoading.value = true;
  //     popularLoading.value = true;
  //     final list = await HomeService.fetchPopularList(limit: 10);

  //     if (list != null) {
  //       popularList.value = list;
  //     }
  //   } catch (e) {
  //     log('Error fetching popular products: $e');
  //   } finally {
  //     popularLoading.value = false;
  //   }
  // }

  // // // Fetch Best Seller Products
  // Future<void> fetchBestSellerList() async {
  //   try {
  //     bestSellerLoading.value = true;
  //     final list = await HomeService.fetchBestSellerList(limit: 10);

  //     if (list != null) {
  //       bestSellerList.value = list;
  //     }
  //   } catch (e) {
  //     log('Error fetching best seller products: $e');
  //   } finally {
  //     bestSellerLoading.value = false;
  //   }
  // }

  // // Fetch Trending Products
  // Future<void> fetchTrendingList() async {
  //   try {
  //     trendingLoading.value = true;
  //     final list = await HomeService.fetchTrendingList(limit: 10);

  //     if (list != null) {
  //       trendingList.value = list;
  //     }
  //   } catch (e) {
  //     log('Error fetching trending products: $e');
  //   } finally {
  //     trendingLoading.value = false;
  //   }
  // }

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

  // Fetch Parent Categories for Home Screen
  Future<void> fetchParentCategories() async {
    try {
      homeCategoryLoading.value = true;

      final result = await CategoryService.fetchCategories();

      if (result != null && result.isNotEmpty) {
        parentCategories.assignAll(result);
      }
    } finally {
      homeCategoryLoading.value = false;
    }
  }

  // Refresh all data
  Future<void> refreshAllData() async {
    await fetchAllProducts();
  }
}
