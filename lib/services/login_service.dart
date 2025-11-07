import '../constants/app_strings.dart';
import '../widgets/app_snackbar.dart';

class LoginService {
  //email validation
  static String? emailValidation({required String email}) {
    if (email.isEmpty ||
        !RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
        ).hasMatch(email)) {
     // appSnackbar(error: true, content: AppStrings.invalid_email);
      return '';
    }

    return null;
  }
}
