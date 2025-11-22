
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fastfoodgo/Models/CuaHangModel.dart';

import '../Service/ApiService.dart';

class CuaHangRepository {
  final ApiService apiService = ApiService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  Future<List<CuaHangModel>> getTatCaCuaHang() async {
    final List<dynamic> jsonData = await apiService.getJsonList('CuaHangs');
    List<CuaHangModel> listCuaHang = [];
    for (int i = 0; i < jsonData.length; i++) {
      final json = jsonData[i];
      final cuaHang = CuaHangModel.fromJson(json);
      listCuaHang.add(cuaHang);
    }
    return listCuaHang;
  }
  Future<CuaHangModel?> getCuaHang(String id) async {
    print("🔹 Gọi API lấy cửa hàng theo id: $id");

    try {
      final jsonData = await apiService.getJson('CuaHangs/$id'); // chỉ 1 object
      if (jsonData == null) {
        print("⚠️ Không nhận được dữ liệu từ API");
        return null;
      }

      print("✅ Dữ liệu cửa hàng nhận được: $jsonData");
      return CuaHangModel.fromJson(jsonData);
    } catch (e) {
      print("❌ Lỗi khi lấy cửa hàng: $e");
      return null;
    }
  }
  bool isOpenNow(String gioMoCua, String gioDongCua) {
    final now = DateTime.now();
    final openParts = gioMoCua.split(':');
    final closeParts = gioDongCua.split(':');

    final openTime = DateTime(now.year, now.month, now.day,
        int.parse(openParts[0]), int.parse(openParts[1]));
    final closeTime = DateTime(now.year, now.month, now.day,
        int.parse(closeParts[0]), int.parse(closeParts[1]));
    if (closeTime.isBefore(openTime)) {
      if (now.isAfter(openTime) || now.isBefore(closeTime.add(Duration(days: 1)))) {
        return true;
      }
    }
    return now.isAfter(openTime) && now.isBefore(closeTime);
  }
  Future<List<CuaHangModel>> getCuaHangVaMonAn() async {
    try {
      final List<dynamic> jsonData = await apiService.getJsonList('CuaHangs/MonAn');

      final listCuaHang = jsonData
          .map((json) => CuaHangModel.fromJson(json))
          .toList();
      // 🔹 In dữ liệu ra console

      for (var ch in listCuaHang) {
        print("Cửa hàng: ${ch.TenCuaHang}, Đánh giá: ${ch.DanhGia}");
        for (var mon in ch.MonAn) {
          print("  Món ăn: ${mon.TenMonAn}, Giá: ${mon.Gia}");
          for(var loai in mon.LoaiMonAnList){
            print(" Loại món ăn: ${loai.Ten}");
          }
        }
      }

      return listCuaHang;
    } catch (e) {
      print("Lỗi khi lấy cửa hàng: $e");
      return [];
    }
  }
  Future<bool> themYeuThich(String maCH) async {
    try {
      final response = await apiService.postJson(
        'CuaHangs/CuaHangYeuThich/$maCH',
        {}, // body rỗng
      );

      // ✅ Nếu response không null hoặc HTTP 200 là thành công
      print("📩 Response từ API: $response");
      print("✅ Đã thêm cửa hàng yêu thích: $maCH");
      return true;
    } catch (e) {
      print("❌ Lỗi khi thêm cửa hàng yêu thích: $e");
      return false;
    }
  }





}


