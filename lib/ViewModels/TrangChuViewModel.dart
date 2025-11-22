import 'package:fastfoodgo/Models/DiaChiModel.dart';
import 'package:fastfoodgo/Repository/DiaChiRepository.dart';
import 'package:flutter/cupertino.dart';

import '../Service/MapService.dart';
import '../Models/CuaHangModel.dart';
import '../Repository/CuaHangRepository.dart';

class CuaHangViewModel extends ChangeNotifier {
  final CuaHangRepository _repoCuaHang = CuaHangRepository();
  final DiaChiRepository _repoDiaChi = DiaChiRepository();

  String? selectedCuaHangId;
  List<CuaHangModel> _cuaHang = [];
   List<DiaChiModel> _diaChiKH = [];
   List<DiaChiModel> _diaChiCH = [];
  List<CuaHangModel> get cuaHang => _cuaHang;
  Future<List<CuaHangModel>> fetchCuaHang() async {
    try {
      _diaChiKH = await _repoDiaChi.getDiaChiKhachHang();
      _diaChiCH = await _repoDiaChi.getDiaChiCuaHang();
      _cuaHang = await _repoCuaHang.getTatCaCuaHang();
      //
      // final mapService = MapService();
      // // 🟡 Kiểm tra danh sách địa chỉ khách hàng
      // if (_diaChiKH.isEmpty) {
      //   print("❌ Không có địa chỉ khách hàng");
      //   return _cuaHang;
      // }
      // final khachHangAddress = _diaChiKH.first;
      // final origin =
      //     "${khachHangAddress.soNha ?? ''} ${khachHangAddress.Duong ?? ''}, ${khachHangAddress.phuongXa ?? ''}, ${khachHangAddress.quanHuyen ?? ''}, ${khachHangAddress.tinhTp ?? ''}, Việt Nam";
      // // 🏪 Lặp qua từng cửa hàng
      // for (var ch in _cuaHang) {
      //
      //   final diaChiCH = _diaChiCH.firstWhere(
      //
      //         (dc) => dc.maCH == ch.id,
      //     orElse: () => DiaChiModel(
      //       id: '',
      //       phuongXa: '',
      //       quanHuyen: '',
      //       soNha: '',
      //       Duong: '',
      //       status: 0,
      //       maCH: '',
      //       tinhTp: '',
      //     ),
      //   );
      //   final destination =
      //       "${diaChiCH.soNha ?? ''} ${diaChiCH.Duong ?? ''}, ${diaChiCH.phuongXa ?? ''}, ${diaChiCH.quanHuyen ?? ''}, ${diaChiCH.tinhTp ?? ''}, Việt Nam";
      //
      //   try {
      //     final result = await mapService.getKhoangCach(
      //       origin: origin,
      //       destination: destination,
      //     );
      //
      //     final distanceStr = result["distance"] ?? "0 km";
      //     final durationStr = result["duration"] ?? "0 phút";
      //
      //     // ✅ Convert distance về double
      //     ch.khoangCach = distanceStr;
      //     ch.ThoiGianThucHienMon = durationStr;
      //   } catch (e) {
      //     print("⚠️ Không lấy được khoảng cách cho ${ch.TenCuaHang}: $e");
      //     ch.khoangCach = "";
      //     ch.ThoiGianThucHienMon = "";
      //   }
      // }
      // _cuaHang.sort((a, b) => a.khoangCach.compareTo(b.khoangCach));
      // for (var ch in _cuaHang) {
      //   print("➡️ ${ch.TenCuaHang} - ${ch.khoangCach}");
      // }

      return _cuaHang;
    } catch (e) {
      print("❌ Lỗi khi tải danh sách cửa hàng: $e");
      return [];
    }
  }

}
