class InvestmentStatusResponse {
  final bool success;
  final String message;
  final InvestmentOverview overview;

  InvestmentStatusResponse({
    required this.success,
    required this.message,
    required this.overview,
  });

  factory InvestmentStatusResponse.fromJson(Map<String, dynamic> json) {
    return InvestmentStatusResponse(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      overview: InvestmentOverview.fromJson(
        json["data"]?["overview"] ?? {},
      ),
    );
  }
}

class InvestmentOverview {
  final int totalOrders;
  final double totalAmount;
  final double totalPaidAmount;
  final double totalRemainingAmount;
  final int totalDays;
  final int remainingDays;
  final double progressPercent;

  InvestmentOverview({
    required this.totalOrders,
    required this.totalAmount,
    required this.totalPaidAmount,
    required this.totalRemainingAmount,
    required this.totalDays,
    required this.remainingDays,
    required this.progressPercent,
  });

  factory InvestmentOverview.fromJson(Map<String, dynamic> json) {
    return InvestmentOverview(
      totalOrders: json["totalOrders"] ?? 0,
      totalAmount: (json["totalAmount"] ?? 0).toDouble(),
      totalPaidAmount: (json["totalPaidAmount"] ?? 0).toDouble(),
      totalRemainingAmount: (json["totalRemainingAmount"] ?? 0).toDouble(),
      totalDays: json["totalDays"] ?? 0,
      remainingDays: json["remainingDays"] ?? 0,
      progressPercent: (json["progressPercent"] ?? 0).toDouble(),
    );
  }
}
