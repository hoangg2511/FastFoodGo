import 'dart:convert';
import 'dart:io';

import 'package:fastfoodgo/Service/ApiService.dart';
import 'package:fastfoodgo/Models/LoaiGG.dart';
import 'package:http/io_client.dart';

import '../Models/GiamGiaModel.dart';

class GiamGiaRepository {
  ApiService _apiService = ApiService();


  Future<List<GiamGiaModel>> getAllGiamGia() async {
    try {

      final data = await _apiService.getJsonList('GiamGias'); // endpoint backend trả về list GiamGia

      final list = data.map((e) => GiamGiaModel.fromJson(e)).toList();

      print("Tất cả giảm giá:");
      for (var gg in list) {
        print("MaGG: ${gg.MaGG}, ChiTietGG: ${gg.ChiTietGG}, GiaTri: ${gg.GiaTri}, MaLoaiGG: ${gg.MaLoaiGG}");
      }

      return list;
    } catch (e) {
      print("Lỗi khi lấy tất cả giảm giá: $e");
      return [];
    }
  }



  Future<List<ChiTietGiamGiaModel>> getChiTietGiamGiaByMaKH(String maKH) async {
    try {
      final data = await _apiService.getJsonList('ChiTietGiamGias');
      final list = data.map((e) => ChiTietGiamGiaModel.fromJson(e)).toList();
      print("Chi tiết giảm giá của MaKH=$maKH: $list");
      return list;
    } catch (e) {
      print("Lỗi khi lấy chi tiết giảm giá theo MaKH: $e");
      return [];
    }
  }


  Future<List<GiamGiaModel>> getGiamGiaTheoMaKH(String maKH) async {
    try {
      final chiTietList = await getChiTietGiamGiaByMaKH(maKH);
      final allGiamGia = await getAllGiamGia();


      final Set<String> maGiamGiaCuaKH = chiTietList.map((e) => e.MaGG).toSet();


      final giamGiaCuaKH = allGiamGia
          .where((gg) => maGiamGiaCuaKH.contains(gg.MaGG))
          .toList();

      return giamGiaCuaKH;
    } catch (e) {
      print("Lỗi khi lấy giảm giá theo MaKH: $e");
      return [];
    }
  }

  Future<List<LoaiGGModel>> getLoaiGiamGia() async {
    try {

      final data = await _apiService.getJsonList("LoaiGiamGias");

      final list = data.map((e) => LoaiGGModel.fromJson(e)).toList();

      print("✅ Danh sách loại giảm giá:");
      for (var item in list) {
        print("👉 ${item.MaLoaiGG} - ${item.TenLoai}");
      }

      return list;
    } catch (e) {
      print("❌ Lỗi khi lấy danh sách loại giảm giá: $e");
      return [];
    }
  }

  Future<void> SdGiamga(String MaGG, String MaKH) async {
    try {
      print("DỮ LIỆU ĐƠN HÀNG  NHẬN TỪ VIEWMODEL ---");
      print("Mã Giảm giá (MaGG): ${MaGG}");
      print("Mã Khách Hàng (MaKh): ${MaKH}");
    } catch (e) {
      print('Lỗi khi in dữ liệu đơn hàng: $e');
    }
  }
}
