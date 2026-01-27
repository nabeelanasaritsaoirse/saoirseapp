// ignore_for_file: unnecessary_nullable_for_final_variable_declarations, await_only_futures

import 'dart:io';
import 'dart:convert';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:crypto/crypto.dart';

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

  // Apple Login
  static Future<String?> appleLogin() async {
    try {
      final rawNonce = generateNonce();
      final nonce = sha256ofString(rawNonce);

      // Request credential for the user
      final AuthorizationCredentialAppleID appleCredential =
          await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      // Create an `OAuthCredential` from the credential data
      final OAuthProvider provider = OAuthProvider('apple.com');
      final AuthCredential credential = provider.credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
        rawNonce: rawNonce,
      );

      // Sign in to Firebase with the Apple Credential
      final UserCredential userCredential =
          await auth.signInWithCredential(credential);

      return userCredential.user?.getIdToken();
    } catch (e) {
      appToast(content: "Apple Login Error: $e", error: true);
      return null;
    }
  }

  /// Generate a random string for the nonce
  static String generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  static String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  static Future<void> signOut() async {
    await auth.signOut();
    await GoogleSignIn.instance.signOut();
    await storage.erase();
  }
}
