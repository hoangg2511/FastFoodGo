import 'package:fastfoodgo/ViewModels/DangNhapViewModel.dart';
import 'package:fastfoodgo/ViewModels/NguoiDungViewModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Nav.dart';



class DangNhap extends StatefulWidget{
  @override

  State<DangNhap> createState() => _DangNhapState();

}


class _DangNhapState extends State<DangNhap> {
  final DangNhapViewModel _dangNhapVM = DangNhapViewModel();
  bool _AnMatKhau = true;
  final NguoiDungViewModel _viewModel = NguoiDungViewModel();
  final TextEditingController textEmail = TextEditingController();
  final TextEditingController textMatKhau = TextEditingController();

  Future<void> DangNhap(BuildContext context) async {
    print("Gọi đăng nhập...");

    String email = textEmail.text.trim();
    String matKhau = textMatKhau.text.trim();

    final vm = context.read<NguoiDungViewModel>();  // Provider đã tồn tại
    final user = await vm.dangNhap(email, matKhau);

    if (user != null) {
      print("Login thành công, chuyển trang...");

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider.value(
            value: vm,                 // TRUYỀN CÙNG VIEWMODEL SANG TRANG CHỦ
            child: Trangchu(),
          ),
        ),
            (route) => false,
      );
    }
  }

  Future<void> DangNhapGG(BuildContext context) async {
    print("Gọi đăng nhập...");


    final vm = context.read<NguoiDungViewModel>();
    final dangNhapVM = context.read<DangNhapViewModel>();
    final user = await dangNhapVM.DangNhapGG(context);

    if (user != null) {
      print("Login thành công, chuyển trang...");

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider.value(
            value: vm,                 // TRUYỀN CÙNG VIEWMODEL SANG TRANG CHỦ
            child: Trangchu(),
          ),
        ),
            (route) => false,
      );
    }
  }


    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 70,),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    "https://res.cloudinary.com/dwbzya1bk/image/upload/v1759599161/photo-1571091718767-18b5b1457add_nrrqej.jpg",
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 50,),
                Text(
                  "FastFoodGo",
                  style: TextStyle(
                    color: Colors.deepOrange,
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                  ),
                ),
                SizedBox(height: 10),
                Text("Đăng nhập để tiếp tục"),
                SizedBox(height: 20,),
                // Input fields
                TextField(
                  controller: textEmail,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: const TextStyle(
                      color: Colors.black, // đổi màu label text
                    ),
                    hintText: 'example@email.com',
                    hintStyle: const TextStyle(
                      color: Colors.grey, // đổi màu hint text
                    ),
                    prefixIcon: const Icon(
                      Icons.mail_outline,
                      color: Color(0xff9ca3af), // đổi màu icon
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),),
                    filled: true,
                    // bật nền
                    fillColor: const Color(0xfff9fafb),
                    // Viền khi chưa focus
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Color(0xffe9ebee), // màu viền
                        width: 1.5, // độ dày viền
                      ),
                    ),

                    // Viền khi focus
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.black, // đổi màu khi focus
                        width: 2.0, // dày hơn khi focus
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                TextField(
                  controller: textMatKhau,
                  obscureText: _AnMatKhau,
                  decoration: InputDecoration(
                    labelText: 'Mật khẩu',
                    labelStyle: const TextStyle(
                      color: Colors.black, // đổi màu label text
                    ),
                    hintText: "Nhập lại mật khẩu",
                    hintStyle: const TextStyle(
                      color: Colors.grey, // đổi màu hint text
                    ),
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: Color(0xff9ca3af), // đổi màu icon
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _AnMatKhau
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Color(0xff9ca3af), // đổi màu icon
                      ),
                      onPressed: () {
                        setState(() {
                          _AnMatKhau = !_AnMatKhau;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),),
                    filled: true,
                    // bật nền
                    fillColor: const Color(0xfff9fafb),
                    // Viền khi chưa focus
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Color(0xffe9ebee), // màu viền
                        width: 1.5, // độ dày viền
                      ),
                    ),

                    // Viền khi focus
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.black, // đổi màu khi focus
                        width: 2.0, // dày hơn khi focus
                      ),
                    ),
                  ),
                ),

                // Quên mật khẩu
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      "Quên mật khẩu ?",
                      style: TextStyle(color: Color(0xFFFF6B35),
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                  ),
                ),

                // Đăng nhập
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: (){DangNhap(context);},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFF6B35),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                    ),
                    child: const Text(
                      "Đăng Nhập",
                      style: TextStyle(fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                  ),
                ),

                // Divider "hoặc"
                SizedBox(height: 20),
                Row(
                  children: const [
                    Expanded(
                        child:
                        Divider(color: Color(0xff6b7280),
                            thickness: 1,
                            endIndent: 10)),
                    Text("Hoặc", style: TextStyle(color: Color(0xff6b7280))),
                    Expanded(
                        child:
                        Divider(color: Color(0xff6b7280),
                            thickness: 1,
                            indent: 10)),
                  ],
                ),
                const SizedBox(height: 20),
                // Social buttons
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Color(0xfff9fafb),
                      foregroundColor: Color(0xff374151),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(
                          color: Color(0xffe9ebee), // màu viền
                          width: 1, // độ dày viền
                        ),),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                    ),
                    child: const Text(
                      "Tiếp tục với Facebook",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {DangNhapGG(context);},
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Color(0xfff9fafb),
                      foregroundColor: Color(0xff374151),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(
                          color: Color(0xffe9ebee), // màu viền
                          width: 1, // độ dày viền
                        ),),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                    ),
                    child: const Text(
                      "Tiếp tục với Google",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                // Đăng ký ngay
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Chưa có tài khoản ?",
                      style: TextStyle(color: Color(0xff6b7280)),),
                    TextButton(
                      onPressed: () {
                        _viewModel.dangKyNgay(context);
                      },
                      child: Text(
                        "Đăng ký ngay",
                        style: TextStyle(color: Color(0xFFFF6B35)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

