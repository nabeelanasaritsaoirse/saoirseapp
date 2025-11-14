class DashboardModel {
  final bool success;
  final DashboardData? dashboardData;

  DashboardModel({required this.success, this.dashboardData});

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      success: json['success'] ?? false,
      dashboardData: json['dashboardData'] != null
          ? DashboardData.fromJson(json['dashboardData'])
          : null,
    );
  }
}

class DashboardData {
  final User? user;
  final Stats? stats;
  final List<Referral>? referrals;
  final PlatformStats? platformStats;
  final List<Transaction>? recentTransactions;

  DashboardData({
    this.user,
    this.stats,
    this.referrals,
    this.platformStats,
    this.recentTransactions,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      stats: json['stats'] != null ? Stats.fromJson(json['stats']) : null,
      referrals: (json['referrals'] as List?)
          ?.map((e) => Referral.fromJson(e))
          .toList(),
      platformStats: json['platformStats'] != null
          ? PlatformStats.fromJson(json['platformStats'])
          : null,
      recentTransactions: (json['recentTransactions'] as List?)
          ?.map((e) => Transaction.fromJson(e))
          .toList(),
    );
  }
}

class User {
  final String name;
  final String referralCode;

  User({required this.name, required this.referralCode});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'] ?? '',
      referralCode: json['referralCode'] ?? '',
    );
  }
}

class Stats {
  final num walletBalance;
  final num totalEarnings;
  final num totalWithdrawn;
  final int activeReferrals;
  final int totalReferrals;

  Stats({
    required this.walletBalance,
    required this.totalEarnings,
    required this.totalWithdrawn,
    required this.activeReferrals,
    required this.totalReferrals,
  });

  factory Stats.fromJson(Map<String, dynamic> json) {
    return Stats(
      walletBalance: json['walletBalance'] ?? 0,
      totalEarnings: json['totalEarnings'] ?? 0,
      totalWithdrawn: json['totalWithdrawn'] ?? 0,
      activeReferrals: json['activeReferrals'] ?? 0,
      totalReferrals: json['totalReferrals'] ?? 0,
    );
  }
}

class Referral {
  final String id;
  final String name;
  final String progress;
  final num progressPercent;
  final String referralStatus;
  final String statusMessage;
  final bool hasPurchased;
  final InstallmentPlan? installmentPlan;
  final String startDate;
  final String endDate;

  Referral({
    required this.id,
    required this.name,
    required this.progress,
    required this.progressPercent,
    required this.referralStatus,
    required this.statusMessage,
    required this.hasPurchased,
    this.installmentPlan,
    required this.startDate,
    required this.endDate,
  });

  factory Referral.fromJson(Map<String, dynamic> json) {
    return Referral(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      progress: json['progress'] ?? '',
      progressPercent: json['progressPercent'] ?? 0,
      referralStatus: json['referralStatus'] ?? '',
      statusMessage: json['statusMessage'] ?? '',
      hasPurchased: json['hasPurchased'] ?? false,
      installmentPlan: json['installmentPlan'] != null
          ? InstallmentPlan.fromJson(json['installmentPlan'])
          : null,
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
    );
  }
}

class InstallmentPlan {
  final num dailyAmount;
  final int days;
  final num totalAmount;
  final num commissionPerDay;
  final num totalCommissionExpected;
  final num commissionEarned;
  final int daysPaid;
  final int daysRemaining;
  final String planName;

  InstallmentPlan({
    required this.dailyAmount,
    required this.days,
    required this.totalAmount,
    required this.commissionPerDay,
    required this.totalCommissionExpected,
    required this.commissionEarned,
    required this.daysPaid,
    required this.daysRemaining,
    required this.planName,
  });

  factory InstallmentPlan.fromJson(Map<String, dynamic> json) {
    return InstallmentPlan(
      dailyAmount: json['dailyAmount'] ?? 0,
      days: json['days'] ?? 0,
      totalAmount: json['totalAmount'] ?? 0,
      commissionPerDay: json['commissionPerDay'] ?? 0,
      totalCommissionExpected: json['totalCommissionExpected'] ?? 0,
      commissionEarned: json['commissionEarned'] ?? 0,
      daysPaid: json['daysPaid'] ?? 0,
      daysRemaining: json['daysRemaining'] ?? 0,
      planName: json['planName'] ?? '',
    );
  }
}

class PlatformStats {
  final int totalPeopleReferred;

  PlatformStats({required this.totalPeopleReferred});

  factory PlatformStats.fromJson(Map<String, dynamic> json) {
    return PlatformStats(
      totalPeopleReferred: json['totalPeopleReferred'] ?? 0,
    );
  }
}

class Transaction {
  final String id;
  final num amount;
  final String date;
  final String referredUser;
  final String status;

  Transaction({
    required this.id,
    required this.amount,
    required this.date,
    required this.referredUser,
    required this.status,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['_id'] ?? '',
      amount: json['amount'] ?? 0,
      date: json['date'] ?? '',
      referredUser: json['referredUser'] ?? '',
      status: json['status'] ?? '',
    );
  }
}
