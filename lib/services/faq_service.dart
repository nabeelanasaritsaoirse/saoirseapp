import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';

import 'package:saoirse_app/constants/app_constant.dart';
import 'package:saoirse_app/constants/app_urls.dart';
import 'package:saoirse_app/models/faq_model.dart';

class FaqService {
  final box = GetStorage();

  Future<List<FaqModel>> getFAQ() async {
    final token = box.read(AppConst.ACCESS_TOKEN);

    final uri = Uri.parse(AppURLs.FAQ_API);

    final response = await http.get(
      uri,
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final faqResponse = FaqResponse.fromJson(decoded);
      log("FAQ fetched successfully: ${faqResponse.data} items");
      log("FAQ fetched successfully: ${faqResponse.data.length} items");
      return faqResponse.data;
    } else {
      throw Exception(
        "Failed to load FAQ (${response.statusCode})",
      );
    }
  }
}
