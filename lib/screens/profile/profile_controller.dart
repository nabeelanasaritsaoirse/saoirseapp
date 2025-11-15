import 'package:get/get.dart';
import 'package:saoirse_app/constants/app_assets.dart';

class ProfileController extends GetxController {
  final myOrders = [
    {"icon": AppAssets.pending_payment, "title": "Pending Payment"},
    {"icon": AppAssets.order_history, "title": "Order History"},
    {"icon": AppAssets.wishlist, "title": "Wishlist"},
    {"icon": AppAssets.transactions, "title": "Transactions"},
    {"icon": AppAssets.delivered, "title": "Delivered"},
    {"icon": AppAssets.customer_care, "title": "Customer Care"},
  ];

  final settings = [
    {"icon": AppAssets.password_security, "title": "Password & security"},
    {"icon": AppAssets.privacy_policy, "title": "Privacy Policy"},
    {"icon": AppAssets.terms_condition, "title": "Terms & Condition"},
    {"icon": AppAssets.faq, "title": "FAQ"},
    {"icon": AppAssets.about, "title": "About EPI"},
    {"icon": AppAssets.logout, "title": "Log Out"},
  ];
}
