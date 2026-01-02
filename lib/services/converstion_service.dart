

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


      if (response == null) {
   
        return null;
      }

      if (response['success'] == true) {
    
        return ConversationModel.fromJson(response['data']);
      }

     
      appToast(error: true, content: response['message']);
      return null;
    } catch (e) {
   
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

  

    try {
      final response = await APIService.postRequest(
        url:
            "${AppURLs.BASE_API}api/chat/conversations/$conversationId/messages",
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: body,
        onSuccess: (json) => json,
      );



      if (response == null) return null;

      if (response['success'] == true) {
        return ChatMessage.fromJson(response['data']);
      }

      appToast(error: true, content: response['message']);
      return null;
    } catch (e) {

      return null;
    }
  }

  Future<List<ChatMessage>> getMessages({
    required String conversationId,
    int page = 1,
    int limit = 50,
  }) async {
    final token = await storage.read(AppConst.ACCESS_TOKEN);

    final url =
        "${AppURLs.BASE_API}api/chat/conversations/$conversationId/messages?page=$page&limit=$limit";

   

    final response = await APIService.getRequest(
      url: url,
      headers: {
        "Authorization": "Bearer $token",
      },
      onSuccess: (json) => json,
    );

    if (response == null) return [];

   

    return (response["data"]["messages"] as List)
        .map((m) => ChatMessage.fromJson(m))
        .toList();
  }

  Future<Map<String, dynamic>?> pollMessages({
    required DateTime lastPollTime,
    String? conversationId,
  }) async {
    final token = await storage.read(AppConst.ACCESS_TOKEN);

    final url =
        "${AppURLs.BASE_API}api/chat/poll?lastPollTime=${lastPollTime.toIso8601String()}"
        "${conversationId != null ? "&conversationId=$conversationId" : ""}";

    

    final response = await APIService.getRequest(
      url: url,
      headers: {"Authorization": "Bearer $token"},
      onSuccess: (json) => json,
    );

    if (response == null) return null;

    return response["data"];
  }
}
