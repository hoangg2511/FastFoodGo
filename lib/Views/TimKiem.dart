import 'package:fastfoodgo/Models/CuaHangModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../ViewModels/TimKiemViewModel.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final SearchViewModel _viewModel = SearchViewModel();

  @override
  void initState() {
    super.initState();
    _viewModel.fetchCuaHang().then((cuaHangList) {
      if (cuaHangList.isNotEmpty) {
        print("======== DỮ LIỆU TỪ INIT STATE ĐÃ TẢI XONG ========");
        for (var ch in cuaHangList) {
          print("🏪 Tên Cửa Hàng: ${ch.TenCuaHang}");
          print("  ID: ${ch.id}, Đánh Giá: ${ch.DanhGia}");
          print("  Khoảng Cách: ${ch.khoangCach}");
          print("-------------------------------------------------");
        }
        print("=================================================");
      } else {
        print("🔴 fetchCuaHang() trả về danh sách rỗng.");
      }
    }).catchError((error) {
      print("❌ Lỗi khi tải dữ liệu trong initState: $error");
    });
  }
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  // Sửa trong file SearchScreen.dart (hàm build)

  @override
  Widget build(BuildContext context) {
    // ✅ CÁCH SỬA ĐÚNG: CHỈ DÙNG .value
    return ChangeNotifierProvider.value(
      value: _viewModel, // Cung cấp instance đã được tạo trong initState
      child: Builder(
        builder: (context) {
          // ... (phần còn lại của Scaffold)
          return Scaffold(
            appBar: AppBar(
              title: const Text('Tìm kiếm'),
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildSearchBar(context),
                  const SizedBox(height: 20),
                  _buildFilterButtons(context),
                  const SizedBox(height: 20),
                  _buildResultCount(context),
                  const SizedBox(height: 10),
                  Expanded(child: _buildList(context)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }


  // 🔍 Ô tìm kiếm
  Widget _buildSearchBar(BuildContext context) {
    final vm = context.read<SearchViewModel>();

    return SearchBar(
      controller: _searchController,
      hintText: "Tìm kiếm món ăn, cửa hàng",
      leading: const Icon(Icons.search),
      backgroundColor: const WidgetStatePropertyAll(Colors.white),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: Colors.blue, width: 2),
        ),
      ),
      // ⚙️ Sử dụng debounce tránh rebuild khi đang gõ
      onChanged: (value) {
        vm.search(value);
      },
    );
  }

  // 🟣 Filter
  Widget _buildFilterButtons(BuildContext context) {
    final vm = context.watch<SearchViewModel>();
    final filters = ["Tất cả", "Gà rán", "Burger", "Pizza", "Đồ uống", "Tráng miệng"];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((filter) {
          final isSelected = vm.selectedFilter == filter;
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: TextButton(
              onPressed: () => vm.applyFilter(filter),
              style: TextButton.styleFrom(
                backgroundColor: isSelected ? Colors.blue[100] : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                filter,
                style: TextStyle(
                  color: isSelected ? Colors.blue[700] : Colors.black87,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // 🧮 Kết quả
  Widget _buildResultCount(BuildContext context) {
    final vm = context.watch<SearchViewModel>();
    return Row(
      children: [
        const Text("Kết quả tìm kiếm: "),
        Text(
          "${vm.filteredItems.length}",
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
        ),
      ],
    );
  }

  // 🧾 Danh sách món
// 🧾 Danh sách món
  Widget _buildList(BuildContext context) {
    // Bọc phần cần dữ liệu bằng Consumer
    return Consumer<SearchViewModel>(
      builder: (context, vm, child) {
        if (vm.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final items = vm.filteredItems;

        if (items.isEmpty) {
          return const Center(child: Text("Không tìm thấy kết quả."));
        }
        return ListView.builder(
          itemCount: items.length,
          itemBuilder: (_, i) => _buildItem(items[i]),
        );
      },
    );
  }

  Widget _buildItem(CuaHangModel item) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              item.AnhDaiDien.toString(),
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  Container(width: 100, height: 100, color: Colors.grey[200], child: const Icon(Icons.fastfood)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.TenCuaHang,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87)),
                  const SizedBox(height: 4),
                  // Text(item.restaurant, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                  // const SizedBox(height: 8),
                  // Text(item.price,
                  //     style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.orange[400])),
                  // const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text("${item.DanhGia}", style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                      const SizedBox(width: 16),
                      const Icon(Icons.location_on, color: Colors.grey, size: 16),
                      const SizedBox(width: 4),
                      Text(item.khoangCach, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
