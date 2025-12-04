class ConversationModel {
  final String conversationId;
  final String type;
  final List<Participant> participants;
  final bool isNewConversation;

  ConversationModel({
    required this.conversationId,
    required this.type,
    required this.participants,
    required this.isNewConversation,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      conversationId: json['conversationId'] ?? '',
      type: json['type'] ?? '',
      participants: _parseParticipants(json['participants']),
      isNewConversation: json['isNewConversation'] ?? false,
    );
  }

  // ----------- IMPORTANT FIX ------------
  static List<Participant> _parseParticipants(dynamic data) {
    if (data == null) return [];

    if (data is List) {
      return data.map((e) {
        // Case 1: String ID → wrap into Participant
        if (e is String) {
          return Participant(id: e, name: '', profilePicture: '');
        }

        // Case 2: Participant Map → convert normally
        if (e is Map<String, dynamic>) {
          return Participant.fromJson(e);
        }

        return Participant(id: '', name: '', profilePicture: '');
      }).toList();
    }

    return [];
  }
}

class Participant {
  final String id;
  final String name;
  final String profilePicture;

  Participant({
    required this.id,
    required this.name,
    required this.profilePicture,
  });

  factory Participant.fromJson(Map<String, dynamic> json) {
    return Participant(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      profilePicture: json['profilePicture'] ?? '',
    );
  }
}
