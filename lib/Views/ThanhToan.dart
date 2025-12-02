
import 'package:fastfoodgo/Models/DiaChiModel.dart';
import 'package:fastfoodgo/ViewModels/QRCodeViewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Models/GiamGiaModel.dart';
import '../Models/GioHangModel.dart';
import 'PaymentWebViewScreen.dart';
import '../ViewModels/DonHangViewModel.dart';
import '../ViewModels/GioHangViewModel.dart';
import '../ViewModels/ThanhToanViewModel.dart';
import '../ViewModels/VnPayViewModel.dart';
import 'QRCodeView.dart';

class ThanhToanScreen extends StatefulWidget {
  const ThanhToanScreen({Key? key}) : super(key: key);

  @override
  State<ThanhToanScreen> createState() => ThanhToanScreenState();
}

class ThanhToanScreenState extends State<ThanhToanScreen> {
  late GioHangViewModel cartVM;
  late ThanhToanViewModel thanhToanVM;
  late VnPayViewModel VnPayVM;
  String currentView = "checkout";
  // Dữ liệu
  String? selectDiaChi;
  String? selectThanhToan;
  String? selectGiamGia;
  double PhiVanChuyen = 30000;
  @override
  void initState() {
    super.initState();
    cartVM = Provider.of<GioHangViewModel>(context, listen: false);
    thanhToanVM = Provider.of<ThanhToanViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await thanhToanVM.loadDiaChi(); // load địa chỉ giao hàng
      await thanhToanVM.fetchGiamGiaTheoLoai();
      await thanhToanVM.fetchDiaChiKH();
      await thanhToanVM.fetchNguoiDung();
    });
  }

  List<GioHangModel> get items => cartVM.items;
  double get subtotal => cartVM.subtotal;

  String _formatPrice(double price) {
    return '${price.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')} đ';
  }

  @override
  Widget build(BuildContext context) {

    final ThanhToanVM = context.watch<ThanhToanViewModel>();
    double discount = selectGiamGia != null ? 50000 : 0;
    double total = subtotal + PhiVanChuyen - discount;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: currentView == "checkout"
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              )
            : IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => setState(() => currentView = "checkout"),
              ),
        title: Text(
          _getTitle(),
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: MainView(total, discount, ThanhToanVM),
      ),
    );
  }

  String _getTitle() {
    switch (currentView) {
      case "address":
        return "Địa chỉ giao hàng";
      case "payment":
        return "Phương thức thanh toán";
      default:
        return "Thanh toán";
    }
  }

  Widget MainView(

    double total,
    double discount,
    ThanhToanViewModel thanhToanVM,
  ) {
    switch (currentView) {
      case "address":
        return ChiTietDiaChi();
      case "payment":
        return ChiTietThanhToan(thanhToanVM);
      default:
        return ContainerThanhToan(total, discount, thanhToanVM);
    }
  }

  Widget ContainerThanhToan(
    double total,
    double discount,
    ThanhToanViewModel thanhToanVM,
  ) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                MonAnOrder(items),
                const SizedBox(height: 8),
                sectionDiaChi(),
                const SizedBox(height: 8),
                sectionThanhToan(),
                const SizedBox(height: 8),
                sectionVoucher(thanhToanVM, total),
                const SizedBox(height: 8),
                ChitietThanhToan(subtotal, PhiVanChuyen, thanhToanVM),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
        buttonThanhToan(items),
      ],
    );
  }

  Widget MonAnOrder(List<GioHangModel> items) {
    if (items.isEmpty) return const SizedBox.shrink();
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tổng quan đơn hàng',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          ...items.map(
                (item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      item.imgUrl,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        // Hiển thị ảnh thay thế khi không load được
                        return Container(
                          width: 60,
                          height: 60,
                          color: Colors.grey[300],
                          child: const Icon(Icons.image_not_supported, color: Colors.grey),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Column chứa tên món và options
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.tenMonAn,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (item.selectedOptions != null && item.selectedOptions!.isNotEmpty)
                          Text(
                            item.selectedOptions!.values.join(', '),
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 13,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Giá tiền và số lượng
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        _formatPrice(item.finalPrice),
                        style: TextStyle(
                          color: Colors.orange[700],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'x${item.quantity}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }



  Widget sectionThanhToan() {
    return InkWell(
      onTap: () => setState(() => currentView = "payment"),
      child: listSection(
        icon: Icons.payment,
        iconColor: Colors.green,
        title: "Phương thức thanh toán",
        subtitle: selectThanhToan ?? "Chọn phương thức thanh toán",
      ),
    );
  }

  Widget sectionVoucher(ThanhToanViewModel thanhToanVM, double total) {
    return InkWell(
      onTap: () => _showChiTietGiamGia(thanhToanVM, total),
      child: listSection(
        icon: Icons.discount,
        iconColor: Colors.orange,
        title: "Mã giảm giá",
        subtitle: thanhToanVM.selectedDiscounts.isEmpty
            ? "Chọn hoặc nhập mã giảm giá"
            : thanhToanVM.selectedDiscounts.values.join(", "),
      ),
    );
  }

  void _showChiTietGiamGia(ThanhToanViewModel thanhToanVM, double total) {
    final groupedDiscounts = thanhToanVM.groupedDiscounts;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (_) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Chọn mã giảm giá',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
              const Divider(height: 20),

              // Render từng loại giảm giá
              ...groupedDiscounts.entries.map((entry) {
                final loai = entry.key;
                final dsGiamGia = entry.value;

                return Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tiêu đề loại giảm giá
                      Text(
                        loai,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // List voucher
                      dsGiamGia.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                "Không có mã giảm giá nào",
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: dsGiamGia.length,
                              itemBuilder: (context, index) {
                                final d = dsGiamGia[index];

                                // Kiểm tra đã chọn theo loại
                                bool isSelected =
                                    thanhToanVM.selectedDiscounts[loai] ==
                                    d.MaGG;

                                return Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: isSelected
                                          ? [
                                              Colors.orange[50]!,
                                              Colors.orange[100]!,
                                            ]
                                          : [
                                              Colors.grey[50]!,
                                              Colors.grey[100]!,
                                            ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isSelected
                                          ? Colors.orange
                                          : Colors.grey[300]!,
                                      width: isSelected ? 2 : 1,
                                    ),
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      thanhToanVM.chonGiamGia(
                                        loai,
                                        d.MaGG,
                                        total,
                                      );
                                      Navigator.pop(context);
                                    },
                                    borderRadius: BorderRadius.circular(12),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Row(
                                        children: [
                                          // Icon voucher
                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: isSelected
                                                  ? Colors.orange
                                                  : Colors.grey[400],
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: const Icon(
                                              Icons.local_offer,
                                              color: Colors.white,
                                              size: 24,
                                            ),
                                          ),
                                          const SizedBox(width: 12),

                                          // Nội dung voucher
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  d.Code,
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: isSelected
                                                        ? Colors.orange[900]
                                                        : Colors.black87,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  d.ChiTietGG,
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.grey[700],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          const SizedBox(width: 8),
                                          // Radio chọn
                                          Radio<String>(
                                            value: d.MaGG,
                                            groupValue: thanhToanVM
                                                .selectedDiscounts[loai],
                                            onChanged: (v) {
                                              thanhToanVM.chonGiamGia(
                                                loai,
                                                v!,
                                                total,
                                              );
                                              Navigator.pop(context);
                                            },
                                            activeColor: Colors.orange,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                    ],
                  ),
                );
              }).toList(),

              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget ChiTietDiaChi() {
    return Consumer<ThanhToanViewModel>(
      builder: (context, thanhToanVM, child) {
        final addresses = thanhToanVM.danhSachDiaChi;
        final nguoiDung = thanhToanVM.nguoiDung;
        final hoTen = nguoiDung?.hoTen ?? "Chưa có tên";
        final soDienThoai = nguoiDung?.sdt ?? "Chưa có SĐT";

        if (thanhToanVM.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (addresses.isEmpty) {
          return const Center(child: Text("Chưa có địa chỉ nào"));
        }

        // ✅ Nếu chưa chọn địa chỉ, tự động chọn địa chỉ mặc định (status == 1)
        final diaChiMacDinh = addresses.firstWhere(
          (a) => a.status == 1,
          orElse: () => addresses.first,
        );

        selectDiaChi ??= "${diaChiMacDinh.soNha}, ${diaChiMacDinh.phuongXa}, ${diaChiMacDinh.quanHuyen}";

        return ListView(
          padding: const EdgeInsets.all(16),
          children: addresses.map((a) {
            String diaChi = "${a.soNha}, ${a.phuongXa}, ${a.quanHuyen}";
            bool isSelected = selectDiaChi == diaChi;

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: isSelected ? Colors.blue : Colors.grey[300]!,
                  width: isSelected ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                title: Row(
                  children: [
                    Expanded(
                      child: Text(
                        hoTen,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    if (a.status == 1)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange[50],
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          "Mặc định",
                          style: TextStyle(
                            color: Colors.orange,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    PopupMenuButton<String>(
                      icon: Icon(
                        Icons.more_vert,
                        color: Colors.grey[600],
                        size: 20,
                      ),
                      onSelected: (value) {
                        if (value == 'edit') {
                          // Xử lý sửa địa chỉ
                        } else if (value == 'delete') {
                          XacNhanXoa(thanhToanVM, a);
                        } else if (value == 'default') {
                          thanhToanVM.setDefaultAddress();
                        }
                      },
                      itemBuilder: (BuildContext context) => [
                        if (a.status != 1)
                          const PopupMenuItem<String>(
                            value: 'default',
                            child: Row(
                              children: [
                                Icon(
                                  Icons.check_circle_outline,
                                  size: 18,
                                  color: Colors.green,
                                ),
                                SizedBox(width: 8),
                                Text('Đặt mặc định'),
                              ],
                            ),
                          ),
                        const PopupMenuItem<String>(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(
                                Icons.edit_outlined,
                                size: 18,
                                color: Colors.blue,
                              ),
                              SizedBox(width: 8),
                              Text('Sửa'),
                            ],
                          ),
                        ),
                        const PopupMenuItem<String>(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(
                                Icons.delete_outline,
                                size: 18,
                                color: Colors.red,
                              ),
                              SizedBox(width: 8),
                              Text('Xóa'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 18,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              diaChi,
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.phone_outlined,
                            size: 18,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            soDienThoai.toString(),
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                leading: Radio<String>(
                  value: diaChi,
                  groupValue: selectDiaChi,
                  onChanged: (value) {
                    setState(() {
                      selectDiaChi = value;
                      currentView = "checkout";
                    });
                  },
                  activeColor: Colors.blue,
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget sectionDiaChi() {
    return Consumer<ThanhToanViewModel>(
      builder: (context, vm, child) {
        // Nếu danh sách trống
        if (vm.danhSachDiaChi.isEmpty) {
          return InkWell(
            onTap: () => setState(() => currentView = "address"),
            child: listSection(
              icon: Icons.location_on,
              iconColor: Colors.blue,
              title: "Địa chỉ giao hàng",
              subtitle: "Chọn địa chỉ giao hàng",
            ),
          );
        }

        // 1️⃣ Lấy địa chỉ mặc định (status == 1)
        final diaChiMacDinh = vm.danhSachDiaChi.firstWhere(
          (a) => a.status == 1,
          orElse: () => vm.danhSachDiaChi.first,
        );
        final diaChiDuocChon = vm.danhSachDiaChi.firstWhere(
              (a) => "${a.soNha}, ${a.phuongXa}, ${a.quanHuyen}" == selectDiaChi,
          orElse: () => diaChiMacDinh,
        );

        print("Địa chỉ được chọn: ${diaChiDuocChon.soNha}, ${diaChiDuocChon.Duong}, ${diaChiDuocChon.phuongXa}");
        print("ID của địa chỉ được chọn: ${diaChiDuocChon.id}");
        vm.selectDiaChi = diaChiDuocChon.id;
        // 3️⃣ Tạo chuỗi địa chỉ hiển thị
        final subtitle =
            "${diaChiDuocChon.soNha}, ${diaChiDuocChon.Duong}, ${diaChiDuocChon.phuongXa}, ${diaChiDuocChon.quanHuyen}, ${diaChiDuocChon.tinhTp}";

        // 4️⃣ Hiển thị InkWell (giữ nguyên như yêu cầu)
        return InkWell(
          onTap: () => setState(() => currentView = "address"),
          child: listSection(
            icon: Icons.location_on,
            iconColor: Colors.blue,
            title: "Địa chỉ giao hàng",
            subtitle: subtitle,
          ),
        );
      },
    );
  }

  Widget listSection({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.grey[700], fontSize: 13),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }

  Widget ChitietThanhToan(
    double subtotal,
    double PhiVanChuyen,
    ThanhToanViewModel thanhToanVM,
  ) {
    double discountTotal = 0.0;

    // Tạo list widget hiển thị voucher
    List<Widget> discountWidgets = [];
    thanhToanVM.selectedDiscounts.forEach((loai, maGG) {
      final voucher = thanhToanVM.danhSachGiamGia.firstWhere(
        (d) => d.MaGG == maGG,
        orElse: () => GiamGiaModel(),
      );

      double voucherValue = 0.0;
      if (voucher.GiaTri < 1) {
        voucherValue = subtotal * voucher.GiaTri; // phần trăm
      } else {
        voucherValue = voucher.GiaTri; // số tiền
      }

      discountTotal += voucherValue;

      discountWidgets.add(
        GiaTien('${voucher.Code}', -voucherValue, color: Colors.orange),
      );
    });

    thanhToanVM.total = subtotal + PhiVanChuyen - discountTotal;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          GiaTien('Tạm tính', subtotal),
          GiaTien('Phí vận chuyển', PhiVanChuyen),
          ...discountWidgets, // hiển thị từng voucher
          const Divider(),
          GiaTien(
            'Tổng cộng',
            thanhToanVM.total,
            bold: true,
            color: Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget GiaTien(
    String label,
    double value, {
    bool bold = false,
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            '${_formatPrice(value)}',
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
  Widget buttonThanhToan(List<GioHangModel> items) {
    return Consumer<ThanhToanViewModel>(
      builder: (context, thanhToanVM, child) {
        final vnPayVM = context.read<VnPayViewModel>();
        final gioHangVM = context.read<GioHangViewModel>();
        return Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: ElevatedButton(
            onPressed: selectDiaChi != null && selectThanhToan != null
                ? () async {
              final maGG = thanhToanVM.selectedDiscounts.values.toList();
              final String trangThaiThanhToan =
                  selectThanhToan ?? 'COD'; // khởi tạo trạng thái
              // 1️⃣ Tạo đơn hàng
              String maDH = await thanhToanVM.taoDonHang(
                  items, maGG, selectThanhToan, trangThaiThanhToan,selectDiaChi!);

              // 2️⃣ Kiểm tra phương thức thanh toán
              if (selectThanhToan == 'VNPay') {
                final url = await vnPayVM.createPayment(
                    thanhToanVM.total, maDH);

                if (url != null && context.mounted) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MultiProvider(
                        providers: [
                          ChangeNotifierProvider.value(value: vnPayVM),
                          ChangeNotifierProvider.value(value: gioHangVM),
                          ChangeNotifierProvider.value(value: thanhToanVM),
                        ],
                        child: PaymentWebViewScreen(paymentUrl: url),
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            vnPayVM.errorMessage ?? 'Không thể tạo thanh toán')),
                  );
                }
              }
              else if(selectThanhToan == 'Qr Code Thanh toán'){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MultiProvider(
                      providers: [
                        ChangeNotifierProvider.value(value: vnPayVM),
                        ChangeNotifierProvider.value(value: gioHangVM),
                        ChangeNotifierProvider.value(value: thanhToanVM),
                        ChangeNotifierProvider(create: (_) => QRCodeViewModel()),
                      ],
                      child: QRCodeView(
                        amount: thanhToanVM.total.toInt(),
                        description: thanhToanVM.generateMaDH(),
                      ),
                    ),
                  ),
                );



              }
              else {
                // Thanh toán COD/Tiền mặt
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Đặt hàng thành công!'),
                    duration: Duration(seconds: 5),
                  ),
                );

                gioHangVM.resetCart();

                // Đóng màn hình Thanh Toán
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              }
            }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              minimumSize: const Size(double.infinity, 54),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Đặt hàng • ${_formatPrice(thanhToanVM.total)}',
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        );
      },
    );
  }

  void XacNhanXoa(ThanhToanViewModel thanhToanVM, address) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text("Xác nhận xóa"),
          content: const Text("Bạn có chắc chắn muốn xóa địa chỉ này?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Hủy", style: TextStyle(color: Colors.grey[600])),
            ),
            TextButton(
              onPressed: () {
                // Xử lý xóa địa chỉ
                // thanhToanVM.deleteAddress(address.id);
                Navigator.pop(context);
              },
              child: const Text("Xóa", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  Widget ChiTietThanhToan(ThanhToanViewModel thanhtoanVM) {
    final methods = [
      {
        'name': 'Thanh toán khi nhận hàng',
        'icon': Icons.payments,
        'color': Colors.green,
      },
      {
        'name': 'VNPay',
        'icon': Icons.account_balance_wallet,
        'color': Colors.red[600],
      },
      {
        'name': 'Qr Code Thanh toán',
        'icon': Icons.qr_code_2,
        'color': Colors.blue,
      },
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: methods.map((m) {
        bool isSelected = selectThanhToan == m['name'];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: isSelected ? Colors.blue : Colors.grey[300]!,
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: Icon(m['icon'] as IconData, color: m['color'] as Color),
            title: Text(m['name'] as String),
            trailing: Radio<String>(
              value: m['name'] as String,
              groupValue: selectThanhToan,
              onChanged: (value) {
                setState(() {
                  selectThanhToan = value;
                  thanhtoanVM.selectThanhToan = selectThanhToan;
                  currentView = "checkout";
                });
              },
              activeColor: Colors.blue,
            ),
          ),
        );
      }).toList(),
    );
  }
}
