import 'package:saoirse_app/constants/app_urls.dart';
import 'package:saoirse_app/models/product_model.dart';
import 'package:saoirse_app/services/api_service.dart';

class HomeService {
   static Future<List<Product>?> fetchPopularProducts({
    int page = 1,
    int limit = 10,
  }) async {
    
       final url = "${AppURLs.POPULAR_PRODUCT_API}page=1&limit=10";
    return await APIService.getRequest<List<Product>>(
      url: url,
      onSuccess: (data) {
        if (data['success'] == true && data['data'] != null) {
          final List<dynamic> productsJson = data['data'];
          return productsJson.map((json) => Product.fromJson(json)).toList();
        }
        return [];
      },
    );
  }

  // // Fetch Best Seller Products
  static Future<List<Product>?> fetchBestSellerProducts({
    int page = 1,
    int limit = 10,
  }) async {
    final url = '${AppURLs.BEST_SELLER_PRODUCT_API}page=$page&limit=$limit';
    
    return await APIService.getRequest<List<Product>>(
      url: url,
      onSuccess: (data) {
        if (data['success'] == true && data['data'] != null) {
          final List<dynamic> productsJson = data['data'];
          return productsJson.map((json) => Product.fromJson(json)).toList();
        }
        return [];
      },
    );
  }

  // // Fetch Trending Products
  static Future<List<Product>?> fetchTrendingProducts({
    int page = 1,
    int limit = 10,
  }) async {
    final url = '${AppURLs.TRENDING_PRODUCT_API}page=$page&limit=$limit';
    
    return await APIService.getRequest<List<Product>>(
      url: url,
      onSuccess: (data) {
        if (data['success'] == true && data['data'] != null) {
          final List<dynamic> productsJson = data['data'];
          return productsJson.map((json) => Product.fromJson(json)).toList();
        }
        return [];
      },
    );
  }
}