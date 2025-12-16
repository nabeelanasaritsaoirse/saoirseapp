// ignore_for_file: file_names, avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/product_list_response.dart';
import '../../services/product_service.dart';

class ProductlistingController extends GetxController {
  TextEditingController nameContoller = TextEditingController();
  var searchQuery = "".obs;
  var isSearching = false.obs;

  final ProductService service = ProductService();

  var products = <Product>[].obs;

  var isLoading = false.obs;
  var isMoreLoading = false.obs;
  int page = 1;
  final int limit = 20;

  var hasNextPage = true.obs;
  //new
  String? categoryId;

  @override
  void onInit() {
    // new: get categoryId from arguments
    final args = Get.arguments;
    if (args != null && args is Map && args['categoryId'] != null) {
      categoryId = args['categoryId'] as String?;
    }

    // When searchQuery changes, wait 400ms, then call API
    debounce<String>(
      searchQuery,
      (_) {
        page = 1;
        hasNextPage.value = true;
        fetchProducts(); // this will clear products when page == 1
      },
      time: const Duration(milliseconds: 400),
    );

    // initial load
    fetchProducts();

    super.onInit();
  }

  Future<void> fetchProducts() async {
    print("📌 Fetching Page: $page | hasNext: ${hasNextPage.value}");

    if (!hasNextPage.value) return;

    try {
      if (page == 1) {
        isLoading(true);
        products.clear();
        print("🔄 Loading first page...");
      } else {
        isMoreLoading(true);
        print("⬇ Loading more products...");
      }

      final response = await service.getProducts(
        page,
        limit,
        search: searchQuery.value.isEmpty ? null : searchQuery.value,
        categoryId: categoryId,
      );

      print("📥 API Response Received");

      if (response != null && response.success) {
        print("🟢 Adding ${response.data.length} new products...");
        products.addAll(response.data);

        // FIX HAS NEXT
        hasNextPage.value =
            response.pagination.current < response.pagination.pages;

        print("📌 hasNextPage = ${hasNextPage.value}");

        // FIX PAGE INCREMENT
        page = response.pagination.current + 1;
        print("➡ Next page will be: $page");
      }
    } catch (e) {
      print("❌ Fetch product error: $e");
    } finally {
      isLoading(false);
      isMoreLoading(false);
    }
  }

  /// User typing search
  void performSearch(String query) {
    searchQuery.value = query.trim();

    // RESET DATA
    page = 1;
    hasNextPage.value = true;
  }
}
