import 'dart:convert';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../constants/app_strings.dart';
import '../../services/api_service.dart';
import '../../services/auth_service.dart';
import '../../widgets/app_snackbar.dart';

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
      await AuthService.googleLogin();
    } else {
      appSnackbar(
        error: true,
        content: AppStrings.no_internet,
      );
    }

    loading.value = false;
  }
}
