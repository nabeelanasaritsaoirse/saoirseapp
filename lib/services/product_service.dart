
import 'package:saoirse_app/constants/app_urls.dart';

import 'package:saoirse_app/models/product_details_model.dart';
import 'package:saoirse_app/services/api_service.dart';

class ProductService {


  
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


}