class PlanModel {
  final String name;
  final int days;
  final double perDayAmount;
  final double totalAmount;
  final bool isRecommended;
  final String? description;

  PlanModel({
    required this.name,
    required this.days,
    required this.perDayAmount,
    required this.totalAmount,
    this.isRecommended = false,
    this.description,
  });

  factory PlanModel.fromJson(Map<String, dynamic> json) {
    return PlanModel(
      name: json["name"],
      days: json["days"],
      perDayAmount: (json["perDayAmount"] ?? 0).toDouble(),
      totalAmount: (json["totalAmount"] ?? 0).toDouble(),
      isRecommended: json["isRecommended"] ?? false,
      description: json["description"],
    );
  }
}
