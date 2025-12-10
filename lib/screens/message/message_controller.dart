import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/converstion_model.dart';
import '../../models/message_model.dart';
import '../../services/converstion_service.dart';
import '../../widgets/app_toast.dart';

class MessageController extends GetxController {
  final String conversationId;
  final List<Participant> participants;
  final referralCode = ''.obs;
  MessageController({
    required this.conversationId,
    required this.participants,
    String? referralCode,
  }) {
    if (referralCode != null) {
      this.referralCode.value = referralCode;
    }
  }
  Timer? _pollTimer;
  DateTime lastPollTime = DateTime.now();
  final textController = TextEditingController();
  final RxList<ChatMessage> messages = <ChatMessage>[].obs;
  final ConversationService _messageservice = ConversationService();
  final ScrollController scrollController = ScrollController();

  RxString friendName = ''.obs;
  var isSending = false.obs;
  final RxString inputText = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadMessages();
    startPolling();
  }

  void scrollToBottom() {
    Future.delayed(Duration(milliseconds: 300), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void startPolling() {
    _pollTimer = Timer.periodic(Duration(seconds: 5), (_) => pollNewMessages());
  }

  Future<void> pollNewMessages() async {
    final data = await _messageservice.pollMessages(
      lastPollTime: lastPollTime,
      conversationId: conversationId,
    );

    if (data == null) return;

    if (data["hasNewMessages"] == true) {
      final newMsgs = data["conversations"][0]["newMessages"] as List;

      for (var msg in newMsgs) {
        final incoming = ChatMessage.fromJson(msg);

        // ⛔ avoid duplicate messages
        if (!messages.any((m) => m.messageId == incoming.messageId)) {
          messages.add(incoming);
        }
      }
    }
    scrollToBottom();
    lastPollTime = DateTime.now(); // Update cursor
    messages.refresh(); // UI update
  }

  void updateInputText(String value) {
    inputText.value = value;
  }

  Future<void> loadMessages({bool refreshUIOnly = false}) async {
    final loaded =
        await _messageservice.getMessages(conversationId: conversationId);
    if (refreshUIOnly) {
      if (loaded.length != messages.length) {
        messages.assignAll(loaded);
        scrollToBottom();
      }
      return;
    }
    messages.assignAll(loaded);
    scrollToBottom(); // oldest top → newest bottom
  }

  Future<void> sendMessage() async {
    final text = textController.text.trim();
    if (text.isEmpty) {
      appToast(error: true, content: "Text message cannot be empty");
      return;
    }

    isSending.value = true;

    final message = await _messageservice.sendMessage(
      conversationId: conversationId,
      text: text,
    );

    isSending.value = false;

    if (message != null) {
      messages.add(message);
      pollNewMessages();
      textController.clear();
      scrollToBottom();
    }
  }

  @override
  void onClose() {
    textController.dispose();
    scrollController.dispose();
    _pollTimer?.cancel();
    super.onClose();
  }

  void copyReferralCode() {
    if (referralCode.value.isEmpty) {
      appToast(
        error: true,
        content: "Referral code is empty",
      );
      return;
    }

    // Copy to clipboard
    Clipboard.setData(
      ClipboardData(text: referralCode.value),
    );

    // Show success toast
    appToaster(
      error: false,
      content: "Referral code copied to clipboard",
    );
  }

  // ---------------------------------------------------------------------------
// SHARE FUNCTIONS (Same as ReferralController but reusable here)
// ---------------------------------------------------------------------------

  String _referralLink(String code) {
    const base =
        'https://inviteapp.onelink.me/VDIY?af_xp=referral&pid=User_invite&c=referral';

    return '$base&deep_link_value=$code';
  }

  Future<void> shareToWhatsApp(String code) async {
    final link = _referralLink(code);
    final message = "Hey! Join me on this app using my referral code: $link";

    final whatsappUrl = "whatsapp://send?text=${Uri.encodeComponent(message)}";

    if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
      await launchUrl(Uri.parse(whatsappUrl));
    } else {
      final fallback = "https://wa.me/?text=${Uri.encodeComponent(message)}";
      await launchUrl(Uri.parse(fallback),
          mode: LaunchMode.externalApplication);
    }
  }

  Future<void> shareToFacebook(String code) async {
    final link = _referralLink(code);
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

  Future<void> shareToTelegram(String code) async {
    final link = _referralLink(code);
    final message = "Hey! Join me on this app using my referral code: $link";

    final tgUrl = "tg://msg?text=${Uri.encodeComponent(message)}";

    if (await canLaunchUrl(Uri.parse(tgUrl))) {
      await launchUrl(Uri.parse(tgUrl));
    } else {
      final fallback =
          "https://t.me/share/url?text=${Uri.encodeComponent(message)}";
      await launchUrl(Uri.parse(fallback),
          mode: LaunchMode.externalApplication);
    }
  }

  Future<void> shareToTwitter(String code) async {
    final link = _referralLink(code);
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

  Future<void> shareToGmail(String code) async {
    final link = _referralLink(code);
    final subject = "Join me on this app!";
    final body = "Hey! Use my referral code: $link";

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

  Future<void> shareMore(String code) async {
    final link = _referralLink(code);
    final message = "Hey! Join me on this app using my referral code: $link";

    final smsUrl = "sms:?body=${Uri.encodeComponent(message)}";

    await launchUrl(Uri.parse(smsUrl), mode: LaunchMode.externalApplication);
  }
}
