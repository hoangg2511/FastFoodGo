

import 'LoaiMonAnModel.dart';

class MonAnModel {
  final String id;
  final String TenMonAn;
  final String MoTa;
  final double Gia;
  final double DanhGia;
  final bool BanChay;
  final String? HinhAnh;
  final String CuaHang;
  final String OptionMonAn;
  final List<LoaiMonAnModel> LoaiMonAnList; // đổi tên List<LoaiMonAnModel>

  MonAnModel({
    this.id = "",
    this.TenMonAn = "",
    this.MoTa = "",
    this.Gia = 0.0,
    this.DanhGia = 0.0,
    this.BanChay = false,
    this.HinhAnh,
    this.CuaHang = "",
    this.OptionMonAn = "",
    List<LoaiMonAnModel>? loaiMonAnList,
  }) : LoaiMonAnList = loaiMonAnList ?? [];


  factory MonAnModel.fromJson(Map<String, dynamic> json) {
    var LoaiMonAnJson = json["maLoais"] as List<dynamic>? ?? [];
    List<LoaiMonAnModel> LoaiMonAnList =
    LoaiMonAnJson.map((e) => LoaiMonAnModel.fromJson(e)).toList();
    return MonAnModel(
      id: json["maMonAn"] ?? "",
      TenMonAn: json["tenMonAn"] ?? "",
      MoTa: json["moTa"] ?? "",
      Gia: (json["gia"]?? 0).toDouble(),
      DanhGia: (json["danhGia"] ?? 0).toDouble(),
      BanChay: (json["banChay"] is int)
          ? json["banChay"] == 1 // nếu là int thì so sánh
          : (json["banChay"] ?? false), // nếu là bool hoặc null thì dùng mặc định
      HinhAnh: json["hinhAnh"],
      CuaHang: json["CuaHang"] ?? "",
      loaiMonAnList: LoaiMonAnList,
      OptionMonAn:json["OptionMonAn"]??"",


    );
  }


  Map<String, dynamic> toJson() {

    return {
      "id": id,
      "TenMonAn": TenMonAn,
      "MoTa": MoTa,
      "Gia": Gia,
      "DanhGia": DanhGia,
      "BanChay": BanChay,
      "HinhAnh": HinhAnh,
      "CuaHang": CuaHang,
      "OptionMonAn":OptionMonAn,
      "maLoais": LoaiMonAnList.map((e) => e.toJson()).toList(),


    };
  }
}
