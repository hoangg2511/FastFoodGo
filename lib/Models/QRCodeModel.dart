class QRCodeModel {
  final String paymentUrl;

  QRCodeModel({required this.paymentUrl});

  factory QRCodeModel.fromJson(Map<String, dynamic> json) {
    return QRCodeModel(
      paymentUrl: json['paymentUrl'] as String,
    );
  }
}