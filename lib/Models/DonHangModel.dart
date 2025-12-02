class DonHangModel {
  final String? maDH;
  final String maKH;
  final DateTime? ngayDat;
  final String trangThaiThanhToan;
  final String? maGG;
  final double tamTinh;
  final String? trangThaiDonHang;

  DonHangModel({
    this.maDH,
    required this.maKH,
    required this.ngayDat,
    required this.trangThaiThanhToan,
    this.maGG,
    required this.tamTinh,
    required this.trangThaiDonHang,
  });

  Map<String, dynamic> toJson() {
    return {
      "maDH": maDH, // có thể null (backend sinh mã)
      "maKH": maKH,
      "ngayDat": ngayDat?.toIso8601String(),
      "trangThaiThanhToan": trangThaiThanhToan,
      "maGG": maGG,
      "tamTinh": tamTinh,
      "trangThaiDonHang":trangThaiDonHang,
    };
  }


  factory DonHangModel.fromJson(Map<String, dynamic> json) {
    return DonHangModel(
      maDH: json["maDH"],
      maKH: json["maKH"],
      ngayDat: DateTime.parse(json["ngayDat"]),
      trangThaiThanhToan: json["trangThaiThanhToan"],
      maGG: json["maGG"],
      tamTinh: (json["tamTinh"] ?? 0).toDouble(),
      trangThaiDonHang: json["trangThaiDonHang"],
    );
  }
}
