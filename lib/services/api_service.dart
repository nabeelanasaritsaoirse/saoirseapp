// ignore_for_file: unrelated_type_equality_checks

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../screens/onboard/onboard_screen.dart';

import 'package:http/http.dart' as http;

class APIService {
  static bool internet = false;

  // ---------------------------------------------------------------------------
  // POST REQUEST
  // Sends a POST request with JSON body and handles all common status codes.
  // ---------------------------------------------------------------------------
  static Future<T?> postRequest<T>({
    required String url,
    Map<String, dynamic>? body,
    required T Function(Map<String, dynamic>) onSuccess,
    Map<String, String>? headers,
    int timeoutSeconds = 15,
  }) async {
    const int maxRetries = 5;

    for (int attempt = 1; attempt <= maxRetries; attempt++) {
      try {
        final response = await http
            .post(
              Uri.parse(url),
              body: jsonEncode(body),
              headers: headers ?? {"Content-Type": "application/json"},
            )
            .timeout(Duration(seconds: timeoutSeconds));
        // log("API URL ==> $url");
        // log("Respose body : =====> ${response.body}");
        switch (response.statusCode) {
          case 200:
          case 201:
            final data = jsonDecode(response.body);
            if (data is! Map<String, dynamic>) {
              return null;
            }
            return onSuccess(data);

          case 204:
            return null;

          case 400:
            return jsonDecode(response.body);

          case 401:
            await handleUnauthorized();
            return null;

          case 403:
            return null;

          case 404:
            return null;

          case 408:
            break;

          case 429:
            break;

          default:
            if (response.statusCode >= 500) {
              break;
            } else {
              return null;
            }
        }
      } on SocketException {
        ("No internet connection. Retrying...");
      } on TimeoutException {
        ("GET request timed out. Retrying...");
      } on FormatException {
        ("Invalid response format.");
        return null;
      } on http.ClientException catch (e) {
        ("Network error: $e. Retrying...");
      } catch (e) {
        ("Unexpected error: ${e.toString()}");
        return null;
      }

      // ⏳ delay before next retry
      if (attempt < maxRetries) {
        await Future.delayed(const Duration(seconds: 1));
      }
    }

    return null;
  }

  // ---------------------------------------------------------------------------
  // GET REQUEST
  // Sends a GET request and processes JSON response with status code handling.
  // ---------------------------------------------------------------------------
  static Future<T?> getRequest<T>({
    required String url,
    required T Function(Map<String, dynamic>) onSuccess,
    Map<String, String>? headers,
    int timeoutSeconds = 15,
  }) async {
    const int maxRetries = 5;

    for (int attempt = 1; attempt <= maxRetries; attempt++) {
      try {
        final response = await http
            .get(
              Uri.parse(url),
              headers: headers ?? {"Content-Type": "application/json"},
            )
            .timeout(Duration(seconds: timeoutSeconds));
        // log("API URL ==> $url");
        // log("Respose body : =====> ${response.body}");
        switch (response.statusCode) {
          case 200:
          case 201:
            final data = jsonDecode(response.body);
            if (data is Map<String, dynamic>) {
              return onSuccess(data); // ✅ stop retry on success
            }

            return null;

          case 204:
            return null;

          case 400:
            return null;

          case 401:
            await handleUnauthorized();
            return null;

          case 403:
            return null;

          case 404:
            ("Resource not found (404).");
            return null;

          case 408:
            ("Request Timeout (408). Retrying...");
            break;

          case 429:
            ("Too Many Requests (429). Retrying...");
            break;

          default:
            if (response.statusCode >= 500) {
              ("Server Error (${response.statusCode}). Retrying...");
              break;
            } else {
              ("Unexpected Error (${response.statusCode}).");
              return null;
            }
        }
      } on SocketException {
        ("No internet connection. Retrying...");
      } on TimeoutException {
        ("GET request timed out. Retrying...");
      } on FormatException {
        ("Invalid response format.");
        return null;
      } on http.ClientException catch (e) {
        ("Network error: $e. Retrying...");
      } catch (e) {
        ("Unexpected error: ${e.toString()}");
        return null;
      }

      // ⏳ delay before next retry
      if (attempt < maxRetries) {
        await Future.delayed(const Duration(seconds: 1));
      }
    }

    ("GET request failed after $maxRetries attempts.");
    return null;
  }

  // ---------------------------------------------------------------------------
  // PUT REQUEST
  // Updates data on server using PUT and handles all major response codes.
  // ---------------------------------------------------------------------------
  static Future<T?> putRequest<T>({
    required String url,
    required Map<String, dynamic> body,
    required T Function(Map<String, dynamic>) onSuccess,
    Map<String, String>? headers,
    int timeoutSeconds = 15,
  }) async {
    const int maxRetries = 5;

    for (int attempt = 1; attempt <= maxRetries; attempt++) {
      try {
        ("PUT Attempt $attempt/$maxRetries: $url");
        ("BODY: $body");

        final response = await http
            .put(
              Uri.parse(url),
              body: jsonEncode(body),
              headers: headers ?? {"Content-Type": "application/json"},
            )
            .timeout(Duration(seconds: timeoutSeconds));

        ("Response [${response.statusCode}]: ${response.body}");
        // log("API URL ==> $url");
        // log("Respose body : =====> ${response.body}");
        switch (response.statusCode) {
          case 200:
          case 201:
            final data = jsonDecode(response.body);
            if (data is! Map<String, dynamic>) {
              ("Invalid response format from server.");
              return null;
            }
            return onSuccess(data); // ✅ stop retry on success

          case 204:
            ("No content (204).");
            return null;

          case 400:
            ("Bad Request (400).");
            return null;

          case 401:
            ("Unauthorized (401). ging out...");
            await handleUnauthorized();
            return null;

          case 403:
            ("Forbidden (403).");
            return null;

          case 404:
            ("Resource not found (404).");
            return null;

          case 408:
            ("Request Timeout (408). Retrying...");
            break;

          case 429:
            ("Too Many Requests (429). Retrying...");
            break;

          default:
            if (response.statusCode >= 500) {
              ("Server Error (${response.statusCode}). Retrying...");
              break;
            } else {
              ("Unexpected Error (${response.statusCode}).");
              return null;
            }
        }
      } on SocketException {
        ("No internet connection. Retrying...");
      } on TimeoutException {
        ("PUT request timed out. Retrying...");
      } on FormatException {
        ("Invalid response format.");
        return null;
      } on http.ClientException catch (e) {
        ("Network error: $e. Retrying...");
      } catch (e) {
        ("Unexpected error: ${e.toString()}");
        return null;
      }

      // ⏳ delay before next retry
      if (attempt < maxRetries) {
        await Future.delayed(const Duration(seconds: 1));
      }
    }

    ("PUT request failed after $maxRetries attempts.");
    return null;
  }

  // ---------------------------------------------------------------------------
  // DELETE REQUEST
  // Sends a DELETE request, allows optional body, and handles responses.
  // ---------------------------------------------------------------------------
  static Future<T?> deleteRequest<T>({
    required String url,
    Map<String, dynamic>? body,
    required T Function(Map<String, dynamic>) onSuccess,
    Map<String, String>? headers,
    int timeoutSeconds = 15,
  }) async {
    const int maxRetries = 5;

    for (int attempt = 1; attempt <= maxRetries; attempt++) {
      try {
        ("DELETE Attempt $attempt/$maxRetries: $url");
        if (body != null) debugPrint("BODY: $body", wrapWidth: 1024);

        final request = http.Request('DELETE', Uri.parse(url));
        request.headers.addAll(headers ?? {"Content-Type": "application/json"});

        if (body != null) request.body = jsonEncode(body);

        final response = await http.Response.fromStream(
          await request.send().timeout(Duration(seconds: timeoutSeconds)),
        );

        ("Response [${response.statusCode}]: ${response.body}");

        switch (response.statusCode) {
          case 200:
          case 201:
          case 202:
          case 204:
            if (response.body.isEmpty) {
              return onSuccess({}); // ✅ stop retry on success
            }

            final data = jsonDecode(response.body);
            if (data is! Map<String, dynamic>) {
              ("Invalid server response format.");
              return null;
            }
            return onSuccess(data); // ✅ stop retry on success

          case 400:
            ("Bad Request (400).");
            return null;

          case 401:
            ("Unauthorized (401). ging out...");
            await handleUnauthorized();
            return null;

          case 403:
            ("Forbidden (403).");
            return null;

          case 404:
            ("Resource not found (404).");
            return null;

          case 408:
            ("Timeout (408). Retrying...");
            break;

          case 429:
            ("Too Many Requests (429). Retrying...");
            break;

          default:
            if (response.statusCode >= 500) {
              ("Server Error (${response.statusCode}). Retrying...");
              break;
            } else {
              ("Unexpected Error (${response.statusCode}).");
              return null;
            }
        }
      } on SocketException {
        ("No internet connection. Retrying...");
      } on TimeoutException {
        ("DELETE request timed out. Retrying...");
      } on FormatException {
        ("Invalid response format.");
        return null;
      } on http.ClientException catch (e) {
        ("Network error: $e. Retrying...");
      } catch (e) {
        ("Unexpected error: ${e.toString()}");
        return null;
      }

      // ⏳ delay before next retry
      if (attempt < maxRetries) {
        await Future.delayed(const Duration(seconds: 1));
      }
    }

    ("DELETE request failed after $maxRetries attempts.");
    return null;
  }

  // ---------------------------------------------------------------------------
  // INTERNET CONNECTIVITY CHECK
  // Listens for internet changes and s connection status.
  // ---------------------------------------------------------------------------
  static void checkConnection(BuildContext context) {
    Connectivity().checkConnectivity().then((result) {
      if (result == ConnectivityResult.none) {
        internet = false;
        ("No Internet Connection.");
      }
    });

    Connectivity().onConnectivityChanged.listen((result) {
      if (result == ConnectivityResult.none) {
        internet = false;
        ("No Internet Connection.");
      } else {
        internet = true;
        Get.closeAllSnackbars();
        ("Internet Connected.");
      }
    });
  }

  // ---------------------------------------------------------------------------
  // IMAGE UPLOAD (Multipart)
  // Handles image file uploads using POST/PUT.
  // ---------------------------------------------------------------------------
  static Future<http.Response?> uploadImageRequest({
    required String url,
    required String method,
    required http.MultipartFile file,
    Map<String, String>? headers,
    Map<String, String>? body,
    int timeoutSeconds = 20,
  }) async {
    try {
      // 🔥 ACTUALLY USE THE PUT METHOD
      var request = http.MultipartRequest(method, Uri.parse(url));

      request.files.add(file);

      if (headers != null) {
        request.headers.addAll({
          ...headers,
          "Accept": "application/json",
        });
      }

      if (body != null) request.fields.addAll(body);

      var streamedResponse =
          await request.send().timeout(Duration(seconds: timeoutSeconds));

      var response = await http.Response.fromStream(streamedResponse);

      ("Image Upload Response: ${response.statusCode}");
      ("BODY: ${response.body}");

      return response;
    } catch (e) {
      ("UPLOAD ERROR => $e");
      return null;
    }
  }




static Future<http.Response?> uploadMultiImagesRequest({
  required String url,
  required List<http.MultipartFile> files,
  Map<String, String>? headers,
  int timeoutSeconds = 180,
}) async {
  log("uri: $url");
  log("Uploading ${files.length} file(s) with ${timeoutSeconds}s timeout");
  
  try {
    final request = http.MultipartRequest('POST', Uri.parse(url));

    request.files.addAll(files);

    if (headers != null) {
      request.headers.addAll(headers);
    }
    
    //  Apply timeout to the entire operation, not just .send()
    final streamedResponse = await request
        .send()
        .timeout(Duration(seconds: timeoutSeconds));

    // Also apply timeout to reading the response
    final response = await http.Response.fromStream(streamedResponse)
        .timeout(Duration(seconds: 30)); // Additional 30s for reading response
  
    log("UPLOAD STATUS: ${response.statusCode}");
    log("UPLOAD BODY: ${response.body}");

    return response;
  } on TimeoutException catch (e) {
    // Specific timeout error logging
    log("UPLOAD TIMEOUT: $e");
    log("Upload took longer than $timeoutSeconds seconds");
    return null;
  } on SocketException catch (e) {
    // Network error logging
    log("NETWORK ERROR: $e");
    return null;
  } catch (e) {
    log("UPLOAD ERROR: $e");
    return null;
  }
}



  

  static Future<void> handleUnauthorized() async {
    (" 401 Unauthorized → Force out");

    try {
      // Clear storage
      final box = Get.find<GetStorage>();
      await box.erase();

      // Optional: clear controllers
      // Get.deleteAll(force: true);

      // Navigate to OnBoard
      Get.offAll(() => OnBoardScreen());
    } catch (e) {
      ("out handling error: $e");
    }
  }
}
