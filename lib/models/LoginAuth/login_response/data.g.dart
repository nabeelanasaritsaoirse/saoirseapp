// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Data _$DataFromJson(Map<String, dynamic> json) => Data(
      userId: json['userId'] as String?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      profilePicture: json['profilePicture'] as String?,
      role: json['role'] as String?,
      referralCode: json['referralCode'] as String?,
      isAgree: json['isAgree'] as bool?,
      wallet: json['wallet'] == null
          ? null
          : Wallet.fromJson(json['wallet'] as Map<String, dynamic>),
      accessToken: json['accessToken'] as String?,
      refreshToken: json['refreshToken'] as String?,
    );

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'userId': instance.userId,
      'name': instance.name,
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      'profilePicture': instance.profilePicture,
      'role': instance.role,
      'referralCode': instance.referralCode,
      'isAgree': instance.isAgree,
      'wallet': instance.wallet,
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
    };
