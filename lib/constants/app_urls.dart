// ignore_for_file: non_constant_identifier_names, prefer_interpolation_to_compose_strings

class AppURLs {
  //base api
  static String BASE_API = 'https://api.epielio.com/';

  //login api
  static String LOGIN_API = BASE_API + 'api/auth/login';

  //user details api
  static String USER_UPDATE_API = BASE_API + "api/auth/profiles/";

  // home screen api
  static String POPULAR_PRODUCT_API =
      BASE_API + "api/products/featured/popular?";
  static String BEST_SELLER_PRODUCT_API =
      BASE_API + "api/products/featured/best-sellers?";
  static String TRENDING_PRODUCT_API =
      BASE_API + "api/products/featured/trending?";

  //refferal api
  static String getRefferal_API = BASE_API + "api/referrals/generate-code";
  static String getDashboard_API = BASE_API + "api/referrals/dashboard?userId=";
  static String FRIEND_DETAILS = BASE_API + "api/referral/friend/";
  static String PRODUCT_DETAILS = BASE_API + "/api/referral/product/";
  static String FETCH_REFERRAL = BASE_API + "/api/referral/list/";

  // Wishlist api
  static String GET_FULL_WISHLIST = BASE_API + "/api/wishlist";
  static String GET_ITEM_COUNT = BASE_API + "/api/wishlist/count";
  static String CHECK_IF_WISHLIST = BASE_API + "/wishlist/check/productId";
  static String ADD_TO_WISH = BASE_API + "/wishlist/add/productId";
  static String DELETE_WISHLIST = BASE_API + "/wishlist/remove/productId";
  static String MOVE_TO_CART = BASE_API + "/wishlist/move-to-cart/productId";
  static String TOGGLE_WISHLIST = BASE_API + "/wishlist/check/productId";
  static String CLEAR_CART_WISHLIST = BASE_API + "/wishlist/clear";

  //Wallet api
  static String Wallet = BASE_API + "api/wallet";
}
