class RazorpayPaymentResponse {
  final String orderId;
  final String paymentId;
  final String signature;

  RazorpayPaymentResponse({
    required this.orderId,
    required this.paymentId,
    required this.signature,
  });
}
