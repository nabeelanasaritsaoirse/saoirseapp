// ignore_for_file: unnecessary_type_check

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

    final response = await APIService.getRequest(
      url: url,
      headers: {
        if (token != null) 'Authorization': 'Bearer $token',
      },
      onSuccess: (data) {
        return data;
      },
    );

    if (response == null) {
      return [];
    }

    if (response is Map &&
        response['success'] == true &&
        response['data'] is List) {
      final lists = (response['data'] as List)
          .map((e) => FeaturedList.fromJson(e))
          .toList()
        ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));

      return lists;
    }

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

  //   return await APIService.getRequest<FeaturedList?>(
  //     url: url,
  //     headers: {
  //       if (token != null) 'Authorization': 'Bearer $token',
  //     },
  //     onSuccess: (data) {

  //       if (data['success'] == true && data['data'] != null) {
  //         final list = FeaturedList.fromJson(data['data']);

  //         return list;
  //       }

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

  //   return await APIService.getRequest<FeaturedList?>(
  //     url: url,
  //     headers: {
  //       if (token != null) 'Authorization': 'Bearer $token',
  //     },
  //     onSuccess: (data) {

  //       if (data['success'] == true && data['data'] != null) {
  //         final list = FeaturedList.fromJson(data['data']);

  //         return list;
  //       }

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

  //   return await APIService.getRequest<FeaturedList?>(
  //     url: url,
  //     headers: {
  //       if (token != null) 'Authorization': 'Bearer $token',
  //     },
  //     onSuccess: (data) {

  //       if (data['success'] == true && data['data'] != null) {
  //         final list = FeaturedList.fromJson(data['data']);

  //         return list;
  //       }

  //       return null;
  //     },
  //   );
  // }
}
