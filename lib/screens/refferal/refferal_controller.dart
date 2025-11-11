import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../models/refferal_model.dart';

class ReferralController extends GetxController {
  final referralCode = '874126'.obs;
  final referralUsers = <ReferralUser>[].obs;
  final filteredUsers = <ReferralUser>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadReferralData();
  }

  void loadReferralData() {
    referralUsers.value = [
      ReferralUser(no: 1, name: 'Rajive Kumar', purchaseItems: 2, commission: 840),
      ReferralUser(no: 2, name: 'Afsal', purchaseItems: 4, commission: 1256),
    ];
    filteredUsers.value = referralUsers;
  }

  void filterReferrals(String query) {
    if (query.isEmpty) {
      filteredUsers.value = referralUsers;
    } else {
      filteredUsers.value = referralUsers
          .where((user) => user.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  void copyReferralCode() {
    Clipboard.setData(ClipboardData(text: referralCode.value));
    Get.snackbar(
      'Copied!',
      'Referral code copied to clipboard',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
      backgroundColor: Colors.green,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
    );
  }

  // Social share methods (mock)
  void shareToWhatsApp() => Get.snackbar('Share', 'Opening WhatsApp...');
  void shareToFacebook() => Get.snackbar('Share', 'Opening Facebook...');
  void shareToTelegram() => Get.snackbar('Share', 'Opening Telegram...');
  void shareToTwitter() => Get.snackbar('Share', 'Opening Twitter...');
  void shareToGmail() => Get.snackbar('Share', 'Opening Gmail...');
  void shareMore() => Get.snackbar('Share', 'Opening more options...');
}





// // Controller
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:saoirse_app/models/refferal_model.dart';

// class ReferralController extends GetxController {
//   final referralCode = '874126'.obs;
//   final referralUsers = <ReferralUser>[].obs;

//   @override
//   void onInit() {
//     super.onInit();
//     loadReferralData();
//   }

//   void loadReferralData() {
//     // Simulated data - replace with actual API call
//     referralUsers.value = [
//       ReferralUser(
//         no: 1,
//         name: 'Rajive Kumar',
//         purchaseItems: 2,
//         commission: 840,
//       ),
//       ReferralUser(
//         no: 2,
//         name: 'Afsal',
//         purchaseItems: 4,
//         commission: 1256,
//       ),
//     ];
//   }

//   void copyReferralCode() {
//     Clipboard.setData(ClipboardData(text: referralCode.value));
//     Get.snackbar(
//       'Copied!',
//       'Referral code copied to clipboard',
//       snackPosition: SnackPosition.BOTTOM,
//       duration: const Duration(seconds: 2),
//       backgroundColor: Colors.green,
//       colorText: Colors.white,
//       margin: const EdgeInsets.all(16),
//     );
//   }

//   void shareToWhatsApp() {
//     // Implement WhatsApp sharing
//     Get.snackbar('Share', 'Opening WhatsApp...');
//   }

//   void shareToFacebook() {
//     // Implement Facebook sharing
//     Get.snackbar('Share', 'Opening Facebook...');
//   }

//   void shareToTelegram() {
//     // Implement Telegram sharing
//     Get.snackbar('Share', 'Opening Telegram...');
//   }

//   void shareToTwitter() {
//     // Implement Twitter sharing
//     Get.snackbar('Share', 'Opening Twitter...');
//   }

//   void shareToGmail() {
//     // Implement Gmail sharing
//     Get.snackbar('Share', 'Opening Gmail...');
//   }

//   void shareMore() {
//     // Implement more sharing options
//     Get.snackbar('Share', 'Opening more options...');
//   }
// }