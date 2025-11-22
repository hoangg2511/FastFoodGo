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

  /// Tính giá cuối dựa trên basePrice, quantity và selectedOptions nếu muốn tự tính
  /// Nếu đã có finalPrice từ trước, có thể bỏ qua
  // double get computedFinalPrice {
  //   double optionsPrice = 0.0;
  //   if (selectedOptions != null) {
  //     // Giả sử giá option lưu trong value, bạn có thể tùy chỉnh
  //     optionsPrice = selectedOptions!.values.fold<double>(
  //         0.0, (sum, v) => sum + double.tryParse(v) ?? 0.0);
  //   }
  //   return (basePrice + optionsPrice) * quantity;
  // }

  /// Chuyển model sang JSON
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

  /// Tạo model từ JSON
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
