import 'dart:async';
import 'package:flutter/foundation.dart' show ChangeNotifier;
import '../Models/CuaHangModel.dart';
import '../Models/MonAnModel.dart';
import '../Repository/CuaHangRepository.dart';
import '../Repository/LoaiMonAnRepository.dart';
import '../Repository/MonAnRepository.dart';

class ChitietCuaHangViewModel extends ChangeNotifier {
  final LoaiMonAnRepository _repo = LoaiMonAnRepository();
  final MonAnRepository _monAnRepo = MonAnRepository();
  final CuaHangRepository _cuaHangRepo = CuaHangRepository();

  List<MonAnModel> _allMonAn = [];
  List<MonAnModel> _filteredMonAn = [];
  List<MonAnModel> get filteredMonAn => _filteredMonAn;
  List<String> _categories = [];
  List<String> get categories => _categories;

  String _selectedCategory = "Tất cả";
  String get selectedCategory => _selectedCategory;
  set selectedCategory(String value) {
    _selectedCategory = value;
    notifyListeners();
  }

  String? CuaHangId;
  CuaHangModel? CuaHang;
  String? Id;
  bool _isOpen = false;
  bool get isOpen => _isOpen;
  Timer? _timer;

  Future<Map<String, String>> _getLoaiMonAnMap() async {
    final list = await _repo.getLoaiMonAn();
    final loaiMap = {for (var loai in list) loai.id: loai.Ten};
    return loaiMap;
  }

  Future<void> fetchTenLoaiMonAn() async {
    try {
      final list = await _repo.getLoaiMonAn();
      _categories = ['Tất cả', ...list.map((e) => e.Ten)];
      notifyListeners();
    } catch (e) {
      print("Lỗi khi lấy tên loại món ăn: $e");
      _categories = ['Tất cả'];
      notifyListeners();
    }
  }

  Future<CuaHangModel?> getChiTietCuaHang(String id) async {
    try {
      if (CuaHang != null && Id == id) return CuaHang;

      final cuaHang = await _cuaHangRepo.getCuaHang(id);
      if (cuaHang != null) {
        CuaHang = cuaHang;
        Id = id;
        checkOpenStatus();
        startAutoCheck();
      }
      return CuaHang;
    } catch (e) {
      print("Lỗi khi lấy chi tiết cửa hàng: $e");
      return null;
    }
  }

  Future<List<MonAnModel>> getMonAnTheoCuaHang(
    String cuaHangId, {
    bool forceRefresh = false,
  }) async {
    try {
      // 1. Logic cache (Giữ nguyên)
      if (_allMonAn.isNotEmpty && CuaHangId == cuaHangId && !forceRefresh) {
        print("Trả về món ăn từ Cache cho cửa hàng ID: $cuaHangId");
        return _allMonAn;
      }

      print("Bắt đầu tải món ăn mới cho cửa hàng ID: $cuaHangId");

      _allMonAn = await _monAnRepo.getMonAnTheoCuaHang(cuaHangId);


      if (_allMonAn.isNotEmpty) {
        print("Đã map thành công ${_allMonAn.length} món ăn.");


        for (var monAn in _allMonAn) {
          print(
            "  - Mã: ${monAn.id}, Tên: ${monAn.TenMonAn}, Giá: ${monAn.Gia}, Đánh giá: ${monAn.DanhGia}",
          );
        }
      } else {
        print("Danh sách món ăn cho cửa hàng $cuaHangId rỗng.");
      }

      _filteredMonAn = _allMonAn;
      CuaHangId = cuaHangId;
      notifyListeners();

      return _allMonAn;
    } catch (e) {
      print("Lỗi khi lấy món ăn: $e");

      return [];
    }
  }

  void filterByCategory(String category) {
    if (category == "Tất cả") {
      _filteredMonAn = _allMonAn;
    } else {
      _filteredMonAn = _allMonAn
          .where((item) => item.LoaiMonAnList == category)
          .toList();
    }
    notifyListeners();
  }

  void checkOpenStatus() {
    if (CuaHang == null) return;

    final gioMo = CuaHang!.MoCua; // ví dụ "08:00"
    final gioDong = CuaHang!.DongCua; // ví dụ "22:00"

    final now = DateTime.now();
    final openTime = _parseTime(gioMo);
    final closeTime = _parseTime(gioDong);

    _isOpen = now.isAfter(openTime) && now.isBefore(closeTime);
    notifyListeners();
  }

  DateTime _parseTime(String time) {
    final now = DateTime.now();
    final parts = time.split(':');
    return DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(parts[0]),
      int.parse(parts[1]),
    );
  }

  void startAutoCheck() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      checkOpenStatus();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
