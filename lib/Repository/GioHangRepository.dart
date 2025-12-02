
import '../Models/GioHangModel.dart';
import 'package:collection/collection.dart';
class GioHangRepository {
   List<GioHangModel> _gioHang = [];

  List<GioHangModel> getItems() => List.unmodifiable(_gioHang);

   void addItem(GioHangModel item) {
     final existingIndex = _gioHang.indexWhere((existing) {
       if (existing.monAnId != item.monAnId) return false;
       if ((existing.note) != (item.note)) return false;
       if (existing.selectedOptions == null && item.selectedOptions == null) {
         return true;
       }
       if (existing.selectedOptions == null || item.selectedOptions == null) {
         return false;
       }
       return const MapEquality().equals(existing.selectedOptions!, item.selectedOptions!);
     });
     if (existingIndex != -1) {
       final existingItem = _gioHang[existingIndex];
       existingItem.quantity++;
       existingItem.finalPrice = existingItem.basePrice * existingItem.quantity;

       print("Đã tăng số lượng món: ${existingItem.monAnId} -> ${existingItem.quantity}");
     } else {
       _gioHang.add(item);
       print("Đã thêm sản phẩm mới: ${item.monAnId} (note: ${item.note})");
     }

     _gioHang = List.from(_gioHang);
   }



   void resetCart() {
    _gioHang.clear();
    print("GIỎ HÀNG ĐÃ ĐƯỢC RESET.");
  }
   void removeItem(int index) {
     if (index < 0 || index >= _gioHang.length) return;
     _gioHang.removeAt(index);
     _gioHang = List.from(_gioHang);
   }


   void updateQuantity(int index, bool increment) {
     if (index < 0 || index >= _gioHang.length) return;
     final item = _gioHang[index];
     if (increment) {
       item.quantity++;
     } else if (item.quantity > 1) {
       item.quantity--;
     }

     item.finalPrice = item.basePrice * item.quantity;

     print("Cập nhật số lượng cho item thứ $index: ${item.quantity}, Giá cuối: ${item.finalPrice}");

     // Tạo copy để trigger UI nếu dùng ViewModel
     _gioHang = List.from(_gioHang);
   }



   double getTotalPrice() {
     double total = 0.0;
     for (var item in _gioHang) {

       double itemTotal = item.finalPrice;


       total += itemTotal;

       // Debug: in thông tin món và tổng tạm thời
       print("Món: ${item.monAnId}, Số lượng: ${item.quantity}, Giá cuối: ${item.finalPrice}, Tổng tạm: $total");
     }

     // Trả về tổng giá
     return total;
   }


   int getTotalQuantity() {
    return _gioHang.fold(0, (sum, item) => sum + item.quantity);
  }
}
