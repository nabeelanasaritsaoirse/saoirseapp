class AutopaySuggestedTopupModel {
  final bool success;
  final AutopaySuggestedTopupData data;

  AutopaySuggestedTopupModel({
    required this.success,
    required this.data,
  });

  factory AutopaySuggestedTopupModel.fromJson(Map<String, dynamic> json) {
    return AutopaySuggestedTopupModel(
      success: json['success'] ?? false,
      data: AutopaySuggestedTopupData.fromJson(json['data'] ?? {}),
    );
  }
}

class AutopaySuggestedTopupData {
  final int currentBalance;
  final int availableForAutopay;
  final int dailyDeduction;
  final int daysRequested;
  final int suggestedTopUp;
  final AutopayTopupBreakdown breakdown;

  AutopaySuggestedTopupData({
    required this.currentBalance,
    required this.availableForAutopay,
    required this.dailyDeduction,
    required this.daysRequested,
    required this.suggestedTopUp,
    required this.breakdown,
  });

  factory AutopaySuggestedTopupData.fromJson(Map<String, dynamic> json) {
    return AutopaySuggestedTopupData(
      currentBalance: json['currentBalance'] ?? 0,
      availableForAutopay: json['availableForAutopay'] ?? 0,
      dailyDeduction: json['dailyDeduction'] ?? 0,
      daysRequested: json['daysRequested'] ?? 0,
      suggestedTopUp: json['suggestedTopUp'] ?? 0,
      breakdown: AutopayTopupBreakdown.fromJson(
        json['breakdown'] ?? {},
      ),
    );
  }
}

class AutopayTopupBreakdown {
  final int totalRequired;
  final int currentAvailable;
  final int shortfall;

  AutopayTopupBreakdown({
    required this.totalRequired,
    required this.currentAvailable,
    required this.shortfall,
  });

  factory AutopayTopupBreakdown.fromJson(Map<String, dynamic> json) {
    return AutopayTopupBreakdown(
      totalRequired: json['totalRequired'] ?? 0,
      currentAvailable: json['currentAvailable'] ?? 0,
      shortfall: json['shortfall'] ?? 0,
    );
  }
}
