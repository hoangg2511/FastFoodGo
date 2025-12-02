import 'package:flutter/cupertino.dart';
import '../Models/DiaChiModel.dart';
import '../Repository/DiaChiRepository.dart';

class DiaChiViewModel extends ChangeNotifier {
  final DiaChiRepository _repo = DiaChiRepository();

  List<DiaChiModel> _diaChiList = [];
  List<DiaChiModel> get diaChiList => _diaChiList;

  bool _isLoading = false;
  bool get isLoading => _isLoading;


  Future<void> fetchDiaChi() async {
    _isLoading = true;
    notifyListeners();
    _diaChiList = await _repo.getDiaChiKhachHang();
    _isLoading = false;
    notifyListeners();
  }


  Future<void> addDiaChi(DiaChiModel diaChi) async {
    _isLoading = true;
    notifyListeners();

    final newId = await _repo.addDiaChi(diaChi);
    if (newId != null) {
      diaChi.id = newId;
      _diaChiList.add(diaChi);
      print("Thêm địa chỉ vào ViewModel: ${diaChi.id}");
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateDiaChi(DiaChiModel diaChi) async {
    _isLoading = true;
    notifyListeners();

    await _repo.updateDiaChi(diaChi);

    final index = _diaChiList.indexWhere((d) => d.id == diaChi.id);
    if (index != -1) {
      _diaChiList[index] = diaChi;
      print("Cập nhật địa chỉ trong ViewModel: ${diaChi.id}");
    }

    _isLoading = false;
    notifyListeners();
  }


  Future<void> deleteDiaChi(String id) async {
    _isLoading = true;
    notifyListeners();

    await _repo.deleteDiaChi(id);
    _diaChiList.removeWhere((d) => d.id == id);
    print("Xóa địa chỉ trong ViewModel: $id");

    _isLoading = false;
    notifyListeners();
  }
}
