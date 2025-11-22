import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

import '../../Models/PaymentInformationModel.dart';

// Tùy chỉnh HttpOverrides để bỏ qua lỗi chứng chỉ SSL tự ký
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)!
      ..badCertificateCallback = (cert, host, port) => true;
  }
}

class VnPayService {
  // Địa chỉ API, lưu ý: 10.0.2.2 là localhost cho Android Emulator
  final String _apiUrl = 'https://10.0.2.2:7156/api/Payment/create';

  Future<String?> createPaymentUrl(PaymentInformationModel model) async {
    try {
      print('Đang gửi request đến $_apiUrl...');

      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(model.toJson()),
      );

      print('Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Giả định API trả về một JSON có trường 'paymentUrl'
        return data['paymentUrl'] as String?;
      } else {
        print('Tạo thanh toán thất bại: ${response.statusCode} ${response.reasonPhrase}');
        // Trong môi trường thực tế, bạn nên ném một ngoại lệ tùy chỉnh
        return null;
      }
    } on SocketException catch (e) {
      print('SocketException (Kết nối/Tường lửa): $e');
      return null;
    } on HttpException catch (e) {
      print('Lỗi HTTP: ${e.message}');
      return null;
    } on FormatException catch (e) {
      print('Lỗi định dạng dữ liệu (JSON): ${e.message}');
      return null;
    } catch (e) {
      print('Lỗi không xác định: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getPaymentCallback(String callbackUrl) async {
    if (callbackUrl.isEmpty) {
      print('🚫 URL callback trống.');
      return null;
    }
    try {
      final uri = Uri.parse(callbackUrl);
      final queryParameters = uri.queryParameters;

      if (queryParameters.isEmpty) {
        print('⚠️ URL callback không chứa tham số VNPay.');
        return null;
      }

      print('📦 Các tham số callback nhận được:');
      queryParameters.forEach((key, value) {
        print(' - $key: $value');
      });

      // ✅ Gửi toàn bộ query params này lên Backend để xác thực
      final callbackUri = Uri.https(
        '10.0.2.2:7156',                // backend host (dùng https cho .NET)
        '/api/Payment/callback',        // endpoint của controller PaymentCallbackVnpay
        queryParameters,                // gửi toàn bộ params
      );

      print('🌐 Gửi xác thực callback tới backend: $callbackUri');

      final response = await http.get(callbackUri);

      if (response.statusCode == 200) {
        print('✅ Backend xác thực thành công.');
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        print('⚠️ Backend trả lỗi: ${response.statusCode} ${response.reasonPhrase}');
        return null;
      }
    } on FormatException catch (e) {
      print('❌ Lỗi định dạng URL callback: ${e.message}');
      return null;
    } on SocketException catch (e) {
      print('🚫 Không thể kết nối backend: $e');
      return null;
    } catch (e) {
      print('❌ Lỗi không xác định khi xử lý callback: $e');
      return null;
    }
  }





}