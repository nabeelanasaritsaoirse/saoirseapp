import 'package:json_annotation/json_annotation.dart';

part 'wallet.g.dart';

@JsonSerializable()
class Wallet {
  int? balance;
  List<dynamic>? transactions;

  Wallet({this.balance, this.transactions});

  factory Wallet.fromJson(Map<String, dynamic> json) {
    return _$WalletFromJson(json);
  }

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
