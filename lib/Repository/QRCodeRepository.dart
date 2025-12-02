
import '../Models/QRCodeModel.dart';
import '../Service/ApiService.dart';
import '../Service/WebSocketService.dart';

class QRCodeRepository {
  final ApiService apiService = ApiService();
  final WebSocketService ws = WebSocketService();

  Future<QRCodeModel> getPaymentUrl(double amount, String description) async {


    final endpoint = "Sepay/pay-url/$amount/$description";

    try {

      final jsonResponse = await apiService.getJson(endpoint);

      if (jsonResponse is Map<String, dynamic>) {
        return QRCodeModel.fromJson(jsonResponse);
      } else {
      throw const FormatException("Dữ liệu nhận được không phải là Map<String, dynamic>.");
      }
    } catch (e) {

      print("Lỗi khi lấy Payment URL: $e");
      throw Exception("Lỗi gọi API: $e");
    }
  }

  QRCodeRepository() {
    ws.connect();
  }

  Stream<String> listenPaymentStatus() {
    return ws.stream;
  }

  // BỔ SUNG: Hàm dọn dẹp
  void dispose() {
    ws.disconnect();
  }
}
