import '../constants/app_strings.dart';
import '../widgets/app_snackbar.dart';

class LoginService {
  //email validation
  static String? emailValidation({required String email}) {
    if (email.isEmpty ||
        !RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
        ).hasMatch(email)) {
      appSnackbar(error: true, content: AppStrings.invalid_email);

      return '';
    }

    return null;
  }

  //password validation
  static String? passValidation({required String pass}) {
    if (pass.isEmpty ||
        !RegExp(
          r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}$",
        ).hasMatch(pass)) {
      appSnackbar(error: true, content: AppStrings.invalid_pass);

      return '';
    }

    return null;
  }

  //phone validation
  static int? phoneValidation({required int phone}) {
    if (phone.toString().length != 10) {
      appSnackbar(error: true, content: AppStrings.invalid_phone);

      return 0;
    }

    return null;
  }
  static String? usernameValidation({required String username}) {
  if (username.isEmpty ||
      !RegExp(r"^[a-zA-Z ]{3,}$").hasMatch(username)) {
    appSnackbar(error: true, content: AppStrings.invalid_name);
    return '';
  }
  return null;
}
// referral code validation
static String? referralValidation({required String referral}) {
  // Example: referral code must be 6–10 alphanumeric
  if (referral.isEmpty ||
      !RegExp(r"^[A-Za-z0-9]{6,10}$").hasMatch(referral)) {
    appSnackbar(error: true, content: AppStrings.invalid_referral);
    return '';
  }
  return null;
}





}
