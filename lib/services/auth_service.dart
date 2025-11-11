import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../main.dart';
import '../widgets/app_snackbar.dart';

class AuthService {
  static FirebaseAuth auth = FirebaseAuth.instance;

  //google Login
  static googleLogin() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn.instance;
      final GoogleSignInAccount googleSignInAccount =
          await googleSignIn.authenticate();

      print(googleSignInAccount.authentication);

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential authCredential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
        );

        // Getting users credential
        UserCredential result = await auth.signInWithCredential(authCredential);

        return result;
      } else {
        appSnackbar(content: 'Login unsuccessful', error: true);
        return null;
      }
    } catch (e) {
      appSnackbar(content: 'Google Error: ${e.toString()}', error: true);
      print("ERROR::: ${e.toString()}");
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
