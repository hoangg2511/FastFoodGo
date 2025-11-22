import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fastfoodgo/Models/LoaiMonAnModel.dart';

class LoaiMonAnRepository{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<LoaiMonAnModel>> getLoaiMonAn() async {
    try {
      final query = await _firestore.collection("LoaiMonAn").get();
      return query.docs
          .map((doc) => LoaiMonAnModel(
        id: doc.id,
        Ten: doc['Ten'],
      ))
          .toList();

    } catch (e) {
      print("Lỗi khi lấy danh sách loại món ăn: $e");
      return [];
    }
  }
}