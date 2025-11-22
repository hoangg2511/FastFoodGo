
  import 'package:uuid/uuid.dart';
import 'package:fastfoodgo/Models/ChiTietDonHangModel.dart';
  import 'package:fastfoodgo/Models/GioHangModel.dart';
import 'package:fastfoodgo/Models/LoaiGG.dart';
import 'package:fastfoodgo/Models/NguoiDungModel.dart';
  import 'package:fastfoodgo/Repository/ChiTietDonHangRepository.dart';
  import 'package:fastfoodgo/Repository/GiamGiaRepository.dart';
  import 'package:fastfoodgo/Repository/MonAnRepository.dart';
  import '../Models/GiamGiaModel.dart';
import '../Repository/DonHangRepository.dart';
  import 'package:flutter/material.dart';
  import '../Models/DiaChiModel.dart';
  import '../Models/DonHangModel.dart';
  import '../Repository/DiaChiRepository.dart';
  import '../Repository/NguoiDungRepository.dart';

  class ThanhToanViewModel extends ChangeNotifier {
    final DiaChiRepository _diaChiRepo = DiaChiRepository();
    final NguoiDungRepository _nguoiDungRepo = NguoiDungRepository();
    final ChiTietDonHangRepository _chiTietDonHangRepo = ChiTietDonHangRepository();
    final DonHangRepository _donHangRepo = DonHangRepository();
    final MonAnRepository _monAnRepo = MonAnRepository();
    final GiamGiaRepository _giamGiaRepo = GiamGiaRepository();
    List<DiaChiModel> danhSachDiaChi = [];
    List<GiamGiaModel> danhSachGiamGia = [];
    List<LoaiGGModel> danhSachLoaiGG = [];
    NguoiDung? nguoiDung;
    Map<String, List<GiamGiaModel>> groupedDiscounts = {};
    String? errorMessage;
    bool isLoading = false;
    // Trong ViewModel
    Map<String, String> selectedDiscounts = {}; // key: MaLoaiGG, value: MaGG đã chọn
    double total = 0.0;

    void chonGiamGia(String maLoaiGG, String maGG, double totalGoc) {
      if (selectedDiscounts[maLoaiGG] == maGG) {
        selectedDiscounts.remove(maLoaiGG);
        print("Bỏ voucher: MaGG=$maGG, Loai=$maLoaiGG");
      } else {
        selectedDiscounts[maLoaiGG] = maGG;
        print("Chọn voucher: MaGG=$maGG, Loai=$maLoaiGG");
      }
      double newTotal = totalGoc;
      // Voucher phần trăm trước
      selectedDiscounts.forEach((loai, maGG) {
        final discount = danhSachGiamGia.firstWhere(
              (d) => d.MaGG == maGG,
          orElse: () => GiamGiaModel(),
        );

        if (discount.GiaTri > 0 && discount.GiaTri < 1) {
          double giam = newTotal * discount.GiaTri;
          newTotal -= giam;

          print("Voucher phần trăm: MaGG=${discount.MaGG}, Loai=${discount.MaLoaiGG}, GiaTri=${discount.GiaTri}, Giảm=$giam");
        }
      });

      // Voucher số tiền cố định
      selectedDiscounts.forEach((loai, maGG) {
        final discount = danhSachGiamGia.firstWhere(
              (d) => d.MaGG == maGG,
          orElse: () => GiamGiaModel(),
        );
        if (discount.GiaTri >= 1) {
          double giam = discount.GiaTri;
          newTotal -= giam;

          print("Voucher tiền mặt: MaGG=${discount.MaGG}, Loai=${discount.MaLoaiGG}, GiaTri=${discount.GiaTri}, Giảm=$giam");
        }
      });
      total = newTotal;
      print("Tổng sau giảm: $total");

      notifyListeners();
    }
    void setDefaultAddress(){}


    Future<void> loadDiaChi() async {
      try {
        isLoading = true;
        notifyListeners();

        final nguoiDung = await _nguoiDungRepo.getNguoiDungHienTai();
        if (nguoiDung == null) {
          print("Không tìm thấy người dùng đăng nhập");
          isLoading = false;
          notifyListeners();
          return;
        }

        danhSachDiaChi = await _diaChiRepo.getDiaChiByUser(nguoiDung.id);
        print("Đã tải ${danhSachDiaChi.length} địa chỉ cho user: ${nguoiDung.id}");
      } catch (e) {
        print("Lỗi khi load danh sách địa chỉ: $e");
      } finally {
        isLoading = false;
        notifyListeners();
      }
    }

    Future<void> thanhToan(List<GioHangModel> danhSachMonAn, List<String> maGG,String TrangThaiThanhToan) async {
      try {
        if (selectThanhToan == "VNPay") {
          // Gọi phương thức VNPay
          await thanhToanVNPay();
          return;
        }

        // Nếu không phải VNPay, gọi hàm tạo đơn bình thường
        await taoDonHang(danhSachMonAn, maGG, selectThanhToan,TrangThaiThanhToan);
      } catch (e, st) {
        print("❌ Lỗi khi thanh toán: $e");
        print(st);
      }
    }
    String generateMaDH() {
      const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
      final rand = DateTime.now().millisecondsSinceEpoch % 100000000;
      return 'DH' + rand.toString().padLeft(8, '0');
    }


    final uuid = Uuid();
    String generateMaCTDH() => 'CTDH${uuid.v4()}';


    Future<String> taoDonHang(
        List<GioHangModel> danhSachMonAn,
        List<String> maGG,
        String? selectThanhToan,
        String TrangThaiThanhToan
        ) async {
      try {
        final nguoiDung = await _nguoiDungRepo.getNguoiDungHienTai();
        if (nguoiDung == null) {
          print("❌ Không tìm thấy người dùng đăng nhập");
          throw Exception("Người dùng chưa đăng nhập.");
        }

        final allOptions = await _monAnRepo.getOption();

        final tongTien = danhSachMonAn.fold<int>(
          0,
              (sum, mon) => sum + mon.finalPrice.toInt(),
        );

        final donHang = DonHangModel(
          maDH: generateMaDH(),  // MaDH chung cho toàn bộ đơn
          ngayDat: DateTime.now(),
          trangThaiThanhToan: TrangThaiThanhToan,
          maKH: nguoiDung.id,
          maGG: null,
          tamTinh: tongTien.toDouble(),
          trangThaiDonHang: 'Đang chờ xác nhận',
        );

        String maDonHang = await _donHangRepo.taoDonHang(donHang);
        print("Mã đơn hàng được tạo là: $maDonHang");

        // 🔹 Tạo chi tiết đơn hàng cho từng món
        List<ChiTietDonHangModel> chiTietDonHangList = danhSachMonAn.map((mon) {
          final optionNames = mon.selectedOptions?.values.toList() ?? [];

          // Lọc option đúng món
          final optionsForMon = allOptions
              .where((opt) => optionNames.contains(opt.ten))
              .toList();

          return ChiTietDonHangModel(
            maCTDH: generateMaCTDH(),  // Duy nhất cho mỗi món
            soLuong: mon.quantity,
            maDH: maDonHang,            // Chung maDH
            maMonAn: mon.monAnId,
            gia: mon.finalPrice.toInt(),
            note: mon.note,
            optionMonAn: optionsForMon,
          );
        }).toList();

        // ⭐ In ra danh sách trước khi gửi API
        print("===== 📝 Danh sách ChiTietDonHangModel =====");
        for (var ct in chiTietDonHangList) {
          print(ct.toJson());
        }
        print("=============================================");

        // Gửi tất cả chi tiết đơn hàng
        await Future.wait(
          chiTietDonHangList.map((ct) => _chiTietDonHangRepo.taoDonHang(ct)),
        );

        return maDonHang;
      } catch (e) {
        print("Lỗi tạo đơn hàng: $e");
        rethrow;
      }
    }
    Future<void> fetchGiamGiaTheoKH() async {
      print("🟡 [DEBUG] Gọi hàm fetchGiamGiaTheoKH()...");

      String maKH = (await _nguoiDungRepo.getNguoiDungHienTai())?.id ?? "";
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      try {
        print("🔹 Đang gọi getGiamGiaTheoMaKH với MaKH = $maKH");

        final result = await _giamGiaRepo.getGiamGiaTheoMaKH(maKH);
        danhSachGiamGia = result;

        print("✅ Lấy ${result.length} giảm giá cho khách hàng $maKH thành công");
      } catch (e) {
        errorMessage = "Lỗi khi lấy dữ liệu giảm giá: $e";
        print("❌ $errorMessage");
      } finally {
        isLoading = false;
        print("🔚 [DEBUG] fetchGiamGiaTheoKH() kết thúc");
        notifyListeners();
      }
    }

    Future<void> fetchLoaiGGTheoDanhSach() async {
      try {
        print("🟡 [DEBUG] Gọi hàm fetchLoaiGGTheoDanhSach()...");

        isLoading = true;
        errorMessage = null;
        notifyListeners();
        danhSachLoaiGG = await _giamGiaRepo.getLoaiGiamGia();

      } catch (e) {
        errorMessage = "Lỗi khi lấy danh sách loại giảm giá: $e";
        print("❌ $errorMessage");
      } finally {
        isLoading = false;
        notifyListeners();
      }
    }

    Future<void> fetchGiamGiaTheoLoai() async {
      print("▶️ fetchGiamGiaTheoLoai() được gọi"); // 🔹 DEBUG

      isLoading = true;
      errorMessage = null;
      notifyListeners();

      try {
        // 1. Lấy danh sách giảm giá theo khách hàng
        String maKH = (await _nguoiDungRepo.getNguoiDungHienTai())?.id ?? "";
        print("🔹 MaKH hiện tại: $maKH"); // 🔹 DEBUG

        final giamGias = await _giamGiaRepo.getGiamGiaTheoMaKH(maKH);
        print("🔹 Số lượng giảm giá lấy được: ${giamGias.length}"); // 🔹 DEBUG

        // 2. Lấy danh sách loại giảm giá
        final loaiGiamGias = await _giamGiaRepo.getLoaiGiamGia();
        print("🔹 Số lượng loại giảm giá: ${loaiGiamGias.length}"); // 🔹 DEBUG

        // 3. Gom nhóm giảm giá theo loại (Map)
        final Map<String, List<GiamGiaModel>> grouped = {
          for (var loai in loaiGiamGias)
            loai.TenLoai: giamGias.where((gg) => gg.MaLoaiGG == loai.MaLoaiGG).toList()
        };

        // 4. Lưu dữ liệu vào ViewModel
        danhSachGiamGia = giamGias;
        danhSachLoaiGG = loaiGiamGias;
        groupedDiscounts = grouped;

        // 🔹 DEBUG: in ra dữ liệu
        for (var gg in giamGias) {
          print("GG: ${gg.Code}, MaLoaiGG='${gg.MaLoaiGG}'");
        }
        for (var loai in loaiGiamGias) {
          print("Loai: ${loai.TenLoai}, MaLoaiGG='${loai.MaLoaiGG}'");
        }
        groupedDiscounts.forEach((tenLoai, dsGiamGia) {
          print("Loại giảm giá: $tenLoai");
          for (var g in dsGiamGia) {
            print("  - ${g.Code} | ${g.GiaTri} | ${g.MaLoaiGG}");
          }
        });
      } catch (e) {
        errorMessage = "Lỗi khi lấy dữ liệu giảm giá theo loại: $e";
        print("❌ $errorMessage");
      } finally {
        isLoading = false;
        notifyListeners();
        print("✅ fetchGiamGiaTheoLoai() kết thúc"); // 🔹 DEBUG
      }
    }

    Future<NguoiDung?> fetchNguoiDung() async {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      try {
        String maKH = (await _nguoiDungRepo.getNguoiDungHienTai())?.id ?? "";
        // await để chờ Future trả về NguoiDung
        NguoiDung? khachHang = await _nguoiDungRepo.getNguoiDung(maKH);
        nguoiDung = khachHang;
        return nguoiDung; // trả về null nếu không tìm thấy
      } catch (e) {
        errorMessage = "Lỗi khi lấy dữ liệu người dùng: $e";
        print("❌ $errorMessage");
        return null; // trả về null khi lỗi
      } finally {
        isLoading = false;
        notifyListeners();
      }
    }

    Future<List<DiaChiModel>> fetchDiaChiKH() async {
      try {
        print("🟡 [DEBUG] Gọi hàm fetchDiaChiKH...");
        isLoading = true;
        errorMessage = null;
        notifyListeners();

        String maKH = (await _nguoiDungRepo.getNguoiDungHienTai())?.id ?? "";

        // Lấy danh sách địa chỉ
        final result = await _diaChiRepo.getDiaChiKhachHang();

        // Ép kiểu sang List<DiaChiModel> nếu chắc chắn kiểu trả về
        danhSachDiaChi = result as List<DiaChiModel>;

        // 🔹 In ra từng địa chỉ
        for (var dc in danhSachDiaChi) {
          print("📍 Địa chỉ: MaDiaChi=${dc.id}, SoNha=${dc.soNha}, Duong=${dc.Duong}, "
              "Phuong_Xa=${dc.phuongXa}, Quan_Huyen=${dc.quanHuyen}, TrangThai=${dc.status}");
        }

        return danhSachDiaChi; // 🔹 Trả về danh sách

      } catch (e) {
        errorMessage = "Lỗi khi lấy danh sách địa chỉ: $e";
        print("❌ $errorMessage");
        return []; // 🔹 Trả về list rỗng nếu lỗi
      } finally {
        isLoading = false;
        notifyListeners();
      }
    }

    String? selectThanhToan;

    // Hàm chọn phương thức thanh toán
    void chonPhuongThucThanhToan(String method) {
      selectThanhToan = method;
      notifyListeners();
    }

    Future<String?> thanhToanVNPay() async {
      print("Thanh toán VNPay Được gọi");
      // Gọi service để lấy paymentUrl
      // String? url = await _vnPayService.createPayment(
      //   name: "Nguyen Van A",
      //   amount: total,
      //   orderDescription: "Thanh toán đơn hàng FastFood",
      // );
      return null;
    }


  }

