// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Wallet _$WalletFromJson(Map<String, dynamic> json) => Wallet(
      balance: (json['balance'] as num?)?.toInt(),
      transactions: json['transactions'] as List<dynamic>?,
    );

Map<String, dynamic> _$WalletToJson(Wallet instance) => <String, dynamic>{
      'balance': instance.balance,
      'transactions': instance.transactions,
    };
