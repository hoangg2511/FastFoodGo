import 'package:fastfoodgo/ViewModels//NguoiDungViewModel.dart';
import 'package:fastfoodgo/Views/ThongBao.dart';
import 'package:flutter/material.dart';

import '../ViewModels/DangNhapViewModel.dart';

class DangKy extends StatefulWidget {
  const DangKy({super.key});

  @override
  State<DangKy> createState() => _DangKyState();
}

class _DangKyState extends State<DangKy> {
  final DangNhapViewModel _dangNhapVM = DangNhapViewModel();
  bool _AnMatKhau = true;
  bool _AnMatKhauConfirm= true;
  final TextEditingController textEmail = TextEditingController();
  final TextEditingController textMatKhau = TextEditingController();
  final TextEditingController textHoten = TextEditingController();
  final TextEditingController textSdt = TextEditingController();
  final TextEditingController textMatKhauConfirm = TextEditingController();
  final NguoiDungViewModel _controller = NguoiDungViewModel();


  void DangKyTaiKhoan() async {
    String email = textEmail.text.trim();
    String matKhau = textMatKhau.text.trim();
    String hoTen = textHoten.text.trim();
    String sdt = textSdt.text.trim();
    String matKhau1 = textMatKhauConfirm.text.trim();
    String msg = await _controller.dangKyTaiKhoan(email, matKhau, hoTen, sdt, matKhau1);
    ThongBao.show(context, msg, isError: msg.contains("Lỗi") || msg.contains("thất bại"));
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
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  "https://res.cloudinary.com/dwbzya1bk/image/upload/v1759599161/photo-1571091718767-18b5b1457add_nrrqej.jpg",
                  width: 130,
                  height: 130,
                  fit: BoxFit.cover,
                ),
              ),
              const Text(
                "FastFoodGo",
                style: TextStyle(
                  color: Color(0xFFFF6B35),
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                ),
              ),
              const SizedBox(height: 20),
              const Text("Tạo tài khoản mới",
              style: TextStyle(fontSize: 20,
              color: Color(0xff111827)),),

              const SizedBox(height: 20),
              //Họ tên
              TextField(
                controller: textHoten,
                decoration: InputDecoration(
                  labelText: 'Họ tên',
                  labelStyle: const TextStyle(
                    color: Colors.black, // đổi màu label text
                  ),
                  hintText: "Nhập họ và tên",
                  hintStyle: const TextStyle(
                    color: Colors.grey, // đổi màu hint text
                  ),
                  prefixIcon: const Icon(
                    Icons.person_2_outlined,
                    color: Color(0xff9ca3af), // đổi màu icon
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),),
                  filled: true, // bật nền
                  fillColor: const Color(0xfff9fafb),
                  // Viền khi chưa focus
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Color(0xffe9ebee), // màu viền
                      width: 1.5,               // độ dày viền
                    ),
                  ),

                  // Viền khi focus
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.black, // đổi màu khi focus
                      width: 2.0,               // dày hơn khi focus
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Email
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
                  filled: true, // bật nền
                  fillColor: const Color(0xfff9fafb),
                  // Viền khi chưa focus
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Color(0xffe9ebee), // màu viền
                      width: 1.5,               // độ dày viền
                    ),
                  ),

                  // Viền khi focus
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.black, // đổi màu khi focus
                      width: 2.0,               // dày hơn khi focus
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // SĐT
              TextField(
                controller: textSdt,
                decoration: InputDecoration(
                  labelText: 'Số điện thoại',
                  labelStyle: const TextStyle(
                    color: Colors.black, // đổi màu label text
                  ),
                  hintText: "Nhập số điện thoại",
                  hintStyle: const TextStyle(
                    color: Colors.grey, // đổi màu hint text
                  ),
                  prefixIcon: const Icon(
                    Icons.phone_outlined,
                    color: Color(0xff9ca3af), // đổi màu icon
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),),
                  filled: true, // bật nền
                  fillColor: const Color(0xfff9fafb),
                  // Viền khi chưa focus
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Color(0xffe9ebee), // màu viền
                      width: 1.5,               // độ dày viền
                    ),
                  ),
                  // Viền khi focus
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.black, // đổi màu khi focus
                      width: 2.0,               // dày hơn khi focus
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Mật khẩu
              TextField(
                controller: textMatKhau,
                obscureText: _AnMatKhau ,
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
                  filled: true, // bật nền
                  fillColor: const Color(0xfff9fafb),
                  // Viền khi chưa focus
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Color(0xffe9ebee), // màu viền
                      width: 1.5,               // độ dày viền
                    ),
                  ),

                  // Viền khi focus
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.black, // đổi màu khi focus
                      width: 2.0,               // dày hơn khi focus
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Nhập lại mật khẩu
              TextField(
                controller: textMatKhauConfirm,
                obscureText: _AnMatKhauConfirm,
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
                      _AnMatKhauConfirm
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Color(0xff9ca3af), // đổi màu icon
                    ),
                    onPressed: () {
                      setState(() {
                        _AnMatKhauConfirm = !_AnMatKhauConfirm;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),),
                  filled: true, // bật nền
                  fillColor: const Color(0xfff9fafb),
                  // Viền khi chưa focus
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Color(0xffe9ebee), // màu viền
                      width: 1.5,               // độ dày viền
                    ),
                  ),

                  // Viền khi focus
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.black, // đổi màu khi focus
                      width: 2.0,               // dày hơn khi focus
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Nút đăng ký
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: DangKyTaiKhoan,
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
                    "Đăng ký",
                    style: TextStyle(fontWeight: FontWeight.bold,
                    fontSize: 15),
                  ),
                ),
              ),

              const SizedBox(height: 20),
              // Divider "hoặc"
              Row(
                children: const [
                  Expanded(
                      child:
                      Divider(color: Color(0xff6b7280), thickness: 1, endIndent: 10)),
                  Text("Hoặc", style: TextStyle(color: Color(0xff6b7280))),
                  Expanded(
                      child:
                      Divider(color: Color(0xff6b7280), thickness: 1, indent: 10)),
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
                        width: 1,                 // độ dày viền
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
                  onPressed: () {_dangNhapVM.login(context);},
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Color(0xfff9fafb),
                    foregroundColor: Color(0xff374151),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(
                        color: Color(0xffe9ebee), // màu viền
                        width: 1,                 // độ dày viền
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

              const SizedBox(height: 20),

              // Đăng nhập ngay
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Đã có tài khoản ?",style: TextStyle(color: Color(0xff6b7280)),),
                  TextButton(
                  onPressed: () {_controller.dangNhapNgay(context);},
                    child: const Text(
                      "Đăng nhập ngay",
                      style: TextStyle(color:Color(0xFFFF6B35),
                      fontWeight: FontWeight.bold),
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
