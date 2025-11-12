import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';

import 'package:get/get.dart';

import 'package:saoirse_app/models/dashboard_model.dart';
import 'package:saoirse_app/services/refferal_service.dart';
import 'package:saoirse_app/widgets/app_snackbar.dart';
import 'package:url_launcher/url_launcher.dart';

class ReferralController extends GetxController {
  final ReferralService _referralService = ReferralService();

  final referralCode = ''.obs;
  final isLoading = false.obs;
  final isDashboardLoading = false.obs;

  final referrals = <Referral>[].obs;
  final filteredReferrals = <Referral>[].obs;

  final walletBalance = 0.0.obs;
  final totalEarnings = 0.0.obs;
  final totalReferrals = 0.obs;
  final activeReferrals = 0.obs;

  @override
  void onInit() {
    super.onInit();
    getReferralCode();
    fetchReferralDashboard();
  }

  //  Fetch referral code
  Future<void> getReferralCode() async {
    try {
      isLoading.value = true;

      final response = await _referralService.fetchReferralCode();
      if (response != null && response.success) {
        referralCode.value = response.referralCode;
      } else {
        appSnackbar(
          error: true,
          content: response?.message ?? 'Failed to fetch referral code',
        );
      }
    } catch (e) {
      appSnackbar(error: true, content: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch Dashboard Data
  Future<void> fetchReferralDashboard() async {
    try {
      isDashboardLoading.value = true;

      final dashboard = await _referralService.fetchReferralDashboard();
      if (dashboard != null && dashboard.success) {
        final data = dashboard.dashboardData;

        // Basic Stats
        walletBalance.value = data?.stats?.walletBalance.toDouble() ?? 0.0;
        totalEarnings.value = data?.stats?.totalEarnings.toDouble() ?? 0.0;
        activeReferrals.value = data?.stats?.activeReferrals ?? 0;
        totalReferrals.value = data?.stats?.totalReferrals ?? 0;

        // Referrals
        referrals.assignAll(data?.referrals ?? []);
        filteredReferrals.assignAll(referrals);
      } else {
        appSnackbar(error: true, content: "Failed to fetch referral dashboard");
      }
    } catch (e) {
      appSnackbar(error: true, content: e.toString());
    } finally {
      isDashboardLoading.value = false;
    }
  }

  Future<void> shareToWhatsApp() async {
    final message =
        "Hey! Join me on this app using my referral code: ${referralCode.value}";
    final whatsappUrl = "whatsapp://send?text=${Uri.encodeComponent(message)}";

    if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
      await launchUrl(Uri.parse(whatsappUrl));
    } else {
      final fallback = "https://wa.me/?text=${Uri.encodeComponent(message)}";
      await launchUrl(
        Uri.parse(fallback),
        mode: LaunchMode.externalApplication,
      );
    }
  }

  Future<void> shareToFacebook() async {
    final message = "Join me using my referral code: ${referralCode.value}";
    final fbUrl =
        "fb://faceweb/f?href=https://facebook.com/sharer/sharer.php?u=${Uri.encodeComponent(message)}";

    if (await canLaunchUrl(Uri.parse(fbUrl))) {
      await launchUrl(Uri.parse(fbUrl));
    } else {
      final fallback =
          "https://www.facebook.com/sharer/sharer.php?u=${Uri.encodeComponent(message)}";
      await launchUrl(
        Uri.parse(fallback),
        mode: LaunchMode.externalApplication,
      );
    }
  }

  Future<void> shareToTelegram() async {
    final message = "Join me using my referral code: ${referralCode.value}";
    final telegramUrl = "tg://msg?text=${Uri.encodeComponent(message)}";

    if (await canLaunchUrl(Uri.parse(telegramUrl))) {
      await launchUrl(Uri.parse(telegramUrl));
    } else {
      final fallback =
          "https://t.me/share/url?text=${Uri.encodeComponent(message)}";
      await launchUrl(
        Uri.parse(fallback),
        mode: LaunchMode.externalApplication,
      );
    }
  }

  Future<void> shareToTwitter() async {
    final message = "Join me using my referral code: ${referralCode.value}";
    final twitterUrl = "twitter://post?message=${Uri.encodeComponent(message)}";

    if (await canLaunchUrl(Uri.parse(twitterUrl))) {
      await launchUrl(Uri.parse(twitterUrl));
    } else {
      final fallback =
          "https://twitter.com/intent/tweet?text=${Uri.encodeComponent(message)}";
      await launchUrl(
        Uri.parse(fallback),
        mode: LaunchMode.externalApplication,
      );
    }
  }

  Future<void> shareToGmail() async {
  final subject = "Join me on this app!";
  final body = "Hey! Use my referral code: ${referralCode.value}";

  if (Platform.isAndroid) {
    try {
      final intent = AndroidIntent(
        action: 'android.intent.action.SEND',
        type: 'message/rfc822',
        package: 'com.google.android.gm', 
        arguments: <String, dynamic>{
          'android.intent.extra.SUBJECT': subject,
          'android.intent.extra.TEXT': body,
        },
      );
      await intent.launch();
    } catch (e) {
      appSnackbar(error: true, content: "Gmail app not found on this device.");
    }
  } else if (Platform.isIOS) {
    
    final uri = Uri.parse("mailto:?subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      final gmailWeb = Uri.parse("https://mail.google.com/mail/?view=cm&fs=1&su=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}");
      await launchUrl(gmailWeb, mode: LaunchMode.externalApplication);
    }
  }
}

  Future<void> shareMore() async {
    final message = "Join me using my referral code: ${referralCode.value}";
    final smsUrl = "sms:?body=${Uri.encodeComponent(message)}";
    await launchUrl(Uri.parse(smsUrl), mode: LaunchMode.externalApplication);
  }

  // Filter
  void filterReferrals(String query) {
    if (query.isEmpty) {
      filteredReferrals.assignAll(referrals);
    } else {
      filteredReferrals.assignAll(
        referrals
            .where((r) => r.name.toLowerCase().contains(query.toLowerCase()))
            .toList(),
      );
    }
  }

  // Copy referral code
  void copyReferralCode() {
    if (referralCode.value.isEmpty) return;

    appSnackbar(
      error: false,
      title: 'Copied!',
      content: 'Referral code copied to clipboard',
    );
  }


}
