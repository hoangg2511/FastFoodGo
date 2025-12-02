import 'package:fastfoodgo/Models/NguoiDungModel.dart';
import 'package:fastfoodgo/ViewModels/ThongTinViewModel.dart';
import 'package:fastfoodgo/ViewModels/TrangChuViewModel.dart';
import 'package:fastfoodgo/Views/DangNhap.dart';
import 'package:fastfoodgo/Views/TrangChu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import '../Repository/NguoiDungRepository.dart';
import '../Views/DiaChi.dart';
import '../Views/Nav.dart';

class DangNhapViewModel extends ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final NguoiDungRepository _repository = NguoiDungRepository();
  // Lấy user hiện tại
  User? get currentUser => auth.currentUser;

  bool get isLoggedIn => currentUser != null;


  Future<NguoiDung?> DangNhapGG(BuildContext context) async {
    try {

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        print("❌ Người dùng đã hủy đăng nhập Google");
        return null;
      }


      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;


      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);

      final User? user = userCredential.user;

      if (user == null) {
        print("⚠️ Không lấy được user từ Firebase");
        return null;
      }

      final String maKH = user.uid; // UID Firebase chính là khóa chính

      print("✅ Firebase Login thành công");
      print("👤 Tên: ${user.displayName}");
      print("📧 Email: ${user.email}");
      print("🆔 UID (MaKH): $maKH");

      final NguoiDung? nguoiDung = await _repository.dangNhapgg(maKH);

      if (nguoiDung == null) {
        print("❌ Backend login thất bại");
        return null;
      }

      notifyListeners();
      return nguoiDung;

    } catch (e) {
      print("⚠️ Lỗi đăng nhập Google: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đăng nhập thất bại: $e')),
      );
      return null;
    }
  }

  Future<void> login(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        print("Người dùng đã hủy đăng nhập Google");
        return;
      }

      final googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        final String maKH = user.uid;
        final String email = user.email ?? "";

        print("Đăng nhập thành công: ${user.displayName}");
        print("MaKH: $maKH");
        print("Email: $email");

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider(
              create: (_) => ThongTinViewModel(),
              child: DiaChi(
                maKH: maKH,
                email: email,
              ),
            ),
          ),
              (route) => false,
        );
      }

    } catch (e) {
      print("⚠️ Lỗi đăng nhập Google: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Đăng nhập thất bại: $e")),
      );
    }
  }


  /// 🔹 Đăng xuất
  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();
      print("👋 Đã đăng xuất khỏi Google và Firebase");
      notifyListeners();
    } catch (e) {
      print("⚠️ Lỗi khi đăng xuất: $e");
    }
  }
}
