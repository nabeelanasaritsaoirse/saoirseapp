import 'package:saoirse_app/constants/app_constant.dart';
import 'package:saoirse_app/main.dart';

import '../constants/app_urls.dart';
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
  Future<ProductListResponse?> getProducts(int page, int limit) async {
    try {
      final url = "${AppURLs.PRODUCTS_LISTING}?page=$page&limit=$limit";

      print("GET PRODUCTS: $url");

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
      print("Product fetch error: $e");
      return null;
    }
  }
}
