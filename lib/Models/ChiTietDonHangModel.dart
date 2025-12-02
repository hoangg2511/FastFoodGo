
import 'OptionMonAnModel.dart';

class ChiTietDonHangModel {
  final String? maCTDH;
  final String maDH;
  final String maMonAn;
  final String maDiaChi;
  int soLuong;
  int gia;
  final String? note;
  final List<OptionMonAnModel> optionMonAn;

  ChiTietDonHangModel({
    this.maCTDH,
    required this.maDH,
    required this.maMonAn,
    required this.maDiaChi,
    required this.soLuong,
    required this.gia,
    this.note,
    this.optionMonAn = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'maCTDH': maCTDH,
      'maDH': maDH,
      'maMonAn': maMonAn,
      'maDiaChi':maDiaChi,
      'soLuong': soLuong,
      'gia': gia,
      'note': note,
      'optionIds': optionMonAn.map((opt) => opt.id).toList(),
    };
  }

  factory ChiTietDonHangModel.fromJson(Map<String, dynamic> json) {
    return ChiTietDonHangModel(
      maCTDH: json['maCTDH'],
      maDH: json['maDH'],
      maMonAn: json['maMonAn'],
      maDiaChi:json['maDiaChi'],
      soLuong: json['soLuong'],
      gia: json['gia'],
      note: json['note'],

      optionMonAn: json['optionMonAn'] != null
          ? (json['optionMonAn'] as List)
          .map((e) => OptionMonAnModel.fromJson(e))
          .toList()
          : [],
    );
  }
}
