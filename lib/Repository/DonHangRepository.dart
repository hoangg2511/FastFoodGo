import 'package:fastfoodgo/Models/DonHangModel.dart';

import '../Service/ApiService.dart';

class DonHangRepository{
  final ApiService _apiService = ApiService();


  // Đã thay đổi kiểu trả về thành Future<String> (MaDH)
  Future<String> taoDonHang(DonHangModel donHang) async {
    try {
      // Gửi POST request tạo đơn hàng
      final response = await _apiService.postJson('DonHangs', donHang.toJson());

      // API trả về JSON có trường "maDonHang" (hoặc "MaDonHang")
      final maDonHang = response?['maDonHang'] ?? response?['MaDonHang'];

      if (maDonHang == null) {
        throw Exception('Không nhận được mã đơn hàng từ API');
      }
      print("✅ Mã đơn hàng được tạo: $maDonHang");
      return maDonHang;
    } catch (e) {
      print("❌ Lỗi khi tạo đơn hàng: $e");
      rethrow;
    }
  }
  Future<void> xoaDonHang(String maDh) async {
    try {
      print('🗑️ [Repo] Gọi API để xóa đơn hàng: $maDh');

      // 🔹 Gọi trực tiếp đến deleteJson endpoint
      final success = await _apiService.deleteJson('DonHangs/$maDh');

      if (success) {
        print('✅ [Repo] Xóa đơn hàng $maDh thành công');
      } else {
        print('⚠️ [Repo] Xóa đơn hàng $maDh thất bại hoặc không tồn tại');
        throw Exception('Không thể xóa đơn hàng $maDh (server trả về false)');
      }
    } catch (e) {
      print('❌ [Repo] Lỗi khi xóa đơn hàng $maDh: $e');
      rethrow;
    }
  }


  Future<List<DonHangModel>> getDonHang() async {
    try {
      // 🔹 Gọi API GET tất cả giảm giá
      final data = await _apiService.getJsonList('DonHangs'); // endpoint backend trả về list GiamGia

      // 🔹 Chuyển danh sách JSON thành List<GiamGiaModel>
      final list = data.map((e) => DonHangModel.fromJson(e)).toList();

      // 🔹 In chi tiết từng giảm giá
      print("📦 Tất cả Đơn hàng:");
      for (var dh in list) {
        print("MaDH: ${dh.maDH}, trạng thái đơn hàng: ${dh.trangThaiDonHang}, Tạm tính: ${dh.tamTinh}, Ngày đặt: ${dh.ngayDat}");
      }

      return list;
    } catch (e) {
      print("❌ Lỗi khi lấy tất cả giảm giá: $e");
      return [];
    }
  }

}