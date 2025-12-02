import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

import '../../Models/PaymentInformationModel.dart';


class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)!
      ..badCertificateCallback = (cert, host, port) => true;
  }
}

class VnPayService {
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

        return data['paymentUrl'] as String?;
      } else {
        print('Tạo thanh toán thất bại: ${response.statusCode} ${response.reasonPhrase}');

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
      print('URL callback trống.');
      return null;
    }
    try {
      final uri = Uri.parse(callbackUrl);
      final queryParameters = uri.queryParameters;

      if (queryParameters.isEmpty) {
        print('URL callback không chứa tham số VNPay.');
        return null;
      }

      print('Các tham số callback nhận được:');
      queryParameters.forEach((key, value) {
        print(' - $key: $value');
      });


      final callbackUri = Uri.https(
        '10.0.2.2:7156',
        '/api/Payment/callback',
        queryParameters,
      );

      print('Gửi xác thực callback tới backend: $callbackUri');

      final response = await http.get(callbackUri);

      if (response.statusCode == 200) {
        print('Backend xác thực thành công.');
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        print('Backend trả lỗi: ${response.statusCode} ${response.reasonPhrase}');
        return null;
      }
    } on FormatException catch (e) {
      print('Lỗi định dạng URL callback: ${e.message}');
      return null;
    } on SocketException catch (e) {
      print('Không thể kết nối backend: $e');
      return null;
    } catch (e) {
      print('Lỗi không xác định khi xử lý callback: $e');
      return null;
    }
  }





}