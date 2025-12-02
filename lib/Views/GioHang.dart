import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Models/GioHangModel.dart';
import '../ViewModels/GioHangViewModel.dart';
import '../ViewModels/ThanhToanViewModel.dart';
import '../ViewModels/VnPayViewModel.dart';
import 'ThanhToan.dart';

class GioHangScreen extends StatelessWidget {
  const GioHangScreen({super.key});

  String _formatPrice(double price) {
    return '${price.toInt().toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
    )} đ';
  }

  @override
  Widget build(BuildContext context) {
    final cartVM = context.watch<GioHangViewModel>();
    final cartItems = cartVM.items;
    final totalPrice = cartVM.totalPrice;
    // final finalTotal = totalPrice + (cartItems.isEmpty ? 0 : 15000);
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Giỏ hàng',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (cartItems.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () => _showClearCartDialog(context, cartVM),
            ),
        ],
      ),
      body: cartItems.isEmpty
          ? gioHangRong(context, cartVM)
          : ContainerGioHang(context, cartVM, _formatPrice),
      bottomNavigationBar:
      cartItems.isNotEmpty ? buttonThanhToan(context, totalPrice, _formatPrice, cartVM) : null,
    );
  }

  Widget gioHangRong(BuildContext context, GioHangViewModel vm) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.orange[50],
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.shopping_cart_outlined, size: 60, color: Colors.orange[300]),
          ),
          const SizedBox(height: 24),
          const Text(
            'Giỏ hàng trống',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text('Hãy thêm món vào giỏ để bắt đầu đặt hàng', style: TextStyle(color: Colors.grey[600])),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: (){
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange[600],
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            ),
            child: const Text('Mua sắm ngay', style: TextStyle(fontSize: 16, color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget ContainerGioHang(BuildContext context, GioHangViewModel vm, String Function(double) formatPrice) {
    final cartItems = vm.items;
    // final total = vm.totalPrice + (cartItems.isEmpty ? 0 : 15000);
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: cartItems.length,
            itemBuilder: (context, index) {
              final item = cartItems[index];
              return MonAn(context, vm, item, formatPrice,index);
            },
          ),
        ),
        tomTaDonHang(vm.totalPrice, vm.totalPrice, formatPrice),
      ],
    );
  }

  Widget MonAn(BuildContext context, GioHangViewModel vm, GioHangModel item, String Function(double) formatPrice, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 70,
                  height: 70,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: FadeInImage.assetNetwork(
                    placeholder: 'assets/placeholder.png',
                    image: item.imgUrl,
                    fit: BoxFit.cover,
                    imageErrorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey[300],
                      child: Icon(Icons.restaurant, color: Colors.grey[600], size: 28),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              item.tenMonAn,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.close, color: Colors.red[400], size: 20),
                            onPressed: () => vm.removeItem(index),
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(),
                          ),
                        ],
                      ),
                      if (item.selectedOptions != null && item.selectedOptions!.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 6,
                          children: item.selectedOptions!.entries.map((entry) => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.orange[50],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.orange[200]!),
                            ),
                            child: Text(
                              '${entry.key}: ${entry.value}',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.orange[700],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )).toList(),
                        ),
                      ],
                      if (item.note.isNotEmpty) ...[
                        if (item.note.isNotEmpty) ...[
                          SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.orange[50],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.orange[200]!,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.edit_note_rounded,
                                  size: 16,
                                  color: Colors.orange[700],
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Ghi chú: ${item.note}",
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.orange[700],
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatPrice(item.finalPrice),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange[700],
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () => vm.updateQuantity(index, false),
                      icon: const Icon(Icons.remove),
                      color: Colors.orange[700],
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        item.quantity.toString(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => vm.updateQuantity(index, true),
                      icon: const Icon(Icons.add),
                      color: Colors.orange[700],
                    ),

                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


  Widget tomTaDonHang(double subtotal, double totalPrice, String Function(double) formatPrice) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, -5))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Tóm tắt đơn hàng',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87)),
        const SizedBox(height: 16),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Tạm tính', style: TextStyle(color: Colors.grey[600])),
          Text(formatPrice(subtotal)),
        ]),
        // const SizedBox(height: 8),
        // Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        //   Text('Phí giao hàng', style: TextStyle(color: Colors.grey[600])),
        //   Text(formatPrice(subtotal == 0 ? 0 : 15000)),
        // ]),
        const Divider(height: 24),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text('Tổng cộng',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 16)),
          Text(formatPrice(totalPrice),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.orange[700])),
        ]),
      ]),
    );
  }

  Widget buttonThanhToan(BuildContext context, double totalPrice, String Function(double) formatPrice, GioHangViewModel vm,) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(color: Colors.white),
      child: SafeArea(
        child: ElevatedButton(
          // Vì hàm này nhận tham số GioHangViewModel vm, ta dùng nó
          onPressed: () {
            // Lấy ViewModel instance hiện tại bằng context.read (không cần listen)
            final vm = context.read<GioHangViewModel>();

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MultiProvider(
                  providers: [
                    ChangeNotifierProvider.value(value: vm),
                    ChangeNotifierProvider<ThanhToanViewModel>(create: (_) => ThanhToanViewModel(),),
                    ChangeNotifierProvider(create: (_) => VnPayViewModel()),
                  ],
                  child: const ThanhToanScreen(),
                ),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange[700],
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.payment, color: Colors.white),
              const SizedBox(width: 10),
              const Text(
                "Thanh toán",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  formatPrice(totalPrice),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  void _showClearCartDialog(BuildContext context, GioHangViewModel vm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xóa tất cả món'),
        content: const Text('Bạn có chắc chắn muốn xóa tất cả món trong giỏ hàng?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy')),
          TextButton(
            onPressed: () {
              vm.resetCart();
              Navigator.pop(context);
            },
            child: const Text('Xóa', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
