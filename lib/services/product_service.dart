// ignore_for_file: avoid_print

import 'dart:developer';

import '../constants/app_constant.dart';
import '../constants/app_urls.dart';
import '../main.dart';
import '../models/plan_model.dart';
import '../models/product_details_model.dart';
import '../models/product_list_response.dart';
import 'api_service.dart';

class ProductService {
  final token = storage.read(AppConst.ACCESS_TOKEN);

  Future<ProductDetailsData?> fetchProductDetails(String productId) async {
    final url = "${AppURLs.PRODUCT_DETAILS_API}$productId";

    return APIService.getRequest<ProductDetailsData?>(
      url: url,
      onSuccess: (data) {
        if (data["success"] == true && data["data"] != null) {
          return ProductDetailsData.fromJson(data["data"]);
        }
        return null;
      },
    );
  }

  // Fetch productslisting with pagination
  Future<ProductListResponse?> getProducts(
    int page,
    int limit, {
    String? search,
  }) async {
    try {
      final query =
          search != null && search.isNotEmpty ? "&search=$search" : "";
      final url = "${AppURLs.PRODUCTS_LISTING}?page=$page&limit=$limit$query";

      print("GET PRODUCTS: $url");

      final response = await APIService.getRequest(
        url: url,
        onSuccess: (data) => data,
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      if (response == null) return null;
      log("Product List response ====> $response");
      return ProductListResponse.fromJson(response);
    } catch (e) {
      print("Product fetch error: $e");
      return null;
    }
  }

  // Fetch investment plans for a product
  Future<List<PlanModel>?> fetchProductPlans(String productId) async {
    try {
      final url = "${AppURLs.PRODUCT_PLAN_API}$productId/plans";

      print("GET PRODUCT PLANS: $url");

      final response = await APIService.getRequest(
        url: url,
        onSuccess: (data) => data,
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      if (response == null) return null;

      if (response["success"] == true &&
          response["data"] != null &&
          response["data"]["plans"] != null) {
        final list = response["data"]["plans"] as List;
        return list.map((e) => PlanModel.fromJson(e)).toList();
      }

      return null;
    } catch (e) {
      print("Plan fetch error: $e");
      return null;
    }
  }
}
