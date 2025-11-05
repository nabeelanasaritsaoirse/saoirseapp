import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../widgets/app_snackbar.dart';
import '../widgets/app_text.dart';

import 'package:http/http.dart' as http;

class APIService {
  static bool internet = false;

  //post api request
  static postRequest({required String url, var body}) async {
    if (internet) {
      Uri uri = Uri.parse(url);
      Map<String, String> headers = {'Content-Type': 'application/json'};

      var response = await http.post(
        uri,
        headers: headers,
        body: jsonEncode(body),
      );

      return response;
    } else {
      if (!Get.isSnackbarOpen) {
        appSnackbar(error: true, content: AppStrings.no_internet);
      }
    }
  }

  //get api request
  static getRequest({
    required String url,
    Map<String, String>? headers,
    Map<String, String>? body,
  }) async {
    if (internet) {
      var request = http.Request('GET', Uri.parse(url));
      if (headers != null) {
        request.headers.addAll(headers);
      }

      if (body != null) {
        request.bodyFields = body;
      }

      http.StreamedResponse response = await request.send();

      return await response.stream.bytesToString();
    } else {
      if (!Get.isSnackbarOpen) {
        appSnackbar(error: true, content: AppStrings.no_internet);
      }
    }
  }

  static checkConnection(BuildContext context) {
    Connectivity().checkConnectivity().then((result) {
      if (result == ConnectivityResult.none) {
        internet = false;

        Get.showSnackbar(
          GetSnackBar(
            isDismissible: false,
            borderRadius: 5,
            margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
            backgroundColor: AppColors.red,
            messageText: appText(
              AppStrings.no_internet,
              color: AppColors.white,
              textAlign: TextAlign.left,
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
            ),
            mainButton: IconButton(
              onPressed: () {
                Get.closeAllSnackbars();
              },
              icon: Icon(Icons.close, size: 18.sp, color: AppColors.white),
            ),
          ),
        );
      }
    });

    Connectivity().onConnectivityChanged.listen((result) {
      if (result == ConnectivityResult.none) {
        internet = false;

        Get.showSnackbar(
          GetSnackBar(
            isDismissible: false,
            borderRadius: 5,
            margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
            backgroundColor: AppColors.red,
            messageText: appText(
              AppStrings.no_internet,
              color: AppColors.white,
              textAlign: TextAlign.left,
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
            ),
            mainButton: IconButton(
              onPressed: () {
                Get.closeAllSnackbars();
              },
              icon: Icon(Icons.close, size: 18.sp, color: AppColors.white),
            ),
          ),
        );
      } else {
        internet = true;
        Get.closeAllSnackbars();
      }
    });
  }
}
