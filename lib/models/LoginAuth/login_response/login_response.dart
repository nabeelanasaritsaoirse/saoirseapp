import 'package:json_annotation/json_annotation.dart';

part 'login_response.g.dart';

@JsonSerializable()
class LoginResponse {
  bool? success;
  String? message;
  Data? data;

  LoginResponse({this.success, this.message, this.data});

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);

  LoginResponse copyWith({
    bool? success,
    String? message,
    Data? data,
  }) {
    return LoginResponse(
      success: success ?? this.success,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }
}

@JsonSerializable()
class Data {
  String? userId;
  String? name;
  String? email;
  String? phoneNumber;
  String? profilePicture;
  String? role;
  String? referralCode;
  bool? isAgree;
  Wallet? wallet;
  String? accessToken;
  String? refreshToken;

  Data({
    this.userId,
    this.name,
    this.email,
    this.phoneNumber,
    this.profilePicture,
    this.role,
    this.referralCode,
    this.isAgree,
    this.wallet,
    this.accessToken,
    this.refreshToken,
  });

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);

  Data copyWith({
    String? userId,
    String? name,
    String? email,
    String? phoneNumber,
    String? profilePicture,
    String? role,
    String? referralCode,
    bool? isAgree,
    Wallet? wallet,
    String? accessToken,
    String? refreshToken,
  }) {
    return Data(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profilePicture: profilePicture ?? this.profilePicture,
      role: role ?? this.role,
      referralCode: referralCode ?? this.referralCode,
      isAgree: isAgree ?? this.isAgree,
      wallet: wallet ?? this.wallet,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }
}

@JsonSerializable()
class Wallet {
  int? balance;
  List<dynamic>? transactions;

  Wallet({this.balance, this.transactions});

  factory Wallet.fromJson(Map<String, dynamic> json) => _$WalletFromJson(json);

  Map<String, dynamic> toJson() => _$WalletToJson(this);

  Wallet copyWith({
    int? balance,
    List<dynamic>? transactions,
  }) {
    return Wallet(
      balance: balance ?? this.balance,
      transactions: transactions ?? this.transactions,
    );
  }
}
