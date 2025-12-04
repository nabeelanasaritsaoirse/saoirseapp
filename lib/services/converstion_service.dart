import '../constants/app_constant.dart';
import '../constants/app_urls.dart';
import '../main.dart';
import '../models/converstion_model.dart';
import '../models/message_model.dart';
import '../widgets/app_toast.dart';
import 'api_service.dart';

class ConversationService {
  Future<ConversationModel?> createIndividualChat(String userId) async {
    final token = await storage.read(AppConst.ACCESS_TOKEN);
    final body = {'withUserId': userId};

    print("\n================ CREATE INDIVIDUAL CHAT API ================");
    print("URL: ${AppURLs.CREATE_INDIVIDUAL_CHAT_FROM_REFFERAL}");
    print("TOKEN: $token");
    print("REQUEST BODY: $body");
    print("============================================================");

    try {
      final response = await APIService.postRequest(
        url: AppURLs.CREATE_INDIVIDUAL_CHAT_FROM_REFFERAL,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: body,
        onSuccess: (json) => json,
      );

      print("\n------ API RAW RESPONSE ------");
      print(response);
      print("------------------------------\n");

      if (response == null) {
        print("❌ Response is NULL");
        return null;
      }

      if (response['success'] == true) {
        print("✅ SUCCESS → Creating ConversationModel");
        return ConversationModel.fromJson(response['data']);
      }

      print("❌ API Error: ${response['message']}");
      appToast(error: true, content: response['message']);
      return null;
    } catch (e) {
      print("⚠️ Chat Error Exception: $e");
      return null;
    }
  }

  Future<ChatMessage?> sendMessage({
    required String conversationId,
    required String text,
  }) async {
    final token = await storage.read(AppConst.ACCESS_TOKEN);

    final body = {
      "messageType": "TEXT",
      "text": text,
    };

    print("\n========== SEND MESSAGE ==========");
    print("URL: ${AppURLs.BASE_API}conversations/$conversationId/messages");
    print("BODY: $body");
    print("=================================");

    try {
      final response = await APIService.postRequest(
        url: "${AppURLs.BASE_API}conversations/$conversationId/messages",
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: body,
        onSuccess: (json) => json,
      );

      print("RAW RESPONSE: $response");

      if (response == null) return null;

      if (response['success'] == true) {
        return ChatMessage.fromJson(response['data']);
      }

      appToast(error: true, content: response['message']);
      return null;
    } catch (e) {
      print("Send Message Error: $e");
      return null;
    }
  }
}
