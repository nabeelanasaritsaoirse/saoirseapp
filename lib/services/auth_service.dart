// ignore_for_file: unnecessary_nullable_for_final_variable_declarations, await_only_futures

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../constants/app_urls.dart';
import '../main.dart';
import '../models/LoginAuth/login_response/login_response.dart';
import '../widgets/app_toast.dart';
import 'api_service.dart';

class AuthService {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static GoogleSignInAccount? googleUser;
  static String? verificationId;
  static int? _resendToken;

  static Future<LoginResponse?> loginWithIdToken(String idToken) async {
    try {
      final response = await APIService.postRequest(
        url: AppURLs.LOGIN_API,
        body: {"idToken": idToken},
        onSuccess: (json) => LoginResponse.fromJson(json),
      );

      if (response == null) {
        return null;
      }

      if (response.success != true) {
        return null;
      }

      return response;
    } catch (e) {
      return null;
    }
  }

  /// STEP 1: SEND OTP
  static Future<bool> sendOTP(String phone, {bool isResend = false}) async {
    try {
      await auth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {},
        verificationFailed: (FirebaseAuthException e) {
          // appToast(content: e.message!, error: true);
        },
        codeSent: (String vId, int? resendToken) {
          verificationId = vId;
          _resendToken = resendToken;
        },
        codeAutoRetrievalTimeout: (String vId) {
          verificationId = vId;
        },
        forceResendingToken: isResend ? _resendToken : null,
      );

      return true;
    } catch (e) {
      // appToast(content: "OTP sending failed: $e", error: true);
      return false;
    }
  }

  /// STEP 2: VERIFY OTP
  static Future<String?> verifyOTP(String otp) async {
    if (verificationId == null) {
      appToast(
          content: "OTP expired or not sent. Please send OTP again.",
          error: true);
      return null;
    }

    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId!,
        smsCode: otp,
      );

      UserCredential result = await auth.signInWithCredential(credential);

      final token = await result.user?.getIdToken();

      return token;
    } catch (e) {
      appToast(content: "Invalid OTP: $e", error: true);
      return null;
    }
  }

  //google Login
  static Future<String?> googleLogin() async {
    try {
      final google = GoogleSignIn.instance;

      // Initialize Google Sign-In
      if (Platform.isAndroid) {
        await google.initialize(
          serverClientId:
              '486829564070-mkrkm4v9tji249t6u7gdfiefups09gs4.apps.googleusercontent.com',
        );
      }

      // Authenticate (opens Google account selector)
      final GoogleSignInAccount? account = await google.authenticate();

      if (account == null) {
        appToast(content: "Login cancelled", error: true);
        return null;
      }
      googleUser = account;

      // Get Google authentication tokens
      final GoogleSignInAuthentication authData = await account.authentication;

      final idToken = authData.idToken;

      if (idToken == null) {
        appToast(content: "Failed to get Google ID Token", error: true);
        return null;
      }

      // Sign in to Firebase using Google token
      final credential = GoogleAuthProvider.credential(
        idToken: idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      return idToken;
    } catch (e) {
      appToast(content: "Google Login Error: $e", error: true);
      return null;
    }
  }

  static Future<void> signOut() async {
    await auth.signOut();
    await GoogleSignIn.instance.signOut();
    await storage.erase();
  }
}
