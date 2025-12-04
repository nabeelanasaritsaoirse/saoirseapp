class ChatMessage {
  final String messageId;
  final String conversationId;
  final String senderId;
  final String senderName;
  final String senderAvatar;
  final String messageType; // TEXT / PRODUCT_SHARE
  final String text;
  final ProductShare? sharedProduct;
  final String deliveryStatus;
  final DateTime createdAt;

  ChatMessage({
    required this.messageId,
    required this.conversationId,
    required this.senderId,
    required this.senderName,
    required this.senderAvatar,
    required this.messageType,
    required this.text,
    required this.deliveryStatus,
    required this.createdAt,
    this.sharedProduct,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      messageId: json["messageId"] ?? "",
      conversationId: json["conversationId"] ?? "",
      senderId: json["senderId"] ?? "",
      senderName: json["senderName"] ?? "",
      senderAvatar: json["senderAvatar"] ?? "",
      messageType: json["messageType"] ?? "TEXT",
      text: json["text"] ?? "",
      deliveryStatus: json['deliveryStatus'] is List
          ? json['deliveryStatus'].join(",")
          : (json['deliveryStatus'] ?? ''),
      createdAt: DateTime.parse(json["createdAt"]),

      /// If product share exists → parse
      sharedProduct: json["sharedProduct"] != null
          ? ProductShare.fromJson(json["sharedProduct"])
          : null,
    );
  }
}

class ProductShare {
  final String productId;
  final String productName;
  final String productImage;
  final double productPrice;
  final String productUrl;

  ProductShare({
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.productPrice,
    required this.productUrl,
  });

  factory ProductShare.fromJson(Map<String, dynamic> json) {
    return ProductShare(
      productId: json["productId"] ?? "",
      productName: json["productName"] ?? "",
      productImage: json["productImage"] ?? "",
      productPrice: (json["productPrice"] ?? 0).toDouble(),
      productUrl: json["productUrl"] ?? "",
    );
  }
}
