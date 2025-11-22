import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../ViewModels/ChitietCuaHangViewModel.dart';
import '../ViewModels/GioHangViewModel.dart';
import '../ViewModels/YeuThichViewModel.dart';
import '../Models/CuaHangModel.dart';
import '../Models/DiaChiModel.dart';
import 'ChiTietCuaHang.dart';

class CuaHangYeuThich extends StatelessWidget {
  const CuaHangYeuThich({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => YeuThichViewModel(), // Khởi tạo và gọi loadDanhSach()
      child: Consumer<YeuThichViewModel>(
        // Sử dụng Consumer để lắng nghe và rebuild các widget cần thiết
        builder: (context, viewModel, child) {
          // 'viewModel' ở đây đã là một listener (giống context.watch)

          return Scaffold(
            backgroundColor: Colors.grey[50],
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              title: const Text(
                'Yêu thích',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: Icon(Icons.delete_outline, color: Colors.red[400]),
                  onPressed: () {
                    // Dùng context.read để gọi hàm không cần rebuild toàn bộ AppBar
                    final viewModelRead = context.read<YeuThichViewModel>();
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Xóa tất cả'),
                        content: const Text(
                            'Bạn có chắc muốn xóa tất cả cửa hàng yêu thích?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Hủy'),
                          ),
                          TextButton(
                            onPressed: () {
                              viewModelRead.xoaTatCa(); // Gọi hàm xóa
                              Navigator.pop(context);
                            },
                            child: const Text('Xóa',
                                style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
            body: _buildBody(context, viewModel),
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, YeuThichViewModel viewModel) {
    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (viewModel.danhSachCuaHang.isEmpty) {
      return _buildEmptyState();
    }

    final combinedList = viewModel.danhSachCuaHang;

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: combinedList.length,
      itemBuilder: (context, index) {
        final item = combinedList[index];
        final cuaHang = item['cuaHang'] as CuaHangModel;
        final diaChiList = item['diaChi'] as List<DiaChiModel>;
        // Truyền viewModel đã là listener để _buildBtnXoa gọi hàm
        return _buildStoreCard(context, cuaHang, diaChiList, viewModel);
      },
    );
  }

  Widget _buildEmptyState() {
    // Logic của hàm này giữ nguyên
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.red[50],
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.favorite_border,
                size: 80, color: Colors.red),
          ),
          const SizedBox(height: 24),
          const Text(
            'Chưa có cửa hàng yêu thích',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            'Hãy thêm cửa hàng bạn yêu thích\nđể xem lại sau',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildStoreCard(BuildContext context, CuaHangModel cuaHang,
      List<DiaChiModel> diaChiList, YeuThichViewModel viewModel) {
    bool isDangMoCua = cuaHang.TrangThai.toLowerCase().contains('đang mở');
    String diaChiText = diaChiList.isNotEmpty
        ? diaChiList
        .map((dc) =>
    '${dc.Duong}, ${dc.phuongXa}, ${dc.quanHuyen}, ${dc.tinhTp}')
        .join(' | ')
        : 'Chưa có địa chỉ';
     return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MultiProvider(
              providers: [
                ChangeNotifierProvider(
                  create: (_) => ChitietCuaHangViewModel(),
                ),
                ChangeNotifierProvider(
                  create: (_) => GioHangViewModel(),
                ),
                ChangeNotifierProvider(
                  create: (_) => YeuThichViewModel(),
                ),
              ],
              child: ShopDetail(CuaHangId: cuaHang.id,),
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                _buildAnhBia(cuaHang),
                _buildTrangThaiBadge(cuaHang, isDangMoCua),
                _buildBtnXoa(context, cuaHang, viewModel),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cuaHang.TenCuaHang,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text('${cuaHang.DanhGia}',
                          style: const TextStyle(fontWeight: FontWeight.w600)),
                      const SizedBox(width: 12),
                      const Icon(Icons.location_on,
                          size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(child: Text(diaChiText)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

  }

  Widget _buildAnhBia(CuaHangModel cuaHang) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        image: cuaHang.AnhBia != null
            ? DecorationImage(
            image: NetworkImage(cuaHang.AnhBia!), fit: BoxFit.cover)
            : null,
        color: Colors.grey[300],
      ),
    );
  }

  Widget _buildTrangThaiBadge(CuaHangModel cuaHang, bool isDangMoCua) {
    return Positioned(
      top: 12,
      left: 12,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isDangMoCua ? Colors.green : Colors.orange,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            const Icon(Icons.access_time, color: Colors.white, size: 14),
            const SizedBox(width: 4),
            Text(
              cuaHang.TrangThai,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBtnXoa(BuildContext context, CuaHangModel cuaHang, YeuThichViewModel viewModel) {
    return Positioned(
      top: 12,
      right: 12,
      child: CircleAvatar(
        backgroundColor: Colors.white,
        child: IconButton(
          icon: const Icon(Icons.favorite, color: Colors.red),
          onPressed: () {
            // Gọi hàm xóa. Hàm này sẽ tự động gọi notifyListeners()
            // và khiến toàn bộ giao diện lắng nghe (Consumer) được rebuild.
            viewModel.xoaYeuThich(cuaHang);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Đã xóa khỏi yêu thích'),
                duration: Duration(seconds: 1),
              ),
            );
          },
        ),
      ),
    );
  }
}