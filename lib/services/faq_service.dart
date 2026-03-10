
import 'dart:developer';

import 'package:get_storage/get_storage.dart';
import 'package:saoirse_app/services/api_service.dart';

import '../constants/app_constant.dart';
import '../constants/app_urls.dart';
import '../models/faq_model.dart';



class FaqService {
  final box = GetStorage();



Future<List<FaqModel>> getFAQ() async {
  final token = box.read(AppConst.ACCESS_TOKEN);
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
