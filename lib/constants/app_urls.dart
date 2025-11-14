// ignore_for_file: non_constant_identifier_names, prefer_interpolation_to_compose_strings

class AppURLs {
  //base api
  static String BASE_API = 'https://epi-api.epielio.com/';

  //login api
  static String GOOGLE_SIGNIN_API = BASE_API + 'api/auth/checkUserExists';
  static String getRefferal_API = BASE_API + "api/referrals/generate-code";
  static String getDashboard_API = BASE_API + "api/referrals/dashboard?userId=";
}
