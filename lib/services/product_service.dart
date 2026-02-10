import 'package:flutter/material.dart';
import 'package:saoirse_app/models/review_resposne.dart';

import '../constants/app_constant.dart';
import '../constants/app_urls.dart';
import '../main.dart';
import '../models/plan_model.dart';
import '../models/product_details_model.dart';
import '../models/product_faq.dart';
import '../models/product_list_response.dart';
import 'api_service.dart';

class ProductService {
  Future<String?> _token() async {
    return storage.read(AppConst.ACCESS_TOKEN);
  }

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
  // Future<ProductListResponse?> getProducts(
  //   int page,
  //   int limit, {
  //   String? search,
  // }) async {
  //   try {
  //     final query =
  //         search != null && search.isNotEmpty ? "&search=$search" : "";
  //     final url = "${AppURLs.PRODUCTS_LISTING}?page=$page&limit=$limit$query";

  //     final response = await APIService.getRequest(
  //       url: url,
  //       onSuccess: (data) => data,
  //       headers: {
  //         "Authorization": "Bearer $token",
  //       },
  //     );

  //     if (response == null) return null;

  //     return ProductListResponse.fromJson(response);
  //   } catch (e) {

  //     return null;
  //   }
  // }

  Future<ProductListResponse?> getProducts(
    int page,
    int limit, {
    String? search,
    String? categoryId, // new
  }) async {
    try {
      final token = await _token();

      debugPrint("🛒 [PRODUCT API] token = $token");
      final query = <String>[];
      query.add('page=$page');
      query.add('limit=$limit');
      if (search != null && search.isNotEmpty) query.add('search=$search');

      final url = (categoryId != null && categoryId.isNotEmpty)
          ? "${AppURLs.PRODUCT_LISTING_SUBCATEGORY}$categoryId?${query.join('&')}"
          : "${AppURLs.PRODUCTS_LISTING}?${query.join('&')}";

      final response = await APIService.getRequest(
        url: url,
        onSuccess: (data) => data,
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      if (response == null) return null;

      return ProductListResponse.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  // Fetch investment plans for a product
  Future<List<PlanModel>> fetchProductPlans(String productId) async {
    try {
      final token = await _token();

      debugPrint("🛒 [PRODUCT API] token = $token");
      final url = "${AppURLs.PRODUCT_PLAN_API}$productId/plans";

      final response = await APIService.getRequest(
        url: url,
        onSuccess: (data) => data,
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      if (response == null) return [];

      // ✅ Parse using new model
      final planResponse = PlanResponseModel.fromJson(response);

      // ✅ Return list of plans
      return planResponse.data.plans;
    } catch (e) {
      return [];
    }
  }

  // **** Product FAQ section **** //
  Future<List<ProductFaq>> fetchProductFaqs(String productId) async {
    try {
      final token = await _token();

      debugPrint("[FAQ API] token = $token");

      final url = "${AppURLs.PRODUCT_FAQ_API}$productId";

      final response = await APIService.getRequest(
        url: url,
        onSuccess: (data) => data,
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      if (response == null || response['success'] != true) {
        return [];
      }

      final List list = response['data'] ?? [];

      return list.map((e) => ProductFaq.fromJson(e)).toList();
    } catch (e) {
      debugPrint("❌ fetchProductFaqs error: $e");
      return [];
    }
  }

  Future<ReviewResponse?> fetchProductReviews({
  required String productId, // PROD185699527
  int page = 1,
  int limit = 10,
  String sort = "newest",
  String? rating,
  bool? verified,
  bool? hasImages,
  String? search,
}) async {
  try {
    final queryParams = <String>[];
    queryParams.add("page=$page");
    queryParams.add("limit=$limit");
    queryParams.add("sort=$sort");

    if (rating != null && rating.isNotEmpty) {
      queryParams.add("rating=$rating");
    }
    if (verified == true) {
      queryParams.add("verified=true");
    }
    if (hasImages == true) {
      queryParams.add("hasImages=true");
    }
    if (search != null && search.isNotEmpty) {
      queryParams.add("search=$search");
    }

    /// 🔵 FINAL URL (match Postman exactly)
    final String url =
        "${AppURLs.PRODUCT_REVIEWS_API}$productId/reviews?${queryParams.join("&")}";

    debugPrint("🔵 Reviews API URL => $url");

    final response = await APIService.getRequest(
      url: url,
      onSuccess: (data) => data,
    );

    debugPrint("🟢 Reviews API response => $response");

    if (response == null || response["success"] != true) {
      return null;
    }

    return ReviewResponse.fromJson(response);
  } catch (e, stack) {
    debugPrint("❌ fetchProductReviews error: $e");
    debugPrint(stack.toString());
    return null;
  }
}

}
