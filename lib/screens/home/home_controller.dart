import 'package:get/get.dart';

import '../../constants/app_constant.dart';
import '../../main.dart';
import '../../models/category_model.dart';
import '../../models/product_model.dart';
import '../../models/success_story_banner_model.dart';
import '../../services/category_service.dart';
import '../../services/home_banner_top_service.dart';
import '../../services/home_service.dart';
import '../../services/success_story_banner_service.dart';

class HomeController extends GetxController {
  RxBool loading = false.obs;
  RxBool successLoading = false.obs;
  RxBool bannerLoading = false.obs;
  RxBool homeCategoryLoading = false.obs;

  RxInt currentCarouselIndex = 0.obs;
  RxInt currentBottomCarouselIndex = 0.obs;

  RxList<String> carouselImages = <String>[].obs;

  final SuccessStoryService successService = SuccessStoryService();
  final HomeBannerService bannerService = HomeBannerService();

  RxBool featuredLoading = false.obs;

  /// All featured lists (dynamic)
  final RxList<FeaturedList> featuredLists = <FeaturedList>[].obs;
  RxList<SuccessStoryItem> successStories = <SuccessStoryItem>[].obs;
  RxList<CategoryGroup> parentCategories = <CategoryGroup>[].obs;
  RxString userName = "".obs;
  RxString selectedCategoryId = "".obs;
  RxString selectedCategoryName = "".obs;

  RxList<SubCategory> visibleSubCategories = <SubCategory>[].obs;

  /// Called when parent category is tapped
  void onParentCategoryTap(CategoryGroup cat) {
    // 🟡 If same category tapped again → CLOSE sub-categories
    if (selectedCategoryId.value == cat.id) {
      selectedCategoryId.value = "";
      selectedCategoryName.value = "";
      visibleSubCategories.clear();
      return;
    }

    // 🟢 New category tapped → OPEN sub-categories
    selectedCategoryId.value = cat.id;
    selectedCategoryName.value = cat.name;
    visibleSubCategories.assignAll(cat.subCategories);
  }

  @override
  void onInit() {
    super.onInit();
    loadUserName();
    fetchFeaturedLists();
    fetchAllProducts();
  }

  void loadUserName() {
    userName.value = storage.read(AppConst.USER_NAME) ?? "";
  }

  // Fetch all products
  Future<void> fetchAllProducts() async {
    await Future.wait([
      fetchSuccessStories(),
      fetchHomeBanners(),
      fetchParentCategories(),
    ]);
  }

  Future<void> fetchFeaturedLists() async {
    try {
      featuredLoading.value = true;

      final lists = await HomeService.fetchFeaturedLists();

      if (lists.isNotEmpty) {
        featuredLists.assignAll(lists);
      } else {}
    } finally {
      featuredLoading.value = false;
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

  // Fetch Success Stories
  Future<void> fetchSuccessStories() async {
    try {
      successLoading.value = true;

      final result = await successService.fetchSuccessStories();

      result.sort((a, b) => a.displayOrder.compareTo(b.displayOrder));

      successStories.value = result;
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
