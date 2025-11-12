import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:saoirse_app/constants/app_constant.dart';
import 'package:saoirse_app/constants/app_urls.dart';
import 'package:saoirse_app/main.dart';
import 'package:saoirse_app/models/dashboard_model.dart';
import 'package:saoirse_app/models/refferal_model.dart';

class ReferralService {
  Future<ReferralResponse?> fetchReferralCode() async {
    try {
      final userId = await storage.read(AppConst.USER_ID);

      if (userId == null || userId.isEmpty) {
        debugPrint("User ID not found in storage");
        throw Exception("User ID not found. Please log in again.");
      }

      final url = Uri.parse(
        AppURLs.getRefferal_API,
      );

      Map<String, String> body = {'userId': userId};

      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data is! Map<String, dynamic>) {
          throw Exception("Invalid response format from server.");
        }

        final referralResponse = ReferralResponse.fromJson(data);

        if (referralResponse.success) {
          log("Referral code fetched: ${referralResponse.referralCode}");
          return referralResponse;
        } else {
          debugPrint("API returned an error: ${referralResponse.message}");
          throw Exception(referralResponse.message);
        }
      } else if (response.statusCode >= 500) {
        debugPrint("Server error: ${response.statusCode}");
        throw Exception("Server error. Please try again later.");
      } else if (response.statusCode == 404) {
        debugPrint("Endpoint not found (404)");
        throw Exception("Referral service not available. (404)");
      } else {
        debugPrint("Unexpected HTTP status: ${response.statusCode}");
        throw Exception("Unexpected error occurred: ${response.statusCode}");
      }
    } on TimeoutException catch (_) {
      debugPrint("Request timed out");
      throw Exception(
        "Request timed out. Please check your internet connection.",
      );
    } on FormatException catch (e) {
      debugPrint("JSON decoding error: $e");
      throw Exception("Invalid data format received from server.");
    } on SocketException catch (_) {
      debugPrint("No Internet connection");
      throw Exception("No internet connection. Please try again later.");
    } on http.ClientException catch (e) {
      debugPrint("Network error: $e");
      throw Exception("Network error. Please check your connection.");
    } catch (e) {
      debugPrint("Unexpected error: $e");
      throw Exception("Something went wrong: ${e.toString()}");
    }
  }


    Future<DashboardModel?> fetchReferralDashboard() async {
    try {
      final userId = await storage.read(AppConst.USER_ID);
      

      if (userId.isEmpty) {
        debugPrint("User ID not found in local storage");
        throw Exception("User ID not found. Please log in again.");
      }

      final url =
          Uri.parse('${AppURLs.getDashboard_API}$userId');
      debugPrint("Fetching dashboard data from: $url");

      final response = await http
          .get(
            url,
            headers: {
              'Content-Type': 'application/json',
            },
          )
          .timeout(const Duration(seconds: 15));

      debugPrint("📥 Response [${response.statusCode}]: ${response.body}");

     
      switch (response.statusCode) {
        case 200:
        case 201:
          final data = jsonDecode(response.body);
          if (data is! Map<String, dynamic>) {
            throw Exception("Invalid response format received from server.");
          }
          return DashboardModel.fromJson(data);

        case 204:
          throw Exception("No data available at the moment.");

        case 400:
          throw Exception("Invalid request. Please check the request parameters.");

        case 401:
          throw Exception("Unauthorized access. Please log in again.");

        case 403:
          throw Exception("Access denied. You don't have permission to view this data.");

        case 404:
          throw Exception("Dashboard not found. (404)");

        case 408:
          throw Exception("Request timeout. Please try again later.");

        case 429:
          throw Exception("Too many requests. Please slow down and try again later.");

        default:
          if (response.statusCode >= 500) {
            throw Exception("Server error (${response.statusCode}). Please try again later.");
          } else {
            throw Exception("Unexpected error (${response.statusCode}). Please try again.");
          }
      }
    } on SocketException {
      debugPrint("No Internet connection");
      throw Exception("No internet connection. Please check your network.");
    } on FormatException catch (e) {
      debugPrint("JSON decoding error: $e");
      throw Exception("Invalid data format received from server.");
    } on TimeoutException {
      debugPrint("Request timed out");
      throw Exception("Request timed out. Please check your internet connection.");
    } on http.ClientException catch (e) {
      debugPrint("HTTP Client error: $e");
      throw Exception("Network error occurred. Please check your connection.");
    } catch (e) {
      debugPrint("Unexpected error: $e");
      throw Exception("Something went wrong: ${e.toString()}");
    }
  }
}
