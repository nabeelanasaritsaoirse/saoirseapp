import 'package:json_annotation/json_annotation.dart';

import 'wallet.dart';

part 'data.g.dart';

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
