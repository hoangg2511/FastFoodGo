import 'package:fastfoodgo/ViewModels/DangNhapViewModel.dart';
import 'package:fastfoodgo/Views/DangNhap.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../ViewModels/DiaChiViewModel.dart';
import '../ViewModels/NguoiDungViewModel.dart';
import '../Models/NguoiDungModel.dart';
import 'Profile/ThongTinCaNhan.dart';
import 'Profile/TrangKhac.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final DangNhapViewModel _dangNhapMV = DangNhapViewModel();
  final NguoiDungViewModel _viewModel = NguoiDungViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Tài khoản',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile Card
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  // Profile Image
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[200],
                    ),
                    child: const Icon(Icons.person, size: 30, color: Colors.grey),
                  ),
                  const SizedBox(width: 16),
                  // User Details
                  Expanded(
                    child: FutureBuilder<NguoiDung?>(
                      future: _viewModel.getNguoiDungHienTai(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        if (!snapshot.hasData || snapshot.data == null) {
                          return const Text("Không có dữ liệu người dùng");
                        }

                        final user = snapshot.data!;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.hoTen,
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[800]),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              user.email,
                              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              user.sdt?.toString() ?? "Chưa có số điện thoại",
                              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  // Message Icon
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.orange[50],
                    ),
                    child: const Icon(Icons.credit_card, size: 20, color: Colors.orange),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Menu Items Card
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildMenuItem(
                    icon: Icons.person,
                    iconColor: Colors.blue,
                    iconBgColor: Colors.blue[50]!,
                    title: 'Thông tin cá nhân',
                    subtitle: 'Quản lý thông tin tài khoản',
                    onTap: () => _navigateToPersonalInfo(),
                  ),
                  _buildDivider(),
                  _buildMenuItem(
                    icon: Icons.location_on,
                    iconColor: Colors.green,
                    iconBgColor: Colors.green[50]!,
                    title: 'Địa chỉ giao hàng',
                    subtitle: 'Quản lý địa chỉ nhận hàng',
                    onTap: () => _navigateToDeliveryAddress(context),
                  ),
                  // _buildDivider(),
                  // _buildMenuItem(
                  //   icon: Icons.payment,
                  //   iconColor: Colors.orange,
                  //   iconBgColor: Colors.orange[50]!,
                  //   title: 'Phương thức thanh toán',
                  //   subtitle: 'Thẻ và ví điện tử',
                  //   onTap: () => _navigateToPaymentMethod(),
                  // ),
                  // _buildDivider(),
                  // _buildMenuItem(
                  //   icon: Icons.notifications,
                  //   iconColor: Colors.purple,
                  //   iconBgColor: Colors.purple[50]!,
                  //   title: 'Thông báo',
                  //   subtitle: 'Cài đặt thông báo',
                  //   onTap: () => _navigateToNotifications(),
                  // ),
                  // _buildDivider(),
                  // _buildMenuItem(
                  //   icon: Icons.help,
                  //   iconColor: Colors.cyan,
                  //   iconBgColor: Colors.cyan[50]!,
                  //   title: 'Hỗ trợ',
                  //   subtitle: 'Liên hệ và FAQ',
                  //   onTap: () => _navigateToSupport(),
                  // ),
                  // _buildDivider(),
                  // _buildMenuItem(
                  //   icon: Icons.settings,
                  //   iconColor: Colors.grey[600]!,
                  //   iconBgColor: Colors.grey[100]!,
                  //   title: 'Cài đặt',
                  //   subtitle: null,
                  //   onTap: () => _navigateToSettings(),
                  //   isLast: true,
                  // ),
                  _buildDivider(),
                  _buildMenuItem(
                    icon: Icons.logout,
                    iconColor: Colors.red[600]!,
                    iconBgColor: Colors.grey[100]!,
                    title: 'Đăng xuất',
                    subtitle: null,
                    onTap: () => _navigateToLogout(),
                    isLast: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    bool isLast = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(isLast ? 12 : 0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(shape: BoxShape.circle, color: iconBgColor),
              child: Icon(icon, size: 20, color: iconColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey[800])),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                  ],
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() => Container(height: 1, margin: const EdgeInsets.only(left: 72), color: Colors.grey[100]);

  void _navigateToPersonalInfo() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => PersonalInfoScreen()));
  }
  void _navigateToDeliveryAddress(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider(
          create: (_) => DiaChiViewModel(),
          child: DeliveryAddressScreen(),
        ),
      ),
    );
  }

  // void _navigateToPaymentMethod() {
  //   Navigator.push(context, MaterialPageRoute(builder: (_) => PaymentMethodScreen()));
  // }
  //
  // void _navigateToNotifications() {
  //   Navigator.push(context, MaterialPageRoute(builder: (_) => NotificationsScreen()));
  // }
  //
  // void _navigateToSupport() {
  //   Navigator.push(context, MaterialPageRoute(builder: (_) => SupportScreen()));
  // }
  //
  // void _navigateToSettings() {
  //   Navigator.push(context, MaterialPageRoute(builder: (_) => SettingsScreen()));
  // }
  void _navigateToLogout() {
    _dangNhapMV.logout();
    Navigator.push(context, MaterialPageRoute(builder: (_) => DangNhap()));
  }

}
