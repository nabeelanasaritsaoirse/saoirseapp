// ignore_for_file: non_constant_identifier_names, prefer_interpolation_to_compose_strings

class AppURLs {
  //base api
  static String BASE_API = 'https://api.epielio.com/';

  //login api
  static String LOGIN_API = BASE_API + 'api/auth/login';

  //user details api
  static String USER_UPDATE_API = BASE_API + "api/auth/profile/";

  //refferal api
  static String getRefferal_API = BASE_API + "api/referrals/generate-code";
  static String getDashboard_API = BASE_API + "api/referrals/dashboard?userId=";
}
