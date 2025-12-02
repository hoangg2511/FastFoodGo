

import '../Models/MonAnModel.dart';
import '../Models/OptionMonAnModel.dart';
import '../Repository/MonAnRepository.dart';
import 'package:flutter/foundation.dart';

import 'GioHangViewModel.dart';
class ChiTietMonAnViewModel extends ChangeNotifier {
  final MonAnRepository _repository = MonAnRepository();

  final GioHangViewModel gioHangVM;
  ChiTietMonAnViewModel({required this.gioHangVM});
  Map<String, dynamic>? _chiTietMonAn;
  Map<String, dynamic>? get chiTietMonAn => _chiTietMonAn;
  bool isLoading = false;
  Map<String, List<OptionMonAnModel>> optionData = {};
  MonAnModel? monAnData ;
  Map<String, String> selectedOptionsByGroup = {};
  Map<String, double> selectedOptionsPriceByGroup = {};
  Map<String, double> optionPrices = {};
  String _itemNote = '';
  String get itemNote => _itemNote;
  Map<String, bool> selectedSizes = {
    'Nhỏ': false,
    'Vừa': true,
    'Lớn': false,
  };
  Map<String, double> sizePrices = {
    'Nhỏ': 0,
    'Vừa': 0,
    'Lớn': 5000,
  };
  void _toggleSize(String size) {

  }
  set itemNote(String value) {
    _itemNote = value;
    notifyListeners();
  }
  double basePrice  = 0;
  double totalPrice = 0;
  int _quantity = 1;

  int get quantity => _quantity;

  set quantity(int value) {
    if (value < 1) return;
    _quantity = value;
    updateTotalPrice();
    notifyListeners();
  }
  void updateTotalPrice() {
    double optionsTotal = 0;
    selectedOptionsPriceByGroup.forEach((group, price) {
      optionsTotal += price;
    });
      totalPrice = (basePrice + optionsTotal) * quantity;
    notifyListeners();
  }
  void selectOption(String groupName, String optionName, double price) {
      if (selectedOptionsByGroup[groupName] == optionName) {
        selectedOptionsByGroup.remove(groupName);
        selectedOptionsPriceByGroup.remove(groupName);
      } else {
        selectedOptionsByGroup[groupName] = optionName;
        selectedOptionsPriceByGroup[groupName] = price;
      }
      updateTotalPrice();
      notifyListeners();
  }
  void updateQuantity(bool increment) {
      if (increment) {
        quantity++;
      } else if (quantity > 1) {
        quantity--;
      }
      updateTotalPrice();
      notifyListeners();
  }
  Future<Map<String, dynamic>?> fetchChiTietMonAn(String monAnId) async {
    try {
      isLoading = true;
      notifyListeners();

      final MonAnModel? monAn = await _repository.getChiTietMonAn(monAnId);
      if (monAn == null) {
        return null;
      }

      monAnData = monAn;
      basePrice = (monAn.Gia).toDouble();
      print("Giá gốc (Base Price) đã set: $basePrice");


      final List<LoaiOptionModel>? loaiOptionList = await _repository.getLoaiOption(monAnId);
      Map<String, List<OptionMonAnModel>> optionMap = {};


      if (loaiOptionList != null && loaiOptionList.isNotEmpty) {
        print("Tổng số loại: ${loaiOptionList.length}");
        for (var loai in loaiOptionList) {
          print("  - ID: ${loai.id}, Tên Loại: ${loai.ten}");
        }

        for (var loaiOption in loaiOptionList) {
          final loaiOptionId = loaiOption.id;
          final List<OptionMonAnModel>? optionList = await _repository.getOptionMonAn(loaiOptionId);
          if (optionList != null && optionList.isNotEmpty) {

            optionMap.putIfAbsent(loaiOption.ten, () => []).addAll(optionList);
          } else {
            print("  -> Không có Options nào cho Loại: ${loaiOption.ten} (ID: $loaiOptionId)");
          }
        }
      } else {
        print('⚠️ Không có Loại Option nào được trả về. OptionMap rỗng được khởi tạo.');
      }


      _chiTietMonAn = {
        'monAn': monAn,
        'optionMap': optionMap,
      };
      optionData = optionMap;

      return _chiTietMonAn;

    } catch (e, st) {
      print("Lỗi khi fetch chi tiết món ăn: $e");
      print(st);
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }


}
