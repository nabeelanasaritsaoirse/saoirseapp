import '../constants/app_constant.dart';
import '../constants/app_urls.dart';
import '../main.dart';
import '../models/address_response.dart';
import 'api_service.dart';

class AddressService {
  static Future<AddressResponse?> getAllAddresses() async {
    // Read userId properly
    String? userId = storage.read(AppConst.USER_ID);

    if (userId!.isEmpty) {
      return null;
    }

    final String url = "${AppURLs.ADDRESS_API}$userId/addresses";

    return await APIService.getRequest<AddressResponse>(
      url: url,
      onSuccess: (data) => AddressResponse.fromJson(data),
    );
  }

  static Future<bool> addAddress(Map<String, dynamic> body) async {
    String? userId = storage.read(AppConst.USER_ID);

    if (userId!.isEmpty) {
      return false;
    }

    String url = "${AppURLs.ADDRESS_API}$userId/addresses";

    final result = await APIService.postRequest<bool>(
      url: url,
      body: body,
      onSuccess: (_) => true,
    );
// dfldsfd
    return result ?? false;
  }

  // ---------------- EDIT ADDRESS ----------------
  static Future<bool> editAddress({
    required String addressId,
    required Map<String, dynamic> body,
  }) async {
    String? userId = storage.read(AppConst.USER_ID);

    if (userId == null || userId.isEmpty) {
      return false;
    }

    final String url = "${AppURLs.ADDRESS_API}$userId/addresses/$addressId";

    final result = await APIService.putRequest<bool>(
      url: url,
      body: body,
      onSuccess: (_) => true,
    );

    return result ?? false;
  }

  // ---------------- DELETE ADDRESS ----------------
  static Future<bool> deleteAddress({
    required String addressId,
  }) async {
    String? userId = storage.read(AppConst.USER_ID);

    if (userId == null || userId.isEmpty) {
      return false;
    }

    final String url = "${AppURLs.ADDRESS_API}$userId/addresses/$addressId";

    final result = await APIService.deleteRequest<bool>(
      url: url,
      onSuccess: (_) => true,
    );

    return result ?? false;
  }
}
