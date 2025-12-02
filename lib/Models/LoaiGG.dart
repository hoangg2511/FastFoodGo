class LoaiGGModel {
  final String MaLoaiGG;
  final String TenLoai;

  LoaiGGModel({this.MaLoaiGG = "", this.TenLoai = ""});

  factory LoaiGGModel.fromJson(Map<String, dynamic> json) {
    return LoaiGGModel(
      MaLoaiGG: json["maLoaiGG"] ?? "",
      TenLoai: json["tenLoai"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {"maLoaiGG": MaLoaiGG,
      "tenLoai": TenLoai,
    };
  }
}
