
import 'DiaChiModel.dart';
import 'MonAnModel.dart';

class CuaHangModel {
  final String id;
  final String TenCuaHang;
  final double DanhGia;
  final String? Sdt;
  String khoangCach;
  final List<DiaChiModel> DiaChi;
   String ThoiGianThucHienMon;
  final String TrangThai;
  final String MoCua;
  final String DongCua;
  final String? AnhBia;
  final String? AnhDaiDien;
  final List<MonAnModel> MonAn;


  CuaHangModel({
    this.id = "",
    this.TenCuaHang = "",
    this.DanhGia = 0.0,
    this.Sdt,
    this.khoangCach = "",
    List<DiaChiModel>? diaChi,
    this.ThoiGianThucHienMon = "",
    this.TrangThai = "",
    this.MoCua = "",
    this.DongCua = "",
    this.AnhBia,
    this.AnhDaiDien,
    List<MonAnModel>? monAn,
  })  : DiaChi = diaChi ?? [],
        MonAn = monAn ?? [];

  Map<String, dynamic> toJson() {
    return {
      "maCH": id,
      "tenCH": TenCuaHang,
      "danhGia": DanhGia,
      "sdt": Sdt,
      "diaChis": DiaChi.map((e) => e.toJson()).toList(),
      "thoiGianThucHien": ThoiGianThucHienMon,
      "trangThai": TrangThai,
      "moCua": MoCua,
      "dongCua": DongCua,
      "anhBia": AnhBia,
      "anhDaiDien": AnhDaiDien,
      "MonAn": MonAn.map((e) => e.toJson()).toList(),
    };
  }

  factory CuaHangModel.fromJson(Map<String, dynamic> json) {
    var diaChisJson = json["diaChis"] as List<dynamic>? ?? [];
    List<DiaChiModel> diaChisList =
    diaChisJson.map((e) => DiaChiModel.fromJson(e)).toList();
    var MonAnJson = json["maMonAns"] as List<dynamic>? ?? [];
    List<MonAnModel> MonAnList =
    MonAnJson.map((e) => MonAnModel.fromJson(e)).toList();

    return CuaHangModel(
      id: json["maCH"] ?? "",
      TenCuaHang: json["tenCH"] ?? "",
      DanhGia: (json["danhGia"] is int)
          ? (json["danhGia"] as int).toDouble()
          : (json["danhGia"] is double ? json["danhGia"] as double : 0.0),
        Sdt: json["sdt"]?.toString(),
      diaChi: diaChisList,
      ThoiGianThucHienMon: json["thoiGianThucHien"] ?? "",
      TrangThai: json["trangThai"] ?? "",
      MoCua: json["moCua"] ?? "",
      DongCua: json["dongCua"] ?? "",
      AnhBia: json["anhBia"],
      AnhDaiDien: json["anhDaiDien"]?? "",
      khoangCach: json["khoangCach"] ?? "",
      monAn: MonAnList,
    );
  }
}
