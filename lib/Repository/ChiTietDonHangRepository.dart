import '../Service/ApiService.dart';
import '../Models/ChiTietDonHangModel.dart';

class ChiTietDonHangRepository {
  final ApiService _apiService = ApiService();

  // Future<String?> taoDonHang(DonHangModel donHang) async {
  //   try {
  //     final data = await apiService.postJson('DonHangs', donHang.toJson());
  //
  //     if (data != null && data.containsKey('MaDH')) {
  //       return data['MaDH'];
  //     } else {
  //       print('⚠️ Không nhận được mã đơn hàng từ API');
  //       return null;
  //     }
  //   } catch (e) {
  //     print('❌ Lỗi khi tạo đơn hàng: $e');
  //     return null;
  //   }
  // }
  Future<void> taoDonHang(ChiTietDonHangModel ctDonHang) async {
    try {
      // 🔹 In dữ liệu trước khi gửi
      print("📤 Gửi ChiTietDonHang tới API: ${ctDonHang.toJson()}");

      await _apiService.postJson(
        'ChiTietDonHangs',
        ctDonHang.toJson(),
      );
      // 🔹 Có thể in thêm thông báo khi gửi thành công
      print("✅ Tạo Chi tiết đơn hàng thành công: ${ctDonHang.maCTDH}");
    } catch (e) {
      print("❌ Lỗi khi tạo Chi tiết đơn hàng: $e");
      rethrow;
    }
  }



  Future<List<ChiTietDonHangModel>> getCTDH() async {
    try {
      // 🔹 Gọi API GET tất cả giảm giá
      final data = await _apiService.getJsonList('ChiTietDonHangs'); // endpoint backend trả về list GiamGia

      // 🔹 Chuyển danh sách JSON thành List<GiamGiaModel>
      final list = data.map((e) => ChiTietDonHangModel.fromJson(e)).toList();

      // 🔹 In chi tiết từng giảm giá
      print("📦 Tất cả Đơn hàng:");
      for (var ctdh in list) {
        print("MaDH: ${ctdh.maDH}, trạng thái đơn hàng: ${ctdh.note}, Tạm tính: ${ctdh.maMonAn}, Ngày đặt: ${ctdh.soLuong}");
      }
      return list;
    } catch (e) {
      print("❌ Lỗi khi lấy tất cả giảm giá: $e");
      return [];
    }
  }

}
