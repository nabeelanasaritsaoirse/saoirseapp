class BulkOrderResponse {
  final bool success;
  final BulkOrderData data;
  final String message;

  BulkOrderResponse({
    required this.success,
    required this.data,
    required this.message,
  });

  factory BulkOrderResponse.fromJson(Map<String, dynamic> json) {
    return BulkOrderResponse(
      success: json['success'] ?? false,
      data: BulkOrderData.fromJson(json['data'] ?? {}),
      message: json['message'] ?? "",
    );
  }
}

// ---------------------------------------------------------------------------

class BulkOrderData {
  final String bulkOrderId;
  final bool success;
  final BulkSummary summary;
  final List<BulkOrderItem> orders;

  /// OLD RESPONSE (may or may not come)
  final List<BulkPayment> payments;

  /// NEW RESPONSE (added by backend)
  final BulkPaymentSummary? payment; // ✅ ADDED (without removing payments)

  final List<dynamic> failedItems;
  final RazorpayOrder? razorpayOrder;
  final String message;

  /// EXISTING (unchanged)
  final List<String> walletTransactionIds;

  BulkOrderData({
    required this.bulkOrderId,
    required this.success,
    required this.summary,
    required this.orders,
    required this.payments,
    this.payment,
    required this.failedItems,
    this.razorpayOrder,
    required this.message,
    required this.walletTransactionIds,
  });

  factory BulkOrderData.fromJson(Map<String, dynamic> json) {
    return BulkOrderData(
      bulkOrderId: json['bulkOrderId'] ?? "",
      success: json['success'] ?? false,
      summary: BulkSummary.fromJson(json['summary'] ?? {}),
      orders: (json['orders'] as List<dynamic>? ?? [])
          .map((e) => BulkOrderItem.fromJson(e))
          .toList(),

      // OLD response support
      payments: (json['payments'] as List<dynamic>? ?? [])
          .map((e) => BulkPayment.fromJson(e))
          .toList(),

      // NEW response support
      payment: json['payment'] != null
          ? BulkPaymentSummary.fromJson(json['payment'])
          : null,

      failedItems: json['failedItems'] ?? [],
      razorpayOrder: json['razorpayOrder'] != null
          ? RazorpayOrder.fromJson(json['razorpayOrder'])
          : null,
      message: json['message'] ?? "",
      walletTransactionIds:
          (json['walletTransactionIds'] as List<dynamic>? ?? [])
              .map((e) => e.toString())
              .toList(),
    );
  }
}

// ---------------------------------------------------------------------------

class BulkSummary {
  final int totalItems;
  final int successfulOrders;
  final int failedItems;
  final int totalFirstPayment;
  final String paymentMethod;

  BulkSummary({
    required this.totalItems,
    required this.successfulOrders,
    required this.failedItems,
    required this.totalFirstPayment,
    required this.paymentMethod,
  });

  factory BulkSummary.fromJson(Map<String, dynamic> json) {
    return BulkSummary(
      totalItems: json['totalItems'] ?? 0,
      successfulOrders: json['successfulOrders'] ?? 0,
      failedItems: json['failedItems'] ?? 0,
      totalFirstPayment: json['totalFirstPayment'] ?? 0,
      paymentMethod: json['paymentMethod'] ?? "",
    );
  }
}

// ---------------------------------------------------------------------------

class BulkOrderItem {
  final String orderId;
  final String id;
  final String productName;
  final int quantity;
  final int totalDays;
  final double dailyPaymentAmount;
  final int productPrice;
  final String status;

  BulkOrderItem({
    required this.orderId,
    required this.id,
    required this.productName,
    required this.quantity,
    required this.totalDays,
    required this.dailyPaymentAmount,
    required this.productPrice,
    required this.status,
  });

  factory BulkOrderItem.fromJson(Map<String, dynamic> json) {
    return BulkOrderItem(
      orderId: json['orderId'] ?? "",
      id: json['_id'] ?? "",
      productName: json['productName'] ?? "",
      quantity: json['quantity'] ?? 0,
      totalDays: json['totalDays'] ?? 0,
      dailyPaymentAmount:
          (json['dailyPaymentAmount'] ?? 0).toDouble(),
      productPrice: json['productPrice'] ?? 0,
      status: json['status'] ?? "",
    );
  }
}

// ---------------------------------------------------------------------------
/// OLD per-item payment mapping (kept for backward compatibility)
class BulkPayment {
  final String paymentId;
  final String orderId;
  final int amount;

  BulkPayment({
    required this.paymentId,
    required this.orderId,
    required this.amount,
  });

  factory BulkPayment.fromJson(Map<String, dynamic> json) {
    return BulkPayment(
      paymentId: json['paymentId'] ?? "",
      orderId: json['orderId'] ?? "",
      amount: json['amount'] ?? 0,
    );
  }
}

// ---------------------------------------------------------------------------
/// NEW summary payment object (ADDED)
class BulkPaymentSummary {
  final String razorpayOrderId;
  final int amount; // rupees
  final String currency;

  BulkPaymentSummary({
    required this.razorpayOrderId,
    required this.amount,
    required this.currency,
  });

  factory BulkPaymentSummary.fromJson(Map<String, dynamic> json) {
    return BulkPaymentSummary(
      razorpayOrderId: json['razorpayOrderId'] ?? "",
      amount: json['amount'] ?? 0,
      currency: json['currency'] ?? "INR",
    );
  }
}

// ---------------------------------------------------------------------------

class RazorpayOrder {
  final String id;
  final int amount; // paise
  final String currency;
  final String keyId;

  RazorpayOrder({
    required this.id,
    required this.amount,
    required this.currency,
    required this.keyId,
  });

  factory RazorpayOrder.fromJson(Map<String, dynamic> json) {
    return RazorpayOrder(
      id: json['id'] ?? "",
      amount: json['amount'] ?? 0,
      currency: json['currency'] ?? "INR",
      keyId: json['keyId'] ?? "",
    );
  }
}








// class BulkOrderResponse {
//   final bool success;
//   final BulkOrderData data;
//   final String message;

//   BulkOrderResponse({
//     required this.success,
//     required this.data,
//     required this.message,
//   });

//   factory BulkOrderResponse.fromJson(Map<String, dynamic> json) {
//     return BulkOrderResponse(
//       success: json['success'] ?? false,
//       data: BulkOrderData.fromJson(json['data'] ?? {}),
//       message: json['message'] ?? "",
//     );
//   }
// }

// // ---------------------------------------------------------------------------

// class BulkOrderData {
//   final String bulkOrderId;
//   final bool success; // ADDED
//   final BulkSummary summary;
//   final List<BulkOrderItem> orders;
//   final List<BulkPayment> payments; // ADDED
//   final List<dynamic> failedItems; // ADDED
//   final RazorpayOrder? razorpayOrder;
//   final String message; // ADDED

//   // EXISTING (UNCHANGED)
//   final List<String> walletTransactionIds;

//   BulkOrderData({
//     required this.bulkOrderId,
//     required this.success,
//     required this.summary,
//     required this.orders,
//     required this.payments,
//     required this.failedItems,
//     this.razorpayOrder,
//     required this.message,
//     required this.walletTransactionIds,
//   });

//   factory BulkOrderData.fromJson(Map<String, dynamic> json) {
//     return BulkOrderData(
//       bulkOrderId: json['bulkOrderId'] ?? "",
//       success: json['success'] ?? false,
//       summary: BulkSummary.fromJson(json['summary'] ?? {}),
//       orders: (json['orders'] as List<dynamic>? ?? [])
//           .map((e) => BulkOrderItem.fromJson(e))
//           .toList(),
//       payments: (json['payments'] as List<dynamic>? ?? [])
//           .map((e) => BulkPayment.fromJson(e))
//           .toList(),
//       failedItems: json['failedItems'] ?? [],
//       razorpayOrder: json['razorpayOrder'] != null
//           ? RazorpayOrder.fromJson(json['razorpayOrder'])
//           : null,
//       message: json['message'] ?? "",
//       walletTransactionIds:
//           (json['walletTransactionIds'] as List<dynamic>? ?? [])
//               .map((e) => e.toString())
//               .toList(),
//     );
//   }
// }

// // ---------------------------------------------------------------------------

// class BulkSummary {
//   final int totalItems;
//   final int successfulOrders;
//   final int failedItems; // ADDED
//   final int totalFirstPayment;
//   final String paymentMethod;

//   BulkSummary({
//     required this.totalItems,
//     required this.successfulOrders,
//     required this.failedItems,
//     required this.totalFirstPayment,
//     required this.paymentMethod,
//   });

//   factory BulkSummary.fromJson(Map<String, dynamic> json) {
//     return BulkSummary(
//       totalItems: json['totalItems'] ?? 0,
//       successfulOrders: json['successfulOrders'] ?? 0,
//       failedItems: json['failedItems'] ?? 0,
//       totalFirstPayment: json['totalFirstPayment'] ?? 0,
//       paymentMethod: json['paymentMethod'] ?? "",
//     );
//   }
// }

// // ---------------------------------------------------------------------------

// class BulkOrderItem {
//   final String orderId;
//   final String id; // ADDED (_id)
//   final String productName;
//   final int quantity;
//   final int totalDays;
//   final double dailyPaymentAmount;
//   final int productPrice; // ADDED
//   final String status;

//   BulkOrderItem({
//     required this.orderId,
//     required this.id,
//     required this.productName,
//     required this.quantity,
//     required this.totalDays,
//     required this.dailyPaymentAmount,
//     required this.productPrice,
//     required this.status,
//   });

//   factory BulkOrderItem.fromJson(Map<String, dynamic> json) {
//     return BulkOrderItem(
//       orderId: json['orderId'] ?? "",
//       id: json['_id'] ?? "",
//       productName: json['productName'] ?? "",
//       quantity: json['quantity'] ?? 0,
//       totalDays: json['totalDays'] ?? 0,
//       dailyPaymentAmount:
//           (json['dailyPaymentAmount'] ?? 0).toDouble(),
//       productPrice: json['productPrice'] ?? 0,
//       status: json['status'] ?? "",
//     );
//   }
// }

// // ---------------------------------------------------------------------------

// class BulkPayment {
//   final String paymentId;
//   final String orderId;
//   final int amount;

//   BulkPayment({
//     required this.paymentId,
//     required this.orderId,
//     required this.amount,
//   });

//   factory BulkPayment.fromJson(Map<String, dynamic> json) {
//     return BulkPayment(
//       paymentId: json['paymentId'] ?? "",
//       orderId: json['orderId'] ?? "",
//       amount: json['amount'] ?? 0,
//     );
//   }
// }

// // ---------------------------------------------------------------------------

// class RazorpayOrder {
//   final String id;
//   final int amount;
//   final String currency;
//   final String keyId;

//   RazorpayOrder({
//     required this.id,
//     required this.amount,
//     required this.currency,
//     required this.keyId,
//   });

//   factory RazorpayOrder.fromJson(Map<String, dynamic> json) {
//     return RazorpayOrder(
//       id: json['id'] ?? "",
//       amount: json['amount'] ?? 0,
//       currency: json['currency'] ?? "INR",
//       keyId: json['keyId'] ?? "",
//     );
//   }
// }


// class BulkOrderResponse {
//   final bool success;
//   final BulkOrderData data;
//   final String message;

//   BulkOrderResponse({
//     required this.success,
//     required this.data,
//     required this.message,
//   });

//   factory BulkOrderResponse.fromJson(Map<String, dynamic> json) {
//     return BulkOrderResponse(
//       success: json['success'] ?? false,
//       data: BulkOrderData.fromJson(json['data']),
//       message: json['message'] ?? "",
//     );
//   }
// }

// class BulkOrderData {
//   final String bulkOrderId;
//   final BulkSummary summary;
//   final List<BulkOrderItem> orders;
//   final RazorpayOrder? razorpayOrder;
//   final List<String> walletTransactionIds;

//   BulkOrderData({
//     required this.bulkOrderId,
//     required this.summary,
//     required this.orders,
//     this.razorpayOrder,
//     required this.walletTransactionIds,
//   });

//   factory BulkOrderData.fromJson(Map<String, dynamic> json) {
//     return BulkOrderData(
//       bulkOrderId: json['bulkOrderId'] ?? "",
//       summary: BulkSummary.fromJson(json['summary']),
//       orders: (json['orders'] as List<dynamic>)
//           .map((e) => BulkOrderItem.fromJson(e))
//           .toList(),
//       razorpayOrder: json['razorpayOrder'] != null
//           ? RazorpayOrder.fromJson(json['razorpayOrder'])
//           : null,
//       walletTransactionIds:
//           (json['walletTransactionIds'] as List<dynamic>? ?? [])
//               .map((e) => e.toString())
//               .toList(),
//     );
//   }
// }

// class BulkSummary {
//   final int totalItems;
//   final int successfulOrders;
//   final int totalFirstPayment;
//   final String paymentMethod;

//   BulkSummary({
//     required this.totalItems,
//     required this.successfulOrders,
//     required this.totalFirstPayment,
//     required this.paymentMethod,
//   });

//   factory BulkSummary.fromJson(Map<String, dynamic> json) {
//     return BulkSummary(
//       totalItems: json['totalItems'] ?? 0,
//       successfulOrders: json['successfulOrders'] ?? 0,
//       totalFirstPayment: json['totalFirstPayment'] ?? 0,
//       paymentMethod: json['paymentMethod'] ?? "",
//     );
//   }
// }

// class BulkOrderItem {
//   final String orderId;
//   final String productName;
//   final int quantity;
//   final int totalDays;
//   final double dailyPaymentAmount;
//   final String status;

//   BulkOrderItem({
//     required this.orderId,
//     required this.productName,
//     required this.quantity,
//     required this.totalDays,
//     required this.dailyPaymentAmount,
//     required this.status,
//   });

//   factory BulkOrderItem.fromJson(Map<String, dynamic> json) {
//     return BulkOrderItem(
//       orderId: json['orderId'] ?? "",
//       productName: json['productName'] ?? "",
//       quantity: json['quantity'] ?? 0,
//       totalDays: json['totalDays'] ?? 0,
//       dailyPaymentAmount:
//           (json['dailyPaymentAmount'] ?? 0).toDouble(),
//       status: json['status'] ?? "",
//     );
//   }
// }

// class RazorpayOrder {
//   final String id;
//   final int amount;
//   final String currency;
//   final String keyId;

//   RazorpayOrder({
//     required this.id,
//     required this.amount,
//     required this.currency,
//     required this.keyId,
//   });

//   factory RazorpayOrder.fromJson(Map<String, dynamic> json) {
//     return RazorpayOrder(
//       id: json['id'] ?? "",
//       amount: json['amount'] ?? 0,
//       currency: json['currency'] ?? "INR",
//       keyId: json['keyId'] ?? "",
//     );
//   }
// }
