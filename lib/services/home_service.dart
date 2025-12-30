// ignore_for_file: unnecessary_type_check

import 'dart:developer';
import 'package:get_storage/get_storage.dart';

import '../constants/app_constant.dart';
import '../constants/app_urls.dart';
import '../models/product_model.dart';
import 'api_service.dart';

class HomeService {
  static final GetStorage storage = GetStorage();

  /// ===============================
  /// FETCH ALL FEATURED LISTS
  /// ===============================
  static Future<List<FeaturedList>> fetchFeaturedLists() async {
    final token = storage.read(AppConst.ACCESS_TOKEN);
    final url = AppURLs.FEATURED_LISTS_API;

    log(' SERVICE → FEATURED LISTS URL: $url');
    log(' SERVICE → TOKEN PRESENT: ${token != null}');

    final response = await APIService.getRequest(
      url: url,
      headers: {
        if (token != null) 'Authorization': 'Bearer $token',
      },
      onSuccess: (data) {
        log(' SERVICE → onSuccess CALLED');
        log(' SERVICE → DATA TYPE: ${data.runtimeType}');
        return data;
      },
    );

    log(' SERVICE → RESPONSE FROM APIService: $response');
    log(' SERVICE → RESPONSE TYPE: ${response.runtimeType}');

    if (response == null) {
      log('SERVICE → RESPONSE IS NULL');
      return [];
    }

    if (response is Map &&
        response['success'] == true &&
        response['data'] is List) {
      final lists = (response['data'] as List)
          .map((e) => FeaturedList.fromJson(e))
          .toList()
        ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));

      log('✅ SERVICE → FEATURED LIST COUNT: ${lists.length}');
      return lists;
    }

    log('⚠️ SERVICE → INVALID RESPONSE STRUCTURE');
    return [];
  }

  // /// ===============================
  // /// POPULAR PRODUCTS LIST
  // /// slug: most-popular
  // /// ===============================
  // static Future<FeaturedList?> fetchPopularList({
  //   int page = 1,
  //   int limit = 10,
  // }) async {
  //   final token = storage.read(AppConst.ACCESS_TOKEN);
  //   final url = '${AppURLs.POPULAR_PRODUCT_API}page=$page&limit=$limit';

  //   log(' POPULAR LIST URL: $url');

  //   return await APIService.getRequest<FeaturedList?>(
  //     url: url,
  //     headers: {
  //       if (token != null) 'Authorization': 'Bearer $token',
  //     },
  //     onSuccess: (data) {
  //       log(' POPULAR LIST RAW RESPONSE: $data');

  //       if (data['success'] == true && data['data'] != null) {
  //         final list = FeaturedList.fromJson(data['data']);
  //         log(' POPULAR LIST LOADED: ${list.products.length} products');
  //         return list;
  //       }

  //       log(' POPULAR LIST NOT FOUND');
  //       return null;
  //     },
  //   );
  // }

  // /// ===============================
  // /// BEST SELLER LIST
  // /// slug: best-selling
  // /// ===============================
  // static Future<FeaturedList?> fetchBestSellerList({
  //   int page = 1,
  //   int limit = 10,
  // }) async {
  //   final token = storage.read(AppConst.ACCESS_TOKEN);
  //   final url = '${AppURLs.BEST_SELLER_PRODUCT_API}page=$page&limit=$limit';

  //   log(' BEST SELLER LIST URL: $url');

  //   return await APIService.getRequest<FeaturedList?>(
  //     url: url,
  //     headers: {
  //       if (token != null) 'Authorization': 'Bearer $token',
  //     },
  //     onSuccess: (data) {
  //       log(' BEST SELLER RAW RESPONSE: $data');

  //       if (data['success'] == true && data['data'] != null) {
  //         final list = FeaturedList.fromJson(data['data']);
  //         log(' BEST SELLER LIST LOADED: ${list.products.length} products');
  //         return list;
  //       }

  //       log(' BEST SELLER LIST NOT FOUND');
  //       return null;
  //     },
  //   );
  // }

  // /// ===============================
  // /// TRENDING PRODUCTS LIST
  // /// slug: trending-products
  // /// ===============================
  // static Future<FeaturedList?> fetchTrendingList({
  //   int page = 1,
  //   int limit = 10,
  // }) async {
  //   final token = storage.read(AppConst.ACCESS_TOKEN);
  //   final url = '${AppURLs.TRENDING_PRODUCT_API}page=$page&limit=$limit';

  //   log(' TRENDING LIST URL: $url');

  //   return await APIService.getRequest<FeaturedList?>(
  //     url: url,
  //     headers: {
  //       if (token != null) 'Authorization': 'Bearer $token',
  //     },
  //     onSuccess: (data) {
  //       log(' TRENDING RAW RESPONSE: $data');

  //       if (data['success'] == true && data['data'] != null) {
  //         final list = FeaturedList.fromJson(data['data']);
  //         log(' TRENDING LIST LOADED: ${list.products.length} products');
  //         return list;
  //       }

  //       log(' TRENDING LIST NOT FOUND');
  //       return null;
  //     },
  //   );
  // }
}
