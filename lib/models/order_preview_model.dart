// order_preview_model.dart

class OrderPreviewModel {
  final bool success;
  final String message;
  final OrderPreviewData data;
  final OrderPreviewMeta meta;

  OrderPreviewModel({
    required this.success,
    required this.message,
    required this.data,
    required this.meta,
  });

  factory OrderPreviewModel.fromJson(Map<String, dynamic> json) {
    return OrderPreviewModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: OrderPreviewData.fromJson(json['data'] ?? {}),
      meta: OrderPreviewMeta.fromJson(json['meta'] ?? {}),
    );
  }
}

// -----------------------------------------------------------------------------
// DATA
// -----------------------------------------------------------------------------

class OrderPreviewData {
  final PreviewProduct product;
  final PreviewPricing pricing;
  final PreviewInstallment installment;
  final PreviewCoupon? coupon;
  final PreviewAddress deliveryAddress;
  final PreviewSummary summary;
  final PreviewValidation validation;

  OrderPreviewData({
    required this.product,
    required this.pricing,
    required this.installment,
    required this.coupon,
    required this.deliveryAddress,
    required this.summary,
    required this.validation,
  });

  factory OrderPreviewData.fromJson(Map<String, dynamic> json) {
    return OrderPreviewData(
      product: PreviewProduct.fromJson(json['product'] ?? {}),
      pricing: PreviewPricing.fromJson(json['pricing'] ?? {}),
      installment: PreviewInstallment.fromJson(json['installment'] ?? {}),
      coupon:
          json['coupon'] != null ? PreviewCoupon.fromJson(json['coupon']) : null,
      deliveryAddress:
          PreviewAddress.fromJson(json['deliveryAddress'] ?? {}),
      summary: PreviewSummary.fromJson(json['summary'] ?? {}),
      validation: PreviewValidation.fromJson(json['validation'] ?? {}),
    );
  }
}

// -----------------------------------------------------------------------------
// PRODUCT
// -----------------------------------------------------------------------------

class PreviewProduct {
  final String id;
  final String name;
  final String description;
  final List<PreviewImage> images;
  final String brand;
  final PreviewCategory category;
  final PreviewVariant variant;

  PreviewProduct({
    required this.id,
    required this.name,
    required this.description,
    required this.images,
    required this.brand,
    required this.category,
    required this.variant,
  });

  factory PreviewProduct.fromJson(Map<String, dynamic> json) {
    return PreviewProduct(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      images: (json['images'] as List? ?? [])
          .map((e) => PreviewImage.fromJson(e))
          .toList(),
      brand: json['brand'] ?? '',
      category: PreviewCategory.fromJson(json['category'] ?? {}),
      variant: PreviewVariant.fromJson(json['variant'] ?? {}),
    );
  }
}

class PreviewImage {
  final String url;
  final bool isPrimary;
  final String altText;
  final int order;
  final String id;

  PreviewImage({
    required this.url,
    required this.isPrimary,
    required this.altText,
    required this.order,
    required this.id,
  });

  factory PreviewImage.fromJson(Map<String, dynamic> json) {
    return PreviewImage(
      url: json['url'] ?? '',
      isPrimary: json['isPrimary'] ?? false,
      altText: json['altText'] ?? '',
      order: json['order'] ?? 0,
      id: json['_id'] ?? '',
    );
  }
}

class PreviewCategory {
  final String mainCategoryId;
  final String mainCategoryName;
  final String subCategoryId;
  final String subCategoryName;

  PreviewCategory({
    required this.mainCategoryId,
    required this.mainCategoryName,
    required this.subCategoryId,
    required this.subCategoryName,
  });

  factory PreviewCategory.fromJson(Map<String, dynamic> json) {
    return PreviewCategory(
      mainCategoryId: json['mainCategoryId'] ?? '',
      mainCategoryName: json['mainCategoryName'] ?? '',
      subCategoryId: json['subCategoryId'] ?? '',
      subCategoryName: json['subCategoryName'] ?? '',
    );
  }
}

class PreviewVariant {
  final String variantId;
  final String sku;
  final Map<String, dynamic> attributes;
  final double price;

  PreviewVariant({
    required this.variantId,
    required this.sku,
    required this.attributes,
    required this.price,
  });

  factory PreviewVariant.fromJson(Map<String, dynamic> json) {
    return PreviewVariant(
      variantId: json['variantId'] ?? '',
      sku: json['sku'] ?? '',
      attributes: json['attributes'] ?? {},
      price: (json['price'] ?? 0).toDouble(),
    );
  }
}

// -----------------------------------------------------------------------------
// PRICING
// -----------------------------------------------------------------------------

class PreviewPricing {
  final double pricePerUnit;
  final int quantity;
  final double totalProductPrice;
  final double originalPrice;
  final double couponDiscount;
  final double finalProductPrice;
  final double savingsPercentage;

  PreviewPricing({
    required this.pricePerUnit,
    required this.quantity,
    required this.totalProductPrice,
    required this.originalPrice,
    required this.couponDiscount,
    required this.finalProductPrice,
    required this.savingsPercentage,
  });

  factory PreviewPricing.fromJson(Map<String, dynamic> json) {
    return PreviewPricing(
      pricePerUnit: (json['pricePerUnit'] ?? 0).toDouble(),
      quantity: json['quantity'] ?? 0,
      totalProductPrice: (json['totalProductPrice'] ?? 0).toDouble(),
      originalPrice: (json['originalPrice'] ?? 0).toDouble(),
      couponDiscount: (json['couponDiscount'] ?? 0).toDouble(),
      finalProductPrice: (json['finalProductPrice'] ?? 0).toDouble(),
      savingsPercentage: (json['savingsPercentage'] ?? 0).toDouble(),
    );
  }
}

// -----------------------------------------------------------------------------
// INSTALLMENT
// -----------------------------------------------------------------------------

class PreviewInstallment {
  final int totalDays;
  final double dailyAmount;
  final double totalPayableAmount;
  final double totalSavings;
  final int freeDays;
  final int reducedDays;
  final double minimumDailyAmount;

  PreviewInstallment({
    required this.totalDays,
    required this.dailyAmount,
    required this.totalPayableAmount,
    required this.totalSavings,
    required this.freeDays,
    required this.reducedDays,
    required this.minimumDailyAmount,
  });

  factory PreviewInstallment.fromJson(Map<String, dynamic> json) {
    return PreviewInstallment(
      totalDays: json['totalDays'] ?? 0,
      dailyAmount: (json['dailyAmount'] ?? 0).toDouble(),
      totalPayableAmount:
          (json['totalPayableAmount'] ?? 0).toDouble(),
      totalSavings: (json['totalSavings'] ?? 0).toDouble(),
      freeDays: json['freeDays'] ?? 0,
      reducedDays: json['reducedDays'] ?? 0,
      minimumDailyAmount:
          (json['minimumDailyAmount'] ?? 0).toDouble(),
    );
  }
}

// -----------------------------------------------------------------------------
// COUPON (UPDATED TO MATCH DOCUMENTATION)
// -----------------------------------------------------------------------------

class PreviewCoupon {
  final String code;
  final String type;
  final String description;
  final double discountAmount;
  final PreviewCouponBenefits benefits;

  PreviewCoupon({
    required this.code,
    required this.type,
    required this.description,
    required this.discountAmount,
    required this.benefits,
  });

  factory PreviewCoupon.fromJson(Map<String, dynamic> json) {
    return PreviewCoupon(
      code: json['code'] ?? '',
      type: json['type'] ?? '',
      description: json['description'] ?? '',
      discountAmount: (json['discountAmount'] ?? 0).toDouble(),
      benefits:
          PreviewCouponBenefits.fromJson(json['benefits'] ?? {}),
    );
  }
}

class PreviewCouponBenefits {
  final String savingsMessage;
  final String howItWorksMessage;

  PreviewCouponBenefits({
    required this.savingsMessage,
    required this.howItWorksMessage,
  });

  factory PreviewCouponBenefits.fromJson(Map<String, dynamic> json) {
    return PreviewCouponBenefits(
      savingsMessage: json['savingsMessage'] ?? '',
      howItWorksMessage: json['howItWorksMessage'] ?? '',
    );
  }
}

// -----------------------------------------------------------------------------
// ADDRESS
// -----------------------------------------------------------------------------

class PreviewAddress {
  final String name;
  final String phoneNumber;
  final String addressLine1;
  final String city;
  final String state;
  final String pincode;
  final String country;

  PreviewAddress({
    required this.name,
    required this.phoneNumber,
    required this.addressLine1,
    required this.city,
    required this.state,
    required this.pincode,
    required this.country,
  });

  factory PreviewAddress.fromJson(Map<String, dynamic> json) {
    return PreviewAddress(
      name: json['name'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      addressLine1: json['addressLine1'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      pincode: json['pincode'] ?? '',
      country: json['country'] ?? '',
    );
  }
}

// -----------------------------------------------------------------------------
// SUMMARY
// -----------------------------------------------------------------------------

class PreviewSummary {
  final String orderType;
  final String status;
  final double totalAmount;
  final double dailyPayment;
  final int duration;
  final double firstPaymentAmount;
  final DateTime estimatedCompletionDate;

  PreviewSummary({
    required this.orderType,
    required this.status,
    required this.totalAmount,
    required this.dailyPayment,
    required this.duration,
    required this.firstPaymentAmount,
    required this.estimatedCompletionDate,
  });

  factory PreviewSummary.fromJson(Map<String, dynamic> json) {
    return PreviewSummary(
      orderType: json['orderType'] ?? '',
      status: json['status'] ?? '',
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      dailyPayment: (json['dailyPayment'] ?? 0).toDouble(),
      duration: json['duration'] ?? 0,
      firstPaymentAmount:
          (json['firstPaymentAmount'] ?? 0).toDouble(),
      estimatedCompletionDate: DateTime.tryParse(
              json['estimatedCompletionDate'] ?? '') ??
          DateTime.now(),
    );
  }
}

// -----------------------------------------------------------------------------
// VALIDATION
// -----------------------------------------------------------------------------

class PreviewValidation {
  final bool isValid;
  final bool productAvailable;
  final bool durationValid;
  final bool dailyAmountValid;
  final bool? couponValid;

  PreviewValidation({
    required this.isValid,
    required this.productAvailable,
    required this.durationValid,
    required this.dailyAmountValid,
    required this.couponValid,
  });

  factory PreviewValidation.fromJson(Map<String, dynamic> json) {
    return PreviewValidation(
      isValid: json['isValid'] ?? false,
      productAvailable: json['productAvailable'] ?? false,
      durationValid: json['durationValid'] ?? false,
      dailyAmountValid: json['dailyAmountValid'] ?? false,
      couponValid: json['couponValid'],
    );
  }
}

// -----------------------------------------------------------------------------
// META
// -----------------------------------------------------------------------------

class OrderPreviewMeta {
  final DateTime timestamp;

  OrderPreviewMeta({required this.timestamp});

  factory OrderPreviewMeta.fromJson(Map<String, dynamic> json) {
    return OrderPreviewMeta(
      timestamp:
          DateTime.tryParse(json['timestamp'] ?? '') ?? DateTime.now(),
    );
  }
}
