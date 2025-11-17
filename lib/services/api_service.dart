import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:saoirse_app/widgets/app_snackbar.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../widgets/app_text.dart';
import 'package:http/http.dart' as http;

class APIService {
  static bool internet = false;

//  Post Request Funtion
  static Future<T?> postRequest<T>({
  required String url,
  required Map<String, dynamic> body,
  required T Function(Map<String, dynamic>) onSuccess,
  Map<String, String>? headers,
  int timeoutSeconds = 15,
}) async {
  try {
    log("post: $url");
    log("body: $body");

    final response = await http
        .post(
          Uri.parse(url),
          body: jsonEncode(body),
          headers: headers ??
              {
                "Content-Type": "application/json",
              },
        )
        .timeout(Duration(seconds: timeoutSeconds));

    log("Response [${response.statusCode}]: ${response.body}");

    // Handle response codes
    switch (response.statusCode) {
      case 200:
      case 201:
        final data = jsonDecode(response.body);

        if (data is! Map<String, dynamic>) {
          appSnackbar(
            title: "Error",
            content: "Invalid response format received from server.",
            error: true,
          );
          return null;
        }

        return onSuccess(data);

      case 204:
        appSnackbar(
          content: "No data available.",
          error: true,
        );
        return null;

      case 400:
        appSnackbar(
          content: "Bad request. Check parameters.",
          error: true,
        );
        return null;

      case 401:
        appSnackbar(
          content: "Unauthorized. Please log in again.",
          error: true,
        );
        return null;

      case 403:
        appSnackbar(
          content: "Forbidden. Access denied.",
          error: true,
        );
        return null;

      case 404:
        appSnackbar(
          content: "Resource not found (404).",
          error: true,
        );
        return null;

      case 408:
        appSnackbar(
          content: "Request timeout. Try again later.",
          error: true,
        );
        return null;

      case 429:
        appSnackbar(
          content: "Too many requests. Try again later.",
          error: true,
        );
        return null;

      default:
        if (response.statusCode >= 500) {
          appSnackbar(
            content: "Server error (${response.statusCode}). Try later.",
            error: true,
          );
        } else {
          appSnackbar(
            content:
                "Unexpected error (${response.statusCode}). Please try again.",
            error: true,
          );
        }
        return null;
    }
  } on SocketException {
    appSnackbar(
      content: "No internet connection. Check your network.",
      error: true,
    );
    return null;
  } on FormatException {
    appSnackbar(
      content: "Invalid response format.",
      error: true,
    );
    return null;
  } on TimeoutException {
    appSnackbar(
      content: "Request timed out. Please try again.",
      error: true,
    );
    return null;
  } on http.ClientException catch (e) {
    appSnackbar(
      content: "Network error occurred: $e",
      error: true,
    );
    return null;
  } catch (e) {
    appSnackbar(
      content: "Something went wrong: ${e.toString()}",
      error: true,
    );
    return null;
  }
}


//  Get Request Funtion
 static Future<T?> getRequest<T>({
  required String url,
  required T Function(Map<String, dynamic>) onSuccess,
  Map<String, String>? headers,
  int timeoutSeconds = 15,
}) async {
  try {
    log("get: $url");

    final response = await http
        .get(
          Uri.parse(url),
          headers: headers ??
              {
                "Content-Type": "application/json",
              },
        )
        .timeout(Duration(seconds: timeoutSeconds));

    log("Response [${response.statusCode}]: ${response.body}");

    // status code handling
    switch (response.statusCode) {
      case 200:
      case 201:
        final data = jsonDecode(response.body);

        if (data is! Map<String, dynamic>) {
          appSnackbar(
            title: "Error",
            content: "Invalid response format received from server.",
            error: true,
          );
          return null;
        }

        return onSuccess(data);

      case 204:
        appSnackbar(
          content: "No data available.",
          error: true,
        );
        return null;

      case 400:
        appSnackbar(
          content: "Bad request. Check parameters.",
          error: true,
        );
        return null;

      case 401:
        appSnackbar(
          content: "Unauthorized. Please log in again.",
          error: true,
        );
        return null;

      case 403:
        appSnackbar(
          content: "Forbidden. Access denied.",
          error: true,
        );
        return null;

      case 404:
        appSnackbar(
          content: "Resource not found (404).",
          error: true,
        );
        return null;

      case 408:
        appSnackbar(
          content: "Request timeout. Try again later.",
          error: true,
        );
        return null;

      case 429:
        appSnackbar(
          content: "Too many requests. Try again later.",
          error: true,
        );
        return null;

      default:
        if (response.statusCode >= 500) {
          appSnackbar(
            content: "Server error (${response.statusCode}). Try later.",
            error: true,
          );
        } else {
          appSnackbar(
            content:
                "Unexpected error (${response.statusCode}). Please try again.",
            error: true,
          );
        }
        return null;
    }
  } on SocketException {
    appSnackbar(
      content: "No internet connection. Check your network.",
      error: true,
    );
    return null;
  } on FormatException {
    appSnackbar(
      content: "Invalid response format.",
      error: true,
    );
    return null;
  } on TimeoutException {
    appSnackbar(
      content: "Request timed out. Please try again.",
      error: true,
    );
    return null;
  } on http.ClientException catch (e) {
    appSnackbar(
      content: "Network error occurred: $e",
      error: true,
    );
    return null;
  } catch (e) {
    appSnackbar(
      content: "Something went wrong: ${e.toString()}",
      error: true,
    );
    return null;
  }
}


// Put Request Function

static Future<T?> putRequest<T>({
  required String url,
  required Map<String, dynamic> body,
  required T Function(Map<String, dynamic>) onSuccess,
  Map<String, String>? headers,
  int timeoutSeconds = 15,
}) async {
  try {
    log("put: $url");
    log("body: $body");

    final response = await http
        .put(
          Uri.parse(url),
          body: jsonEncode(body),
          headers: headers ??
              {
                "Content-Type": "application/json",
              },
        )
        .timeout(Duration(seconds: timeoutSeconds));

    log("Response [${response.statusCode}]: ${response.body}");

    // status code handling 
    switch (response.statusCode) {
      case 200:
      case 201:
        final data = jsonDecode(response.body);

        if (data is! Map<String, dynamic>) {
          appSnackbar(
            title: "Error",
            content: "Invalid response format received from server.",
            error: true,
          );
          return null;
        }

        return onSuccess(data);

      case 204:
        appSnackbar(
          content: "No data available.",
          error: true,
        );
        return null;

      case 400:
        appSnackbar(
          content: "Bad request. Check parameters.",
          error: true,
        );
        return null;

      case 401:
        appSnackbar(
          content: "Unauthorized. Please log in again.",
          error: true,
        );
        return null;

      case 403:
        appSnackbar(
          content: "Forbidden. Access denied.",
          error: true,
        );
        return null;

      case 404:
        appSnackbar(
          content: "Resource not found (404).",
          error: true,
        );
        return null;

      case 408:
        appSnackbar(
          content: "Request timeout. Try again later.",
          error: true,
        );
        return null;

      case 429:
        appSnackbar(
          content: "Too many requests. Try again later.",
          error: true,
        );
        return null;

      default:
        if (response.statusCode >= 500) {
          appSnackbar(
            content: "Server error (${response.statusCode}). Try later.",
            error: true,
          );
        } else {
          appSnackbar(
            content:
                "Unexpected error (${response.statusCode}). Please try again.",
            error: true,
          );
        }
        return null;
    }
  } on SocketException {
    appSnackbar(
      content: "No internet connection. Check your network.",
      error: true,
    );
    return null;
  } on FormatException {
    appSnackbar(
      content: "Invalid response format.",
      error: true,
    );
    return null;
  } on TimeoutException {
    appSnackbar(
      content: "Request timed out. Please try again.",
      error: true,
    );
    return null;
  } on http.ClientException catch (e) {
    appSnackbar(
      content: "Network error occurred: $e",
      error: true,
    );
    return null;
  } catch (e) {
    appSnackbar(
      content: "Something went wrong: ${e.toString()}",
      error: true,
    );
    return null;
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
