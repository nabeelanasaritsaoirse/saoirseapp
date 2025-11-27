import '../constants/app_urls.dart';
import '../models/home_banner_model.dart';
import 'api_service.dart';

class HomeBannerService {

  Future<List<HomeBannerItem>> fetchHomeBanners() async {
    final String url = AppURLs.HOME_SCREEN_TOP_BANNER_API;
    final response = await APIService.getRequest<HomeBannerResponse>(
      url: url,
      onSuccess: (json) => HomeBannerResponse.fromJson(json),
    );

   return response?.data ?? [];
  }
  
}