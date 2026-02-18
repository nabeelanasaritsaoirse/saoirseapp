class FaqResponse {
  final bool success;
  final List<FaqModel> data;

  FaqResponse({
    required this.success,
    required this.data,
  });

  factory FaqResponse.fromJson(Map<String, dynamic> json) {
    return FaqResponse(
      success: json['success'] ?? false,
      data: json['data'] != null
          ? List<FaqModel>.from(
              json['data'].map((x) => FaqModel.fromJson(x)),
            )
          : [],
    );
  }
}

class FaqModel {
  final String id;
  final String type;
  final String? productId;
  final String question;
  final String answer;
  final bool isActive;
  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int version;

  FaqModel({
    required this.id,
    required this.type,
    this.productId,
    required this.question,
    required this.answer,
    required this.isActive,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
  });

  factory FaqModel.fromJson(Map<String, dynamic> json) {
    return FaqModel(
      id: json['_id'] ?? '',
      type: json['type'] ?? '',
      productId: json['productId'],
      question: json['question'] ?? '',
      answer: json['answer'] ?? '',
      isActive: json['isActive'] ?? false,
      createdBy: json['createdBy'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      version: json['__v'] ?? 0,
    );
  }
}
