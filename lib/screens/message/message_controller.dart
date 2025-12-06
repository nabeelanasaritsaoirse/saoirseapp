import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/converstion_model.dart';
import '../../models/message_model.dart';
import '../../services/converstion_service.dart';
import '../../widgets/app_toast.dart';

class MessageController extends GetxController {
  final String conversationId;
  final List<Participant> participants;

  MessageController({
    required this.conversationId,
    required this.participants,
  });
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
}
