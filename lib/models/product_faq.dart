class ProductFaq {
  final String id;
  final String question;
  final String answer;

  // New fields (optional / added)
  final String? type;
  final String? productId;
  final bool? isActive;
  final String? createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ProductFaq({
    required this.id,
    required this.question,
    required this.answer,
    this.type,
    this.productId,
    this.isActive,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
  });

  factory ProductFaq.fromJson(Map<String, dynamic> json) {
    return ProductFaq(
      id: json['_id'],
      question: json['question'],
      answer: json['answer'],
      type: json['type'],
      productId: json['productId'],
      isActive: json['isActive'],
      createdBy: json['createdBy'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }
}
