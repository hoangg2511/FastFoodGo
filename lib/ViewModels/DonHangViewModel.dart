import 'package:fastfoodgo/Models/ChiTietDonHangModel.dart';
import 'package:fastfoodgo/Models/DonHangModel.dart';
import 'package:fastfoodgo/Repository/MonAnRepository.dart';
import 'package:flutter/material.dart';
import '../Models/MonAnModel.dart';
import '../Models/OrderItem.dart';
import '../Repository/ChiTietDonHangRepository.dart';
import '../Repository/DonHangRepository.dart';


class DonHangViewModel extends ChangeNotifier {
  final DonHangRepository _repoDonHang = DonHangRepository();
  final MonAnRepository _repoMonAn  = MonAnRepository();
  final ChiTietDonHangRepository _repoCTDH = ChiTietDonHangRepository();
  List<Map<String, dynamic>> _orders = [];
  List<Map<String, dynamic>> _processingOrders = [];
  List<Map<String, dynamic>> orderItem = [];
  int selectedTab = 1;

  List<Map<String, dynamic>> get orders => _orders;

  List<Map<String, dynamic>> get processingOrders => _processingOrders;

  void setTab(int index) {
    selectedTab = index;
    notifyListeners();
  }

  String formatPrice(double price) {
    return '${price.toInt().toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
    )} đ';
  }

  Future<ChiTietDonHangModel?> getCTDH() async {
    notifyListeners();
    return null;
  }



  Future<void> getOrders() async {
    try {
      // 🔹 Lấy dữ liệu từ các repository
      final ctdhList = await _repoCTDH.getCTDH();       // Danh sách chi tiết đơn hàng
      final monAns = await _repoMonAn.getMonAn();       // Danh sách món ăn
      final donHangs = await _repoDonHang.getDonHang(); // Danh sách đơn hàng

      print(" Số chi tiết đơn hàng: ${ctdhList.length}");
      print(" Số món ăn: ${monAns.length}");
      print(" Số đơn hàng: ${donHangs.length}");


      final combinedList = ctdhList.map((ct) {
        // 1️⃣ Tìm món ăn tương ứng
        final mon = monAns.firstWhere(
              (m) => m.id == ct.maMonAn,
          orElse: () => MonAnModel(),
        );

        final dh = donHangs.firstWhere(
              (d) => d.maDH == ct.maDH,
          orElse: () => DonHangModel(
            maDH: '',
            maKH: '',
            trangThaiThanhToan: '',
            tamTinh: 0,
            trangThaiDonHang: '',
            ngayDat: null,
          ),
        );
        final combined = {
          'chiTiet': ct,
          'tenMon': mon.TenMonAn,
          'donHang': dh,
          'id': dh.maDH,
          'imageUrl': mon.HinhAnh,
          'price': mon.Gia.toDouble(),
          'rating': mon.DanhGia,
          'date': dh.ngayDat,
          'status': dh.trangThaiDonHang,
        };

        print("➡️ Combined Item: $combined"); // ✅ In từng item

        return combined;
      }).toList();

      // 🔹 Gán vào ViewModel hoặc biến cục bộ
      orderItem = combinedList;

      // 🔥 Lọc ra đơn hàng đã hoàn thành
      _orders = combinedList
          .where((item) => item['status']?.toString() == "Đã Hoàn Thành")
          .toList();
      print("✅ Đơn hàng đã hoàn thành: ${_orders.length}");

      // 🔥 Lọc ra đơn hàng đang xử lý
      _processingOrders = combinedList
          .where((item) => item['status']?.toString() != "Đã Hoàn Thành")
          .toList();
      print("⏳ Đơn hàng đang xử lý: ${_processingOrders.length}");

      notifyListeners();
    } catch (e) {
      print("❌ Lỗi khi lấy dữ liệu đơn hàng: $e");
    }
  }


}
