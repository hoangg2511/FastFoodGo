import 'package:fastfoodgo/Repository/CuaHangRepository.dart';
import 'package:flutter/material.dart';
import '../Service/MapService.dart';
import '../Models/CuaHangModel.dart';
import '../Models/DiaChiModel.dart';
import '../Repository/DiaChiRepository.dart';

class SearchViewModel extends ChangeNotifier {

  CuaHangRepository _repoCuaHang = CuaHangRepository();
  List<CuaHangModel> _filteredItems = [];
  List<CuaHangModel> get filteredItems => _filteredItems;
  final DiaChiRepository _repoDiaChi = DiaChiRepository();
  List<CuaHangModel> _cuaHang = [];
  List<DiaChiModel> _diaChiKH = [];
  List<DiaChiModel> _diaChiCH = [];
  String _selectedFilter = "Tất cả";
  String get selectedFilter => _selectedFilter;
  bool isLoading = false;

  SearchViewModel() {
    _filteredItems = List.from(_cuaHang);
  }

  void search(String query) {
    final lowerQuery = query.toLowerCase().trim();

    if (lowerQuery.isEmpty) {
      _filteredItems = _cuaHang;
    } else {
      _filteredItems = _cuaHang.where((ch) {
        final tenCuaHang = ch.TenCuaHang.toLowerCase();

        // Kiểm tra nếu tên cửa hàng khớp
        if (tenCuaHang.contains(lowerQuery)) return true;

        // Kiểm tra món ăn trong cửa hàng
        final monAnMatch = ch.MonAn.any((mon) {
          final tenMonAn = mon.TenMonAn.toLowerCase();
          final loaiMonAnList = mon.LoaiMonAnList.map((e) => e.Ten.toLowerCase()).toList();

          // Nếu tên món ăn hoặc loại món ăn trùng
          return tenMonAn.contains(lowerQuery) ||
              loaiMonAnList.any((loai) => loai.contains(lowerQuery));
        });

        return monAnMatch;
      }).toList();
    }

    notifyListeners();
  }

  void applyFilter(String filter) {
    _selectedFilter = filter;
    if (filter == "Tất cả") {
      _filteredItems = List.from(_cuaHang);
    } else {
      _filteredItems =
          _cuaHang.where((item) => item.TenCuaHang.contains(filter)).toList();
    }
    notifyListeners();
  }



  Future<List<CuaHangModel>> fetchCuaHang() async {
    try {
      isLoading = true;
      notifyListeners();
      // 🔹 1. Lấy danh sách cửa hàng + món ăn
      _cuaHang = await _repoCuaHang.getCuaHangVaMonAn();

      // Debug in ra
      for (var ch in _cuaHang) {
        print("Cửa hàng: ${ch.TenCuaHang}, Đánh giá: ${ch.DanhGia}");
        for (var mon in ch.MonAn) {
          print("  Món ăn: ${mon.TenMonAn}, Giá: ${mon.Gia}, Loại: ${mon.LoaiMonAnList.map((e) => e.Ten).join(", ")}");
        }
      }

      // 🔹 2. Lấy địa chỉ khách hàng & cửa hàng
      _diaChiKH = await _repoDiaChi.getDiaChiKhachHang();
      _diaChiCH = await _repoDiaChi.getDiaChiCuaHang();

      final mapService = MapService();

      // 🟡 Nếu không có địa chỉ khách hàng → bỏ qua tính khoảng cách
      if (_diaChiKH.isEmpty) {
        print(" Không có địa chỉ khách hàng");
        notifyListeners();
        return _cuaHang;
      }

      // 🔹 3. Lấy địa chỉ khách hàng làm gốc (origin)
      final khachHangAddress = _diaChiKH.first;
      final origin =
          "${khachHangAddress.soNha} ${khachHangAddress.Duong ?? ''}, ${khachHangAddress.phuongXa ?? ''}, ${khachHangAddress.quanHuyen ?? ''}, ${khachHangAddress.tinhTp ?? ''}, Việt Nam";

      // 🔹 4. Tính khoảng cách cho từng cửa hàng
      for (var ch in _cuaHang) {
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

          final distanceStr = result["distance"] ?? "0 km";
          ch.khoangCach = distanceStr;
        } catch (e) {
          print("Không lấy được khoảng cách cho ${ch.TenCuaHang}: $e");
          ch.khoangCach = "";
        }
      }

      // 🔹 5. Sắp xếp theo khoảng cách (đổi "x km" sang số)
      _cuaHang.sort((a, b) {
        double parseKm(String? s) {
          if (s == null || s.isEmpty) return double.infinity;
          final cleaned = s.replaceAll("km", "").trim();
          return double.tryParse(cleaned) ?? double.infinity;
        }

        return parseKm(a.khoangCach as String?).compareTo(parseKm(b.khoangCach as String?));
      });

      // 🔹 6. In kết quả cuối cùng
      for (var ch in _cuaHang) {
        print("➡️ ${ch.TenCuaHang} - ${ch.khoangCach}");
      }
      _filteredItems = List.from(_cuaHang);
      isLoading = false;
      notifyListeners();
      return _cuaHang;
    } catch (e) {
      print("Lỗi khi tải danh sách cửa hàng: $e");
      return [];
    }
  }

}
