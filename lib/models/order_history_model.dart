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
    return OrderHistoryResponse(
      success: json["success"] ?? false,
      orders: (json["orders"] as List<dynamic>? ?? [])
          .map((e) => OrderHistoryItem.fromJson(e))
          .toList(),
      count: json["count"] ?? 0,
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
    final variant = (product["variants"] as List?)?.isNotEmpty == true
        ? product["variants"][0]
        : {};
    final attributes = variant?["attributes"] ?? {};
    final payment = json["paymentDetails"] ?? {};

    final images = (product["images"] as List?) ?? [];
    String imageUrl = "";
    if (images.isNotEmpty && images[0]?["url"] != null) {
      imageUrl = images[0]["url"];
    }

    return OrderHistoryItem(
        id: json["_id"] ?? "",
        name: product["name"] ?? "",
        color: attributes["color"] ?? "Not specified",
        storage: product["variantId"] ?? "", // no storage provided in API
        price: pricing["finalPrice"] ?? 0,
        qty: 1, // API has no quantity field, default 1
        image: imageUrl, // API returns images array but now empty
        dailyPlan:
            "₹${payment["dailyAmount"] ?? 0}/${payment["totalDuration"] ?? 0} Days",
        status: json["orderStatus"] ?? "",
        openDate: payment["startDate"] ?? "",
        closeDate: payment["endDate"] ?? "",
        invested: json["emiPaidAmount"] ?? 0,
        currency: pricing["currency"] ?? "INR");
  }
}
