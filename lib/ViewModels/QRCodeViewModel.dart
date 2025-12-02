import 'package:flutter/material.dart';
import '../Repository/QRCodeRepository.dart';
import '../Models/QRCodeModel.dart';

class QRCodeViewModel extends ChangeNotifier {

  final QRCodeRepository _repo = QRCodeRepository();

  String? qrUrl;
  bool isLoading = false;
  String? errorMessage;


  Stream<String> get paymentStatusStream => _repo.listenPaymentStatus();

  @override
  void dispose() {
    _repo.dispose();
    super.dispose();
  }



  Future<void> loadQRCode(int amount, String description) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final qrCodeModel = await _repo.getPaymentUrl(amount.toDouble(), description);


      qrUrl = qrCodeModel.paymentUrl;

      isLoading = false;
      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      isLoading = false;
      print('Lỗi tải mã QR: $errorMessage');
      notifyListeners();
    }
  }
}