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

  // Lấy user hiện tại
  User? get currentUser => auth.currentUser;

  bool get isLoggedIn => currentUser != null;

  /// 🔹 Đăng ký tài khoản với Google
  Future<void> DangKyVoiGG(BuildContext context) async {
    try {
      // 1️⃣ Đăng nhập Google
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        print("❌ Người dùng đã hủy đăng ký bằng Google");
        return;
      }

      // 2️⃣ Lấy token xác thực từ Google
      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      // 3️⃣ Tạo credential Firebase
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 4️⃣ Đăng ký (sign in lên Firebase)
      final UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);

      // 5️⃣ Lấy thông tin user vừa tạo
      final User? user = userCredential.user;
      if (user != null) {
        final String maKH = user.uid; // ✅ ID duy nhất trong Firebase
        print("✅ Đăng ký thành công: ${user.displayName}");
        print("🆔 Mã khách hàng (MaKH): $maKH");

        // 🔹 Sau khi đăng ký xong => chuyển sang Trang chủ và truyền maKH
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider(
              create: (_) => ThongTinViewModel(),
              child: DiaChi(maKH: maKH),
            ),
          ),
        );


      } else {
        print("⚠️ Không thể lấy thông tin người dùng sau khi đăng ký.");
      }


      notifyListeners();
    } catch (e) {
      print("⚠️ Lỗi đăng ký Google: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đăng ký thất bại: $e')),
      );
    }
  }
  Future<void> login(BuildContext context) async {
    try {
      // 1️⃣ Mở hộp thoại đăng nhập Google
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        print("❌ Người dùng đã hủy đăng nhập Google");
        return;
      }

      // 2️⃣ Lấy token xác thực
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // 3️⃣ Tạo credential cho Firebase
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 4️⃣ Đăng nhập vào Firebase
      final UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        final String maKH = user.uid; // ✅ ID duy nhất trong Firebase
        print("✅ Đăng ký thành công: ${user.displayName}");
        print("🆔 Mã khách hàng (MaKH): $maKH");

        // 🔹 Sau khi đăng ký xong => chuyển sang Trang chủ và truyền maKH
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider(
              create: (_) => ThongTinViewModel(),
              child: DiaChi(maKH: maKH),
            ),
          ),
              (route) => false,
        );
      } else {
        print("⚠️ Không thể lấy thông tin người dùng sau khi đăng ký.");
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
