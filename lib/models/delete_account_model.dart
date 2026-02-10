class DeleteAccountModel {
  final bool success;
  final DeletionInfo deletionInfo;

  DeleteAccountModel({
    required this.success,
    required this.deletionInfo,
  });

  factory DeleteAccountModel.fromJson(Map<String, dynamic> json) {
    return DeleteAccountModel(
      success: json['success'] ?? false,
      deletionInfo: DeletionInfo.fromJson(json['deletionInfo'] ?? {}),
    );
  }
}

class DeletionInfo {
  final List<String> dataToBeDeleted;
  final DataCounts dataCounts;
  final String retentionPeriod;
  final String note;

  DeletionInfo({
    required this.dataToBeDeleted,
    required this.dataCounts,
    required this.retentionPeriod,
    required this.note,
  });

  factory DeletionInfo.fromJson(Map<String, dynamic> json) {
    return DeletionInfo(
      dataToBeDeleted: List<String>.from(json['dataToBeDeleted'] ?? []),
      dataCounts: DataCounts.fromJson(json['dataCounts'] ?? {}),
      retentionPeriod: json['retentionPeriod'] ?? '',
      note: json['note'] ?? '',
    );
  }
}

class DataCounts {
  final int addresses;
  final int bankAccounts;
  final int kycDocuments;
  final int transactions;
  final int wishlistItems;
  final double walletBalance;

  DataCounts({
    required this.addresses,
    required this.bankAccounts,
    required this.kycDocuments,
    required this.transactions,
    required this.wishlistItems,
    required this.walletBalance,
  });

  factory DataCounts.fromJson(Map<String, dynamic> json) {
    return DataCounts(
      addresses: json['addresses'] ?? 0,
      bankAccounts: json['bankAccounts'] ?? 0,
      kycDocuments: json['kycDocuments'] ?? 0,
      transactions: json['transactions'] ?? 0,
      wishlistItems: json['wishlistItems'] ?? 0,
      walletBalance: (json['walletBalance'] ?? 0).toDouble(),
    );
  }
}
