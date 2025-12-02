
class DiaChiModel {
  String id;
  String phuongXa;
  String quanHuyen;
  String soNha;
  String Duong;
  String tinhTp;
  int status;
  String? maCH;
  String? DCCuThe;

  DiaChiModel({
    required this.id,
    required this.phuongXa,
    required this.quanHuyen,
    required this.soNha,
    required this.Duong,
    required this.status,
    required this.maCH,
    required this.tinhTp,
    required this.DCCuThe,
  });
  factory DiaChiModel.fromJson(Map<String, dynamic> json) {
    return DiaChiModel(
      id: json['maDiaChi'],
      phuongXa: json['phuongXa'] ?? '',
      quanHuyen: json['quanHuyen'] ?? '',
      soNha: json['soNha'] ?? '',
      Duong: json['duong'] ?? '',
      tinhTp: json['tinhTp'] ?? '',
      status: json['trangThai'] ?? 0,
      maCH: json['maCH'] ?? '',
      DCCuThe: json['dcCuThe'] ?? '',
    );
  }

  // Chuyển từ model sang JSON
  Map<String, dynamic> toJson() {
    return {
      'maDiaChi': id,
      'phuongXa': phuongXa,
      'quanHuyen': quanHuyen,
      'soNha': soNha,
      'duong':Duong,
      'status': status,
      'tinhTp':tinhTp,
      'maCH': maCH,
      'dcCuThe':DCCuThe,
    };
  }

  // // Tạo từ DocumentSnapshot của Firestore
  // factory DiaChiModel.fromSnapshot(DocumentSnapshot doc) {
  //   final data = doc.data() as Map<String, dynamic>;
  //   return DiaChiModel.fromJson(data, id: doc.id);
  // }
}


