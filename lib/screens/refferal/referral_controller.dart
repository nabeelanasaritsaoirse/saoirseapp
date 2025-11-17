import 'dart:io';
import 'package:android_intent_plus/android_intent.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/referral_response_model.dart';
import '../../services/refferal_service.dart';
import '../../widgets/app_snackbar.dart';

class ReferralController extends GetxController {
  final ReferralService _referralService = ReferralService();

  // Observables
  final referralCode = ''.obs;
  final isLoading = false.obs;
  final isDashboardLoading = false.obs;

  final referrals = <Referral>[].obs;
  final filteredReferrals = <Referral>[].obs;

  @override
  void onInit() {
    super.onInit();
    getReferralCode();
    fetchReferralData();
  }

  // ---------------------------------------------------------------------------
  // Fetch Referral Code
  // ---------------------------------------------------------------------------

  Future<void> getReferralCode() async {
    try {
      isLoading(true);

      final response = await _referralService.fetchReferralCode();

      if (response != null && response.success) {
        referralCode.value = response.referralCode;
      } else {
        appSnackbar(
          error: true,
          content: response?.message ?? "Failed to fetch referral code",
        );
      }
    } catch (e) {
      appSnackbar(error: true, content: e.toString());
    } finally {
      isLoading(false);
    }
  }

  // ---------------------------------------------------------------------------
  // Fetch Referral List (Dashboard Data)
  // ---------------------------------------------------------------------------

  Future<void> fetchReferralData() async {
    try {
      isDashboardLoading(true);

      final response = await _referralService.fetchReferralResponseFromServer();

      if (response != null && response.success) {
        referrals.assignAll(response.referrals);
        filteredReferrals.assignAll(response.referrals);
      } else {
        appSnackbar(
          error: true,
          content: response?.message ?? "Failed to fetch referral data",
        );
      }
    } catch (e) {
      appSnackbar(error: true, content: e.toString());
    } finally {
      isDashboardLoading(false);
    }
  }

  // ---------------------------------------------------------------------------
  // Fetch Product Details List (Referral Details screen)
  // ---------------------------------------------------------------------------

  // ---------------------------------------------------------------------------
  // SHARE OPTIONS
  // ---------------------------------------------------------------------------

  Future<void> shareToWhatsApp() async {
    final message =
        "Hey! Join me on this app using my referral code: ${referralCode.value}";

    final whatsappUrl = "whatsapp://send?text=${Uri.encodeComponent(message)}";

    if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
      await launchUrl(Uri.parse(whatsappUrl));
    } else {
      // Fallback to web WhatsApp
      final fallback = "https://wa.me/?text=${Uri.encodeComponent(message)}";
      await launchUrl(Uri.parse(fallback),
          mode: LaunchMode.externalApplication);
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
      await launchUrl(Uri.parse(fallback),
          mode: LaunchMode.externalApplication);
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
      await launchUrl(Uri.parse(fallback),
          mode: LaunchMode.externalApplication);
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
      await launchUrl(Uri.parse(fallback),
          mode: LaunchMode.externalApplication);
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
          arguments: {
            'android.intent.extra.SUBJECT': subject,
            'android.intent.extra.TEXT': body,
          },
        );
        await intent.launch();
      } catch (e) {
        appSnackbar(
            error: true, content: "Gmail app not found on this device.");
      }
    } else if (Platform.isIOS) {
      final uri = Uri.parse(
          "mailto:?subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}");
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        final gmailWeb = Uri.parse(
            "https://mail.google.com/mail/?view=cm&fs=1&su=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}");

        await launchUrl(gmailWeb, mode: LaunchMode.externalApplication);
      }
    }
  }

  Future<void> shareMore() async {
    final message = "Join me using my referral code: ${referralCode.value}";

    final smsUrl = "sms:?body=${Uri.encodeComponent(message)}";

    await launchUrl(Uri.parse(smsUrl), mode: LaunchMode.externalApplication);
  }

  void filterReferrals(String query) {
    if (query.isEmpty) {
      filteredReferrals.assignAll(referrals);
    } else {
      filteredReferrals.assignAll(
        referrals.where((ref) =>
            ref.referredUser!.name.toLowerCase().contains(query.toLowerCase())),
      );
    }
  }

  // ---------------------------------------------------------------------------
  // Copy Referral Code
  // ---------------------------------------------------------------------------

  void copyReferralCode() {
    if (referralCode.isEmpty) return;

    appSnackbar(
      error: false,
      title: "Copied!",
      content: "Referral code copied to clipboard",
    );
  }
}
