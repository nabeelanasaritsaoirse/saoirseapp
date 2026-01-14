import 'package:flutter/widgets.dart';

import '../constants/app_constant.dart';
import '../constants/app_urls.dart';
import '../main.dart';
import '../models/plan_model.dart';
import '../models/product_details_model.dart';
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
}
