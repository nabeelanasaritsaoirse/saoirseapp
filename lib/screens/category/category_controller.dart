



import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../models/category_model.dart';
import '../../services/category_service.dart';

class CategoryController extends GetxController {
  RxInt selectedIndex = 0.obs;
  final scrollController = Rxn<ScrollController>();

  // All categories from API
  RxList<CategoryGroup> categoryGroups = <CategoryGroup>[].obs;

  //for Loading and error handling
  RxBool isLoading = true.obs;
  RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
    scrollController.value = ScrollController();
  }

  Future<void> fetchCategories() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await CategoryService.fetchCategories();

      if (result != null && result.isNotEmpty) {
        categoryGroups.assignAll(result);

        if (selectedIndex.value < 0 ||
            selectedIndex.value >= categoryGroups.length) {
          selectedIndex.value = 0;
        }
      } else {
        categoryGroups.clear();
        errorMessage.value = 'No categories found';
      }
    } catch (e) {
      errorMessage.value = 'Failed to load categories';
    } finally {
      isLoading.value = false;
    }
  }

  void selectCategory(int index) {
    selectedIndex.value = index;

    final controller = scrollController.value;
    if (controller != null && controller.hasClients) {
      controller.animateTo(
        index * 90.0.h,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  // Getter: subcategories of currently selected category
  List<SubCategory> get selectedSubCategories {
    if (categoryGroups.isEmpty) return [];
    return categoryGroups[selectedIndex.value].subCategories;
  }
}
