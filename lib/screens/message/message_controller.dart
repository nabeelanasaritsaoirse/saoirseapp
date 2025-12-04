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

  final textController = TextEditingController();
  final RxList<ChatMessage> messages = <ChatMessage>[].obs;
  final ConversationService _messageservice = ConversationService();

  var isSending = false.obs;
  final RxString inputText = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadInitialMessages(); // later you can integrate history API
  }

  void updateInputText(String value) {
    inputText.value = value;
  }

  Future<void> loadInitialMessages() async {
    // TODO: load conversation history API (next step)
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
      textController.clear();
    }
  }

  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }
}
