class GiamGiaModel{
  final String MaGG;
  final String ChiTietGG;
  final String MotaGG;
  final String ThoiHan;
  final double GiaTri;
  final String DieuKien;
  final String Code;
  final String MaLoaiGG;

  GiamGiaModel({
    this.MaGG = "",
    this.ChiTietGG = "",
    this.MotaGG = "",
    this.ThoiHan = "",
    this.GiaTri = 0.0,
    this.DieuKien = "",
    this.Code="",
    this.MaLoaiGG=""
  });
  static double parseGiaTri(dynamic value) {
    if (value == null) return 0.0;

    if (value is num) {
      // Nếu đã là số, convert sang double
      return value.toDouble();
    } else if (value is String) {
      if (value.endsWith('%')) {
        // Nếu là phần trăm, ví dụ "15%" => 0.15
        final percent = double.tryParse(value.replaceAll('%', '').trim());
        return percent != null ? percent / 100 : 0.0;
      } else {
        // Nếu là số dạng chuỗi, ví dụ "15000"
        return double.tryParse(value.trim()) ?? 0.0;
      }
    }

    return 0.0; // fallback
  }
  factory GiamGiaModel.fromJson(Map<String, dynamic> json) {
    return GiamGiaModel(
      MaGG: json["maGG"] ?? "",
      ChiTietGG: json["chiTietGG"] ?? "",
      MotaGG: json["moTaGG"] ?? "",
      ThoiHan: json["thoiHan"] ?? "",
      GiaTri: parseGiaTri(json["giaTri"]),
      DieuKien: json["dieuKien"]?? "",
      Code : json["code"] ?? "",
      MaLoaiGG: json["maLoaiGG"]?? "",
    );
  }


  Map<String, dynamic> toJson() {
    return {
      "maGG": MaGG,
      "chiTietGG": ChiTietGG,
      "giaTri": GiaTri.toDouble(),
      "thoiHan":ThoiHan,
      "motaGG": MotaGG,
      "dieuKien": DieuKien,
      "code":Code,
      "maLoaiGG":MaLoaiGG,

    };
  }
}

class ChiTietGiamGiaModel{
  final String MaKH;
  final String MaGG;
  final String NgayBD;
  final String NgayKT;

  ChiTietGiamGiaModel({
    this.MaGG = "",
    this.MaKH = "",
    this.NgayBD = "",
    this.NgayKT = "",

  });

  factory ChiTietGiamGiaModel.fromJson(Map<String, dynamic> json) {
    return ChiTietGiamGiaModel(
      MaGG: json["maGG"] ?? "",
      MaKH: json["maKH"] ?? "",
      NgayBD: json["ngayBD"] ?? "",
      NgayKT: json["ngayKT"]?? "",
    );
  }


  Map<String, dynamic> toJson() {
    return {
      "maGG": MaGG,
      "maKH": MaKH,
      "ngayBD": NgayBD,
      "ngayKT": NgayKT,

    };
  }
}