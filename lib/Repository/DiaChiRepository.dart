import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../Service/ApiService.dart';
import '../Models/DiaChiModel.dart';

class DiaChiRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ApiService apiService = ApiService();
  // Lấy danh sách địa chỉ của user
  Future<List<DiaChiModel>> getDiaChiByUser(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('DiaChi')
          .where('Users', isEqualTo: userId) // lưu ý trường trong model
          .get();

      return snapshot.docs
          .map((doc) => DiaChiModel.fromJson(doc.data())..id = doc.id)
          .toList();
    } catch (e) {
      print("Lỗi khi lấy danh sách địa chỉ: $e");
      return [];
    }
  }

  // Lấy địa chỉ mặc định (Status = true)
  Future<List<DiaChiModel>> getDiaChiKhachHang() async {
    try {
      final data = await apiService.getJsonList('ChiTietDiaChis/KhachHang');

      if (data.isEmpty) {
        print("⚠️ Không có địa chỉ nào cho khách hàng");
        return [];
      }
      final addresses = data.map((e) => DiaChiModel.fromJson(e)).toList();

      // 🔹 Log ra JSON đẹp
      print("📦 Dữ liệu địa chỉ:");
      print(const JsonEncoder.withIndent('  ').convert(data));

      return addresses;
    } catch (e) {
      print("❌ Lỗi khi lấy địa chỉ: $e");
      return [];
    }
  }
  Future<List<DiaChiModel>> getDiaChiCuaHang() async {
    try {
      final data = await apiService.getJsonList('DiaChis/CuaHang');

      if (data.isEmpty) {
        print("⚠️ Không có địa chỉ nào cho Cửa hàng");
        return [];
      }

      final addresses = data.map((e) => DiaChiModel.fromJson(e)).toList();

      // 🔹 Log ra JSON đẹp
      print("📦 Dữ liệu địa chỉ:");
      print(const JsonEncoder.withIndent('  ').convert(data));

      return addresses;
    } catch (e) {
      print("❌ Lỗi khi lấy địa chỉ1: $e");
      return [];
    }
  }


  // Thêm địa chỉ mới
  Future<String?> addDiaChi(DiaChiModel diaChi) async {
    try {
      final api = ApiService();
      final response = await api.postJson(
        "DiaChis",
        diaChi.toJson(),
      );

      if (response != null && response.containsKey("maDiaChi")) {
        print("✅ Thêm địa chỉ thành công: ${response["maDiaChi"]}");
        return response["maDiaChi"]; // trả về mã
      } else {
        print("⚠️ API không trả về maDiaChi");
        return null;
      }
    } catch (e) {
      print("❌ Lỗi khi thêm địa chỉ: $e");
      return null;
    }
  }


  // Cập nhật địa chỉ
  Future<void> updateDiaChi(String id, DiaChiModel diaChi) async {
    try {
      await _firestore.collection('DiaChi').doc(id).update(diaChi.toJson());
    } catch (e) {
      print("Lỗi khi cập nhật địa chỉ: $e");
    }
  }

  // Xóa địa chỉ
  Future<void> deleteDiaChi(String id) async {
    try {
      await _firestore.collection('DiaChi').doc(id).delete();
    } catch (e) {
      print("Lỗi khi xóa địa chỉ: $e");
    }
  }
}
