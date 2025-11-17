class InviteFriendProductModel {
  final String productName;
  final String productId;
  final String date;
  final double amount;
  final int pendingCount;
  final String pendingLabel;
  final double dailySip;
  final double commissionPerDay;
  final double totalEarnings;

  InviteFriendProductModel({
    required this.productName,
    required this.productId,
    required this.date,
    required this.amount,
    required this.pendingCount,
    required this.pendingLabel,
    required this.dailySip,
    required this.commissionPerDay,
    required this.totalEarnings,
  });
}
