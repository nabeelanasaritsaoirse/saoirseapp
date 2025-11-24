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

  @override
  void onInit() {
    fetchProducts();
    super.onInit();
  }

  Future<void> fetchProducts() async {
    if (!hasNextPage.value) return;

    try {
      if (page == 1) {
        isLoading(true); // first page loader
      } else {
        isMoreLoading(true); // bottom loader
      }

      final response = await service.getProducts(
        page,
        limit,
        search: searchQuery.value.isEmpty ? null : searchQuery.value,
      );

      if (response != null && response.success) {
        products.addAll(response.data);
        hasNextPage.value = response.pagination.hasNext;
        page++;
      }
    } catch (e) {
      print("Fetch product error: $e");
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
    products.clear();
    hasNextPage.value = true;

    fetchProducts(); // reload with search
  }
}
