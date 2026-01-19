class KycWithdrawalStatusResponse {
  final bool success;
  final bool isEligibleForWithdrawal;
  final KycWithdrawalStatus status;
  final String? message;

  KycWithdrawalStatusResponse({
    required this.success,
    required this.isEligibleForWithdrawal,
    required this.status,
    this.message,
  });

  factory KycWithdrawalStatusResponse.fromJson(Map<String, dynamic> json) {
    return KycWithdrawalStatusResponse(
      success: json['success'] ?? false,
      isEligibleForWithdrawal: json['isEligibleForWithdrawal'] ?? false,
      status: KycWithdrawalStatus.fromJson(json['status'] ?? {}),
      message: json['message'],
    );
  }
}

class KycWithdrawalStatus {
  final KycStatus kycStatus;
  final BankStatus bankStatus;
  final int pendingDocuments;
  final int rejectedDocuments;

  KycWithdrawalStatus({
    required this.kycStatus,
    required this.bankStatus,
    required this.pendingDocuments,
    required this.rejectedDocuments,
  });

  factory KycWithdrawalStatus.fromJson(Map<String, dynamic> json) {
    return KycWithdrawalStatus(
      kycStatus: KycStatus.fromJson(json['kycStatus'] ?? {}),
      bankStatus: BankStatus.fromJson(json['bankStatus'] ?? {}),
      pendingDocuments: json['pendingDocuments'] ?? 0,
      rejectedDocuments: json['rejectedDocuments'] ?? 0,
    );
  }
}

class KycStatus {
  final bool aadharVerified;
  final bool panVerified;
  final bool hasVerifiedDocument;
  final String? aadharNumber;
  final String? panNumber;

  KycStatus({
    required this.aadharVerified,
    required this.panVerified,
    required this.hasVerifiedDocument,
    this.aadharNumber,
    this.panNumber,
  });

  factory KycStatus.fromJson(Map<String, dynamic> json) {
    return KycStatus(
      aadharVerified: json['aadharVerified'] ?? false,
      panVerified: json['panVerified'] ?? false,
      hasVerifiedDocument: json['hasVerifiedDocument'] ?? false,
      aadharNumber: json['aadharNumber'],
      panNumber: json['panNumber'],
    );
  }
}

class BankStatus {
  final bool hasBankAccount;
  final bool hasVerifiedBankAccount;
  final int totalBankAccounts;

  BankStatus({
    required this.hasBankAccount,
    required this.hasVerifiedBankAccount,
    required this.totalBankAccounts,
  });

  factory BankStatus.fromJson(Map<String, dynamic> json) {
    return BankStatus(
      hasBankAccount: json['hasBankAccount'] ?? false,
      hasVerifiedBankAccount: json['hasVerifiedBankAccount'] ?? false,
      totalBankAccounts: json['totalBankAccounts'] ?? 0,
    );
  }
}
