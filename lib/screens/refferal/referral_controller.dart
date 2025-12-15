// ignore_for_file: deprecated_member_use

import 'dart:developer';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constants/app_constant.dart';
import '../../main.dart';
import '../../models/referral_response_model.dart';
import '../../models/refferal_info_model.dart';
import '../../services/refferal_service.dart';
import '../../widgets/app_toast.dart';
import 'package:share_plus/share_plus.dart';

class ReferralController extends GetxController {
  final ReferralService _referralService = ReferralService();

  // Observables
  final referralCode = ''.obs;
  final isLoading = false.obs;
  final isDashboardLoading = false.obs;

  final referrals = <Referral>[].obs;
  final filteredReferrals = <Referral>[].obs;
  Rxn<ReferrerInfoModel> referrer = Rxn<ReferrerInfoModel>();
  String get referralLink => _referralLink();

  @override
  void onInit() {
    super.onInit();
    loadReferralFromStorage();
    fetchReferralData();
    fetchReferrerInfo();
  }

  Future<void> fetchReferrerInfo() async {
    log("\n================ FETCH REFERRER INFO ================");
    log("📡 Calling API: /api/referral/referrer-info");
    isLoading.value = true;

    final result = await _referralService.getReferrerInfo();

    if (result != null) {
      log("✅ Referrer found:");
      log("ID     : ${result.userId}");
      log("Name   : ${result.name}");
      log("Email  : ${result.email}");
      log("Photo  : ${result.profilePicture}");
      log("Code   : ${result.referralCode}");
    } else {
      log("❌ No referrer data / null received");
    }

    referrer.value = result;

    isLoading.value = false;
    log("=====================================================\n");
  }

  // ---------------------------------------------------------------------------
  // Fetch Referral Code
  // ---------------------------------------------------------------------------

  Future<void> loadReferralFromStorage() async {
    try {
      final storedCode = await storage.read(AppConst.REFERRAL_CODE);

      if (storedCode != null && storedCode.toString().isNotEmpty) {
        referralCode.value = storedCode.toString();
      }
    } catch (e) {
      log("Error reading referral code from storage: $e");
    }
  }

  //---------------------------------------------------------------------------
  // Referral Link From Appfyer Onelink with referral code(Defferred Deep Linking)
  //---------------------------------------------------------------------------

  String _referralLink() {
    const base =
        'https://inviteapp.onelink.me/VDIY?af_xp=referral&pid=User_invite&c=referral';

    return '$base&deep_link_value=${referralCode.value}';
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
        appToast(
          error: true,
          content: response?.message ?? "Failed to fetch referral data",
        );
      }
    } catch (e) {
      appToast(error: true, content: e.toString());
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
    final link = _referralLink();

    final message = "Hey! Join me on this app using my referral code: $link";

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
    final link = _referralLink();

    final message = "Hey! Join me on this app using my referral code: $link";

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
    final link = _referralLink();

    final message = "Hey! Join me on this app using my referral code: $link";

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

  Future<void> shareToInstagram() async {
    final link = _referralLink();

    final message = "Hey! Join me on this app using my referral code: $link";

    // Instagram deep link (opens Instagram if installed)
    final instagramUrl =
        "instagram://share?text=${Uri.encodeComponent(message)}";

    if (await canLaunchUrl(Uri.parse(instagramUrl))) {
      await launchUrl(Uri.parse(instagramUrl));
    } else {
      // Fallback → Instagram doesn't support web text share,
      // so we fallback to SharePlus system share
      final fallbackMessage = message;
      await Share.share(fallbackMessage);
    }
  }

  Future<void> shareToTwitter() async {
    final link = _referralLink();

    final message = "Hey! Join me on this app using my referral code: $link";

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
    final link = _referralLink();

    final subject = "Join me on this app!";
    final body = "Hey! Use my referral code: $link";

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
        appToast(error: true, content: "Gmail app not found on this device.");
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
    final link = _referralLink();

    final message = "Hey! Join me on this app using my referral code: $link";

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
  // Share QR as image (used by QR popup)
  // ---------------------------------------------------------------------------
  Future<void> shareQrImage({
    required GlobalKey qrKey,
    String? message,
  }) async {
    try {
      final renderObject = qrKey.currentContext?.findRenderObject();
      if (renderObject == null || renderObject is! RenderRepaintBoundary) {
        log("❌ QR RenderRepaintBoundary not found");
        return;
      }

      final ui.Image image = await renderObject.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) {
        log("❌ QR ByteData is null");
        return;
      }

      final Uint8List pngBytes = byteData.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();
      final file = File("${tempDir.path}/referral_qr.png");
      await file.writeAsBytes(pngBytes);

      final params = ShareParams(
        files: [XFile(file.path)],
        text: message ??
            "Join this app & earn rewards! Use my referral link: $referralLink",
      );

      await SharePlus.instance.share(params);
    } catch (e, st) {
      log("QR Image Share Error: $e\n$st");
    }
  }

  // ---------------------------------------------------------------------------
  // Copy Referral Code
  // ---------------------------------------------------------------------------

  void copyReferralCode() {
    if (referralCode.isEmpty) return;

    // Copy the text to clipboard
    Clipboard.setData(
      ClipboardData(text: referralCode.value),
    );

    // Show success message
    appToast(
      error: false,
      title: "Copied!",
      content: "Referral code copied to clipboard",
    );
  }
}
