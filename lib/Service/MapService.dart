import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class MapService {
  final String? apiKey;

  MapService() : apiKey = dotenv.env['API_KEY_DM'];

  Future<Map<String, String>> getKhoangCach({
    required String origin,
    required String destination,
  }) async {
    if (apiKey == null || apiKey!.isEmpty) {
      throw Exception("MAP_KEY chưa được cấu hình trong .env");
    }

    final encodedOrigin = Uri.encodeComponent(origin);
    final encodedDestination = Uri.encodeComponent(destination);

    final url = Uri.parse(
        "https://api.distancematrix.ai/maps/api/distancematrix/json?origins=$encodedOrigin&destinations=$encodedDestination&key=$apiKey");

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception("Lỗi API ${response.statusCode}: ${response.body}");
    }

    final data = json.decode(response.body);

    if (data['rows'] != null &&
        data['rows'][0]['elements'] != null &&
        data['rows'][0]['elements'][0]['status'] == "OK") {
      final element = data['rows'][0]['elements'][0];
      return {
        "distance": element['distance']['text'],
        "duration": element['duration']['text'],
      };
    } else {
      throw Exception(
          "Không tìm thấy tuyến đường: ${data['rows'][0]['elements'][0]['status']}");
    }
  }
}
