// ignore_for_file: unrelated_type_equality_checks

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

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
      debugPrint("body: $body", wrapWidth: 1024);

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
            appToast(
              title: "Error",
              content: "Invalid response format received from server.",
              error: true,
            );
            return null;
          }

          return onSuccess(data);

        case 204:
          appToast(
            content: "No data available.",
            error: true,
          );
          return null;

        case 400:
          appToast(
            content: "Bad request. Check parameters.",
            error: true,
          );
          return null;

        case 401:
          appToast(
            content: "Unauthorized. Please log in again.",
            error: true,
          );
          return null;

        case 403:
          appToast(
            content: "Forbidden. Access denied.",
            error: true,
          );
          return null;

        case 404:
          appToast(
            content: "Resource not found (404).",
            error: true,
          );
          return null;

        case 408:
          appToast(
            content: "Request timeout. Try again later.",
            error: true,
          );
          return null;

        case 429:
          appToast(
            content: "Too many requests. Try again later.",
            error: true,
          );
          return null;

        default:
          if (response.statusCode >= 500) {
            appToast(
              content: "Server error (${response.statusCode}). Try later.",
              error: true,
            );
          } else {
            appToast(
              content:
                  "Unexpected error (${response.statusCode}). Please try again.",
              error: true,
            );
          }
          return null;
      }
    } on SocketException {
      appToast(
        content: "No internet connection. Check your network.",
        error: true,
      );
      return null;
    } on FormatException {
      appToast(
        content: "Invalid response format.",
        error: true,
      );
      return null;
    } on TimeoutException {
      appToast(
        content: "Request timed out. Please try again.",
        error: true,
      );
      return null;
    } on http.ClientException catch (e) {
      appToast(
        content: "Network error occurred: $e",
        error: true,
      );
      return null;
    } catch (e) {
      appToast(
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

          if (data is Map<String, dynamic>) {
            return onSuccess(data);
          } else {
            appToast(
              title: "Error",
              content: "Invalid response format. Expected JSON object.",
              error: true,
            );
            return null;
          }

        case 204:
          appToast(
            content: "No data available.",
            error: true,
          );
          return null;

        case 400:
          appToast(
            content: "Bad request. Check parameters.",
            error: true,
          );
          return null;

        case 401:
          appToast(
            content: "Unauthorized. Please log in again.",
            error: true,
          );
          return null;

        case 403:
          appToast(
            content: "Forbidden. Access denied.",
            error: true,
          );
          return null;

        case 404:
          appToast(
            content: "Resource not found (404).",
            error: true,
          );
          return null;

        case 408:
          appToast(
            content: "Request timeout. Try again later.",
            error: true,
          );
          return null;

        case 429:
          appToast(
            content: "Too many requests. Try again later.",
            error: true,
          );
          return null;

        default:
          if (response.statusCode >= 500) {
            appToast(
              content: "Server error (${response.statusCode}). Try later.",
              error: true,
            );
          } else {
            appToast(
              content:
                  "Unexpected error (${response.statusCode}). Please try again.",
              error: true,
            );
          }
          return null;
      }
    } on SocketException {
      appToast(
        content: "No internet connection. Check your network.",
        error: true,
      );
      return null;
    } on FormatException {
      appToast(
        content: "Invalid response format.",
        error: true,
      );
      return null;
    } on TimeoutException {
      appToast(
        content: "Request timed out. Please try again.",
        error: true,
      );
      return null;
    } on http.ClientException catch (e) {
      appToast(
        content: "Network error occurred: $e",
        error: true,
      );
      return null;
    } catch (e) {
      log("Error =====> ${e.toString()}");
      appToast(
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
            appToast(
              title: "Error",
              content: "Invalid response format received from server.",
              error: true,
            );
            return null;
          }

          return onSuccess(data);

        case 204:
          appToast(
            content: "No data available.",
            error: true,
          );
          return null;

        case 400:
          appToast(
            content: "Bad request. Check parameters.",
            error: true,
          );
          return null;

        case 401:
          appToast(
            content: "Unauthorized. Please log in again.",
            error: true,
          );
          return null;

        case 403:
          appToast(
            content: "Forbidden. Access denied.",
            error: true,
          );
          return null;

        case 404:
          appToast(
            content: "Resource not found (404).",
            error: true,
          );
          return null;

        case 408:
          appToast(
            content: "Request timeout. Try again later.",
            error: true,
          );
          return null;

        case 429:
          appToast(
            content: "Too many requests. Try again later.",
            error: true,
          );
          return null;

        default:
          if (response.statusCode >= 500) {
            appToast(
              content: "Server error (${response.statusCode}). Try later.",
              error: true,
            );
          } else {
            appToast(
              content:
                  "Unexpected error (${response.statusCode}). Please try again.",
              error: true,
            );
          }
          return null;
      }
    } on SocketException {
      appToast(
        content: "No internet connection. Check your network.",
        error: true,
      );
      return null;
    } on FormatException {
      appToast(
        content: "Invalid response format.",
        error: true,
      );
      return null;
    } on TimeoutException {
      appToast(
        content: "Request timed out. Please try again.",
        error: true,
      );
      return null;
    } on http.ClientException catch (e) {
      appToast(
        content: "Network error occurred: $e",
        error: true,
      );
      return null;
    } catch (e) {
      appToast(
        content: "Something went wrong: ${e.toString()}",
        error: true,
      );
      return null;
    }
  }

  // Delete Method
  static Future<T?> deleteRequest<T>({
    required String url,
    Map<String, dynamic>? body,
    required T Function(Map<String, dynamic>) onSuccess,
    Map<String, String>? headers,
    int timeoutSeconds = 15,
  }) async {
    try {
      log("delete: $url");
      if (body != null) {
        debugPrint("body: $body", wrapWidth: 1024);
      }

      final request = http.Request('DELETE', Uri.parse(url));

      request.headers.addAll(headers ?? {"Content-Type": "application/json"});

      if (body != null) {
        request.body = jsonEncode(body);
      }

      final response = await http.Response.fromStream(
          await request.send().timeout(Duration(seconds: timeoutSeconds)));

      log("Response [${response.statusCode}]: ${response.body}");

      // Handle response codes
      switch (response.statusCode) {
        case 200:
        case 201:
        case 202:
        case 204:
          if (response.statusCode == 204) {
            return onSuccess({});
          }

          // For other success codes, parse response
          if (response.body.isEmpty) {
            return onSuccess({});
          }

          final data = jsonDecode(response.body);

          if (data is! Map<String, dynamic>) {
            appToast(
              title: "Error",
              content: "Invalid response format received from server.",
              error: true,
            );
            return null;
          }

          return onSuccess(data);

        case 400:
          appToast(
            content: "Bad request. Check parameters.",
            error: true,
          );
          return null;

        case 401:
          appToast(
            content: "Unauthorized. Please log in again.",
            error: true,
          );
          return null;

        case 403:
          appToast(
            content: "Forbidden. Access denied.",
            error: true,
          );
          return null;

        case 404:
          appToast(
            content: "Resource not found (404).",
            error: true,
          );
          return null;

        case 408:
          appToast(
            content: "Request timeout. Try again later.",
            error: true,
          );
          return null;

        case 429:
          appToast(
            content: "Too many requests. Try again later.",
            error: true,
          );
          return null;

        default:
          if (response.statusCode >= 500) {
            appToast(
              content: "Server error (${response.statusCode}). Try later.",
              error: true,
            );
          } else {
            appToast(
              content:
                  "Unexpected error (${response.statusCode}). Please try again.",
              error: true,
            );
          }
          return null;
      }
    } on SocketException {
      appToast(
        content: "No internet connection. Check your network.",
        error: true,
      );
      return null;
    } on FormatException {
      appToast(
        content: "Invalid response format.",
        error: true,
      );
      return null;
    } on TimeoutException {
      appToast(
        content: "Request timed out. Please try again.",
        error: true,
      );
      return null;
    } on http.ClientException catch (e) {
      appToast(
        content: "Network error occurred: $e",
        error: true,
      );
      return null;
    } catch (e) {
      appToast(
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

        // Get.showSnackbar(
        //   GetSnackBar(
        //     isDismissible: false,
        //     borderRadius: 5,
        //     margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
        //     backgroundColor: AppColors.red,
        //     messageText: appText(
        //       AppStrings.no_internet,
        //       color: AppColors.white,
        //       textAlign: TextAlign.left,
        //       fontSize: 12.sp,
        //       fontWeight: FontWeight.w400,
        //     ),
        //     mainButton: IconButton(
        //       onPressed: () {
        //         Get.closeAllSnackbars();
        //       },
        //       icon: Icon(Icons.close, size: 18.sp, color: AppColors.white),
        //     ),
        //   ),
        // );
        appToast(
          content: AppStrings.no_internet,
          error: true,
        );
      }
    });

    Connectivity().onConnectivityChanged.listen((result) {
      if (result == ConnectivityResult.none) {
        internet = false;

        // Get.showSnackbar(
        //   GetSnackBar(
        //     isDismissible: false,
        //     borderRadius: 5,
        //     margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
        //     backgroundColor: AppColors.red,
        //     messageText: appText(
        //       AppStrings.no_internet,
        //       color: AppColors.white,
        //       textAlign: TextAlign.left,
        //       fontSize: 12.sp,
        //       fontWeight: FontWeight.w400,
        //     ),
        //     mainButton: IconButton(
        //       onPressed: () {
        //         Get.closeAllSnackbars();
        //       },
        //       icon: Icon(Icons.close, size: 18.sp, color: AppColors.white),
        //     ),
        //   ),
        // );
        appToast(
          content: AppStrings.no_internet,
          error: true,
        );
      } else {
        internet = true;
        Get.closeAllSnackbars();
      }
    });
  }

  static Future<http.Response?> uploadImageRequest({
    required String url,
    required String method, // POST / PUT / PATCH
    required http.MultipartFile file,
    Map<String, String>? headers,
    Map<String, String>? body,
    int timeoutSeconds = 20,
  }) async {
    try {
      var request = http.MultipartRequest(method, Uri.parse(url));

      // Files
      request.files.add(file);

      // Headers
      if (headers != null) {
        request.headers.addAll(headers);
      }

      // Fields
      if (body != null) {
        request.fields.addAll(body);
      }

      // Send request
      var streamedResponse = await request.send().timeout(
            Duration(seconds: timeoutSeconds),
          );

      var response = await http.Response.fromStream(streamedResponse);

      log("Image Upload Response: ${response.statusCode}");
      log("Body: ${response.body}");

      return response;
    } catch (e) {
      log("UPLOAD ERROR => $e");
      return null;
    }
  }
}
