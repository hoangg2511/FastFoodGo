import 'package:fastfoodgo/ViewModels/YeuThichViewModel.dart';
import 'package:fastfoodgo/Views/GioHang.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Models/CuaHangModel.dart';
import '../ViewModels/ChiTietMonAnViewModel.dart';
import '../ViewModels/ChitietCuaHangViewModel.dart';
import '../ViewModels/GioHangViewModel.dart';
import 'ChiTietMonAn.dart';


class ShopDetail extends StatelessWidget {
  final String CuaHangId;
  const ShopDetail({super.key, required this.CuaHangId});

  @override
  Widget build(BuildContext context) {
    return ShopDetailScreen(CuaHangId: CuaHangId);
  }
}

class ShopDetailScreen extends StatefulWidget {
  final String CuaHangId;
  const ShopDetailScreen({super.key, required this.CuaHangId});

  @override
  State<ShopDetailScreen> createState() => _ShopDetailScreenState();
}

class _ShopDetailScreenState extends State<ShopDetailScreen> with SingleTickerProviderStateMixin {
  late ChitietCuaHangViewModel ChiTietCuaHangVM;
  late GioHangViewModel GioHangVM;
  late Future<CuaHangModel?> _shopFuture;
  late YeuThichViewModel yeuThichVM;

  @override
  void initState() {
    super.initState();
    ChiTietCuaHangVM = context.read<ChitietCuaHangViewModel>();
    yeuThichVM = context.read<YeuThichViewModel>();
    _shopFuture = ChiTietCuaHangVM.getChiTietCuaHang(widget.CuaHangId);
    context.read<ChitietCuaHangViewModel>().fetchTenLoaiMonAn();
    ChiTietCuaHangVM.getMonAnTheoCuaHang(widget.CuaHangId);
    yeuThichVM.kiemTraYeuThich(widget.CuaHangId);
  }
  @override
  void dispose() {
    super.dispose();
  }
  String formatTien(double price) {
    return '${price.toInt().toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
    )}đ';
  }
  Widget _buildInfoChip(IconData icon, String text, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            color: color,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget filterLoaiMonAn() {
    return Consumer<ChitietCuaHangViewModel>(
        builder: (context, vm, _) {
          if (vm.categories.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: vm.categories.map((category) {
                bool isSelected = vm.selectedCategory == category;
                return Container(
                  margin: const EdgeInsets.only(right: 12),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        vm.selectedCategory = category;
                      });
                      vm.filterByCategory(category);
                    },
                    borderRadius: BorderRadius.circular(25),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.orange[600] : Colors
                            .grey[100],
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: isSelected ? Colors.orange[600]! : Colors
                              .grey[300]!,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        category,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontSize: 14,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight
                              .normal,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        }
    );
  }

  Widget thongTinCuaHang() {
    return FutureBuilder<CuaHangModel?>(
      future: _shopFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 100,
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (!snapshot.hasData || snapshot.data == null) {
          return const SizedBox(
            height: 100,
            child: Center(child: Text("Không tìm thấy cửa hàng")),
          );
        }

        final cuaHang = snapshot.data!;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  cuaHang.AnhDaiDien.toString(),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.restaurant, color: Colors.grey, size: 40),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cuaHang.TenCuaHang,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),

                  Row(
                    children: [
                      _buildInfoChip(Icons.star, cuaHang.DanhGia.toString(), Colors.amber),
                      const SizedBox(width: 12),
                      _buildInfoChip(
                        Icons.location_on_outlined,
                        '${cuaHang.khoangCach} km',
                        Colors.grey[600]!,
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  Row(
                    children: [
                      _buildInfoChip(
                        Icons.access_time_rounded,
                        cuaHang.ThoiGianThucHienMon,
                        Colors.grey[600]!,
                      ),
                      const SizedBox(width: 12),

                      Consumer<ChitietCuaHangViewModel>(
                        builder: (context, vm, child) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: vm.isOpen ? Colors.green[100] : Colors.red[100],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              vm.isOpen ? "Mở cửa" : "Đóng cửa",
                              style: TextStyle(
                                color: vm.isOpen ? Colors.green : Colors.red,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Consumer<YeuThichViewModel>(
                builder: (context, yeuThichVM, child) {
                  final bool isLiked = yeuThichVM.kiemTraYeuThich(cuaHang.id);
                  return IconButton(
                    onPressed: () async {
                      if (isLiked) {
                        await yeuThichVM.xoaYeuThich(cuaHang); // Xóa khỏi yêu thích
                      } else {
                        await yeuThichVM.themYeuThich(cuaHang); // Thêm vào yêu thích
                      }
                      // Không cần gọi setState, Consumer tự rebuild
                    },
                    icon: Icon(
                      Icons.favorite,
                      color: isLiked ? Colors.orange : Colors.grey,
                      size: 24,
                    ),
                    splashColor: Colors.orange[100],
                    highlightColor: Colors.orange[100],
                  );
                },
              )

            ),
          ],
        );
      },
    );
  }



  Widget CuaHang() {
    return FutureBuilder<CuaHangModel?>(
        future: _shopFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox(
              height: 100,
              child: Center(child: CircularProgressIndicator()),
            );
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const SizedBox(
              height: 100,
              child: Center(child: Text("Không tìm thấy cửa hàng")),
            );
          }
          final cuaHang = snapshot.data!;
          return Container(
            height: 500,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.network(
                    cuaHang.AnhBia.toString(),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Center(
                          child:
                          Icon(Icons.image_not_supported, size: 50,
                              color: Colors.grey),
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                          top: Radius.circular(25)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, -5),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        thongTinCuaHang(),
                        const SizedBox(height: 20),
                        filterLoaiMonAn(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }
    );
  }

  Widget TieuDe() {
    return Consumer<ChitietCuaHangViewModel>(
        builder: (context, vm, _) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  vm.selectedCategory,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          );
        }
    );
  }

  Widget DanhSachMonAn() {
    return Consumer<ChitietCuaHangViewModel>(
      builder: (context, vm, _) {
        if (vm.filteredMonAn.isEmpty) {
          return const Center(child: Text("Không có món ăn nào"));
        }
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          itemCount: vm.filteredMonAn.length,
          itemBuilder: (context, index) {
            final MonAn = vm.filteredMonAn[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(15),
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            MonAn.HinhAnh!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[300],
                                child: const Icon(Icons.restaurant, color: Colors.grey),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              MonAn.TenMonAn,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              MonAn.MoTa,
                              style: TextStyle(color: Colors.grey[600], fontSize: 13),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  formatTien(MonAn.Gia.toDouble()),
                                  style: TextStyle(
                                    color: Colors.orange[700],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [Colors.orange[400]!, Colors.orange[600]!],
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(20),
                                      onTap: () async {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => MultiProvider(
                                              providers: [
                                                ChangeNotifierProvider.value(
                                                  value: context.read<GioHangViewModel>(),
                                                ),
                                                ChangeNotifierProvider(
                                                  create: (_) => ChiTietMonAnViewModel(
                                                    gioHangVM: context.read<GioHangViewModel>(),
                                                  ),
                                                ),
                                              ],
                                              child: ChiTietMonAn(MonAn: MonAn.id),
                                            ),
                                          ),
                                        );

                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Icon(Icons.add, color: Colors.white, size: 20),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget buttonGioHang() {
    return Consumer<GioHangViewModel>(
        builder: (context, cartVM, _) {
          final totalItems = cartVM
              .totalQuantity; // Lúc này getter được truy cập
          if (totalItems == 0) return Container();

          return Container(
            margin: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orange[400]!, Colors.deepOrange[600]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(50),
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.withOpacity(0.4),
                  blurRadius: 20,
                  spreadRadius: 2,
                  offset: Offset(0, 8),
                ),
                BoxShadow(
                  color: Colors.deepOrange.withOpacity(0.3),
                  blurRadius: 30,
                  spreadRadius: -5,
                  offset: Offset(0, 15),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  final gioHangVM = context.read<GioHangViewModel>();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChangeNotifierProvider.value(
                        value: gioHangVM,
                        child: GioHangScreen(),
                      ),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(50),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.shopping_cart_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      SizedBox(width: 16),
                      Text(
                        'Giỏ hàng',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                      SizedBox(width: 12),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          totalItems.toString(),
                          style: TextStyle(
                            color: Colors.deepOrange[600],
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "Chi tiết cửa hàng",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CuaHang(),
            TieuDe(),
            DanhSachMonAn(),
          ],
        ),
      ),
      floatingActionButton: buttonGioHang(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
