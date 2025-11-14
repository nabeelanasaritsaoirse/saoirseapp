import 'dart:convert';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../constants/app_constant.dart';
import '../../constants/app_strings.dart';
import '../../constants/app_urls.dart';
import '../../main.dart';
import '../../services/api_service.dart';
import '../../services/auth_service.dart';
import '../../widgets/app_snackbar.dart';
import '../dashboard/dashboard_screen.dart';

class LoginController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController referrelController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  RxBool loading = false.obs;
  Rx<Country?> country = Rx<Country?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchCountryCode();
  }

  Future<void> fetchCountryCode() async {
    try {
      final response = await http.get(Uri.parse("http://ip-api.com/json"));

      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        print("Response body: $body");
        final countryCode = body["countryCode"];
        country.value = CountryParser.tryParseCountryCode(countryCode);
      }
    } catch (e) {
      print("Error fetching country code: $e");
    }
  }

  void updateCountry(Country selectedCountry) {
    country.value = selectedCountry;
  }

  String get fullPhoneNumber {
    final c = country.value;
    if (c == null) return '';
    return '+${c.phoneCode}${phoneController.text}';
  }

  @override
  void onClose() {
    phoneController.dispose();
    super.onClose();
  }

  //google login
  googleLogin() async {
    loading.value = true;

    if (APIService.internet) {
      await AuthService.signOut();
      String? idToken = await AuthService.googleLogin();
      debugPrint(idToken, wrapWidth: 1024);

      if (idToken != null) {
        await userLogin(idToken);
      }
    } else {
      appSnackbar(
        error: true,
        content: AppStrings.no_internet,
      );
    }

    loading.value = false;
  }

  //user login
  userLogin(String idToken) async {
    Map<String, dynamic> body = {
      'idToken': idToken,
    };

    await APIService.postRequest(
      url: AppURLs.LOGIN_API,
      body: body,
      onSuccess: (data) {
        storage.write(AppConst.USER_ID, data['data']['userId']);
        storage.write(AppConst.ACCESS_TOKEN, data['data']['accessToken']);
        storage.write(AppConst.REFRESH_TOKEN, data['data']['refreshToken']);
        Get.offAll(() => DashboardScreen());
        return;
      },
    );

    // print(response.toString());

    // if (response != null) {
    //   var responseData = json.decode(response.body);
    //   print(responseData.toString());

    //   if (response.statusCode == 200) {
    //     print(responseData.toString());
    //     storage.write(AppConst.USER_ID, responseData['data']['userId']);
    //     storage.write(
    //         AppConst.ACCESS_TOKEN, responseData['data']['accessToken']);
    //     storage.write(
    //         AppConst.REFRESH_TOKEN, responseData['data']['refreshToken']);
    //     Get.offAll(() => DashboardScreen());
    //   } else {
    //     appSnackbar(
    //       error: true,
    //       content: responseData['message'] ?? AppStrings.something_went_wrong,
    //     );
    //     Get.offAll(() => DashboardScreen());
    //   }
    // }
  }
}
