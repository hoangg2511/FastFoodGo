import 'dart:convert';
import 'dart:io';

import 'package:fastfoodgo/Service/ApiService.dart';
import 'package:fastfoodgo/Models/LoaiGG.dart';
import 'package:http/io_client.dart';

import '../Models/GiamGiaModel.dart';

class GiamGiaRepository {
  ApiService _apiService = ApiService();
  // static const List<Map<String, dynamic>> mockGiamGiaJson = [
  //   {
  //     "MaGG": "SALE2025",
  //     "ChiTietGG": "Giảm 15% cho tổng hóa đơn",
  //     "MotaGG": "Ưu đãi đặc biệt mùa hè",
  //     "ThoiHan": "2025-06-30",
  //     "GiaTri": "15%",
  //     "DieuKien": "HoaDon > 500000",
  //     "Code": "SALE2025",
  //     "MaLoaiGG": "loai1",
  //   },
  //   {
  //     "MaGG": "FREESHIP",
  //     "ChiTietGG": "Miễn phí vận chuyển cho đơn hàng ",
  //     "MotaGG": "Miễn phí giao hàng",
  //     "ThoiHan": "2025-12-31",
  //     "GiaTri": "15000",
  //     "DieuKien": "HoaDon > 100000",
  //     "Code": "FREESHIP",
  //     "MaLoaiGG": "loai2",
  //   },
  //   {
  //     "MaGG": "GIAMGIANGUOIMOI",
  //     "ChiTietGG": "Giảm giá 50% cho đơn hàng đầu tiên",
  //     "MotaGG": "Miễn phí giao hàng",
  //     "ThoiHan": "2025-12-31",
  //     "GiaTri": "50%",
  //     "DieuKien": "HoaDon > 100000",
  //     "Code": "DONHANGDAUTIEN",
  //     "MaLoaiGG": "loai1",
  //   },
  // ];
  //
  // static const List<Map<String, dynamic>> mockChiTietGiamGiaJson = [
  //   {
  //     "MaKH": "6Sav7PWdgIVMmslvwlAeL6EAt4d2",
  //     "MaGG": "SALE2025",
  //     "NgayBD": "2025-06-01",
  //     "NgayKT": "2025-06-30",
  //   },
  //   {
  //     "MaKH": "6Sav7PWdgIVMmslvwlAeL6EAt4d2",
  //     "MaGG": "FREESHIP",
  //     "NgayBD": "2025-01-01",
  //     "NgayKT": "2025-12-31",
  //   },
  //   {
  //     "MaKH": "6Sav7PWdgIVMmslvwlAeL6EAt4d2",
  //     "MaGG": "FREESHIP",
  //     "NgayBD": "2025-03-15",
  //     "NgayKT": "2025-09-15",
  //   },
  //   {
  //     "MaKH": "6Sav7PWdgIVMmslvwlAeL6EAt4d2",
  //     "MaGG": "GIAMGIANGUOIMOI",
  //     "NgayBD": "2025-06-01",
  //     "NgayKT": "2025-06-30",
  //   },
  // ];
  // static const List<Map<String, dynamic>> LoaiGiamGia = [
  //   {"MaLoaiGG": "loai1", "TenLoai": "Đơn hàng"},
  //   {"MaLoaiGG": "loai2", "TenLoai": "Vận chuyển"},
  // ];

  // 🔹 Lấy tất cả giảm giá
  Future<List<GiamGiaModel>> getAllGiamGia() async {
    try {
      // 🔹 Gọi API GET tất cả giảm giá
      final data = await _apiService.getJsonList('GiamGias'); // endpoint backend trả về list GiamGia

      // 🔹 Chuyển danh sách JSON thành List<GiamGiaModel>
      final list = data.map((e) => GiamGiaModel.fromJson(e)).toList();

      // 🔹 In chi tiết từng giảm giá
      print("📦 Tất cả giảm giá:");
      for (var gg in list) {
        print("MaGG: ${gg.MaGG}, ChiTietGG: ${gg.ChiTietGG}, GiaTri: ${gg.GiaTri}, MaLoaiGG: ${gg.MaLoaiGG}");
      }

      return list;
    } catch (e) {
      print("❌ Lỗi khi lấy tất cả giảm giá: $e");
      return [];
    }
  }



  Future<List<ChiTietGiamGiaModel>> getChiTietGiamGiaByMaKH(String maKH) async {
    try {
      final data = await _apiService.getJsonList('ChiTietGiamGias');
      final list = data.map((e) => ChiTietGiamGiaModel.fromJson(e)).toList();
      print("📦 Chi tiết giảm giá của MaKH=$maKH: $list");
      return list;
    } catch (e) {
      print("❌ Lỗi khi lấy chi tiết giảm giá theo MaKH: $e");
      return [];
    }
  }

  // 🔹 Lấy danh sách giảm giá đầy đủ (có thông tin mô tả) theo khách hàng
  Future<List<GiamGiaModel>> getGiamGiaTheoMaKH(String maKH) async {
    try {
      final chiTietList = await getChiTietGiamGiaByMaKH(maKH);
      final allGiamGia = await getAllGiamGia();

      // Lấy danh sách mã GG khách hàng có
      final Set<String> maGiamGiaCuaKH = chiTietList.map((e) => e.MaGG).toSet();

      // Lọc ra thông tin chi tiết của các mã đó
      final giamGiaCuaKH = allGiamGia
          .where((gg) => maGiamGiaCuaKH.contains(gg.MaGG))
          .toList();

      return giamGiaCuaKH;
    } catch (e) {
      print("❌ Lỗi khi lấy giảm giá theo MaKH: $e");
      return [];
    }
  }

  Future<List<LoaiGGModel>> getLoaiGiamGia() async {
    try {
      // 🔹 Gọi API lấy danh sách loại giảm giá
      final data = await _apiService.getJsonList("LoaiGiamGias");
      // 🔹 Chuyển JSON thành List<LoaiGGModel>
      final list = data.map((e) => LoaiGGModel.fromJson(e)).toList();

      // 🔹 In ra debug
      print("✅ Danh sách loại giảm giá:");
      for (var item in list) {
        print("👉 ${item.MaLoaiGG} - ${item.TenLoai}");
      }

      return list;
    } catch (e) {
      print("❌ Lỗi khi lấy danh sách loại giảm giá: $e");
      return [];
    }
  }


  // Future<Map<String, dynamic>?> postJson(String endpoint, Map<String, dynamic> body) async {
  //   HttpClient httpClient = HttpClient()
  //     ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  //
  //   IOClient client = IOClient(httpClient);
  //   final uri = Uri.parse('$baseUrl$endpoint');
  //   print("🔹 POST: $uri");
  //   print("🔹 Body: $body");
  //
  //   try {
  //     final response = await client.post(
  //       uri,
  //       headers: {'Content-Type': 'application/json; charset=UTF-8'},
  //       body: jsonEncode(body),
  //     );
  //
  //     print("🔹 Status: ${response.statusCode}");
  //     print("🔹 Response: ${response.body}");
  //
  //     if (response.statusCode >= 200 && response.statusCode <= 299) {
  //       if (response.body.isEmpty) return null;
  //       return jsonDecode(response.body) as Map<String, dynamic>;
  //     } else {
  //       throw Exception('HTTP Error: ${response.statusCode} - ${response.body}');
  //     }
  //   } catch (e) {
  //     print("❌ Error in postJson: $e");
  //     rethrow;
  //   } finally {
  //     client.close();
  //   }
  // }

  Future<void> SdGiamga(String MaGG, String MaKH) async {
    try {
      print("🧾 --- DỮ LIỆU ĐƠN HÀNG  NHẬN TỪ VIEWMODEL ---");
      print("Mã Giảm giá (MaGG): ${MaGG}");
      print("Mã Khách Hàng (MaKh): ${MaKH}");
    } catch (e) {
      print('❌ Lỗi khi in dữ liệu đơn hàng: $e');
    }
  }
}
