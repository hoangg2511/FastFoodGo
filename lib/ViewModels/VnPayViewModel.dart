
import 'package:fastfoodgo/Repository/NguoiDungRepository.dart';
import 'package:flutter/material.dart';
import '../Models/PaymentInformationModel.dart';
import '../Views/PaymentWebViewScreen.dart';
import '../Repository/DonHangRepository.dart';
import '../Service/VnPayService.dart';

class VnPayViewModel extends ChangeNotifier {
  final VnPayService _vnpayService = VnPayService();
  final NguoiDungRepository _repoNguoiDung = NguoiDungRepository();
  final DonHangRepository _repoDonHang = DonHangRepository();


  String? _paymentUrl;
  String? get paymentUrl => _paymentUrl;


  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;


  bool paymentCompleted = false;

  VnPayViewModel();


  Future<String?> createPayment(double amount, String orderDescription) async {
    _errorMessage = null;
    _paymentUrl = null;
    _isLoading = true;
    notifyListeners();

    try {
      final nd = await _repoNguoiDung.getNguoiDungHienTai();
      if (nd == null) {
        _errorMessage = 'Không tìm thấy thông tin người dùng.';
        _isLoading = false;
        notifyListeners();
        return null;
      }

      final model = PaymentInformationModel(
        orderType: 'online_payment',
        amount: amount,
        orderDescription: orderDescription,
        name: nd.hoTen,
      );


      final url = await _vnpayService.createPaymentUrl(model);


      if (url != null && url.isNotEmpty) {
        _paymentUrl = url;
        _isLoading = false;
        notifyListeners();
        return url;
      } else {
        _errorMessage = 'Không thể tạo URL thanh toán. Vui lòng kiểm tra lại.';
        _isLoading = false;
        notifyListeners();
        return null;
      }
    } catch (e, stack) {
      _errorMessage = 'Đã xảy ra lỗi: $e';
      debugPrint(stack.toString());
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }


  Future<void> completePayment(String callbackUrl) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final uri = Uri.parse(callbackUrl);
      final query = uri.query;

      final response = await _vnpayService.getPaymentCallback(query);

      if (response == null) {
        paymentCompleted = false;
        _errorMessage = 'Không nhận được phản hồi từ API callback.';
        print('[Payment] Response từ API callback null');
        return;
      }

      final responseCode = response['vnp_ResponseCode'];
      final transactionStatus = response['vnp_TransactionStatus'];
      final orderId = response['vnp_TxnRef'];


      if (responseCode == '00' && transactionStatus == '00') {
        paymentCompleted = true;
        _errorMessage = null;
      } else {

        paymentCompleted = false;
        _errorMessage = 'Thanh toán thất bại (Mã lỗi: $responseCode)';
        print('⚠️ [Payment] Lỗi thanh toán: $responseCode');

        if (orderId != null) {
          try {
            final donHangRepo = DonHangRepository();
            await donHangRepo.xoaDonHang(orderId);
            print('🗑️ [Payment] Đã xóa đơn hàng do thanh toán thất bại: $orderId');
          } catch (e) {
            print('[Payment] Lỗi khi xóa đơn hàng thất bại: $e');
          }
        }
      }
    } catch (e) {
      paymentCompleted = false;
      _errorMessage = 'Lỗi khi xác nhận thanh toán: $e';
      print('[Payment] Exception: $e');
    } finally {
      _paymentUrl = null;
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> xoaDonHang(String maDh) async {
    try {
      await _repoDonHang.xoaDonHang(maDh); // 🔹 Gọi hàm trong Repository
      notifyListeners();
      print('[VM] Đã xóa đơn hàng $maDh');
    } catch (e) {
      print('[VM] Lỗi khi xóa đơn hàng: $e');
      rethrow;
    }
  }

  void resetUrl() {
    _paymentUrl = null;
    notifyListeners();
  }
}
