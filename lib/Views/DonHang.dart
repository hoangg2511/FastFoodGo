import 'package:fastfoodgo/Models/DonHangModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Models/OrderItem.dart';
import '../ViewModels/DonHangViewModel.dart';

class DonHangPage extends StatefulWidget {
  const DonHangPage({Key? key}) : super(key: key);

  @override
  State<DonHangPage> createState() => _DonHangPageState();
}

class _DonHangPageState extends State<DonHangPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final vm = DonHangViewModel();
        vm.getOrders(); // 🔹 gọi ngay khi khởi tạo
        return vm;
      },
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: const Text(
            'Đơn hàng',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          bottom: TabBar(
            controller: _tabController,
            labelColor: Colors.orange[700],
            unselectedLabelColor: Colors.grey[600],
            labelStyle:
            const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            unselectedLabelStyle:
            const TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
            indicatorColor: Colors.orange[700],
            indicatorWeight: 3,
            tabs: const [
              Tab(text: 'Đang thực hiện'),
              Tab(text: 'Lịch sử'),
            ],
          ),
        ),
        body: Consumer<DonHangViewModel>(
          builder: (context, vm, child) {
            return TabBarView(
              controller: _tabController,
              children: [
                _buildProcessingOrders(vm, context),
                _buildOrderHistory(vm, context),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildProcessingOrders(DonHangViewModel vm, BuildContext context) {
    if (vm.processingOrders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.delivery_dining, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text('Hiện tại chưa có đơn hàng nào',
                style: TextStyle(fontSize: 16, color: Colors.grey[600])),
            const SizedBox(height: 8),
            Text('Đặt món ngay để thưởng thức!',
                style: TextStyle(fontSize: 14, color: Colors.grey[500])),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: vm.processingOrders.length,
      itemBuilder: (context, index) {
        return _buildOrderCard(
          vm,
          vm.processingOrders[index],
          showReorder: false,
          context: context,
        );
      },
    );
  }

  Widget _buildOrderHistory(DonHangViewModel vm, BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: vm.orders.length,
      itemBuilder: (context, index) {
        return _buildOrderCard(vm, vm.orders[index], context: context);
      },
    );
  }

  Widget _buildOrderCard(
      DonHangViewModel vm,
      Map<String, dynamic> order, {
        bool showReorder = true,
        required BuildContext context,
      }) {
    final tenMon = order['tenMon'];
    final imageUrl = order['imageUrl'];
    final price = order['price'];
    final rating = order['rating'];
    final status = order['status'];
    final date = order['date'];
    print(imageUrl);
    print(price);
    print(rating);
    print(status);
    print(date.toString());
    print(tenMon);

    // Hàm helper để lấy màu sắc và style cho trạng thái
    Map<String, dynamic> _getStatusStyle(String status) {
      switch (status) {
        case 'Đang chờ xác nhận':
          return {
            'color': Colors.yellow[800],
            'bgColor': Colors.yellow,
            'icon': Icons.access_time,
          };
        case 'Đang thực hiện':
          return {
            'color': Colors.blue[700],
            'bgColor': Colors.blue[100],
            'icon': Icons.access_time,
          };
        case 'Đã Hoàn Thành':
          return {
            'color': Colors.green[700],
            'bgColor': Colors.green[100],
            'icon': Icons.check_circle,
          };
          case 'Đã hủy':
          return {
            'color': Colors.red[700],
            'bgColor': Colors.red[100],
            'icon': Icons.cancel,
          };
        case 'Đang giao':
          return {
            'color': Colors.orange[700],
            'bgColor': Colors.orange[100],
            'icon': Icons.delivery_dining,
          };
        default:
          return {
            'color': Colors.grey[700],
            'bgColor': Colors.grey[100],
            'icon': Icons.info,
          };
      }
    }

    final statusStyle = _getStatusStyle(status);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header với trạng thái đơn hàng
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Đơn hàng #${order['id'] ?? ''}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusStyle['bgColor'],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        statusStyle['icon'],
                        color: statusStyle['color'],
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        status,
                        style: TextStyle(
                          color: statusStyle['color'],
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Thông tin sản phẩm
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey[200],
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Icon(
                      Icons.restaurant,
                      color: Colors.grey[600],
                      size: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              order['tenMon'] ?? 'Tên món ăn',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            vm.formatPrice(price),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                     // Text(
                     //   'Option món ăn',   // 🔥 Chỉ giữ value
                     //    style: TextStyle(
                     //      fontSize: 10,
                     //      color: Colors.orange[700],
                     //      fontWeight: FontWeight.w500,
                     //    ),
                     //  ),
                    const SizedBox(height: 8),
                      Row(
                        children: [
                          if (rating > 0) ...[
                            const Icon(Icons.star, color: Colors.amber, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              rating.toString(),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 16),
                          ],
                          Icon(Icons.calendar_today, size: 14, color: Colors.grey[500]),
                          const SizedBox(width: 4),
                          Text(
                            date.toString(),
                            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Nút đặt lại
            if (showReorder && status != 'Đã hủy') ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {}, //=> vm.reorderItem(order)
                  icon: Icon(Icons.refresh, color: Colors.orange[700], size: 20),
                  label: Text(
                    'Đặt lại',
                    style: TextStyle(
                      color: Colors.orange[700],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.orange[300]!),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
