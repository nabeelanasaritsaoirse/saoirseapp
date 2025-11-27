import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saoirse_app/models/message_model.dart';


class MessageController extends GetxController {
  final TextEditingController textController = TextEditingController();
  final RxList<Message> messages = <Message>[].obs;
  final RxString inputText = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // this is the initial messages
    messages.addAll([
      Message(
        text: "Hi! Your order from yesterday is still pending. Please complete the payment to confirm it.",
        isUser: false,
        time: DateTime.now().subtract(Duration(minutes: 5)),
      ),
      Message(
        text: "Hello! You have a pending payment left. Kindly finish it when you're free",
        isUser: false,
        time: DateTime.now().subtract(Duration(minutes: 2)),
      ),
    ]);
    textController.text = "OK Thanks! ";
  }

  void sendMessage() {
    if (textController.text.trim().isNotEmpty) {
      messages.add(
        Message(
          text: textController.text,
          isUser: true,
          time: DateTime.now(),
        ),
      );
      textController.clear();
      inputText.value = '';
    }
  }

  void updateInputText(String value) {
    inputText.value = value;
  }

  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }
}

