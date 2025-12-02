import 'package:fastfoodgo/Models/DiaChiModel.dart';
import 'package:fastfoodgo/Models/NguoiDungModel.dart';
import 'package:fastfoodgo/ViewModels/DangNhapViewModel.dart';
import 'package:fastfoodgo/ViewModels/DiaChiViewModel.dart';
import 'package:fastfoodgo/ViewModels/NguoiDungViewModel.dart';
import 'package:fastfoodgo/ViewModels/ThongTinViewModel.dart';
import 'package:fastfoodgo/ViewModels/TrangChuViewModel.dart';
import 'package:fastfoodgo/Views/DangNhap.dart';
import 'package:fastfoodgo/Views/Nav.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'TrangChu.dart';

class DiaChi extends StatefulWidget {
  final String maKH;
  final String email;
  final Map<String, dynamic>? existingAddress;

  const DiaChi({super.key, this.existingAddress, required this.maKH, required this.email});

  @override
  State<DiaChi> createState() => _CapNhatDiaChiPageState();
}

class _CapNhatDiaChiPageState extends State<DiaChi> {
  late ThongTinViewModel thongTin;
  late String email;
  late String maKH;

  final _formKey = GlobalKey<FormState>();
  final _hoTenController = TextEditingController();
  final _soDienThoaiController = TextEditingController();
  final _diaChiController = TextEditingController();
  final _phuongXaController = TextEditingController();
  final _quanHuyenController = TextEditingController();
  final _tinhThanhController = TextEditingController();
  final _matKhauHienTaiController = TextEditingController();
  final _matKhauMoiController = TextEditingController();
  final _xacNhanMatKhauController = TextEditingController();

  bool _isDefaultAddress = false;
  bool _isLoading = false;
  bool _showPasswordFields = false;
  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();

    /// ❗ GÁN GIÁ TRỊ ĐÚNG TỪ widget
    email = widget.email;
    maKH = widget.maKH;

    thongTin = Provider.of<ThongTinViewModel>(context, listen: false);

    if (widget.existingAddress != null) {
      _hoTenController.text = widget.existingAddress!['hoTen'] ?? '';
      _soDienThoaiController.text = widget.existingAddress!['soDienThoai'] ?? '';
      _diaChiController.text = widget.existingAddress!['diaChi'] ?? '';
      _phuongXaController.text = widget.existingAddress!['phuongXa'] ?? '';
      _quanHuyenController.text = widget.existingAddress!['quanHuyen'] ?? '';
      _tinhThanhController.text = widget.existingAddress!['tinhThanh'] ?? '';
      _isDefaultAddress = widget.existingAddress!['isDefault'] ?? false;
    }
  }

  @override
  void dispose() {
    _hoTenController.dispose();
    _soDienThoaiController.dispose();
    _diaChiController.dispose();
    _phuongXaController.dispose();
    _quanHuyenController.dispose();
    _tinhThanhController.dispose();
    _matKhauHienTaiController.dispose();
    _matKhauMoiController.dispose();
    _xacNhanMatKhauController.dispose();
    super.dispose();
  }

  Future<void> CapNhatThongTin(BuildContext context) async {
    print("➡️ Gọi hàm cập nhật thông tin");

    final ten = _hoTenController.text.trim();
    final sdt = _soDienThoaiController.text.trim();
    final diaChi = _diaChiController.text.trim();
    final phuongXa = _phuongXaController.text.trim();
    final quanHuyen = _quanHuyenController.text.trim();
    final tinhTP = _tinhThanhController.text.trim();
    final trangThaiInt = _isDefaultAddress ? 1 : 0;

    if (ten.isEmpty || sdt.isEmpty || diaChi.isEmpty ||
        phuongXa.isEmpty || quanHuyen.isEmpty || tinhTP.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng nhập đầy đủ thông tin")),
      );
      return;
    }

    if (_showPasswordFields) {
      if (_matKhauMoiController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Vui lòng nhập mật khẩu")),
        );
        return;
      }
      if (_matKhauMoiController.text.length < 6) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Mật khẩu phải có ít nhất 6 ký tự")),
        );
        return;
      }
      if (_matKhauMoiController.text != _xacNhanMatKhauController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Mật khẩu xác nhận không khớp")),
        );
        return;
      }


    }
    print("thêm thông tin và địa chỉ");

    await thongTin.ThemDiaChi(
      ten,
      sdt,
      phuongXa,
      quanHuyen,
      tinhTP,
      trangThaiInt,
      diaChi,
      maKH,
      email,
      _matKhauMoiController.text,
    );
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => DangNhap()),
          (route) => false,
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Cập nhật thông tin',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Thông tin liên hệ
            _buildSectionTitle('Thông tin liên hệ', Icons.person),
            const SizedBox(height: 12),
            _buildTextField(
              controller: _hoTenController,
              label: 'Họ và tên',
              hint: 'Nhập họ và tên người nhận',
              icon: Icons.person_outline,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập họ và tên';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _soDienThoaiController,
              label: 'Số điện thoại',
              hint: 'Nhập số điện thoại',
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập số điện thoại';
                }
                if (value.length < 10) {
                  return 'Số điện thoại không hợp lệ';
                }
                return null;
              },
            ),

            const SizedBox(height: 24),
            // Đổi mật khẩu section
            _buildSectionTitle('Bảo mật', Icons.lock),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.orange[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.vpn_key, color: Colors.orange[700], size: 20),
                    ),
                    title: const Text(
                      'Nhập thông tin mật khẩu',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    // subtitle: Text(
                    //   'Nhập thông tin mật khẩu mới',
                    //   style: TextStyle(fontSize: 12, color: Colors.grey),
                    // ),
                  ),

                  Divider(color: Colors.grey[200], height: 1),

                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const SizedBox(height: 16),

                        _buildPasswordField(
                          controller: _matKhauMoiController,
                          label: 'Mật khẩu ',
                          hint: 'Nhập mật khẩu  (tối thiểu 6 ký tự)',
                          obscureText: _obscureNewPassword,
                          onToggleVisibility: () {
                            setState(() => _obscureNewPassword = !_obscureNewPassword);
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Vui lòng nhập mật khẩu ';
                            }
                            if (value.length < 6) {
                              return 'Mật khẩu phải có ít nhất 6 ký tự';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        _buildPasswordField(
                          controller: _xacNhanMatKhauController,
                          label: 'Xác nhận mật khẩu ',
                          hint: 'Nhập lại mật khẩu ',
                          obscureText: _obscureConfirmPassword,
                          onToggleVisibility: () {
                            setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Vui lòng xác nhận mật khẩu';
                            }
                            if (value != _matKhauMoiController.text) {
                              return 'Mật khẩu xác nhận không khớp';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 12),

                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.info_outline, color: Colors.blue[700], size: 20),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Mật khẩu mạnh nên có ít nhất 8 ký tự, bao gồm chữ hoa, chữ thường và số',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.blue[700],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

            ),

            const SizedBox(height: 32),
            // Địa chỉ
            _buildSectionTitle('Địa chỉ', Icons.location_on),
            const SizedBox(height: 12),
            _buildTextField(
              controller: _tinhThanhController,
              label: 'Tỉnh/Thành phố',
              hint: 'Chọn tỉnh/thành phố',
              icon: Icons.location_city_outlined,
              readOnly: true,
              onTap: () => _showLocationPicker('Tỉnh/Thành phố'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng chọn tỉnh/thành phố';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _quanHuyenController,
              label: 'Quận/Huyện',
              hint: 'Chọn quận/huyện',
              icon: Icons.location_on_outlined,
              readOnly: true,
              onTap: () => _showLocationPicker('Quận/Huyện'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng chọn quận/huyện';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _phuongXaController,
              label: 'Phường/Xã',
              hint: 'Chọn phường/xã',
              icon: Icons.map_outlined,
              readOnly: true,
              onTap: () => _showLocationPicker('Phường/Xã'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng chọn phường/xã';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _diaChiController,
              label: 'Địa chỉ cụ thể',
              hint: 'Số nhà, tên đường...',
              icon: Icons.home_outlined,
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập địa chỉ cụ thể';
                }
                return null;
              },
            ),

            const SizedBox(height: 24),

            // Địa chỉ mặc định
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: CheckboxListTile(
                value: _isDefaultAddress,
                onChanged: (value) {
                  setState(() => _isDefaultAddress = value ?? false);
                },
                title: const Text(
                  'Đặt làm địa chỉ mặc định',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                activeColor: Colors.orange[700],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 24),


            // Nút lưu
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : () => CapNhatThongTin(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange[700],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: _isLoading
                    ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
                    : const Text(
                  'Cập nhật thông tin',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.orange[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.orange[700], size: 20),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int maxLines = 1,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        validator: validator,
        keyboardType: keyboardType,
        maxLines: maxLines,
        readOnly: readOnly,
        onTap: onTap,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon, color: Colors.orange[700]),
          suffixIcon: readOnly
              ? Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400])
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required bool obscureText,
    required VoidCallback onToggleVisibility,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(Icons.lock_outline, color: Colors.orange[700]),
        suffixIcon: IconButton(
          icon: Icon(
            obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
            color: Colors.grey[600],
          ),
          onPressed: onToggleVisibility,
        ),
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[200]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[200]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.orange[700]!, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }

  void _showLocationPicker(String title) {
    final List<String> locations = title == 'Tỉnh/Thành phố'
        ? ['Hồ Chí Minh', 'Hà Nội', 'Đà Nẵng', 'Cần Thơ', 'Hải Phòng']
        : title == 'Quận/Huyện'
        ? ['Quận 1', 'Quận 2', 'Quận 3', 'Quận 4', 'Quận 5', 'Quận 7', 'Thủ Đức', 'Tân Bình', 'Tân Phú', 'Bình Tân', 'Nhà Bè']
        : ['Phường Bến Nghé', 'Phường Bến Thành', 'Phường Cô Giang', 'Phường Nguyễn Cư Trinh'];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Chọn $title',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: locations.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(locations[index]),
                    onTap: () {
                      if (title == 'Tỉnh/Thành phố') {
                        _tinhThanhController.text = locations[index];
                      } else if (title == 'Quận/Huyện') {
                        _quanHuyenController.text = locations[index];
                      } else {
                        _phuongXaController.text = locations[index];
                      }
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}