import 'package:fastfoodgo/Repository/CuaHangRepository.dart';
import 'package:flutter/material.dart';
import '../Models/CuaHangModel.dart';
import '../Models/DiaChiModel.dart';
import '../Repository/DiaChiRepository.dart';
import '../Repository/NguoiDungRepository.dart';


class YeuThichViewModel extends ChangeNotifier {
  final NguoiDungRepository _repoNguoiDung = NguoiDungRepository();
  final DiaChiRepository _repoDiaChi = DiaChiRepository();
  final CuaHangRepository _cuaHangRepo = CuaHangRepository();


  bool _isLoading = false;
  List<Map<String, dynamic>> _danhSachCuaHangCombined = [];


  bool get isLoading => _isLoading;
  List<Map<String, dynamic>> get danhSachCuaHang => _danhSachCuaHangCombined;


  YeuThichViewModel() {
    loadDanhSach();
  }


  Future<void> loadDanhSach() async {
    _isLoading = true;
    notifyListeners();

    try {

      final List<CuaHangModel> cuaHangs =
      await _repoNguoiDung.getCuaHangYeuThich();
      final List<DiaChiModel> diaChis = await _repoDiaChi.getDiaChiCuaHang();


      final Map<String, List<DiaChiModel>> diaChiMap = {};
      for (var dc in diaChis) {
        diaChiMap.putIfAbsent(dc.maCH.toString(), () => []);
        diaChiMap[dc.maCH]!.add(dc);
      }


      _danhSachCuaHangCombined = cuaHangs.map((ch) {
        final dcList = diaChiMap[ch.id] ?? [];
        return {
          'cuaHang': ch,
          'diaChi': dcList,
        };
      }).toList();

    } catch (e) {
      // Xử lý lỗi nếu cần
      _danhSachCuaHangCombined = [];
    }

    _isLoading = false;
    notifyListeners(); // Báo hiệu View hiển thị danh sách mới
  }


  Future<void> themYeuThich(CuaHangModel cuaHang) async {
    final success = await _cuaHangRepo.themYeuThich(cuaHang.id);

    if (success) {

      await loadDanhSach();
    } else {
      debugPrint("⚠️ Thêm cửa hàng yêu thích thất bại: ${cuaHang.id}");
    }
  }


  Future<void> xoaYeuThich(CuaHangModel cuaHang) async {
    final success = await _repoNguoiDung.xoaCuaHangYeuThich(cuaHang.id);

    if (success) {

      await loadDanhSach();
      debugPrint("Đã xóa cửa hàng yêu thích: ${cuaHang.TenCuaHang}");
    } else {
      debugPrint("Xóa cửa hàng yêu thích thất bại: ${cuaHang.id}");
    }
  }


  Future<void> xoaTatCa() async {

    await loadDanhSach();
  }


  bool kiemTraYeuThich(String cuaHangId) {
    return _danhSachCuaHangCombined.any(
            (item) => (item['cuaHang'] as CuaHangModel).id == cuaHangId);
  }
}