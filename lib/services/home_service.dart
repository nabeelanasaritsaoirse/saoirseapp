// ignore_for_file: unnecessary_type_check

import '../constants/app_constant.dart';
import '../constants/app_urls.dart';
import '../main.dart';
import '../models/product_model.dart';
import 'api_service.dart';

class HomeService {
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
}
