import 'package:fastfoodgo/Models/OptionMonAnModel.dart';

class ChiTietDonHangModel {
  final String? maCTDH;
  final String maDH;
  final String maMonAn;
  int soLuong;
  int gia;
  final String? note;
  /// Danh sách các option món ăn được chọn
  final List<OptionMonAnModel> optionMonAn;

  ChiTietDonHangModel({
    this.maCTDH,
    required this.maDH,
    required this.maMonAn,
    required this.soLuong,
    required this.gia,
    this.note,
    this.optionMonAn = const [],
  });

  /// Gửi dữ liệu lên API
  Map<String, dynamic> toJson() {
    return {
      'maCTDH': maCTDH,
      'maDH': maDH,
      'maMonAn': maMonAn,
      'soLuong': soLuong,
      'gia': gia,
      'note': note,
      // 🟢 Chuyển danh sách Option sang danh sách ID
      'optionIds': optionMonAn.map((opt) => opt.id).toList(),
    };
  }

  /// Nhận dữ liệu từ API
  factory ChiTietDonHangModel.fromJson(Map<String, dynamic> json) {
    return ChiTietDonHangModel(
      maCTDH: json['maCTDH'],
      maDH: json['maDH'],
      maMonAn: json['maMonAn'],
      soLuong: json['soLuong'],
      gia: json['gia'],
      note: json['note'],
      // 🟢 Parse danh sách option (nếu có)
      optionMonAn: json['optionMonAn'] != null
          ? (json['optionMonAn'] as List)
          .map((e) => OptionMonAnModel.fromJson(e))
          .toList()
          : [],
    );
  }
}
