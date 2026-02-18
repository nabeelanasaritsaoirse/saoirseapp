import 'package:get/get.dart';

import '../screens/add_address/add_address_controller.dart';
import '../screens/add_money/add_money_controller.dart';
import '../screens/home/investment_status_controller.dart';
import '../screens/login/login_controller.dart';
import '../screens/my_wallet/my_wallet_controller.dart';
import '../screens/order_delivered/order_delivered_controller.dart';
import '../screens/order_details/order_details_controller.dart';
import '../screens/order_history/order_history_controller.dart';
import '../screens/orders_active/orders_active_controller.dart';
import '../screens/pending_transaction/pending_transaction_controller.dart';
import '../screens/profile/profile_controller.dart';
import '../screens/kyc/kyc_controller.dart';
import '../screens/razorpay/pending_transaction_razorpay_controller.dart';
import '../screens/razorpay/razorpay_cart_controller.dart';
import '../screens/razorpay/razorpay_controller.dart';
import '../screens/select_account/select_account_controller.dart';
import '../screens/select_address/select_address_controller.dart';
import '../screens/wishlist/wishlist_controller.dart';
import '../screens/refferal/referral_controller.dart';
import '../screens/dashboard/dashboard_controller.dart';
import '../screens/cart/cart_controller.dart';
import '../screens/home/home_controller.dart';
import '../screens/category/category_controller.dart';
import '../screens/productListing/productListing_controller.dart';
import '../screens/withdtraw/withdraw_controller.dart';

class AllController extends Bindings {
  @override
  void dependencies() {
    // 🔒 APP LEVEL (PERMANENT)
    Get.put(DashboardController(), permanent: true);
    Get.put(CartController(), permanent: true);
    // Get.put(MessageController(conversationId: '', participants: []),
    //     permanent: true);

    // 🔐 AUTH / USER
    Get.lazyPut<LoginController>(
      () => LoginController(),
      fenix: true,
    );
    // 💳 WALLET & PAYMENTS
    Get.put(MyWalletController(), permanent: true);
    // Get.lazyPut<VerifyOtpController>(
    //     () => VerifyOtpController(phoneNumber: '', referral: '', username: ''));
    Get.lazyPut<ProfileController>(
      () => ProfileController(),
      fenix: true,
    );
    Get.lazyPut<KycController>(
      () => KycController(),
      fenix: true,
    );
    Get.lazyPut<SelectAddressController>(
      () => SelectAddressController(),
      fenix: true,
    );
    Get.lazyPut<WishlistController>(
      () => WishlistController(),
      fenix: true,
    );
    Get.lazyPut<ReferralController>(
      () => ReferralController(),
      fenix: true,
    );

    // 🏠 HOME & CATEGORY
    Get.lazyPut<HomeController>(
      () => HomeController(),
      fenix: true,
    );
    Get.lazyPut<CategoryController>(
      () => CategoryController(),
      fenix: true,
    );
    Get.lazyPut<InvestmentStatusController>(
      () => InvestmentStatusController(),
      fenix: true,
    );

    Get.lazyPut<SelectAccountController>(
      () => SelectAccountController(),
      fenix: true,
    );

    // 🛍 PRODUCT
    Get.lazyPut<ProductlistingController>(
      () => ProductlistingController(),
      fenix: true,
    );
    // Get.lazyPut<ProductDetailsController>(
    //   () => ProductDetailsController(productId: ''),
    //   fenix: true,
    // );

    // 📦 ORDERS
    Get.lazyPut<OrderActiveController>(
      () => OrderActiveController(),
      fenix: true,
    );
    Get.lazyPut<OrderHistoryController>(
      () => OrderHistoryController(),
      fenix: true,
    );
    Get.lazyPut<OrderDeliveredController>(
      () => OrderDeliveredController(),
      fenix: true,
    );
    Get.lazyPut<OrderDetailsController>(
      () => OrderDetailsController(),
      fenix: true,
    );

    Get.lazyPut<WithdrawController>(
      () => WithdrawController(),
      fenix: true,
    );
    Get.lazyPut<RazorpayController>(
      () => RazorpayController(),
      fenix: true,
    );
    Get.put<RazorpayCartController>(
      RazorpayCartController(),
      permanent: true,
    );
    Get.lazyPut<PendingTransactionRazorpayController>(
      () => PendingTransactionRazorpayController(),
      fenix: true,
    );

    Get.put<PendingTransactionController>(
      PendingTransactionController(),
      permanent: true,
    );

    // 📍 ADDRESS & MONEY
    Get.lazyPut<AddAddressController>(
      () => AddAddressController(),
      fenix: true,
    );
    Get.lazyPut<AddMoneyController>(
      () => AddMoneyController(),
      fenix: true,
    );
  }
}
