import 'dart:developer';

import 'package:saoirse_app/constants/app_urls.dart';

import '../constants/app_constant.dart';
import '../main.dart';
import '../models/address_response.dart';
import 'api_service.dart';

class AddressService {
  static Future<AddressResponse?> getAllAddresses() async {
    // Read userId properly
    String? userId = storage.read(AppConst.USER_ID);

    if (userId == null || userId.isEmpty) {
      log("❌ ERROR: User ID not found in storage");
      return null;
    }

    final String url = "${AppURLs.ADDRESS_API}$userId/addresses";

    return await APIService.getRequest<AddressResponse>(
      url: url,
      onSuccess: (data) => AddressResponse.fromJson(data),
    );
  }

  static Future<bool> addAddress(Map<String, dynamic> body) async {
    log("Entered function");
    String? userId = storage.read(AppConst.USER_ID);
    log("body ===> $body");
    log("Userid : $userId");

    if (userId == null || userId.isEmpty) {
      log("❌ USER ID NOT FOUND");
      return false;
    }

    String url = "${AppURLs.ADDRESS_API}$userId/addresses";

    final result = await APIService.postRequest<bool>(
      url: url,
      body: body,
      onSuccess: (_) => true,
    );

    return result ?? false;
  }
}
