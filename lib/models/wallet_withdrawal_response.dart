class WalletWithdrawalStatusResponse {
  final bool success;
  final bool canWithdraw;
  final int withdrawableNow;
  final int holdBalance;
  final int availableBalance;
  final String message;

  WalletWithdrawalStatusResponse({
    required this.success,
    required this.canWithdraw,
    required this.withdrawableNow,
    required this.holdBalance,
    required this.availableBalance,
    required this.message,
  });

  factory WalletWithdrawalStatusResponse.fromJson(Map<String, dynamic> json) {
    return WalletWithdrawalStatusResponse(
      success: json['success'] ?? false,
      canWithdraw: json['canWithdraw'] ?? false,
      withdrawableNow: json['withdrawableNow'] ?? 0,
      holdBalance: json['holdBalance'] ?? 0,
      availableBalance: json['availableBalance'] ?? 0,
      message: json['message'] ?? '',
    );
  }
}