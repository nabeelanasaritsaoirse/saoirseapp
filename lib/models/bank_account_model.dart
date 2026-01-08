class BankAccountModel {
  final String? id;
  final String accountNumber;
  final String ifscCode;
  final String accountHolderName;
  final String? bankName;
  final String? branchName;
  final bool isDefault;

  BankAccountModel({
    this.id,
    required this.accountNumber,
    required this.ifscCode,
    required this.accountHolderName,
    this.bankName,
    this.branchName,
    this.isDefault = false,
  });

  factory BankAccountModel.fromJson(Map<String, dynamic> json) {
    return BankAccountModel(
      id: json['_id'],
      accountNumber: json['accountNumber'] ?? '',
      ifscCode: json['ifscCode'] ?? '',
      accountHolderName: json['accountHolderName'] ?? '',
      bankName: json['bankName'],
      branchName: json['branchName'],
      isDefault: json['isDefault'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "accountNumber": accountNumber,
      "ifscCode": ifscCode,
      "accountHolderName": accountHolderName,
      "bankName": bankName,
      "branchName": branchName,
      "isDefault": isDefault,
    };
  }
}
