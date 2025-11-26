// plan_model.dart

class PlanResponseModel {
  final bool success;
  final PlansDataModel data;

  PlanResponseModel({
    required this.success,
    required this.data,
  });

  factory PlanResponseModel.fromJson(Map<String, dynamic> json) {
    return PlanResponseModel(
      success: json["success"] ?? false,
      data: PlansDataModel.fromJson(json["data"] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "success": success,
      "data": data.toJson(),
    };
  }
}

class PlansDataModel {
  final String productId;
  final List<PlanModel> plans;

  PlansDataModel({
    required this.productId,
    required this.plans,
  });

  factory PlansDataModel.fromJson(Map<String, dynamic> json) {
    return PlansDataModel(
      productId: json["productId"] ?? "",
      plans: (json["plans"] as List<dynamic>? ?? [])
          .map((e) => PlanModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "productId": productId,
      "plans": plans.map((e) => e.toJson()).toList(),
    };
  }
}

class PlanModel {
  final String id;
  final String name;
  final int days;
  final double perDayAmount;
  final double totalAmount;
  final bool isRecommended;
  final String? description;

  PlanModel({
    required this.id,
    required this.name,
    required this.days,
    required this.perDayAmount,
    required this.totalAmount,
    required this.isRecommended,
    this.description,
  });

  factory PlanModel.fromJson(Map<String, dynamic> json) {
    return PlanModel(
      id: json["_id"] ?? "",
      name: json["name"] ?? "",
      days: json["days"] ?? 0,
      perDayAmount: (json["perDayAmount"] ?? 0).toDouble(),
      totalAmount: (json["totalAmount"] ?? 0).toDouble(),
      isRecommended: json["isRecommended"] ?? false,
      description: json["description"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "name": name,
      "days": days,
      "perDayAmount": perDayAmount,
      "totalAmount": totalAmount,
      "isRecommended": isRecommended,
      "description": description,
    };
  }
}
