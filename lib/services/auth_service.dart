// ignore_for_file: avoid_print, unnecessary_nullable_for_final_variable_declarations, await_only_futures

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

  static Future<LoginResponse?> loginWithIdToken(String idToken) async {
    try {
      print("============================================");
      print(" [LOGIN SERVICE] Starting login process...");
      print("ID Token:");
      print(idToken);
      print("============================================");

      final response = await APIService.postRequest(
        url: AppURLs.LOGIN_API,
        body: {"idToken": idToken},
        onSuccess: (json) => LoginResponse.fromJson(json),
      );

      print("[RAW RESPONSE] $response");

      if (response == null) {
        print("[LOGIN ERROR] Response NULL");
        return null;
      }

      print(" [LOGIN SUCCESS FLAG] ${response.success}");
      print(" [LOGIN MESSAGE] ${response.message}");

      if (response.success != true) {
        print(" [LOGIN FAIL MESSAGE] ${response.message}");
        return null;
      }

      final data = response.data!;

      print("============================================");
      print(" [LOGIN SUCCESS - PARSED DATA]");
      print("   ➤ userId: ${data.userId}");
      print("   ➤ accessToken: ${data.accessToken}");
      print("   ➤ refreshToken: ${data.refreshToken}");
      print("============================================");

      return response;
    } catch (e) {
      print(" [LOGIN EXCEPTION] $e");
      return null;
    }
  }

  /// STEP 1: SEND OTP
  static Future<bool> sendOTP(String phone) async {
    print("[SEND OTP] Requesting OTP for: $phone");
    try {
      await auth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto complete
          print(" [AUTO VERIFIED] Firebase auto verified OTP.");
        },
        verificationFailed: (FirebaseAuthException e) {
          print(" [OTP FAILED] ${e.code} : ${e.message}");
          // appToast(content: e.message!, error: true);
        },
        codeSent: (String vId, int? resendToken) {
          print("[CODE SENT] verificationId: $vId");
          verificationId = vId;
        },
        codeAutoRetrievalTimeout: (String vId) {
          print("[TIMEOUT] Auto-retrieval timed out");
          verificationId = vId;
        },
      );
      print("[SEND OTP COMPLETED]");
      return true;
    } catch (e) {
      print("[SEND OTP ERROR] $e");
      // appToast(content: "OTP sending failed: $e", error: true);
      return false;
    }
  }

  /// STEP 2: VERIFY OTP
  static Future<String?> verifyOTP(String otp) async {
    print("[VERIFY OTP] Verifying OTP: $otp");

    if (verificationId == null) {
      print("[ERROR] verificationId is NULL!");
      appToast(
          content: "OTP expired or not sent. Please send OTP again.",
          error: true);
      return null;
    }

    try {
      print("Using verificationId: $verificationId");

      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId!,
        smsCode: otp,
      );

      UserCredential result = await auth.signInWithCredential(credential);

      print("[OTP VERIFIED] Firebase logged in: ${result.user?.uid}");

      final token = await result.user?.getIdToken();
      print("[FIREBASE ID TOKEN] $token");

      return token;
    } catch (e) {
      print("[VERIFY OTP ERROR] $e");
      appToast(content: "Invalid OTP: $e", error: true);
      return null;
    }
  }

  //google Login
  static Future<String?> googleLogin() async {
    try {
      final google = GoogleSignIn.instance;

      // Initialize Google Sign-In
      await google.initialize(
        serverClientId:
            '486829564070-mkrkm4v9tji249t6u7gdfiefups09gs4.apps.googleusercontent.com',
      );

      // Authenticate (opens Google account selector)
      final GoogleSignInAccount? account = await google.authenticate();

      if (account == null) {
        appToast(content: "Login cancelled", error: true);
        return null;
      }
      googleUser = account;
      print("GOOGLE NAME: ${account.displayName}");
      print("GOOGLE EMAIL: ${account.email}");
      print("GOOGLE PHOTO: ${account.photoUrl}");
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
      print("GOOGLE LOGIN ERROR::: $e");
      appToast(content: "Google Login Error: $e", error: true);
      return null;
    }
  }

  static signOut() async {
    try {
      await auth.signOut();
      await GoogleSignIn.instance.signOut();
      await storage.erase();
    } catch (e) {
      print("GET ERROR::: $e");
    }
  }
}
