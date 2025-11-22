// import 'dart:convert';
//
// import '../ApiService.dart';
//
// class OptionMonAnrepository{
//   final ApiService apiService = ApiService();
//
//   Future<Map<String, dynamic>?> getChiTietMonAn(String monAnId) async {
//     try {
//       print("🔹 Gửi request lấy chi tiết món ăn: $monAnId");
//
//       // API trả về List, nên dùng getJsonList
//       final List<dynamic> jsonList =
//       await apiService.getJsonList('OptionMonAns/$monAnId');
//
//       if (jsonList.isEmpty) {
//         print("Không có dữ liệu trả về từ API cho món ăn ID: $monAnId");
//         return null;
//       }
//
//       print("Nhận được ${jsonList.length} loại option từ API");
//       print(jsonEncode(jsonList));
//
//       // Lấy danh sách Loại Option + Option bên trong
//       final optionData = jsonList.map((loai) {
//         return {
//           'MaLoaiOption': loai['MaLoaiOption'],
//           'TenLoaiOption': loai['TenLoaiOption'],
//           'Options': (loai['Options'] as List<dynamic>?)
//               ?.map((op) => {
//             'MaOption': op['MaOption'],
//             'TenOption': op['TenOption'],
//             'Gia': op['Gia']
//           })
//               .toList() ??
//               []
//         };
//       }).toList();
//
//       // Không có phần "monAn" nếu API không trả
//       return {
//         'monAn': {'MaMonAn': monAnId}, // tạo placeholder để thống nhất cấu trúc
//         'option': optionData,
//       };
//     } catch (e, stackTrace) {
//       print("🔥 Lỗi khi lấy chi tiết món ăn: $e");
//       print(stackTrace);
//       return null;
//     }
//   }
// }