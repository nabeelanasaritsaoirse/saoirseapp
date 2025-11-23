class OrderResponseModel {
  final String message;
  final OrderModel order;
  final PricingModel pricing;
  final PaymentModel payment;

  OrderResponseModel({
    required this.message,
    required this.order,
    required this.pricing,
    required this.payment,
  });

  factory OrderResponseModel.fromJson(Map<String, dynamic> json) {
    return OrderResponseModel(
      message: json["message"] ?? "",
      order: OrderModel.fromJson(json["order"]),
      pricing: PricingModel.fromJson(json["pricing"]),
      payment: PaymentModel.fromJson(json["payment"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "message": message,
      "order": order.toJson(),
      "pricing": pricing.toJson(),
      "payment": payment.toJson(),
    };
  }
}

// -----------------------------------------------------------------------------
// ORDER MODEL
// -----------------------------------------------------------------------------
class OrderModel {
  final String user;
  final String product;
  final int orderAmount;
  final String paymentOption;
  final PaymentDetailsModel paymentDetails;
  final int currentEmiNumber;
  final int emiPaidAmount;
  final int totalPaid;
  final String orderStatus;
  final String paymentStatus;
  final DeliveryAddressModel deliveryAddress;
  final String deliveryStatus;
  final String id;
  final String createdAt;
  final String updatedAt;
  final int v;

  OrderModel({
    required this.user,
    required this.product,
    required this.orderAmount,
    required this.paymentOption,
    required this.paymentDetails,
    required this.currentEmiNumber,
    required this.emiPaidAmount,
    required this.totalPaid,
    required this.orderStatus,
    required this.paymentStatus,
    required this.deliveryAddress,
    required this.deliveryStatus,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      user: json["user"],
      product: json["product"],
      orderAmount: json["orderAmount"],
      paymentOption: json["paymentOption"],
      paymentDetails: PaymentDetailsModel.fromJson(json["paymentDetails"]),
      currentEmiNumber: json["currentEmiNumber"],
      emiPaidAmount: json["emiPaidAmount"],
      totalPaid: json["totalPaid"],
      orderStatus: json["orderStatus"],
      paymentStatus: json["paymentStatus"],
      deliveryAddress: DeliveryAddressModel.fromJson(json["deliveryAddress"]),
      deliveryStatus: json["deliveryStatus"],
      id: json["_id"],
      createdAt: json["createdAt"],
      updatedAt: json["updatedAt"],
      v: json["__v"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "user": user,
      "product": product,
      "orderAmount": orderAmount,
      "paymentOption": paymentOption,
      "paymentDetails": paymentDetails.toJson(),
      "currentEmiNumber": currentEmiNumber,
      "emiPaidAmount": emiPaidAmount,
      "totalPaid": totalPaid,
      "orderStatus": orderStatus,
      "paymentStatus": paymentStatus,
      "deliveryAddress": deliveryAddress.toJson(),
      "deliveryStatus": deliveryStatus,
      "_id": id,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
      "__v": v,
    };
  }
}

// -----------------------------------------------------------------------------
// PAYMENT DETAILS MODEL
// -----------------------------------------------------------------------------
class PaymentDetailsModel {
  final int dailyAmount;
  final int totalDuration;
  final int totalEmis;
  final String startDate;
  final String endDate;

  PaymentDetailsModel({
    required this.dailyAmount,
    required this.totalDuration,
    required this.totalEmis,
    required this.startDate,
    required this.endDate,
  });

  factory PaymentDetailsModel.fromJson(Map<String, dynamic> json) {
    return PaymentDetailsModel(
      dailyAmount: json["dailyAmount"],
      totalDuration: json["totalDuration"],
      totalEmis: json["totalEmis"],
      startDate: json["startDate"],
      endDate: json["endDate"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "dailyAmount": dailyAmount,
      "totalDuration": totalDuration,
      "totalEmis": totalEmis,
      "startDate": startDate,
      "endDate": endDate,
    };
  }
}

// -----------------------------------------------------------------------------
// DELIVERY ADDRESS MODEL
// -----------------------------------------------------------------------------
class DeliveryAddressModel {
  final String name;
  final String phoneNumber;
  final String addressLine1;
  final String city;
  final String state;
  final String pincode;

  DeliveryAddressModel({
    required this.name,
    required this.phoneNumber,
    required this.addressLine1,
    required this.city,
    required this.state,
    required this.pincode,
  });

  factory DeliveryAddressModel.fromJson(Map<String, dynamic> json) {
    return DeliveryAddressModel(
      name: json["name"],
      phoneNumber: json["phoneNumber"],
      addressLine1: json["addressLine1"],
      city: json["city"],
      state: json["state"],
      pincode: json["pincode"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "phoneNumber": phoneNumber,
      "addressLine1": addressLine1,
      "city": city,
      "state": state,
      "pincode": pincode,
    };
  }
}

// -----------------------------------------------------------------------------
// PRICING MODEL
// -----------------------------------------------------------------------------
class PricingModel {
  final int originalPrice;
  final int finalPrice;
  final dynamic coupon;

  PricingModel({
    required this.originalPrice,
    required this.finalPrice,
    this.coupon,
  });

  factory PricingModel.fromJson(Map<String, dynamic> json) {
    return PricingModel(
      originalPrice: json["originalPrice"],
      finalPrice: json["finalPrice"],
      coupon: json["coupon"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "originalPrice": originalPrice,
      "finalPrice": finalPrice,
      "coupon": coupon,
    };
  }
}

// -----------------------------------------------------------------------------
// PAYMENT MODEL
// -----------------------------------------------------------------------------
class PaymentModel {
  final String orderId;
  final int amount;
  final String currency;
  final String transactionId;
  final String keyId;

  PaymentModel({
    required this.orderId,
    required this.amount,
    required this.currency,
    required this.transactionId,
    required this.keyId,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      orderId: json["order_id"],
      amount: json["amount"],
      currency: json["currency"],
      transactionId: json["transaction_id"],
      keyId: json["key_id"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "order_id": orderId,
      "amount": amount,
      "currency": currency,
      "transaction_id": transactionId,
      "key_id": keyId,
    };
  }
}
