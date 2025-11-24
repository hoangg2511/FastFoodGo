class NguoiDung {
  final String id;
  final String hoTen;
  final String email;
  final String matKhau;
  final int? tuoi;
  final String? sdt;
  final String diaChi;

  NguoiDung({
    this.id = "",
    this.hoTen = "",
    this.email = "",
    this.matKhau = "",
    this.tuoi,
    this.sdt,
    this.diaChi = "",
  });


  Map<String, dynamic> toJson() {
    return {
      "maKH": id,
      "tenKH": hoTen,
      "email": email,
      "matKhau":matKhau,
      "sdt": sdt,
      // "tuoi": tuoi,
      "diaChi": diaChi,
    };
  }

  factory NguoiDung.fromJson(Map<String, dynamic> json) {
    return NguoiDung(
      id: json["maKH"] ?? "",
      hoTen: json["tenKH"] ?? "",
      email: json["email"] ?? "",
      matKhau: json["matKhau"] ?? "",
      tuoi: json["tuoi"] is int ? json["tuoi"] as int : null,
      sdt: json["sdt"] ?? "",
      diaChi: json["diaChi"] ?? "",
    );
  }
}
