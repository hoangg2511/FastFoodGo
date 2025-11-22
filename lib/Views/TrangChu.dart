import 'package:fastfoodgo/ViewModels/NguoiDungViewModel.dart';
import 'package:fastfoodgo/ViewModels/YeuThichViewModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart' show ChangeNotifierProvider, MultiProvider, Consumer, ReadContext;
import '../Models/CuaHangModel.dart';
import '../ViewModels/ChitietCuaHangViewModel.dart';
import '../ViewModels/GioHangViewModel.dart';
import '../ViewModels/TrangChuViewModel.dart';
import 'ChiTietCuaHang.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CuaHangViewModel viewModel = new CuaHangViewModel();
  final List<Map<String, dynamic>> LoaiMonAn = [
    {
      "icon": Icons.fastfood,
      "name": "Burger",
      "color": Color(0xFFFFE0B2), // Màu nền
      "iconColor": Colors.orange, // Màu icon
    },
    {
      "icon": Icons.local_pizza,
      "name": "Pizza",
      "color": Color(0xFFFFCDD2),
      "iconColor": Colors.redAccent,
    },
    {
      "icon": Icons.local_drink,
      "name": "Nước uống",
      "color": Color(0xFFBBDEFB),
      "iconColor": Colors.blueAccent,
    },
    {
      "icon": Icons.rice_bowl,
      "name": "Sushi",
      "color": Color(0xFFC8E6C9),
      "iconColor": Colors.green,
    },
    {
      "icon": Icons.ramen_dining,
      "name": "Mì",
      "color": Color(0xFFD1C4E9),
      "iconColor": Colors.purple,
    },
    {
      "icon": Icons.cake,
      "name": "Tráng miệng",
      "color": Color(0xFFF8BBD0),
      "iconColor": Colors.pinkAccent,
    },
  ];


  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final nguoiDungVM = context.read<NguoiDungViewModel>();
      await nguoiDungVM.getDiaChi();
      print(nguoiDungVM.danhSachDiaChi);

    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DiaChi(),
              searchBar(),
              Banner(),
              danhSachTheLoai(),
              SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Cửa hàng gần bạn',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
              // SizedBox(height: 20),
              DanhSachCuaHang(),
            ],
          ),
        ),
      ),
    );
  }

  Widget DiaChi() {
    return Consumer<NguoiDungViewModel>(
      builder: (context, vm, child) {
        final diaChiMacDinh =
        vm.danhSachDiaChi.isNotEmpty
            ? vm.danhSachDiaChi.firstWhere(
              (dc) => dc.status == 1,
          orElse: () => vm.danhSachDiaChi.first,
        )
            : null;
        return Container(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.location_on, color: Colors.orange, size: 20),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Giao hàng đến',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                    Text(
                      diaChiMacDinh != null
                          ? "${diaChiMacDinh.DCCuThe}, ${diaChiMacDinh.phuongXa},${diaChiMacDinh.quanHuyen} "
                          : "Chưa có địa chỉ",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }


  Widget searchBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        onChanged: (value) {
          setState(() {});
        },
        decoration: InputDecoration(
          hintText: 'Tìm món ăn, cửa hàng...',
          hintStyle: TextStyle(color: Colors.grey[400]),
          prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
      ),
    );
  }

  Widget Banner() {
    return Container(
      margin: EdgeInsets.all(16),
      height: 150,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            itemBanner(
              title: 'Giảm 50% cho đơn\nđầu tiên',
              subtitle: 'Áp dụng cho tất cả món ăn',
              imageUrl:
              'https://file.hstatic.net/200000700229/article/ga-ran-gion-1_83c75dcbff794589a4be4ae74e71c8e6.jpg',
            ),
            itemBanner(
              title: 'Free ship 0đ',
              subtitle: 'Đơn từ 150k',
              imageUrl:
              'https://res.cloudinary.com/dwbzya1bk/image/upload/v1759599161/photo-1571091718767-18b5b1457add_nrrqej.jpg',
            ),
          ],
        ),
      ),
    );
  }

  Widget itemBanner({required String title, required String subtitle, required String imageUrl,}) {
    return Container(
      width: 300,
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orange[400]!, Colors.orange[600]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text(subtitle,
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.9), fontSize: 12)),
              ],
            ),
          ),
          SizedBox(width: 12),
          // Ảnh
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              imageUrl,
              width: 90,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }

  Widget danhSachTheLoai() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Danh mục',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 16),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1,
            ),
            itemCount: LoaiMonAn.length,
            itemBuilder: (context, index) {
              final category = LoaiMonAn[index];
              return GestureDetector(
                onTap: () {},
                child: Container(
                  decoration: BoxDecoration(
                    color: category['color'],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        category['icon'],
                        size: 32,
                        color: category['iconColor'],

                      ),
                      SizedBox(height: 8),
                      Text(
                        category['name'],
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget ThongTinCuaHang(IconData icon, String text, [Color? color]) {
    return Row(
      children: [
        Icon(icon, color: color ?? Colors.grey, size: 16),
        SizedBox(width: 4),
        Text(text, style: TextStyle(color: Colors.grey[600])),
      ],
    );
  }

  Widget DanhSachCuaHang() {
    return FutureBuilder<List<CuaHangModel>>(
      future: CuaHangViewModel().fetchCuaHang(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text("Không có cửa hàng nào"));
        }
        final stores = snapshot.data!;
        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: stores.length,
          itemBuilder: (context, index) {
            final store = stores[index];
            return GestureDetector(
              onTap: () {},
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  children: [
                    SizedBox(height: 16),
                    GestureDetector(
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
                              child: ShopDetail(CuaHangId: store.id),
                            ),
                          ),
                        );

                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 10,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                              child: Container(
                                height: 150,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(
                                     store.AnhDaiDien.toString(),
                                    ),
                                    fit: BoxFit.cover, // ảnh phủ toàn bộ
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(store.TenCuaHang,
                                            style: TextStyle(
                                                fontSize: 16, fontWeight: FontWeight.bold)),
                                        SizedBox(height: 5),
                                        Text("Burger",
                                            style: TextStyle(
                                                color: Colors.grey[600], fontSize: 15)),
                                        SizedBox(height: 5),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            ThongTinCuaHang(Icons.star, store.DanhGia.toStringAsFixed(1), Colors.amber),
                                            ThongTinCuaHang(Icons.location_on_outlined, "1.2km"),
                                            ThongTinCuaHang(
                                                Icons.access_time_outlined, store.ThoiGianThucHienMon),
                                          ],
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
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

}


