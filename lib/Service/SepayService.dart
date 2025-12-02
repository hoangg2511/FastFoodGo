import 'dart:convert';
import 'package:http/http.dart' as http;

class Sepayservice {
  final String baseUrl = "https://localhost:7156/api/sepay"; // đổi theo server của bạn

  Future<String?> getPaymentUrl(double amount, String description) async {
    final encodedDescription = Uri.encodeComponent(description);

    final url = Uri.parse("$baseUrl/pay-url/$amount/$encodedDescription");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["payUrl"];
    } else {
      throw Exception("API Error: ${response.statusCode}");
    }
  }
}
