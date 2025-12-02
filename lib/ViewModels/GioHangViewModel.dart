// lib/ViewModel/GioHangViewModel.dart
import 'package:flutter/foundation.dart';
import '../Models/GioHangModel.dart';
import '../Models/DiaChiModel.dart';
import '../Repository/DiaChiRepository.dart';
import '../Repository/GioHangRepository.dart';

class GioHangViewModel extends ChangeNotifier {
  final GioHangRepository _gioHangRepo = GioHangRepository();
  final DiaChiRepository _diaChiRepo = DiaChiRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<DiaChiModel> _diaChiList = [];
  List<DiaChiModel> get diaChiList => _diaChiList;

  List<GioHangModel> get items => _gioHangRepo.getItems();

  double get totalPrice => _gioHangRepo.getTotalPrice();
  double get subtotal => _gioHangRepo.getTotalPrice();
  int get totalQuantity => _gioHangRepo.getTotalQuantity();

  void addItem(GioHangModel item) {
    _gioHangRepo.addItem(item);
    notifyListeners();
  }

  void removeItem(int index) {
    _gioHangRepo.removeItem(index);
    notifyListeners();
  }

  void resetCart() {
    _gioHangRepo.resetCart();
    notifyListeners();
  }

  void updateQuantity(int index, bool increment) {
    _gioHangRepo.updateQuantity(index, increment);
    notifyListeners();
  }

  Future<void> proceedToCheckout() async {
    await Future.delayed(const Duration(seconds: 2));
    resetCart();
  }


  Future<void> loadDiaChi(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _diaChiList = await _diaChiRepo.getDiaChiByUser();
    } catch (e) {
      print("Lỗi khi load địa chỉ: $e");
      _diaChiList = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<List<DiaChiModel>> getDefaultAddress(String userId) async {
    return await _diaChiRepo.getDiaChiKhachHang();
  }
}
