import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fastfoodgo/Models/CuaHangModel.dart';
import 'package:fastfoodgo/Models/MonAnModel.dart';
import 'package:fastfoodgo/Models/OptionMonAnModel.dart';

import '../Service/ApiService.dart';

class MonAnRepository {
  final ApiService apiService = ApiService();

  Future<List<MonAnModel>> getMonAnTheoCuaHang(String cuaHangId) async {
    try {
      print("🔹 Gửi request lấy món ăn của cửa hàng: $cuaHangId");

      final List<dynamic> jsonData =
      await apiService.getJsonList('MonAns/CuaHang/$cuaHangId');
      print("Dữ liệu JSON nhận được từ API:");
      print(jsonEncode(jsonData));

      print("✅ Nhận được ${jsonData.length} món ăn từ API");

      return jsonData.map((json) => MonAnModel.fromJson(json)).toList();
    } catch (e, stackTrace) {
      print("Lỗi khi lấy danh sách món ăn: $e");
      print("StackTrace: $stackTrace");
      return [];
    }
  }
  Future<MonAnModel?> getChiTietMonAn(String monAnId) async {
    try {
      print("🔹 Gửi request lấy chi tiết món ăn: $monAnId");
      // 1. Dùng phương thức lấy về một Object JSON đơn
      final Map<String, dynamic>? jsonData =
      await apiService.getJson('MonAns/$monAnId');

      // Kiểm tra nếu API trả về null (404 Not Found)
      if (jsonData == null) {
        print("⚠️ Không tìm thấy món ăn với mã $monAnId.");
        return null;
      }

      print("Dữ liệu JSON nhận được từ API:");
      print(jsonEncode(jsonData)); // Dùng jsonEncode để in ra console cho dễ đọc

      // 2. Chuyển đổi Object JSON thành MonAnModel
      final monAn = MonAnModel.fromJson(jsonData);

      print("✅ Đã lấy chi tiết món ăn: ${monAn.TenMonAn}");

      // 3. Trả về object MonAnModel
      return monAn;

    } catch (e, stackTrace) {
      print("❌ Lỗi khi lấy chi tiết món ăn $monAnId: $e");
      print("StackTrace: $stackTrace");
      return null;
    }
  }
  Future<List<LoaiOptionModel>?> getLoaiOption(String monAnId) async {
    try {
      print("🔹 Gửi request lấy Loại Option theo MonAnID: $monAnId");
      final List<dynamic> jsonDataList =
      await apiService.getJsonList('LoaiOptions/MonAn/$monAnId');

      // Kiểm tra dữ liệu
      if (jsonDataList.isEmpty) {
        print("⚠️ Không tìm thấy Loại Option nào cho món ăn $monAnId.");
        return []; // Trả về danh sách rỗng nếu không có dữ liệu
      }

      // 2. Chuyển đổi List<dynamic> thành List<LoaiOptionModel>
      final loaiOptions = jsonDataList
          .map((json) => LoaiOptionModel.fromJson(json as Map<String, dynamic>))
          .toList();

      print("✅ Nhận được ${loaiOptions.length} Loại Option từ API.");

      // 3. Trả về danh sách model
      return loaiOptions;

    } catch (e, stackTrace) {
      print("❌ Lỗi khi lấy danh sách Loại Option (MonAnID: $monAnId): $e");
      print("StackTrace: $stackTrace");
      return null; // Trả về null nếu có lỗi hệ thống
    }
  }
  Future<List<OptionMonAnModel>?> getOptionMonAn(String idLoaiOption) async {
    try {
      print("🔹 Gửi request lấy OptionMonAn theo Mã Loại Option: $idLoaiOption");
      final List<dynamic> jsonList =
      await apiService.getJsonList('OptionMonAns/LoaiOption/$idLoaiOption');

      if (jsonList.isEmpty) {
        print("⚠️ Không tìm thấy OptionMonAn nào cho Loại Option ID: $idLoaiOption");
        return [];
      }

      print("✅ Nhận được ${jsonList.length} OptionMonAn từ API");
      final optionMonAns = jsonList
          .map((json) => OptionMonAnModel.fromJson(json as Map<String, dynamic>))
          .toList();

      return optionMonAns;

    } catch (e, stackTrace) {
      print("🔥 Lỗi khi lấy danh sách OptionMonAn: $e");
      print("StackTrace: $stackTrace");
      return null; // Trả về null nếu có lỗi hệ thống
    }
  }

  Future<List<MonAnModel>> getMonAn() async {
    try {
      // 🔹 Gọi API GET tất cả giảm giá
      final data = await apiService.getJsonList('MonAns'); // endpoint backend trả về list GiamGia

      // 🔹 Chuyển danh sách JSON thành List<GiamGiaModel>
      final list = data.map((e) => MonAnModel.fromJson(e)).toList();
      return list;
    } catch (e) {
      print("❌ Lỗi khi lấy tất món ăn: $e");
      return [];
    }
  }
  Future<List<OptionMonAnModel>> getOption() async {
    try {
      // 🔹 Gọi API GET tất cả giảm giá
      final data = await apiService.getJsonList('OptionMonAns'); // endpoint backend trả về list GiamGia

      // 🔹 Chuyển danh sách JSON thành List<GiamGiaModel>
      final list = data.map((e) => OptionMonAnModel.fromJson(e)).toList();
      return list;
    } catch (e) {
      print("❌ Lỗi khi lấy tất món ăn: $e");
      return [];
    }
  }

  Future<void> taoDonHang(OptionMonAnModel option) async {
    try {
      print("🧾 --- DỮ LIỆU CHI TIẾT MÓN ĂN ĐƠN HÀNG NHẬN TỪ VIEWMODEL ---");
      print("Mã option món ăn đơn hàng (MaCtDH): ${option.id}");
      print("Giá món ăn (MaMonAn): ${option.gia}");
      print("Tên option món ăn  ${option.ten}");
    } catch (e) {
      print('❌ Lỗi khi in dữ liệu chi tiết đơn hàng: $e');
    }
  }

}
