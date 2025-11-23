import 'dart:convert';

WalletmModels walletmModelsFromJson(String str) =>
    WalletmModels.fromJson(json.decode(str));

String walletmModelsToJson(WalletmModels data) => json.encode(data.toJson());

class WalletmModels {
  bool success;
  String message;
  int walletBalance;
  int totalBalance;
  int holdBalance;
  int referralBonus;
  int investedAmount;
  int requiredInvestment;
  int availableBalance;
  int totalEarnings;
  List<dynamic> transactions;

  WalletmModels({
    required this.success,
    required this.message,
    required this.walletBalance,
    required this.totalBalance,
    required this.holdBalance,
    required this.referralBonus,
    required this.investedAmount,
    required this.requiredInvestment,
    required this.availableBalance,
    required this.totalEarnings,
    required this.transactions,
  });

  factory WalletmModels.fromJson(Map<String, dynamic> json) => WalletmModels(
        success: json["success"],
        message: json["message"],
        walletBalance: json["walletBalance"],
        totalBalance: json["totalBalance"],
        holdBalance: json["holdBalance"],
        referralBonus: json["referralBonus"],
        investedAmount: json["investedAmount"],
        requiredInvestment: json["requiredInvestment"],
        availableBalance: json["availableBalance"],
        totalEarnings: json["totalEarnings"],
        transactions: List<dynamic>.from(json["transactions"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "walletBalance": walletBalance,
        "totalBalance": totalBalance,
        "holdBalance": holdBalance,
        "referralBonus": referralBonus,
        "investedAmount": investedAmount,
        "requiredInvestment": requiredInvestment,
        "availableBalance": availableBalance,
        "totalEarnings": totalEarnings,
        "transactions": List<dynamic>.from(transactions.map((x) => x)),
      };
}
