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
      await googleSignIn.initialize(
          serverClientId:
              '486829564070-mkrkm4v9tji249t6u7gdfiefups09gs4.apps.googleusercontent.com');
      final GoogleSignInAccount googleSignInAccount =
          await googleSignIn.authenticate();

      final GoogleSignInAuthentication googleSignInAuthentication =
          googleSignInAccount.authentication;
      final AuthCredential authCredential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
      );

      // Getting users credential
      UserCredential result = await auth.signInWithCredential(authCredential);

      return await result.user?.getIdToken();
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
