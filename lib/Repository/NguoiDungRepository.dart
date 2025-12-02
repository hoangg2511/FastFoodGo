import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fastfoodgo/Models/CuaHangModel.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:fastfoodgo/Models/NguoiDungModel.dart';

import '../Service/ApiService.dart';

class NguoiDungRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ApiService apiService = ApiService();

  Future<User?> dangKyTaiKhoan(NguoiDung nguoiDung, String matKhau) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: nguoiDung.email,
        password: matKhau,
      );

      final User? user = credential.user;
      if (user != null) {
        await _firestore
            .collection("Users")
            .doc(user.uid)
            .set(nguoiDung.toJson());
      }
      return user;
    } on FirebaseAuthException catch (e) {
      print("Firebase Auth error: ${e.code}");
      return null;
    } catch (e) {
      print("Lỗi khác: $e");
      return null;
    }
  }

  Future<NguoiDung?> dangNhap(String email, String matKhau) async {
    try {
      final body = {
        "Email": email,
        "Password": matKhau,
      };

      // 🔹 Gọi API POST tới endpoint /KhachHang/login (ví dụ)
      final response = await apiService.postJson("KhachHangs/login", body);

      if (response != null) {
        print("✅ Đăng nhập thành công: $response");

        // Chuyển JSON thành đối tượng NguoiDung
        final nguoiDung = NguoiDung.fromJson(response);
        return nguoiDung;
      } else {
        print("❌ Đăng nhập thất bại, không có dữ liệu trả về");
        return null;
      }
    } catch (e) {
      print("⚠️ Lỗi khi đăng nhập API: $e");
      return null;
    }
  }
  Future<NguoiDung?> dangNhapgg(String id) async {
    try {

      final body = {
        "GoogleId": id,
      };


      final response = await apiService.postJson(
        "KhachHangs/login/google",
        body,
      );

      if (response != null) {
        print("Đăng nhập thành công: $response");

        return NguoiDung.fromJson(response);
      } else {
        print("API trả về rỗng!");
        return null;
      }
    } catch (e) {
      print("Lỗi khi gọi API đăng nhập Google: $e");
      return null;
    }
  }

  // Đăng xuất
  Future<void> dangXuat() async {
    await _auth.signOut();
  }

  // Lấy người dùng hiện tại
  Future<NguoiDung?> getNguoiDungHienTai() async {
    try {

      final data = await apiService.getJson('KhachHangs');

      if (data == null) {
        print("Không tìm thấy người dùng trong session.");
        return null;
      }

      // 🔹 Chuyển JSON sang model NguoiDung
      final user = NguoiDung.fromJson(data);
      print("Người dùng hiện tại: ${user.hoTen}");
      return user;
    } catch (e) {
      print("Lỗi khi lấy thông tin người dùng: $e");
      return null;
    }
  }


  Future<NguoiDung?> getNguoiDung(String maKH) async {
    try {

      final data = await apiService.getJson('KhachHangs/$maKH');

      if (data == null) {
        print("Không tìm thấy người dùng với MaKH: $maKH");
        return null;
      }

      return NguoiDung.fromJson(data);
    } catch (e) {
      print("Lỗi khi lấy thông tin người dùng: $e");
      return null;
    }
  }
  Future<void> updateNguoiDung(NguoiDung nguoiDung) async {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      await _firestore
          .collection("Users")
          .doc(currentUser.uid)
          .update(nguoiDung.toJson());
    }
  }
  Future<bool> taoNguoiDung(NguoiDung nguoiDung) async {
    try {
      print("gọi tới hàm taojh người dùng");
      final endpoint = "KhachHangs";

      final response = await ApiService().postJson(endpoint, nguoiDung.toJson());

      if (response != null) {
        print("Tạo người dùng thành công: $response");
        return true;
      } else {
        print("API không trả về dữ liệu");
        return false;
      }
    } catch (e) {
      print("Lỗi khi tạo người dùng: $e");
      return false;
    }
  }



  Future<List<CuaHangModel>> getCuaHangYeuThich() async {
    try {
      final data = await apiService.getJson('KhachHangs/CuaHangYeuThich');

      if (data == null) {
        print("Không tìm thấy cửa hàng yêu thích của khách hàng này");
        return [];
      }

      // Giả sử data là List<dynamic> từ JSON
      return (data as List<dynamic>)
          .map((json) => CuaHangModel.fromJson(json))
          .toList();
    } catch (e) {
      print("Lỗi khi lấy thông tin cửa hàng yêu thích: $e");
      return [];
    }
  }
  Future<bool> xoaCuaHangYeuThich(String maCH) async {
    try {
      final endpoint = 'KhachHangs/CuaHangYeuThich/$maCH';
      final success = await apiService.deleteJson(endpoint);

      if (success) {
        print("Xóa cửa hàng yêu thích thành công: $maCH");
      } else {
        print("Xóa cửa hàng yêu thích thất bại: $maCH");
      }

      return success;
    } catch (e) {
      print("Lỗi khi xóa cửa hàng yêu thích: $e");
      return false;
    }
  }



}
