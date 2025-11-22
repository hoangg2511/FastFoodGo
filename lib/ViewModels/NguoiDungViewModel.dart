
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fastfoodgo/Models/NguoiDungModel.dart';
import 'package:fastfoodgo/Repository/NguoiDungRepository.dart';
import 'package:fastfoodgo/Views/DangKy.dart';
import 'package:fastfoodgo/Views/DangNhap.dart';
import 'package:fastfoodgo/Views/Nav.dart';

import 'package:fastfoodgo/Models/DiaChiModel.dart';
import 'package:fastfoodgo/Repository/DiaChiRepository.dart';
import 'package:provider/provider.dart';

class NguoiDungViewModel extends ChangeNotifier{
  final NguoiDungRepository _repository = NguoiDungRepository();

  void dangKyNgay(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => DangKy()));
  }
  void dangNhapNgay(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => DangNhap()));
  }

  Future<NguoiDung?> dangNhap(String email, String matKhau) async {
    final nguoiDung = await _repository.dangNhap(email, matKhau);

    if (nguoiDung != null) {
      print("Đăng nhập thành công");
      notifyListeners();
    } else {
      print("Đăng nhập thất bại hoặc user chưa có trong Firestore");
    }

    return nguoiDung;
  }


  Future<void> dangXuat(BuildContext context) async {
    await _repository.dangXuat();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => DangNhap()),
          (route) => false,
    );
  }

  Future<String> dangKyTaiKhoan(String email, String matKhau, String hoTen, String sdt, String matKhau1) async {
    if (matKhau != matKhau1) return "Mật khẩu xác nhận không khớp";
    if (!email.endsWith("@gmail.com")) return "Email phải có đuôi @gmail.com";

    final nguoiDung = NguoiDung(
      hoTen: hoTen,
      email: email,
      sdt: sdt,
    );

    final user = await _repository.dangKyTaiKhoan(nguoiDung, matKhau);
    return user != null ? "Đăng ký thành công" : "Đăng ký thất bại";
  }

  Future<NguoiDung?> getNguoiDungHienTai() async {
    return await _repository.getNguoiDungHienTai();
  }

  Future<void> updateNguoiDung(NguoiDung nguoiDung) async {
    await _repository.updateNguoiDung(nguoiDung);
  }

  final DiaChiRepository _repo = DiaChiRepository();

  List<DiaChiModel> danhSachDiaChi = [];
  DiaChiModel? diaChiMacDinh;
  bool isLoading = false;

  // 🔹 Lấy tất cả địa chỉ của khách hàng
  Future<void> getDiaChi() async {
    try {
      isLoading = true;
      notifyListeners();

      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        print("⚠️ Không có user Firebase đang đăng nhập");
        return;
      }

      final userId = user.uid;

      // Gọi API lấy địa chỉ theo userId
      final data = await _repo.getDiaChiKhachHang();

      danhSachDiaChi = data;

      // Lấy địa chỉ mặc định
      DiaChiModel diaChiMacDinh = danhSachDiaChi.isNotEmpty
          ? danhSachDiaChi.firstWhere(
            (dc) => dc.status == 1,
        orElse: () => danhSachDiaChi.first,
      )
          : DiaChiModel(
        id: '',
        soNha: '',
        Duong: '',
        phuongXa: '',
        quanHuyen: '',
        tinhTp: '',
        status: 0,
        maCH: '',
        DCCuThe: '',
      );

      print("📦 Danh sách địa chỉ:");
      for (var dc in danhSachDiaChi) {
        print(dc.toJson());
      }
    } catch (e) {
      print("❌ Lỗi khi lấy địa chỉ: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

}
