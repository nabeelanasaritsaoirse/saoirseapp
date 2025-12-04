import '../constants/app_strings.dart';

class LoginService {
  // email validation
  static String? emailValidation({required String email}) {
    if (email.isEmpty ||
        !RegExp(
          r"^[a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+$",
        ).hasMatch(email)) {
      return AppStrings.invalid_email;
    }
    return null;
  }

  // password validation
  static String? passValidation({required String pass}) {
    if (pass.isEmpty ||
        !RegExp(
          r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}$",
        ).hasMatch(pass)) {
      return AppStrings.invalid_pass;
    }
    return null;
  }

  // phone validation
  static int? phoneValidation({required int phone}) {
    if (phone.toString().length != 10) {
      return 0; // invalid
    }
    return null; // valid
  }

  // username validation
  static String? usernameValidation({required String username}) {
    if (username.isEmpty || !RegExp(r"^[a-zA-Z ]{3,}$").hasMatch(username)) {
      return AppStrings.invalid_name;
    }
    return null;
  }

  // referral code validation
  static String? referralValidation({required String referral}) {
    if (referral.isEmpty ||
        !RegExp(r"^[A-Za-z0-9]{6,10}$").hasMatch(referral)) {
      return AppStrings.invalid_referral;
    }
    return null;
  }
}
