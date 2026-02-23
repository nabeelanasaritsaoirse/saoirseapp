class WalletWithdrawalStatusResponse {
  final bool success;
  final bool canWithdraw;
  final String message;

  WalletWithdrawalStatusResponse({
    required this.success,
    required this.canWithdraw,
    required this.message,
  });

  factory WalletWithdrawalStatusResponse.fromJson(Map<String, dynamic> json) {
    return WalletWithdrawalStatusResponse(
      success: json['success'] ?? false,
      canWithdraw: json['canWithdraw'] ?? false,
      message: json['message'] ?? '',
    );
  }
}
