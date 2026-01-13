// bulk_order_preview_response.dart

class BulkOrderPreviewResponse {
  final bool success;
  final String message;
  final BulkOrderPreviewData data;
  final PreviewMeta meta;

  BulkOrderPreviewResponse({
    required this.success,
    required this.message,
    required this.data,
    required this.meta,
  });

  factory BulkOrderPreviewResponse.fromJson(Map<String, dynamic> json) {
    return BulkOrderPreviewResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: BulkOrderPreviewData.fromJson(json['data']),
      meta: PreviewMeta.fromJson(json['meta']),
    );
  }
}

/* ======================= DATA ======================= */

class BulkOrderPreviewData {
  final bool success;
  final PreviewSummary summary;
  final List<PreviewItem> items;
  final List<dynamic> invalidItems;
  final PreviewPayment payment;
  final PreviewWallet wallet;
  final PreviewAddress deliveryAddress;
  final PreviewValidation validation;

  BulkOrderPreviewData({
    required this.success,
    required this.summary,
    required this.items,
    required this.invalidItems,
    required this.payment,
    required this.wallet,
    required this.deliveryAddress,
    required this.validation,
  });

  factory BulkOrderPreviewData.fromJson(Map<String, dynamic> json) {
    return BulkOrderPreviewData(
      success: json['success'] ?? false,
      summary: PreviewSummary.fromJson(json['summary']),
      items: (json['items'] as List)
          .map((e) => PreviewItem.fromJson(e))
          .toList(),
      invalidItems: json['invalidItems'] ?? [],
      payment: PreviewPayment.fromJson(json['payment']),
      wallet: PreviewWallet.fromJson(json['wallet']),
      deliveryAddress: PreviewAddress.fromJson(json['deliveryAddress']),
      validation: PreviewValidation.fromJson(json['validation']),
    );
  }
}

/* ======================= SUMMARY ======================= */

class PreviewSummary {
  final int totalItems;
  final int validItems;
  final int invalidItems;
  final double totalFirstPayment;
  final double totalProductPrice;
  final double totalOriginalPrice;
  final double totalCouponDiscount;
  final double totalSavings;

  PreviewSummary({
    required this.totalItems,
    required this.validItems,
    required this.invalidItems,
    required this.totalFirstPayment,
    required this.totalProductPrice,
    required this.totalOriginalPrice,
    required this.totalCouponDiscount,
    required this.totalSavings,
  });

  factory PreviewSummary.fromJson(Map<String, dynamic> json) {
    return PreviewSummary(
      totalItems: json['totalItems'] ?? 0,
      validItems: json['validItems'] ?? 0,
      invalidItems: json['invalidItems'] ?? 0,
      totalFirstPayment:
          (json['totalFirstPayment'] ?? 0).toDouble(),
      totalProductPrice:
          (json['totalProductPrice'] ?? 0).toDouble(),
      totalOriginalPrice:
          (json['totalOriginalPrice'] ?? 0).toDouble(),
      totalCouponDiscount:
          (json['totalCouponDiscount'] ?? 0).toDouble(),
      totalSavings:
          (json['totalSavings'] ?? 0).toDouble(),
    );
  }
}

/* ======================= ITEM ======================= */

class PreviewItem {
  final int itemIndex;
  final PreviewProduct product;
  final PreviewVariant? variant;
  final int quantity;
  final PreviewPricing pricing;
  final PreviewInstallment installment;
  final dynamic coupon;

  PreviewItem({
    required this.itemIndex,
    required this.product,
    this.variant,
    required this.quantity,
    required this.pricing,
    required this.installment,
    this.coupon,
  });

  factory PreviewItem.fromJson(Map<String, dynamic> json) {
    return PreviewItem(
      itemIndex: json['itemIndex'],
      product: PreviewProduct.fromJson(json['product']),
      variant: json['variant'] != null
          ? PreviewVariant.fromJson(json['variant'])
          : null,
      quantity: json['quantity'],
      pricing: PreviewPricing.fromJson(json['pricing']),
      installment: PreviewInstallment.fromJson(json['installment']),
      coupon: json['coupon'],
    );
  }
}

/* ======================= PRODUCT ======================= */

class PreviewProduct {
  final String id;
  final String name;
  final String brand;
  final List<PreviewImage> images;

  PreviewProduct({
    required this.id,
    required this.name,
    required this.brand,
    required this.images,
  });

  factory PreviewProduct.fromJson(Map<String, dynamic> json) {
    return PreviewProduct(
      id: json['id'],
      name: json['name'],
      brand: json['brand'],
      images: (json['images'] as List)
          .map((e) => PreviewImage.fromJson(e))
          .toList(),
    );
  }
}

class PreviewImage {
  final String url;
  final bool isPrimary;

  PreviewImage({
    required this.url,
    required this.isPrimary,
  });

  factory PreviewImage.fromJson(Map<String, dynamic> json) {
    return PreviewImage(
      url: json['url'],
      isPrimary: json['isPrimary'] ?? false,
    );
  }
}

/* ======================= VARIANT ======================= */

class PreviewVariant {
  final String sku;
  final PreviewAttributes attributes;
  final double price;

  PreviewVariant({
    required this.sku,
    required this.attributes,
    required this.price,
  });

  factory PreviewVariant.fromJson(Map<String, dynamic> json) {
    return PreviewVariant(
      sku: json['sku'],
      attributes: PreviewAttributes.fromJson(json['attributes']),
      price: (json['price'] ?? 0).toDouble(),
    );
  }
}

class PreviewAttributes {
  final String? color;
  final String? size;
  final String? weight;
  final String? material;

  PreviewAttributes({
    this.color,
    this.size,
    this.weight,
    this.material,
  });

  factory PreviewAttributes.fromJson(Map<String, dynamic> json) {
    return PreviewAttributes(
      color: json['color'],
      size: json['size'],
      weight: json['weight'],
      material: json['material'],
    );
  }
}

/* ======================= PRICING ======================= */

class PreviewPricing {
  final double pricePerUnit;
  final double totalProductPrice;
  final double originalPrice;
  final double couponDiscount;
  final double finalPrice;

  PreviewPricing({
    required this.pricePerUnit,
    required this.totalProductPrice,
    required this.originalPrice,
    required this.couponDiscount,
    required this.finalPrice,
  });

  factory PreviewPricing.fromJson(Map<String, dynamic> json) {
    return PreviewPricing(
      pricePerUnit:
          (json['pricePerUnit'] ?? 0).toDouble(),
      totalProductPrice:
          (json['totalProductPrice'] ?? 0).toDouble(),
      originalPrice:
          (json['originalPrice'] ?? 0).toDouble(),
      couponDiscount:
          (json['couponDiscount'] ?? 0).toDouble(),
      finalPrice:
          (json['finalPrice'] ?? 0).toDouble(),
    );
  }
}

/* ======================= INSTALLMENT ======================= */

class PreviewInstallment {
  final int totalDays;
  final double dailyAmount;
  final double firstPayment;
  final double totalPayable;
  final int freeDays;
  final int reducedDays;

  PreviewInstallment({
    required this.totalDays,
    required this.dailyAmount,
    required this.firstPayment,
    required this.totalPayable,
    required this.freeDays,
    required this.reducedDays,
  });

  factory PreviewInstallment.fromJson(Map<String, dynamic> json) {
    return PreviewInstallment(
      totalDays: json['totalDays'],
      dailyAmount:
          (json['dailyAmount'] ?? 0).toDouble(),
      firstPayment:
          (json['firstPayment'] ?? 0).toDouble(),
      totalPayable:
          (json['totalPayable'] ?? 0).toDouble(),
      freeDays: json['freeDays'] ?? 0,
      reducedDays: json['reducedDays'] ?? 0,
    );
  }
}

/* ======================= PAYMENT ======================= */

class PreviewPayment {
  final double firstPaymentRequired;
  final double totalOrderValue;
  final double remainingAfterFirstPayment;

  PreviewPayment({
    required this.firstPaymentRequired,
    required this.totalOrderValue,
    required this.remainingAfterFirstPayment,
  });

  factory PreviewPayment.fromJson(Map<String, dynamic> json) {
    return PreviewPayment(
      firstPaymentRequired:
          (json['firstPaymentRequired'] ?? 0).toDouble(),
      totalOrderValue:
          (json['totalOrderValue'] ?? 0).toDouble(),
      remainingAfterFirstPayment:
          (json['remainingAfterFirstPayment'] ?? 0).toDouble(),
    );
  }
}

/* ======================= WALLET ======================= */

class PreviewWallet {
  final double balance;
  final bool canPayWithWallet;
  final double shortfall;

  PreviewWallet({
    required this.balance,
    required this.canPayWithWallet,
    required this.shortfall,
  });

  factory PreviewWallet.fromJson(Map<String, dynamic> json) {
    return PreviewWallet(
      balance: (json['balance'] ?? 0).toDouble(),
      canPayWithWallet: json['canPayWithWallet'] ?? false,
      shortfall: (json['shortfall'] ?? 0).toDouble(),
    );
  }
}

/* ======================= ADDRESS ======================= */

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
      name: json['name'],
      phoneNumber: json['phoneNumber'],
      addressLine1: json['addressLine1'],
      city: json['city'],
      state: json['state'],
      pincode: json['pincode'],
      country: json['country'],
    );
  }
}

/* ======================= VALIDATION ======================= */

class PreviewValidation {
  final bool allItemsValid;
  final bool hasValidItems;
  final bool canProceed;

  PreviewValidation({
    required this.allItemsValid,
    required this.hasValidItems,
    required this.canProceed,
  });

  factory PreviewValidation.fromJson(Map<String, dynamic> json) {
    return PreviewValidation(
      allItemsValid: json['allItemsValid'] ?? false,
      hasValidItems: json['hasValidItems'] ?? false,
      canProceed: json['canProceed'] ?? false,
    );
  }
}

/* ======================= META ======================= */

class PreviewMeta {
  final String timestamp;

  PreviewMeta({required this.timestamp});

  factory PreviewMeta.fromJson(Map<String, dynamic> json) {
    return PreviewMeta(
      timestamp: json['timestamp'],
    );
  }
}
