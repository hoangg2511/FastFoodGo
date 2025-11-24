// delivery_address_screen.dart
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Models/DiaChiModel.dart';
import '../../ViewModels/DiaChiViewModel.dart';


class DeliveryAddressScreen extends StatelessWidget {
  const DeliveryAddressScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DiaChiViewModel()..fetchDiaChi(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Địa chỉ giao hàng'),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () async {
                showDiaChiForm(context);
              },
            ),
          ],
        ),
        body: Consumer<DiaChiViewModel>(
          builder: (context, vm, child) {
            final addresses = vm.diaChiList;

            if (vm.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (addresses.isEmpty) {
              return const Center(child: Text("Chưa có địa chỉ nào"));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: addresses.length,
              itemBuilder: (context, index) {
                final diaChi = addresses[index];
                return Column(
                  children: [
                    _buildAddressCard(
                      context: context, // truyền context để dùng ViewModel
                      diaChi: diaChi,
                    ),
                    const SizedBox(height: 12),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildAddressCard({
    required BuildContext context,
    required DiaChiModel diaChi,
  }) {
    final vm = Provider.of<DiaChiViewModel>(context, listen: false);

    return Container(
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
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Địa chỉ',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if ((diaChi.status ?? 0) == 1) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.orange[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Mặc định',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.edit, size: 20),
                onPressed: () async {
                  showDiaChiForm(context, diaChi: diaChi);
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                onPressed: () async {
                  // Xóa địa chỉ
                  await vm.deleteDiaChi(diaChi.id);
                  await vm.fetchDiaChi();
                },
              ),
            ],
          ),
          Text(
            '${diaChi.DCCuThe}, ${diaChi.phuongXa}, ${diaChi.quanHuyen}, ${diaChi.tinhTp}',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '0123456789',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> showDiaChiForm(BuildContext context, {DiaChiModel? diaChi}) async {
    final vm = Provider.of<DiaChiViewModel>(context, listen: false);

    // Controllers
    final dCCuTheController = TextEditingController(text: diaChi?.DCCuThe ?? '');
    final phuongXaController = TextEditingController(text: diaChi?.phuongXa ?? '');
    final quanHuyenController = TextEditingController(text: diaChi?.quanHuyen ?? '');
    final tinhTpController = TextEditingController(text: diaChi?.tinhTp ?? '');
    final soNhaController = TextEditingController(text: diaChi?.soNha ?? '');
    final duongController = TextEditingController(text: diaChi?.Duong ?? '');

    final formKey = GlobalKey<FormState>();
    bool isDefault = (diaChi?.status ?? 0) == 1;
    bool isLoading = false;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Handle bar
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Title
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.orange[50],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            diaChi == null ? Icons.add_location_alt : Icons.edit_location_alt,
                            color: Colors.orange[700],
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          diaChi == null ? 'Thêm địa chỉ mới' : 'Chỉnh sửa địa chỉ',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Địa chỉ chi tiết section
                    _buildSectionTitle('Địa chỉ chi tiết'),
                    const SizedBox(height: 12),

                    _buildTextField(
                      controller: soNhaController,
                      label: 'Số nhà',
                      hint: 'VD: 123',
                      icon: Icons.home_outlined,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập số nhà';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    _buildTextField(
                      controller: duongController,
                      label: 'Tên đường',
                      hint: 'VD: Nguyễn Huệ',
                      icon: Icons.route_outlined,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập tên đường';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    _buildTextField(
                      controller: dCCuTheController,
                      label: 'Địa chỉ cụ thể',
                      hint: 'Tòa nhà, tầng, căn hộ...',
                      icon: Icons.location_on_outlined,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 24),

                    // Khu vực section
                    _buildSectionTitle('Khu vực'),
                    const SizedBox(height: 12),

                    _buildDropdownField(
                      controller: tinhTpController,
                      label: 'Tỉnh/Thành phố',
                      hint: 'Chọn tỉnh/thành phố',
                      icon: Icons.location_city_outlined,
                      onTap: () => _showLocationPicker(
                        context,
                        'Chọn Tỉnh/Thành phố',
                        ['Hồ Chí Minh', 'Hà Nội', 'Đà Nẵng', 'Cần Thơ', 'Hải Phòng'],
                            (value) => setState(() => tinhTpController.text = value),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng chọn tỉnh/thành phố';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    _buildDropdownField(
                      controller: quanHuyenController,
                      label: 'Quận/Huyện',
                      hint: 'Chọn quận/huyện',
                      icon: Icons.map_outlined,
                      onTap: () => _showLocationPicker(
                        context,
                        'Chọn Quận/Huyện',
                        ['Quận 1', 'Quận 2', 'Quận 3', 'Quận 4', 'Quận 5', 'Quận 7', 'Thủ Đức'],
                            (value) => setState(() => quanHuyenController.text = value),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng chọn quận/huyện';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    _buildDropdownField(
                      controller: phuongXaController,
                      label: 'Phường/Xã',
                      hint: 'Chọn phường/xã',
                      icon: Icons.holiday_village_outlined,
                      onTap: () => _showLocationPicker(
                        context,
                        'Chọn Phường/Xã',
                        ['Phường Bến Nghé', 'Phường Bến Thành', 'Phường Cô Giang', 'Phường Nguyễn Cư Trinh'],
                            (value) => setState(() => phuongXaController.text = value),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng chọn phường/xã';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    // Địa chỉ mặc định
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: CheckboxListTile(
                        value: isDefault,
                        onChanged: (value) {
                          setState(() => isDefault = value ?? false);
                        },
                        title: const Text(
                          'Đặt làm địa chỉ mặc định',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        subtitle: const Text(
                          'Địa chỉ này sẽ được sử dụng cho đơn hàng tiếp theo',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        activeColor: Colors.orange[700],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: isLoading ? null : () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              side: BorderSide(color: Colors.grey[300]!),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Hủy',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            onPressed: isLoading
                                ? null
                                : () async {
                              if (formKey.currentState!.validate()) {
                                setState(() => isLoading = true);

                                final newDiaChi = DiaChiModel(
                                  id: diaChi?.id ?? '',
                                  DCCuThe: dCCuTheController.text,
                                  soNha: soNhaController.text,
                                  Duong: duongController.text,
                                  phuongXa: phuongXaController.text,
                                  quanHuyen: quanHuyenController.text,
                                  tinhTp: tinhTpController.text,
                                  status: isDefault ? 1 : 0,
                                  maCH: diaChi?.maCH ?? '',
                                );

                                try {
                                  if (diaChi == null) {
                                    await vm.addDiaChi(newDiaChi);
                                  } else {
                                    await vm.updateDiaChi(newDiaChi);
                                  }
                                  await vm.fetchDiaChi();

                                  if (context.mounted) {
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          diaChi == null
                                              ? 'Thêm địa chỉ thành công'
                                              : 'Cập nhật địa chỉ thành công',
                                        ),
                                        backgroundColor: Colors.green,
                                        behavior: SnackBarBehavior.floating,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                    );
                                  }
                                } catch (e) {
                                  setState(() => isLoading = false);
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Lỗi: ${e.toString()}'),
                                        backgroundColor: Colors.red,
                                        behavior: SnackBarBehavior.floating,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                    );
                                  }
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange[700],
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: isLoading
                                ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                                : Text(
                              diaChi == null ? 'Thêm địa chỉ' : 'Cập nhật',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

    // Dispose controllers
    dCCuTheController.dispose();
    phuongXaController.dispose();
    quanHuyenController.dispose();
    tinhTpController.dispose();
    soNhaController.dispose();
    duongController.dispose();
  }

// Helper Widgets
  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 16,
          decoration: BoxDecoration(
            color: Colors.orange[700],
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
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
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.orange[700], size: 22),
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
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }

  Widget _buildDropdownField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required VoidCallback onTap,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      readOnly: true,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.orange[700], size: 22),
        suffixIcon: Icon(Icons.arrow_drop_down, color: Colors.grey[600], size: 24),
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

  void _showLocationPicker(BuildContext context, String title, List<String> options, Function(String) onSelected,) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Icon(Icons.location_on, color: Colors.orange[700]),
                  const SizedBox(width: 12),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Divider(color: Colors.grey[200], thickness: 1),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(Icons.location_city_outlined,
                        color: Colors.grey[600], size: 20),
                    title: Text(
                      options[index],
                      style: const TextStyle(fontSize: 15),
                    ),
                    onTap: () {
                      onSelected(options[index]);
                      Navigator.pop(context);
                    },
                    trailing: Icon(Icons.arrow_forward_ios,
                        size: 16, color: Colors.grey[400]),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}



// // payment_method_screen.dart
// class PaymentMethodScreen extends StatelessWidget {
//   const PaymentMethodScreen({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Phương thức thanh toán'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.add),
//             onPressed: () {
//               // Add new payment method
//             },
//           ),
//         ],
//       ),
//       body: ListView(
//         padding: const EdgeInsets.all(16),
//         children: [
//           _buildPaymentCard(
//             icon: Icons.credit_card,
//             title: 'Thẻ tín dụng',
//             subtitle: '**** **** **** 1234',
//             isDefault: true,
//           ),
//           const SizedBox(height: 12),
//           _buildPaymentCard(
//             icon: Icons.account_balance_wallet,
//             title: 'Ví điện tử MoMo',
//             subtitle: '0123 456 789',
//             isDefault: false,
//           ),
//           const SizedBox(height: 12),
//           _buildPaymentCard(
//             icon: Icons.money,
//             title: 'Tiền mặt',
//             subtitle: 'Thanh toán khi nhận hàng',
//             isDefault: false,
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildPaymentCard({
//     required IconData icon,
//     required String title,
//     required String subtitle,
//     required bool isDefault,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             spreadRadius: 1,
//             blurRadius: 4,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: ListTile(
//         leading: Container(
//           width: 40,
//           height: 40,
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             color: Colors.orange[50],
//           ),
//           child: Icon(icon, color: Colors.orange),
//         ),
//         title: Text(title),
//         subtitle: Text(subtitle),
//         trailing: isDefault
//             ? Container(
//           padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//           decoration: BoxDecoration(
//             color: Colors.orange[100],
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: const Text(
//             'Mặc định',
//             style: TextStyle(
//               fontSize: 10,
//               color: Colors.orange,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         )
//             : const Icon(Icons.settings_rounded, size: 23),
//         onTap: () {},
//       ),
//     );
//   }
// }
//
// // notifications_screen.dart
// class NotificationsScreen extends StatefulWidget {
//   const NotificationsScreen({Key? key}) : super(key: key);
//   @override
//   State<NotificationsScreen> createState() => _NotificationsScreenState();
// }
//
// class _NotificationsScreenState extends State<NotificationsScreen> {
//   bool _orderNotification = true;
//   bool _promotionNotification = false;
//   bool _emailNotification = true;
//   bool _smsNotification = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Thông báo'),
//       ),
//       body: ListView(
//         padding: const EdgeInsets.all(16),
//         children: [
//           Container(
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(12),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.1),
//                   spreadRadius: 1,
//                   blurRadius: 4,
//                   offset: const Offset(0, 2),
//                 ),
//               ],
//             ),
//             child: Column(
//               children: [
//                 _buildSwitchTile(
//                   icon: Icons.shopping_bag,
//                   title: 'Thông báo đơn hàng',
//                   subtitle: 'Nhận thông báo về trạng thái đơn hàng',
//                   value: _orderNotification,
//                   onChanged: (value) => setState(() => _orderNotification = value),
//                 ),
//                 _buildDivider(),
//                 _buildSwitchTile(
//                   icon: Icons.local_offer,
//                   title: 'Thông báo khuyến mãi',
//                   subtitle: 'Nhận thông báo về ưu đãi và khuyến mãi',
//                   value: _promotionNotification,
//                   onChanged: (value) => setState(() => _promotionNotification = value),
//                 ),
//                 _buildDivider(),
//                 _buildSwitchTile(
//                   icon: Icons.email,
//                   title: 'Thông báo email',
//                   subtitle: 'Nhận thông báo qua email',
//                   value: _emailNotification,
//                   onChanged: (value) => setState(() => _emailNotification = value),
//                 ),
//                 _buildDivider(),
//                 _buildSwitchTile(
//                   icon: Icons.sms,
//                   title: 'Thông báo SMS',
//                   subtitle: 'Nhận thông báo qua tin nhắn',
//                   value: _smsNotification,
//                   onChanged: (value) => setState(() => _smsNotification = value),
//                   isLast: true,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildSwitchTile({
//     required IconData icon,
//     required String title,
//     required String subtitle,
//     required bool value,
//     required Function(bool) onChanged,
//     bool isLast = false,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: Row(
//         children: [
//           Container(
//             width: 40,
//             height: 40,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: Colors.purple[50],
//             ),
//             child: Icon(icon, color: Colors.purple, size: 20),
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: const TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 Text(
//                   subtitle,
//                   style: TextStyle(
//                     fontSize: 12,
//                     color: Colors.grey[600],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Switch(
//             value: value,
//             onChanged: onChanged,
//             activeColor: Colors.orange,
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildDivider() {
//     return Container(
//       height: 1,
//       margin: const EdgeInsets.only(left: 72),
//       color: Colors.grey[100],
//     );
//   }
// }
//
// // support_screen.dart
// class SupportScreen extends StatelessWidget {
//   const SupportScreen({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Hỗ trợ'),
//       ),
//       body: ListView(
//         padding: const EdgeInsets.all(16),
//         children: [
//           // Contact Section
//           Container(
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(12),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.1),
//                   spreadRadius: 1,
//                   blurRadius: 4,
//                   offset: const Offset(0, 2),
//                 ),
//               ],
//             ),
//             child: Column(
//               children: [
//                 _buildContactTile(
//                   icon: Icons.phone,
//                   title: 'Hotline',
//                   subtitle: '1900 1234',
//                   onTap: () {},
//                 ),
//                 _buildDivider(),
//                 _buildContactTile(
//                   icon: Icons.email,
//                   title: 'Email hỗ trợ',
//                   subtitle: 'support@example.com',
//                   onTap: () {},
//                 ),
//                 _buildDivider(),
//                 _buildContactTile(
//                   icon: Icons.chat,
//                   title: 'Chat trực tuyến',
//                   subtitle: 'Hỗ trợ 24/7',
//                   onTap: () {},
//                   isLast: true,
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 16),
//           // FAQ Section
//           Container(
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(12),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.1),
//                   spreadRadius: 1,
//                   blurRadius: 4,
//                   offset: const Offset(0, 2),
//                 ),
//               ],
//             ),
//             child: Column(
//               children: [
//                 _buildFAQTile(
//                   question: 'Làm thế nào để đặt hàng?',
//                   onTap: () {},
//                 ),
//                 _buildDivider(),
//                 _buildFAQTile(
//                   question: 'Chính sách đổi trả như thế nào?',
//                   onTap: () {},
//                 ),
//                 _buildDivider(),
//                 _buildFAQTile(
//                   question: 'Thời gian giao hàng bao lâu?',
//                   onTap: () {},
//                 ),
//                 _buildDivider(),
//                 _buildFAQTile(
//                   question: 'Làm thế nào để hủy đơn hàng?',
//                   onTap: () {},
//                   isLast: true,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildContactTile({
//     required IconData icon,
//     required String title,
//     required String subtitle,
//     required VoidCallback onTap,
//     bool isLast = false,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Row(
//           children: [
//             Container(
//               width: 40,
//               height: 40,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Colors.cyan[50],
//               ),
//               child: Icon(icon, color: Colors.cyan, size: 20),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     title,
//                     style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   Text(
//                     subtitle,
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Colors.grey[600],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Icon(
//               Icons.arrow_forward_ios,
//               size: 16,
//               color: Colors.grey[400],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildFAQTile({
//     required String question,
//     required VoidCallback onTap,
//     bool isLast = false,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Row(
//           children: [
//             const Icon(Icons.help_outline, color: Colors.cyan),
//             const SizedBox(width: 16),
//             Expanded(
//               child: Text(
//                 question,
//                 style: const TextStyle(
//                   fontSize: 15,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ),
//             Icon(
//               Icons.arrow_forward_ios,
//               size: 16,
//               color: Colors.grey[400],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDivider() {
//     return Container(
//       height: 1,
//       margin: const EdgeInsets.only(left: 72),
//       color: Colors.grey[100],
//     );
//   }
// }
//
// // settings_screen.dart
// class SettingsScreen extends StatefulWidget {
//   const SettingsScreen({Key? key}) : super(key: key);
//
//   @override
//   State<SettingsScreen> createState() => _SettingsScreenState();
// }

// class _SettingsScreenState extends State<SettingsScreen> {
//   bool _darkMode = false;
//   bool _fingerprintAuth = true;
//   String _language = 'Tiếng Việt';
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Cài đặt'),
//       ),
//       body: ListView(
//         padding: const EdgeInsets.all(16),
//         children: [
//           // App Settings
//           Container(
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(12),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.1),
//                   spreadRadius: 1,
//                   blurRadius: 4,
//                   offset: const Offset(0, 2),
//                 ),
//               ],
//             ),
//             child: Column(
//               children: [
//                 _buildSwitchTile(
//                   icon: Icons.dark_mode,
//                   title: 'Chế độ tối',
//                   value: _darkMode,
//                   onChanged: (value) => setState(() => _darkMode = value),
//                 ),
//                 _buildDivider(),
//                 _buildTile(
//                   icon: Icons.language,
//                   title: 'Ngôn ngữ',
//                   subtitle: _language,
//                   onTap: _changeLanguage,
//                 ),
//                 _buildDivider(),
//                 _buildSwitchTile(
//                   icon: Icons.fingerprint,
//                   title: 'Xác thực sinh trắc học',
//                   value: _fingerprintAuth,
//                   onChanged: (value) => setState(() => _fingerprintAuth = value),
//                 ),
//                 _buildDivider(),
//                 _buildTile(
//                   icon: Icons.storage,
//                   title: 'Xóa cache',
//                   subtitle: '245 MB',
//                   onTap: _clearCache,
//                   isLast: true,
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 16),
//           // About Section
//           Container(
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(12),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.1),
//                   spreadRadius: 1,
//                   blurRadius: 4,
//                   offset: const Offset(0, 2),
//                 ),
//               ],
//             ),
//             child: Column(
//               children: [
//                 _buildTile(
//                   icon: Icons.info,
//                   title: 'Về ứng dụng',
//                   subtitle: 'Phiên bản 1.0.0',
//                   onTap: () {},
//                 ),
//                 _buildDivider(),
//                 _buildTile(
//                   icon: Icons.privacy_tip,
//                   title: 'Chính sách bảo mật',
//                   onTap: () {},
//                 ),
//                 _buildDivider(),
//                 _buildTile(
//                   icon: Icons.gavel,
//                   title: 'Điều khoản sử dụng',
//                   onTap: () {},
//                   isLast: true,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTile({
//     required IconData icon,
//     required String title,
//     String? subtitle,
//     required VoidCallback onTap,
//     bool isLast = false,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Row(
//           children: [
//             Container(
//               width: 40,
//               height: 40,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Colors.grey[100],
//               ),
//               child: Icon(icon, color: Colors.grey[600], size: 20),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     title,
//                     style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   if (subtitle != null)
//                     Text(
//                       subtitle,
//                       style: TextStyle(
//                         fontSize: 12,
//                         color: Colors.grey[600],
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//             Icon(
//               Icons.arrow_forward_ios,
//               size: 16,
//               color: Colors.grey[400],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildSwitchTile({
//     required IconData icon,
//     required String title,
//     required bool value,
//     required Function(bool) onChanged,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: Row(
//         children: [
//           Container(
//             width: 40,
//             height: 40,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: Colors.grey[100],
//             ),
//             child: Icon(icon, color: Colors.grey[600], size: 20),
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Text(
//               title,
//               style: const TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           Switch(
//             value: value,
//             onChanged: onChanged,
//             activeColor: Colors.orange,
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildDivider() {
//     return Container(
//       height: 1,
//       margin: const EdgeInsets.only(left: 72),
//       color: Colors.grey[100],
//     );
//   }
//
//   void _changeLanguage() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Chọn ngôn ngữ'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             RadioListTile<String>(
//               title: const Text('Tiếng Việt'),
//               value: 'Tiếng Việt',
//               groupValue: _language,
//               onChanged: (value) {
//                 setState(() => _language = value!);
//                 Navigator.pop(context);
//               },
//             ),
//             RadioListTile<String>(
//               title: const Text('English'),
//               value: 'English',
//               groupValue: _language,
//               onChanged: (value) {
//                 setState(() => _language = value!);
//                 Navigator.pop(context);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void _clearCache() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Xóa cache'),
//         content: const Text('Bạn có chắc chắn muốn xóa cache không?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Hủy'),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(
//                   content: Text('Đã xóa cache thành công'),
//                   backgroundColor: Colors.green,
//                 ),
//               );
//             },
//             child: const Text('Xóa'),
//           ),
//         ],
//       ),
//     );
//   }
// }