import 'dart:developer';

import '../constants/app_constant.dart';
import '../constants/app_urls.dart';
import '../main.dart';
import '../models/faq_model.dart';
import 'api_service.dart';

class FaqService {
  Future<List<FaqModel>> getFAQ() async {
    final token = storage.read(AppConst.ACCESS_TOKEN);
    final uri = AppURLs.FAQ_API;

    final response = await APIService.getRequest<FaqResponse>(
      url: uri,
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
      onSuccess: (data) {
        log("FAQ fetched successfully: ${data.length} items");
        return FaqResponse.fromJson(data);
      },
    );

    return response?.data ?? [];
  }
}
