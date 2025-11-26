// ignore_for_file: non_constant_identifier_names, prefer_interpolation_to_compose_strings

class AppURLs {
  //base api
  static String BASE_API = 'https://api.epielio.com/';

  //login api
  static String LOGIN_API = BASE_API + 'api/auth/login';

  //user details api
  static String USER_UPDATE_API = BASE_API + "api/auth/profiles/";
  static String PROFILE_UPDATE_API = BASE_API + "api/users/";

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
  static String PRODUCT_DETAILS = BASE_API + "api/referral/product/";
  static String FETCH_REFERRAL = BASE_API + "api/referral/list/";

  // Wishlist api
  static String GET_WISHLIST = BASE_API + "api/wishlist";
  static String GET_ITEM_COUNT = BASE_API + "api/wishlist/count";
  static String CHECK_IF_WISHLIST = BASE_API + "api/wishlist/check";
  static String ADD_TO_WISH = BASE_API + "api/wishlist/add";
  static String DELETE_WISHLIST = BASE_API + "api/wishlist/remove";
  static String MOVE_TO_CART = BASE_API + "api/wishlist/move-to-cart";
  static String TOGGLE_WISHLIST = BASE_API + "api/wishlist/check";
  static String CLEAR_CART_WISHLIST = BASE_API + "api/wishlist/clear";

  //Wallet api
  static String Wallet = BASE_API + "api/wallet";
  static String WALLET_TRANSACTIONS = BASE_API + "api/wallet/transactions";

  // Category api
  static String CATEGORY_API =
      BASE_API + "api/categories?parentCategoryId=null&isActive=true";

  // Product Details
  static String PRODUCT_DETAILS_API = BASE_API + "api/products/";
  static String PRODUCT_PLAN_API = BASE_API + "api/products/";

  // Products List
  static String PRODUCTS_LISTING = BASE_API + "api/products";

  //Cart Api
  static String GET_FULL_CART = BASE_API + "api/cart";
  static String GET_CART_COUNT = BASE_API + "api/cart/count";
  static String ADD_TO_CART = BASE_API + "api/cart/add/";
  static String REMOVE_FROM_CART = BASE_API + "api/cart/remove/";
  static String UPDATE_CART = BASE_API + "api/cart/update/";
  static String CLEAR_CART = BASE_API + "api/cart/clear";

  // Address api
  static String ADDRESS_API = BASE_API + "api/users/";

  // Order api
  static String CREATE_ORDER_API = BASE_API + "api/orders";

  // Payment Api
  static String PAYMENT_PROCESS_API = BASE_API + "api/payments/process";

  // Notifications
  static String NOTIFICATIONS = BASE_API + "api/notifications";
  static String UNREAD_NOTIFICATIONS =
      BASE_API + "api/notifications/unread-count";

  // Orders History
  static String ORDER_HISTORY_API = BASE_API + "api/orders/user/history";
  static String ORDER_DELIVERED_HISTORY_API =
      BASE_API + "api/orders/user/delivered";

  // Pending Transactions Api
  static String PENDING_TRANSACTIONS_API =
      BASE_API + "api/installments/payments/daily-pending";


      // Profile Api
  static String MY_PROFILE = BASE_API + "api/users/me/profile";
}
