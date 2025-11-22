import '../Models/CuaHangModel.dart';
import '../Service/ApiService.dart';

class ApiHandler {
  final ApiService apiService;

  ApiHandler({required this.apiService});

  Future<List<CuaHangModel>> getCuaHang() async {
    final List<dynamic> jsonData = await apiService.getJsonList('/CuaHangs');
    print("🔹 Mapping ${jsonData.length} cửa hàng...");

    return jsonData.map((json) => CuaHangModel.fromJson(json)).toList();
  }
}
