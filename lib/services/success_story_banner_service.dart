import '../constants/app_urls.dart';
import '../models/success_story_banner_model.dart';
import 'api_service.dart';

class SuccessStoryService {
  Future<List<SuccessStoryItem>> fetchSuccessStories() async {
    final url = AppURLs.SUCCESS_STORY_BANNER_API;

    final response = await APIService.getRequest<SuccessStoryResponse>(
      url: url,
      headers: {},
      onSuccess: (json) => SuccessStoryResponse.fromJson(json),
    );

    return response?.data ?? [];
  }
}
