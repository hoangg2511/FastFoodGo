import 'package:fastfoodgo/Models/DiaChiModel.dart';
import 'package:fastfoodgo/Repository/DiaChiRepository.dart';
import 'package:flutter/cupertino.dart';
import '../Service/MapService.dart';
import '../Models/CuaHangModel.dart';
import '../Repository/CuaHangRepository.dart';

class CuaHangViewModel extends ChangeNotifier {
  final CuaHangRepository _repoCuaHang = CuaHangRepository();
  final DiaChiRepository _repoDiaChi = DiaChiRepository();
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String? selectedCuaHangId;
  List<CuaHangModel> _cuaHang = [];
   List<DiaChiModel> _diaChiKH = [];
   List<DiaChiModel> _diaChiCH = [];
  List<CuaHangModel> get cuaHang => _cuaHang;
  Future<List<CuaHangModel>> fetchCuaHang() async {
    try {
      _isLoading = true;
      notifyListeners();

      _diaChiKH = await _repoDiaChi.getDiaChiKhachHang();
      _diaChiCH = await _repoDiaChi.getDiaChiCuaHang();
      _cuaHang = await _repoCuaHang.getTatCaCuaHang();

      if (_diaChiKH.isEmpty) {
        print("Không có địa chỉ khách hàng");
        _isLoading = false;
        notifyListeners();
        return _cuaHang;
      }

      final khachHangAddress = _diaChiKH.first;
      final origin =
          "${khachHangAddress.soNha ?? ''} ${khachHangAddress.Duong ?? ''}, ${khachHangAddress.phuongXa ?? ''}, ${khachHangAddress.quanHuyen ?? ''}, ${khachHangAddress.tinhTp ?? ''}, Việt Nam";

      final mapService = MapService();

      // Tạo danh sách Future song song cho tất cả cửa hàng
      final futures = _cuaHang.map((ch) async {
        final diaChiCH = _diaChiCH.firstWhere(
              (dc) => dc.maCH == ch.id,
          orElse: () => DiaChiModel(
            id: '',
            phuongXa: '',
            quanHuyen: '',
            soNha: '',
            Duong: '',
            status: 0,
            maCH: '',
            tinhTp: '',
            DCCuThe: '',
          ),
        );

        final destination =
            "${diaChiCH.soNha ?? ''} ${diaChiCH.Duong ?? ''}, ${diaChiCH.phuongXa ?? ''}, ${diaChiCH.quanHuyen ?? ''}, ${diaChiCH.tinhTp ?? ''}, Việt Nam";

        try {
          final result = await mapService.getKhoangCach(
            origin: origin,
            destination: destination,
          );

          ch.khoangCach = result["distance"] ?? "0 km";
          ch.ThoiGianThucHienMon = result["duration"] ?? "0 phút";
        } catch (e) {
          print("Không lấy được khoảng cách cho ${ch.TenCuaHang}: $e");
          ch.khoangCach = "";
          ch.ThoiGianThucHienMon = "";
        }

        notifyListeners();
      }).toList();


      await Future.wait(futures);


      _cuaHang.sort((a, b) {
        double parseDistance(String s) {
          try {
            return double.parse(s.replaceAll(RegExp(r'[^0-9.]'), ''));
          } catch (_) {
            return double.infinity;
          }
        }
        return parseDistance(a.khoangCach).compareTo(parseDistance(b.khoangCach));
      });

      _isLoading = false;
      notifyListeners();

      return _cuaHang;
    } catch (e) {
      print("Lỗi khi tải danh sách cửa hàng: $e");
      _isLoading = false;
      notifyListeners();
      return [];
    }
  }


}
