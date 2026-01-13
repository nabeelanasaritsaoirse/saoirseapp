// ignore_for_file: non_constant_identifier_names, prefer_interpolation_to_compose_strings

class AppURLs {
  //base api
  // static String BASE_API = 'https://api.epielio.com/';
  static String BASE_API = 'http://13.127.15.87:8080/';

  //login api
  static String LOGIN_API = BASE_API + 'api/auth/login';

  // Noitification
  static String NOTIFICATION_API = BASE_API + "api/notifications/trigger";

  //user details api
  static String USER_UPDATE_API = BASE_API + "api/auth/profiles/";
  static String PROFILE_UPDATE_API = BASE_API + "api/users/";

  static String FEATURED_LISTS_API = BASE_API + "api/featured-lists";

  //refferal api
  static String getRefferal_API = BASE_API + "api/referrals/generate-code";
  static String getDashboard_API = BASE_API + "api/referrals/dashboard?userId=";
  static String FRIEND_DETAILS = BASE_API + "api/referral/friend/";
  static String PRODUCT_DETAILS = BASE_API + "api/referral/product/";
  static String FETCH_REFERRAL = BASE_API + "api/referral/list/";
  static String APPLY_REFERRAL = BASE_API + "api/auth/applyReferralCode";
  static String REFERRAL_INFO = BASE_API + "api/referral/referrer-info";
  static String REFERRAL_STATS = BASE_API + "api/referral/stats/";

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
  static String ADD_MONEY_WALLET = BASE_API + "api/wallet/add-money";
  static String VERIFY_PAYMENT = BASE_API + "api/wallet/verify-payment";
  static String WITHDRAWAL_API = BASE_API + "api/wallet/withdraw";

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

  // KYC api
  static String KYC_API = BASE_API + "api/kyc/status";
  static String KYC_SUBMIT_API = BASE_API + "api/kyc/submit";
  static String KYC_UPLOAD_API = BASE_API + "api/kyc/upload";

  // Order api
  static String CREATE_ORDER_API = BASE_API + "api/installments/orders";
  static String CREATE_BULK_ORDER_API =
      BASE_API + "api/installments/orders/bulk";
  static String INSTALLMENT_ORDER_PREVIEW_API =
      BASE_API + "api/installments/orders/preview";
  static String BULK_ORDER_PREVIEW =
      BASE_API + "api/installments/orders/bulk/preview";

  // Payment Api
  static String PAYMENT_PROCESS_API =
      BASE_API + "api/installments/payments/process";
  static String PAYMENT_VERIFY_API =
      BASE_API + "api/installments/orders/bulk/verify-payment";

  // Notifications
  static String NOTIFICATIONS = BASE_API + "api/notifications";
  static String UNREAD_NOTIFICATIONS =
      BASE_API + "api/notifications/unread-count";
  static String ENABLE_AUTOPAY = BASE_API + "api/installments/autopay/enable";

  // Orders History
  static String ORDER_HISTORY_API = BASE_API + "api/installments/orders";
  static String ORDER_DELIVERED_HISTORY_API = BASE_API +
      "api/installments/orders"; // same endpoint with different status filter only

  // Pending Transactions Api
  static String PENDING_TRANSACTIONS_API =
      BASE_API + "api/installments/payments/daily-pending";

  // Investment Status Api
  static String INVESTMENT_STATUS_API =
      BASE_API + "api/installments/orders/overall-status";

  // Success Story Banner API
  static String SUCCESS_STORY_BANNER_API =
      BASE_API + "api/success-stories/public/active";

  // Home Screen Top Banner API
  static String HOME_SCREEN_TOP_BANNER_API =
      BASE_API + "api/banners/public/active";

  // Profile Api
  static String MY_PROFILE = BASE_API + "api/users/me/profile";

  //Log Out Api
  static String LOGOUT_API = BASE_API + "api/auth/logout";

  // Pending Transaction (BEFORE PAYMENT METHOD API RESPONSE)
  static String PENDING_TRANSACTION_PAYMENT_RESPONSE =
      BASE_API + "api/installments/payments/create-combined-razorpay";

  // Pending Transaction (AFTER PAYMENT METHOD API )
  static String PENDING_TRANSACTION_PAY_DAILY_SELECTED =
      BASE_API + "api/installments/payments/pay-daily-selected";

  // Sub Category Order Listing Page
  static String PRODUCT_LISTING_SUBCATEGORY =
      BASE_API + "api/products/category/";

  //Get all coupons from api
  static String GET_ALL_COUPONS = BASE_API + "api/coupons";

  //Chat messages
  static String CREATE_INDIVIDUAL_CHAT_FROM_REFFERAL =
      BASE_API + "api/chat/conversations/individual";

  //Post request for Coupon Validation after this API will send the response
  static String POST_RQ_COUPONS_VALIDATION =
      BASE_API + "api/installments/validate-coupon";
}
