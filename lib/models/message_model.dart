class ChatMessage {
  final String messageId;
  final String conversationId;
  final String senderId;
  final String messageType;
  final String text;
  final String deliveryStatus;
  final DateTime createdAt;

  ChatMessage({
    required this.messageId,
    required this.conversationId,
    required this.senderId,
    required this.messageType,
    required this.text,
    required this.deliveryStatus,
    required this.createdAt,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      messageId: json['messageId'] ?? '',
      conversationId: json['conversationId'] ?? '',
      senderId: json['senderId'] ?? '',
      messageType: json['messageType'] ?? '',
      text: json['text'] ?? '',
      deliveryStatus: json['deliveryStatus'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
