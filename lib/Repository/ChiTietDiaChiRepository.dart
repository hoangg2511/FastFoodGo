import '../Service/ApiService.dart';
import '../Models/ChiTietDiaChiModel.dart';

class ChiTietDiaChiRepository {
  final ApiService apiService = ApiService();


  Future<void> ThemDiaChi(ChiTietDiaChiModel ctdc) async {
    print("gọi đến post ctdc");
    try {
      final response = await ApiService().postJson(
        "ChiTietDiaChis",
        ctdc.toJson(),
      );
      print("✅ Thêm chi tiết địa chỉ thành công: $response");
    } catch (e) {
      print("❌ Lỗi khi thêm chi tiết địa chỉ: $e");
    }
  }

}
