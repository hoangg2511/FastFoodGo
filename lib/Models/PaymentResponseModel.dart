class PaymentResponseModel {
  final bool success;
  final String message;
  final String? vnpTxnRef;
  final String? vnpResponseCode;
  final String? vnpTransactionNo;
  final String? vnpAmount;

  PaymentResponseModel({
    required this.success,
    required this.message,
    this.vnpTxnRef,
    this.vnpResponseCode,
    this.vnpTransactionNo,
    this.vnpAmount,
  });

  factory PaymentResponseModel.fromJson(Map<String, dynamic> json) {
    return PaymentResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      vnpTxnRef: json['vnp_TxnRef'],
      vnpResponseCode: json['vnp_ResponseCode'],
      vnpTransactionNo: json['vnp_TransactionNo'],
      vnpAmount: json['vnp_Amount'],
    );
  }
}
