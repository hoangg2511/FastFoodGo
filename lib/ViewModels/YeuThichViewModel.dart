import 'package:fastfoodgo/Repository/CuaHangRepository.dart';
import 'package:flutter/material.dart';
import '../Models/CuaHangModel.dart';
import '../Models/DiaChiModel.dart';
import '../Repository/DiaChiRepository.dart';
import '../Repository/NguoiDungRepository.dart';

// ViewModel quản lý cửa hàng yêu thích
class YeuThichViewModel extends ChangeNotifier {
  final NguoiDungRepository _repoNguoiDung = NguoiDungRepository();
  final DiaChiRepository _repoDiaChi = DiaChiRepository();
  final CuaHangRepository _cuaHangRepo = CuaHangRepository();

  // 1. Trạng thái Loading và Danh sách hiển thị
  bool _isLoading = false;
  List<Map<String, dynamic>> _danhSachCuaHangCombined = []; // Danh sách kết hợp để hiển thị

  // 2. Getter công khai
  bool get isLoading => _isLoading;
  List<Map<String, dynamic>> get danhSachCuaHang => _danhSachCuaHangCombined; // Tên getter đồng bộ với View

  // 3. Khởi tạo và tải dữ liệu ban đầu
  YeuThichViewModel() {
    loadDanhSach();
  }

  /// Tải danh sách cửa hàng yêu thích kết hợp địa chỉ (được gọi ở View)
  Future<void> loadDanhSach() async {
    _isLoading = true;
    notifyListeners(); // Báo hiệu View hiển thị CircularProgressIndicator

    try {
      // 3.1. Lấy danh sách cửa hàng yêu thích từ repo
      final List<CuaHangModel> cuaHangs =
      await _repoNguoiDung.getCuaHangYeuThich();
      final List<DiaChiModel> diaChis = await _repoDiaChi.getDiaChiCuaHang();

      // 3.2. Map địa chỉ theo MaCH
      final Map<String, List<DiaChiModel>> diaChiMap = {};
      for (var dc in diaChis) {
        diaChiMap.putIfAbsent(dc.maCH.toString(), () => []);
        diaChiMap[dc.maCH]!.add(dc);
      }

      // 3.3. Tạo danh sách kết hợp để hiển thị (combinedList)
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

  /// 4. Thêm yêu thích (và tải lại danh sách)
  Future<void> themYeuThich(CuaHangModel cuaHang) async {
    final success = await _cuaHangRepo.themYeuThich(cuaHang.id);

    if (success) {
      // ✅ Tải lại toàn bộ danh sách để cập nhật dữ liệu và giao diện
      await loadDanhSach();
    } else {
      debugPrint("⚠️ Thêm cửa hàng yêu thích thất bại: ${cuaHang.id}");
    }
  }

  /// 5. Xóa yêu thích (và tải lại danh sách)
  Future<void> xoaYeuThich(CuaHangModel cuaHang) async {
    final success = await _repoNguoiDung.xoaCuaHangYeuThich(cuaHang.id);

    if (success) {
      // ✅ Tải lại toàn bộ danh sách để cập nhật dữ liệu và giao diện
      await loadDanhSach();
      debugPrint("✅ Đã xóa cửa hàng yêu thích: ${cuaHang.TenCuaHang}");
    } else {
      debugPrint("⚠️ Xóa cửa hàng yêu thích thất bại: ${cuaHang.id}");
    }
  }

  /// 6. Xóa tất cả (và tải lại danh sách)
  Future<void> xoaTatCa() async {
    // ⚠️ CHÚ Ý: Bạn chưa có logic xóa tất cả trong Repository,
    // nên phần này chỉ clear danh sách nội bộ (không khuyến khích)
    // Để hoàn chỉnh, bạn cần gọi API/DB xóa tất cả ở đây.

    // Giả định logic gọi API/DB xóa tất cả thành công

    // Sau khi xóa thành công, tải lại danh sách:
    await loadDanhSach();
  }

  /// 7. Kiểm tra yêu thích
  bool kiemTraYeuThich(String cuaHangId) {
    // Kiểm tra trong danh sách combinedList (sử dụng CuaHangModel từ map)
    return _danhSachCuaHangCombined.any(
            (item) => (item['cuaHang'] as CuaHangModel).id == cuaHangId);
  }
}