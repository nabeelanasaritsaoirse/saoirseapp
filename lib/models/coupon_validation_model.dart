
class CouponValidationResponse {
  final CouponInfo coupon;
  final PricingInfo pricing;
  final InstallmentInfo installment;
  final BenefitsInfo benefits;

  CouponValidationResponse({
    required this.coupon,
    required this.pricing,
    required this.installment,
    required this.benefits,
  });

  factory CouponValidationResponse.fromJson(Map<String, dynamic> json) {
    return CouponValidationResponse(
      coupon: CouponInfo.fromJson(json["coupon"] ?? {}),
      pricing: PricingInfo.fromJson(json["pricing"] ?? {}),
      installment: InstallmentInfo.fromJson(json["installment"] ?? {}),
      benefits: BenefitsInfo.fromJson(json["benefits"] ?? {}),
    );
  }
}

class CouponInfo {
  final String type; // "INSTANT" | "REDUCE_DAYS" | "MILESTONE_REWARD" etc

  CouponInfo({required this.type});

  factory CouponInfo.fromJson(Map<String, dynamic> json) {
    return CouponInfo(type: json["type"] ?? "");
  }
}

class PricingInfo {
  final double originalPrice;
  final double discountAmount;
  final double finalPrice;

  PricingInfo({
    required this.originalPrice,
    required this.discountAmount,
    required this.finalPrice,
  });

  factory PricingInfo.fromJson(Map<String, dynamic> json) {
    double toDouble(dynamic v) {
      if (v == null) return 0.0;
      if (v is int) return v.toDouble();
      if (v is double) return v;
      try {
        return double.parse(v.toString());
      } catch (_) {
        return 0.0;
      }
    }

    return PricingInfo(
      originalPrice: toDouble(json["originalPrice"]),
      discountAmount: toDouble(json["discountAmount"]),
      finalPrice: toDouble(json["finalPrice"]),
    );
  }
}

class InstallmentInfo {
  final int totalDays;
  final double dailyAmount;
  final int freeDays;
  final int? reducedDays; // present for REDUCE_DAYS

  InstallmentInfo({
    required this.totalDays,
    required this.dailyAmount,
    required this.freeDays,
    required this.reducedDays,
  });

  factory InstallmentInfo.fromJson(Map<String, dynamic> json) {
    int toInt(dynamic v) {
      if (v == null) return 0;
      if (v is int) return v;
      try {
        return int.parse(v.toString());
      } catch (_) {
        return 0;
      }
    }

    double toDouble(dynamic v) {
      if (v == null) return 0.0;
      if (v is int) return v.toDouble();
      if (v is double) return v;
      try {
        return double.parse(v.toString());
      } catch (_) {
        return 0.0;
      }
    }

    return InstallmentInfo(
      totalDays: toInt(json["totalDays"]),
      dailyAmount: toDouble(json["dailyAmount"]),
      freeDays: toInt(json["freeDays"] ?? 0),
      reducedDays: json.containsKey("reducedDays")
          ? toInt(json["reducedDays"])
          : null,
    );
  }
}

class BenefitsInfo {
  final String savingsMessage;
  final String howItWorksMessage;

  BenefitsInfo({
    required this.savingsMessage,
    required this.howItWorksMessage,
  });

  factory BenefitsInfo.fromJson(Map<String, dynamic> json) {
    return BenefitsInfo(
      savingsMessage: json["savingsMessage"] ?? "",
      howItWorksMessage: json["howItWorksMessage"] ?? "",
    );
  }
}
