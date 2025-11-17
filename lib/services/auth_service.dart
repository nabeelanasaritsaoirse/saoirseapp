import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../main.dart';
import '../widgets/app_snackbar.dart';

class AuthService {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static GoogleSignInAccount? googleUser;
  static String? verificationId;

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
          appSnackbar(content: e.message!, error: true);
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
      appSnackbar(content: "OTP sending failed: $e", error: true);
      return false;
    }
  }

  /// STEP 2: VERIFY OTP
  static Future<String?> verifyOTP(String otp) async {
    print("[VERIFY OTP] Verifying OTP: $otp");

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
      appSnackbar(content: "Invalid OTP: $e", error: true);
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
        appSnackbar(content: "Login cancelled", error: true);
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
        appSnackbar(content: "Failed to get Google ID Token", error: true);
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
      appSnackbar(content: "Google Login Error: $e", error: true);
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
