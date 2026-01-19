import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

import '../../models/plan_model.dart';
import '../../models/product_details_model.dart';
import '../../services/product_service.dart';
import '../../services/wishlist_service.dart';
import '../../widgets/app_loader.dart';
import '../../widgets/app_toast.dart';
import '../../widgets/select_plan_sheet.dart';

class ProductDetailsController extends GetxController {
  final String productId;
  final String? id;

  ProductDetailsController({
    required this.productId,
    this.id,
  });

  RxList<PlanModel> plans = <PlanModel>[].obs;

  final WishlistService wishlistService = WishlistService();
  final ProductService productService = ProductService();

  bool isUpdating = false;
  RxBool isPageLoading = false.obs;
  RxBool isCartLoading = false.obs;

  RxBool isProductLoading = true.obs;
  Rx<ProductDetailsData?> product = Rx<ProductDetailsData?>(null);
  RxList<ImageData> mergedImages = <ImageData>[].obs;
  late final PageController pageController;

  RxInt currentImageIndex = 0.obs;
  RxBool isFavorite = false.obs;
  RxInt selectedPlanIndex = (-1).obs;
  RxString selectedVariantId = "".obs;

  /// Custom plan values
  RxInt customDays = 0.obs;
  RxDouble customAmount = 0.0.obs;

  RxBool showBottomButtons = false.obs;
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    pageController = PageController();
    scrollController.addListener(_scrollListener);
    fetchProductDetails();
    checkIfInWishlist(productId);
  }

  // FETCH PRODUCT DETAILS
  // Future<void> fetchProductDetails() async {
  //   try {
  //     isLoading(true);

  //     final result = await productService.fetchProductDetails(productId);
  //     product.value = result;

  //     if (result != null && result.hasVariants && result.variants.isNotEmpty) {
  //       selectedVariantId.value = result.variants.first.variantId;

  //     }
  //   } catch (e) {

  //     appToast(content: "Failed to load product details");
  //   } finally {
  //     isLoading(false);
  //   }
  // }

  Future<void> fetchProductDetails() async {
    try {
      isProductLoading(true);

      final result = await productService.fetchProductDetails(productId);
      product.value = result;

      if (result == null) return;

      // Start with base images
      mergedImages.assignAll(result.images);

      // If it has variants → override only the first image
      if (result.hasVariants && result.variants.isNotEmpty) {
        final firstVariant = result.variants.first;
        selectedVariantId.value = firstVariant.variantId;

        if (firstVariant.images.isNotEmpty) {
          mergedImages[0] = firstVariant.images.first;
        }
      }

      // Reset page
      currentImageIndex.value = 0;
      jumpToPageSafe(0);
    } finally {
      isProductLoading(false);
    }
  }

  Future<void> checkIfInWishlist(String id) async {
    final exists = await wishlistService.checkWishlist(id);
    isFavorite.value = exists;
  }

  Future<void> toggleFavorite(String id) async {
    final productData = product.value;

    if (productData == null) {
      appToast(content: "Product not loaded");
      return;
    }
    if (id.isEmpty) {
      appToast(content: "Invalid Product ID", error: true);
      return;
    }

    if (isFavorite.value) {
      final removed = await wishlistService.removeFromWishlist(id);

      if (removed) {
        isFavorite(false);
        appToaster(content: "Removed from wishlist");
      } else {
        appToast(content: "Failed to remove from wishlist", error: true);
      }

      return;
    }

    final added = await wishlistService.addToWishlist(id);

    if (added) {
      isFavorite(true);
      appToaster(content: "Added to wishlist");
    } else {
      appToast(content: "Failed to add wishlist", error: true);
    }
  }

  // SCROLL LISTENER
  void _scrollListener() {
    if (!scrollController.hasClients) return;

    final maxScroll = scrollController.position.maxScrollExtent;
    final current = scrollController.position.pixels;

    if (maxScroll <= 0) return;

    final percent = (current / maxScroll) * 100;

    showBottomButtons.value = percent >= 60;
  }

  void updateImageIndex(int index) {
    currentImageIndex.value = index;
  }

  void openSelectPlanSheet() async {
    if (product.value == null) return;

    // Reset previous plan selection
    resetPlanSelection();

    appLoader();

    // Fetch plans
    isProductLoading.value = true;
    await loadPlans(product.value!.id);
    isProductLoading.value = false;

    // Close loader
    if (Get.isDialogOpen ?? false) Get.back();

    // Open sheet
    Get.bottomSheet(
      const SelectPlanSheet(),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  void updateAmountFromDays(
    TextEditingController daysController,
    TextEditingController amountController,
  ) {
    if (isUpdating) return;
    isUpdating = true;

    final data = product.value;
    if (data == null) {
      isUpdating = false;
      return;
    }

    final double totalPrice = data.pricing.finalPrice;
    final int days = int.tryParse(daysController.text.trim()) ?? 0;

    if (days <= 0) {
      amountController.text = "";
      isUpdating = false;
      return;
    }

    final double perDayAmount = totalPrice / days;

    amountController.text = perDayAmount.toStringAsFixed(2);

    isUpdating = false;
  }

  void updateDaysFromAmount(
    TextEditingController daysController,
    TextEditingController amountController,
  ) {
    if (isUpdating) return;
    isUpdating = true;

    final data = product.value;
    if (data == null) {
      isUpdating = false;
      return;
    }

    final double totalPrice = data.pricing.finalPrice;
    final double perDayAmount =
        double.tryParse(amountController.text.trim()) ?? 0;

    if (perDayAmount <= 0) {
      daysController.text = "";
      isUpdating = false;
      return;
    }

    final int days = (totalPrice / perDayAmount).round();

    daysController.text = days.toString();

    isUpdating = false;
  }

  Future loadPlans(String productId) async {
    isProductLoading.value = true;

    final result = await ProductService().fetchProductPlans(productId);

    plans.assignAll(result);

    isProductLoading.value = false;
  }

  void selectApiPlan(int index) {
    selectedPlanIndex.value = index;

    final plan = plans[index];

    //  store selected API plan values
    customDays.value = plan.days;
    customAmount.value = plan.perDayAmount;
  }

  void resetPlanSelection() {
    selectedPlanIndex.value = -1;
    customDays.value = 0;
    customAmount.value = 0.0;
  }

  Map<String, dynamic> getSelectedPlan() {
    if (selectedPlanIndex.value != -1) {
      final plan = plans[selectedPlanIndex.value];
      return {
        "days": plan.days,
        "amount": plan.perDayAmount,
      };
    }

    return {
      "days": customDays.value,
      "amount": customAmount.value,
    };
  }

  void setCustomPlan(int days, double amount) {
    customDays.value = days;
    customAmount.value = amount;

    selectedPlanIndex.value = -1;

    Get.back();
  }

  void selectVariantById(String variantId) {
    selectedVariantId.value = variantId;

    final data = product.value;
    if (data == null) return;

    final variant = data.variants.firstWhere(
      (v) => v.variantId == variantId,
      orElse: () => data.variants.first,
    );

    // Always start with base product images
    mergedImages.assignAll(data.images);

    // Replace only the FIRST image if variant has its own image
    if (variant.images.isNotEmpty) {
      mergedImages[0] = variant.images.first;
    }

    // Reset slider
    currentImageIndex.value = 0;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (pageController.hasClients) {
        pageController.animateToPage(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  Variant? getSelectedVariant() {
    if (selectedVariantId.value.isEmpty) return null;

    for (final v in product.value?.variants ?? []) {
      if (v.variantId == selectedVariantId.value) {
        return v;
      }
    }
    return null;
  }

  void clearSelectedVariant() {
    selectedVariantId.value = "";
  }

  String get selectedPlanButtonText {
    if (selectedPlanIndex.value != -1) {
      final plan = plans[selectedPlanIndex.value];
      return "${plan.days} Days";
    }

    if (customDays.value > 0) {
      return "${customDays.value} Days";
    }

    return "Select Plan";
  }

  //Product Sharing Option
  Future<void> productSharing(String productId) async {
    final link =
        "https://inviteapp.onelink.me/VDIY?af_dp=epi://product/$productId";
    await SharePlus.instance.share(
      ShareParams(
        text: "Check out this product 👇\n$link",
        subject: "Product from EPI",
      ),
    );
  }

  void jumpToPageSafe(int page) {
    if (pageController.hasClients) {
      pageController.jumpToPage(page);
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (pageController.hasClients) {
          pageController.jumpToPage(page);
        }
      });
    }
  }

  @override
  void onClose() {
    pageController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
