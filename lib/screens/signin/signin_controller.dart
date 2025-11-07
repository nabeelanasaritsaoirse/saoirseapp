import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/app_constant.dart';
import '../../constants/app_strings.dart';
import '../../constants/app_urls.dart';
import '../../main.dart';
import '../../services/api_service.dart';
import '../../widgets/app_snackbar.dart';
import '../home/home_screen.dart';

class SignInController extends GetxController {
  TextEditingController emailController = TextEditingController();
  RxBool loading = false.obs;

  //sign in or signup account
  signInAccount() async {
    loading.value = true;

    try {
      var body = {'email': emailController.text.trim()};

      var response = await APIService.postRequest(
        url: AppURLs.SIGNIN_API,
        body: body,
      );

      if (response != null) {
        print(response.body.toString());
        print(response.statusCode.toString());

        if (response.statusCode == 200) {
          var responseData = jsonDecode(response.body);
          storage.write(AppConst.USER_ID, responseData['data']['id']);
          Get.offAll(() => const HomeScreen());
        } else {
          //appSnackbar(error: true, content: AppStrings.email_not_found);
        }
      }
    } catch (error) {
      appSnackbar(error: true, content: error.toString());
    }
    loading.value = false;
  }
}
