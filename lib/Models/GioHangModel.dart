class GioHangModel {
  final String monAnId;
  final String tenMonAn;
  final double basePrice;
  int quantity;
  final String note;
  double finalPrice;
  final Map<String, String>? selectedOptions;
  final String imgUrl;

  GioHangModel({
    required this.monAnId,
    required this.tenMonAn,
    required this.basePrice,
    this.quantity = 1,
    required this.note,
    required this.finalPrice,
    this.selectedOptions,
    required this.imgUrl,
  });


  Map<String, dynamic> toJson() {
    return {
      'monAnId': monAnId,
      'tenMonAn': tenMonAn,
      'basePrice': basePrice,
      'quantity': quantity,
      'note': note,
      'finalPrice': finalPrice,
      'selectedOptions': selectedOptions,
      'imgUrl': imgUrl,
    };
  }


  factory GioHangModel.fromJson(Map<String, dynamic> json) {
    return GioHangModel(
      monAnId: json['monAnId'],
      tenMonAn: json['tenMonAn'],
      basePrice: (json['basePrice'] as num).toDouble(),
      quantity: json['quantity'] ?? 1,
      note: json['note'],
      finalPrice: (json['finalPrice'] as num).toDouble(),
      selectedOptions: json['selectedOptions'] != null
          ? Map<String, String>.from(json['selectedOptions'])
          : null,
      imgUrl: json['imgUrl'],
    );
  }

  void operator [](int other) {}
}
