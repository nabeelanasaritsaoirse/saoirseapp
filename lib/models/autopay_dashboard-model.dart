// ================= ROOT RESPONSE =================

// ignore_for_file: file_names

class AutopayDashboardModel {
  final bool success;
  final AutopayDashboardData data;

  AutopayDashboardModel({
    required this.success,
    required this.data,
  });

  factory AutopayDashboardModel.fromJson(Map<String, dynamic> json) {
    return AutopayDashboardModel(
      success: json['success'] ?? false,
      data: AutopayDashboardData.fromJson(json['data'] ?? {}),
    );
  }
}

// ================= DATA WRAPPER =================

class AutopayDashboardData {
  final Wallet wallet;
  final Autopay autopay;
  final Stats stats;
  final Streak streak;
  final Suggestions suggestions;
  final List<Order> orders;

  AutopayDashboardData({
    required this.wallet,
    required this.autopay,
    required this.stats,
    required this.streak,
    required this.suggestions,
    required this.orders,
  });

  factory AutopayDashboardData.fromJson(Map<String, dynamic> json) {
    return AutopayDashboardData(
      wallet: Wallet.fromJson(json['wallet'] ?? {}),
      autopay: Autopay.fromJson(json['autopay'] ?? {}),
      stats: Stats.fromJson(json['stats'] ?? {}),
      streak: Streak.fromJson(json['streak'] ?? {}),
      suggestions: Suggestions.fromJson(json['suggestions'] ?? {}),
      orders: (json['orders'] as List<dynamic>? ?? [])
          .map((e) => Order.fromJson(e))
          .toList(),
    );
  }
}

// ================= WALLET =================

class Wallet {
  final num balance;
  final num minimumLock;
  final num availableForAutopay;
  final bool isLowBalance;
  final int lowBalanceThreshold;

  Wallet({
    required this.balance,
    required this.minimumLock,
    required this.availableForAutopay,
    required this.isLowBalance,
    required this.lowBalanceThreshold,
  });

  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      balance: json['balance'] ?? 0,
      minimumLock: json['minimumLock'] ?? 0,
      availableForAutopay: json['availableForAutopay'] ?? 0,
      isLowBalance: json['isLowBalance'] ?? false,
      lowBalanceThreshold: json['lowBalanceThreshold'] ?? 0,
    );
  }
}

// ================= AUTOPAY =================

class Autopay {
  final bool enabled;
  final int totalOrders;
  final int autopayEnabledOrders;
  final int totalDailyDeduction;
  final int daysBalanceLasts;
  final DateTime? nextPaymentTime;
  final String timePreference;

  Autopay({
    required this.enabled,
    required this.totalOrders,
    required this.autopayEnabledOrders,
    required this.totalDailyDeduction,
    required this.daysBalanceLasts,
    required this.nextPaymentTime,
    required this.timePreference,
  });

  factory Autopay.fromJson(Map<String, dynamic> json) {
    return Autopay(
      enabled: json['enabled'] ?? false,
      totalOrders: json['totalOrders'] ?? 0,
      autopayEnabledOrders: json['autopayEnabledOrders'] ?? 0,
      totalDailyDeduction: json['totalDailyDeduction'] ?? 0,
      daysBalanceLasts: json['daysBalanceLasts'] ?? 0,
      nextPaymentTime: json['nextPaymentTime'] != null
          ? DateTime.tryParse(json['nextPaymentTime'])
          : null,
      timePreference: json['timePreference'] ?? '',
    );
  }
}

// ================= STATS =================

class Stats {
  final int thisMonthPaid;
  final int thisMonthPaymentsCount;

  Stats({
    required this.thisMonthPaid,
    required this.thisMonthPaymentsCount,
  });

  factory Stats.fromJson(Map<String, dynamic> json) {
    return Stats(
      thisMonthPaid: json['thisMonthPaid'] ?? 0,
      thisMonthPaymentsCount: json['thisMonthPaymentsCount'] ?? 0,
    );
  }
}

// ================= STREAK =================

class Streak {
  final int current;
  final int longest;
  final String? lastPaymentDate;
  final NextMilestone? nextMilestone;

  Streak({
    required this.current,
    required this.longest,
    required this.lastPaymentDate,
    required this.nextMilestone,
  });

  factory Streak.fromJson(Map<String, dynamic> json) {
    return Streak(
      current: json['current'] ?? 0,
      longest: json['longest'] ?? 0,
      lastPaymentDate: json['lastPaymentDate'],
      nextMilestone: json['nextMilestone'] != null &&
              (json['nextMilestone'] as Map).isNotEmpty
          ? NextMilestone.fromJson(json['nextMilestone'])
          : null,
    );
  }
}

// ================= NEXT MILESTONE =================

class NextMilestone {
  final int days;
  final int reward;
  final String badge;

  NextMilestone({
    required this.days,
    required this.reward,
    required this.badge,
  });

  factory NextMilestone.fromJson(Map<String, dynamic> json) {
    return NextMilestone(
      days: json['days'] ?? 0,
      reward: json['reward'] ?? 0,
      badge: json['badge'] ?? '',
    );
  }
}

// ================= SUGGESTIONS =================

class Suggestions {
  final int suggestedTopUp;
  final int topUpFor7Days;
  final int topUpFor30Days;

  Suggestions({
    required this.suggestedTopUp,
    required this.topUpFor7Days,
    required this.topUpFor30Days,
  });

  factory Suggestions.fromJson(Map<String, dynamic> json) {
    return Suggestions(
      suggestedTopUp: json['suggestedTopUp'] ?? 0,
      topUpFor7Days: json['topUpFor7Days'] ?? 0,
      topUpFor30Days: json['topUpFor30Days'] ?? 0,
    );
  }
}

// ================= ORDERS =================

class Order {
  final String id;
  final String productName;
  final int dailyAmount;
  final int remainingAmount;
  final bool autopayEnabled;
  final int priority;
  final double progress;

  Order({
    required this.id,
    required this.productName,
    required this.dailyAmount,
    required this.remainingAmount,
    required this.autopayEnabled,
    required this.priority,
    required this.progress,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id']?.toString() ?? '',
      productName: json['productName'] ?? '',
      dailyAmount: json['dailyAmount'] ?? 0,
      remainingAmount: json['remainingAmount'] ?? 0,
      autopayEnabled: json['autopayEnabled'] ?? false,
      priority: json['priority'] ?? 0,
      progress: (json['progress'] ?? 0).toDouble(),
    );
  }
}
