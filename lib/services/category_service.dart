import '../constants/app_urls.dart';
import '../models/category_model.dart';
import 'api_service.dart';

class CategoryService {
  static Future<List<CategoryGroup>?> fetchCategories() async {
    final url = AppURLs.CATEGORY_API;

    return await APIService.getRequest<List<CategoryGroup>>(
      url: url,
      onSuccess: (data) {
        if (data["success"] == true && data["data"] != null) {
          final List list = data["data"];
          return list.map((e) => CategoryGroup.fromJson(e)).toList();
        }
        return [];
      },
    );
  }
}
