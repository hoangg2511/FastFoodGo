
import 'dart:math';

import 'package:fastfoodgo/Service/ApiService.dart';
import 'package:flutter/cupertino.dart';
import '../Models/ChiTietDiaChiModel.dart';
import '../Models/DiaChiModel.dart';
import '../Models/NguoiDungModel.dart';
import '../Repository/ChiTietDiaChiRepository.dart';
import '../Repository/DiaChiRepository.dart';
import '../Repository/NguoiDungRepository.dart';

class ThongTinViewModel extends ChangeNotifier{
  final ApiService _apiService = ApiService();
  final ChiTietDiaChiRepository _repoCTDC = ChiTietDiaChiRepository();
  final NguoiDungRepository _repoNguoiDung = NguoiDungRepository();
  final DiaChiRepository _repoDiaChi = DiaChiRepository();


  String generateDiaChiId() {
    const length = 8; // số ký tự ngẫu nhiên
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rand = Random.secure();

    final randomString = List.generate(length, (_) => chars[rand.nextInt(chars.length)]).join();
    return 'DC$randomString';
  }
  Future<void> ThemDiaChi(String ten,String sdt,String phuongXa,String quanHuyen,String tinhTP,int trangThaiInt,String diaChi,String MaKh,String email,String matKhau) async {
    print("Gọi hàm thêm địa chỉ");
    try {
      final dc = DiaChiModel(
          id: generateDiaChiId(),
          phuongXa: phuongXa,
          quanHuyen: quanHuyen,
          soNha: '',
          Duong: '',
          status: trangThaiInt,
          maCH: null,
          tinhTp: tinhTP,
          DCCuThe: diaChi
      );
      await _repoDiaChi.addDiaChi(dc);

      final nd = NguoiDung(
        id: MaKh,
        hoTen: ten,
        sdt: sdt,
        diaChi:dc.id,
        email: email,
        matKhau: matKhau,
      );

      await _repoNguoiDung.taoNguoiDung(nd);

      final ctdc = ChiTietDiaChiModel(
        MaKH: nd.id,
        MaDiaChi: dc.id,
        TrangThai: trangThaiInt,
      );
      await _repoCTDC.ThemDiaChi(ctdc);
    } catch (e, st) {
      print("Lỗi khi thêm địa chỉ: $e\n$st");
    }
  }

}