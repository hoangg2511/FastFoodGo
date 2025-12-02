
class ChiTietDiaChiModel {
  String MaKH;
  String MaDiaChi;
  int TrangThai;

  ChiTietDiaChiModel({
   required this.MaKH,
    required this.MaDiaChi,
    required this.TrangThai
  });
  factory ChiTietDiaChiModel.fromJson(Map<String, dynamic> json) {
    return   ChiTietDiaChiModel(
      MaKH: json['maKH'] ?? '',
      MaDiaChi: json['maDiaChi'] ?? '',
      TrangThai:json['trangThai'] ?? 0,
    );
  }

  // Chuyển từ model sang JSON
  Map<String, dynamic> toJson() {
    return {
      'maKH': MaKH,
      'maDiaChi': MaDiaChi,
      'trangThai': TrangThai,
    };
  }
}


