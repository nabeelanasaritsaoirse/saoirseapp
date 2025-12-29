class OrderHistoryResponse {
  final bool success;
  final List<OrderHistoryItem> orders;
  final int count;

  OrderHistoryResponse({
    required this.success,
    required this.orders,
    required this.count,
  });

  factory OrderHistoryResponse.fromJson(Map<String, dynamic> json) {
    final data = json["data"] ?? {};

    return OrderHistoryResponse(
      success: json["success"] ?? false,
      orders: (data["orders"] as List<dynamic>? ?? [])
          .map((e) => OrderHistoryItem.fromJson(e))
          .toList(),
      count: data["count"] ?? 0,
    );
  }
}

class OrderHistoryItem {
  final String id;
  final String name;
  final String color;
  final String storage;
  final int price;
  final int qty;
  final String image;
  final String dailyPlan;
  final String status;
  final String openDate;
  final String closeDate;
  final int invested;
  final String currency;

  OrderHistoryItem(
      {required this.id,
      required this.name,
      required this.color,
      required this.storage,
      required this.price,
      required this.qty,
      required this.image,
      required this.dailyPlan,
      required this.status,
      required this.openDate,
      required this.closeDate,
      required this.invested,
      required this.currency});

  factory OrderHistoryItem.fromJson(Map<String, dynamic> json) {
    final product = json["product"] ?? {};
    final pricing = product["pricing"] ?? {};
    final images = (product["images"] as List?) ?? [];
    final schedule = (json["paymentSchedule"] as List?) ?? [];

    String imageUrl = "";
    if (images.isNotEmpty && images[0]["url"] != null) {
      imageUrl = images[0]["url"];
    }

    final String openDateValue =
        schedule.isNotEmpty ? (schedule.first["dueDate"] ?? "") : "";

    final String closeDateValue =
        schedule.isNotEmpty ? (schedule.last["dueDate"] ?? "") : "";

    return OrderHistoryItem(
      id: json["orderId"] ?? "", // user-friendly ID
      name: product["name"] ?? "",
      color: "Not specified", // not provided
      storage: "", // not provided
      price: pricing["finalPrice"] ?? 0,
      qty: json["quantity"] ?? 1,
      image: imageUrl,
      dailyPlan:
          "₹${json["dailyPaymentAmount"] ?? 0}/${json["totalDays"] ?? 0} Days",
      status: json["status"] ?? "",
      openDate: openDateValue,
      closeDate: closeDateValue,
      invested: json["totalPaidAmount"] ?? 0,
      currency: pricing["currency"] ?? "INR",
    );
  }
}
