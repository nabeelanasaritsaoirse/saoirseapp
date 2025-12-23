import 'package:saoirse_app/constants/app_urls.dart';
import 'package:saoirse_app/models/product_model.dart';
import 'package:saoirse_app/services/api_service.dart';

import 'dart:developer';
import 'package:get_storage/get_storage.dart';

import '../constants/app_constant.dart';

class HomeService {
  static final GetStorage storage = GetStorage();

  /// ===============================
  /// POPULAR PRODUCTS LIST
  /// slug: most-popular
  /// ===============================
  static Future<FeaturedList?> fetchPopularList({
    int page = 1,
    int limit = 10,
  }) async {
    final token = storage.read(AppConst.ACCESS_TOKEN);
    final url = '${AppURLs.POPULAR_PRODUCT_API}page=$page&limit=$limit';

    log(' POPULAR LIST URL: $url');

    return await APIService.getRequest<FeaturedList?>(
      url: url,
      headers: {
        if (token != null) 'Authorization': 'Bearer $token',
      },
      onSuccess: (data) {
        log(' POPULAR LIST RAW RESPONSE: $data');

        if (data['success'] == true && data['data'] != null) {
          final list = FeaturedList.fromJson(data['data']);
          log(' POPULAR LIST LOADED: ${list.products.length} products');
          return list;
        }

        log(' POPULAR LIST NOT FOUND');
        return null;
      },
    );
  }

  /// ===============================
  /// BEST SELLER LIST
  /// slug: best-selling
  /// ===============================
  static Future<FeaturedList?> fetchBestSellerList({
    int page = 1,
    int limit = 10,
  }) async {
    final token = storage.read(AppConst.ACCESS_TOKEN);
    final url = '${AppURLs.BEST_SELLER_PRODUCT_API}page=$page&limit=$limit';

    log(' BEST SELLER LIST URL: $url');

    return await APIService.getRequest<FeaturedList?>(
      url: url,
      headers: {
        if (token != null) 'Authorization': 'Bearer $token',
      },
      onSuccess: (data) {
        log(' BEST SELLER RAW RESPONSE: $data');

        if (data['success'] == true && data['data'] != null) {
          final list = FeaturedList.fromJson(data['data']);
          log(' BEST SELLER LIST LOADED: ${list.products.length} products');
          return list;
        }

        log(' BEST SELLER LIST NOT FOUND');
        return null;
      },
    );
  }

  /// ===============================
  /// TRENDING PRODUCTS LIST
  /// slug: trending-products
  /// ===============================
  static Future<FeaturedList?> fetchTrendingList({
    int page = 1,
    int limit = 10,
  }) async {
    final token = storage.read(AppConst.ACCESS_TOKEN);
    final url = '${AppURLs.TRENDING_PRODUCT_API}page=$page&limit=$limit';

    log(' TRENDING LIST URL: $url');

    return await APIService.getRequest<FeaturedList?>(
      url: url,
      headers: {
        if (token != null) 'Authorization': 'Bearer $token',
      },
      onSuccess: (data) {
        log(' TRENDING RAW RESPONSE: $data');

        if (data['success'] == true && data['data'] != null) {
          final list = FeaturedList.fromJson(data['data']);
          log(' TRENDING LIST LOADED: ${list.products.length} products');
          return list;
        }

        log(' TRENDING LIST NOT FOUND');
        return null;
      },
    );
  }
}
