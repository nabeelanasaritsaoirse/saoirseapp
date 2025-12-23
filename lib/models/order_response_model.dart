class OrderResponseModel {
  final OrderModel order;
  final FirstPaymentModel payment;
  final RazorpayOrderModel razorpayOrder;

  OrderResponseModel({
    required this.order,
    required this.payment,
    required this.razorpayOrder,
  });

  factory OrderResponseModel.fromJson(Map<String, dynamic> json) {
    return OrderResponseModel(
      order: OrderModel.fromJson(json['order'] ?? {}),
      payment: FirstPaymentModel.fromJson(json['firstPayment'] ?? {}),
      razorpayOrder: RazorpayOrderModel.fromJson(json['razorpayOrder'] ?? {}),
    );
  }
}

// -----------------------------------------------------------------------------
// ORDER MODEL
// -----------------------------------------------------------------------------
class OrderModel {
  final String id;
  final String orderId;
  final String status;
  final int quantity;
  final int dailyPaymentAmount;
  final int totalDays;
  final int remainingAmount;
  final bool canPayToday;
  final DeliveryAddressModel deliveryAddress;

  OrderModel({
    required this.id,
    required this.orderId,
    required this.status,
    required this.quantity,
    required this.dailyPaymentAmount,
    required this.totalDays,
    required this.remainingAmount,
    required this.canPayToday,
    required this.deliveryAddress,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['_id'] ?? '',
      orderId: json['orderId'] ?? '',
      status: json['status'] ?? '',
      quantity: json['quantity'] ?? 0,
      dailyPaymentAmount: json['dailyPaymentAmount'] ?? 0,
      totalDays: json['totalDays'] ?? 0,
      remainingAmount: json['remainingAmount'] ?? 0,
      canPayToday: json['canPayToday'] ?? false,
      deliveryAddress:
          DeliveryAddressModel.fromJson(json['deliveryAddress'] ?? {}),
    );
  }
}

// -----------------------------------------------------------------------------
// FIRST PAYMENT MODEL
// -----------------------------------------------------------------------------
class FirstPaymentModel {
  final String paymentId;
  final int amount;
  final String paymentMethod;
  final String razorpayOrderId;

  FirstPaymentModel({
    required this.paymentId,
    required this.amount,
    required this.paymentMethod,
    required this.razorpayOrderId,
  });

  factory FirstPaymentModel.fromJson(Map<String, dynamic> json) {
    return FirstPaymentModel(
      paymentId: json['paymentId'] ?? '',
      amount: json['amount'] ?? 0,
      paymentMethod: json['paymentMethod'] ?? '',
      razorpayOrderId: json['razorpayOrderId'] ?? '',
    );
  }
}

// -----------------------------------------------------------------------------
// RAZORPAY ORDER MODEL
// -----------------------------------------------------------------------------
class RazorpayOrderModel {
  final String id;
  final int amount;
  final String currency;
  final String keyId;

  RazorpayOrderModel({
    required this.id,
    required this.amount,
    required this.currency,
    required this.keyId,
  });

  factory RazorpayOrderModel.fromJson(Map<String, dynamic> json) {
    return RazorpayOrderModel(
      id: json['id'] ?? '',
      amount: json['amount'] ?? 0,
      currency: json['currency'] ?? 'INR',
      keyId: json['keyId'] ?? '',
    );
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
      name: json['name'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      addressLine1: json['addressLine1'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      pincode: json['pincode'] ?? '',
    );
  }
}







