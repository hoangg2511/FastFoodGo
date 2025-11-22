import 'package:fastfoodgo/Models/GioHangModel.dart';
import 'package:fastfoodgo/ViewModels/GioHangViewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Models/OptionMonAnModel.dart';
import '../ViewModels/ChiTietMonAnViewModel.dart';


class ChiTietMonAn extends StatefulWidget {
  final String MonAn;
  const ChiTietMonAn({super.key, required this.MonAn});

  @override
  State<ChiTietMonAn> createState() => _ChiTietMonAnState();
}

class _ChiTietMonAnState extends State<ChiTietMonAn> {
  late ChiTietMonAnViewModel ChiTietMonAnVM;
  late GioHangViewModel GioHangVM;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ChiTietMonAnVM = context.read<ChiTietMonAnViewModel>();
      ChiTietMonAnVM.isLoading   = true;
      await ChiTietMonAnVM.fetchChiTietMonAn(widget.MonAn);
      ChiTietMonAnVM.updateTotalPrice();
    });
  }

  String _formatPrice(double price) {
    return '${price.toInt().toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
    )}đ';
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      extendBodyBehindAppBar: true,
      appBar: AppBar( elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title:
        Text(
          "Thêm món mới",
          style:
          TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(
              Icons.arrow_back,
              color: Colors.black
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildImageSection(),
            _buildAllToppingSections(),
            _buildNoteSection(),
            _buildQuantitySection(),
            SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomButton(),
    );
  }
  Widget _buildImageSection() {
    final viewModel = context.watch<ChiTietMonAnViewModel>();
    final monAn = viewModel.monAnData;
    if (viewModel.isLoading || monAn== null) {
      return Container(
        height: 400,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Container(
      height: 400,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 400,
            child: ClipRRect(
              child: Image.network(
                monAn.HinhAnh.toString(),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: Center(
                      child: Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                    ),
                  );
                },
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              monAn.TenMonAn,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              monAn.MoTa,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.green[100],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.star, color: Colors.green[700], size: 16),
                            const SizedBox(width: 4),
                            Text(
                              monAn.DanhGia.toString(),
                              style: TextStyle(
                                color: Colors.green[700],
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _formatPrice(double.tryParse(monAn.Gia.toString()) ?? 0),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange[700],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildSizeSection(Map<String, double> sizesMap) {
    final viewModel = context.watch<ChiTietMonAnViewModel>();
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Chọn size",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: viewModel.selectedSizes.keys.map((size) {
              bool isSelected = viewModel.selectedSizes[size] ?? false;
              Object price =viewModel.selectedSizes[size] ?? 0;

              return Container(
                width: 107,
                margin: EdgeInsets.only(right: size == 'Lớn' ? 0 : 8),
                child: InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    height: 100,
                    padding: EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.orange[600] : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? Colors.orange[600]! : Colors.grey[300]!,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          size,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : Colors.black87,
                          ),
                        ),
                        if (price != 0) ...[
                          SizedBox(height: 4),
                          Text(
                            '+${_formatPrice((price as num).toDouble())}',
                            style: TextStyle(
                              fontSize: 12,
                              color: isSelected ? Colors.white.withOpacity(0.9) : Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          )
        ],
      ),
    );
  }
  Widget _buildAllToppingSections() {
    final viewModel = context.watch<ChiTietMonAnViewModel>();
    if (viewModel.isLoading) {
      return Container(
        height: 200,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final optionData = viewModel.optionData;
    if (optionData.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          "Không có tùy chọn thêm cho món này.",
          style: TextStyle(color: Colors.grey[600]),
        ),
      );
    }

    List<Widget> sections = [];
    optionData.forEach((title, value) {
      if (title.toLowerCase() == 'size') {
        Map<String, double> sizesMap = {};
        for (var opt in value) {
          final sizeName = opt.ten;
          final sizePrice = (opt.gia).toDouble();
          sizesMap[sizeName] = sizePrice;
        }
        sections.add(_buildSizeSection(sizesMap));
      } else {
        sections.add(_buildToppingsSection(title, value));
      }
    });

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: sections,
      ),
    );
  }
  Widget _buildToppingsSection(String title, List<OptionMonAnModel> items) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.add_circle_outline, color: Colors.orange[600], size: 20),
              SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          ...items.map((opt) {
            return _buildToppingItem(
              title,
              opt.ten,
              opt.gia.toDouble(),
            );
          }).toList(),
        ],
      ),
    );
  }
  Widget _buildToppingItem(String groupName, String optionName, double price) {
    return Consumer<ChiTietMonAnViewModel>(
      builder: (context, viewModel, child) {
        final bool isSelected = viewModel.selectedOptionsByGroup[groupName] == optionName;

        return Container(
          margin: EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: () {
              print("🔥 Topping được chọn: $groupName -> $optionName, price: $price");
              viewModel.selectOption(groupName, optionName, price);
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isSelected ? Colors.orange[50] : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? Colors.orange[300]! : Colors.grey[200]!,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          optionName,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: isSelected ? Colors.orange[800] : Colors.black87,
                          ),
                        ),
                        if (price > 0)
                          Text(
                            "+${_formatPrice(price)}",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.orange[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.orange[600] : Colors.white,
                      border: Border.all(
                        color: isSelected ? Colors.orange[600]! : Colors.grey[400]!,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: isSelected
                        ? Icon(Icons.check, color: Colors.white, size: 16)
                        : null,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }


  Widget _buildNoteSection() {
    final viewModel = context.watch<ChiTietMonAnViewModel>();
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.edit_note, color: Colors.orange[600], size: 20),
              SizedBox(width: 8),
              Text(
                "Ghi chú món ăn",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          TextField(
            onChanged: (value) {
              setState(() {
                viewModel.itemNote = value;
              });
            },
            decoration: InputDecoration(
              hintText: 'Ví dụ: Không hành, ít đá, không đường...',
              hintStyle: TextStyle(
                color: Colors.grey[400],
                fontSize: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.orange[600]!, width: 2),
              ),
              contentPadding: EdgeInsets.all(16),
              filled: true,
              fillColor: Colors.grey[50],
            ),
            maxLines: 3,
            maxLength: 200,
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.info_outline, size: 14, color: Colors.grey[500]),
              SizedBox(width: 4),
              Expanded(
                child: Text(
                  'Những yêu cầu đặc biệt có thể làm tăng thời gian chế biến',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[500],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuantitySection() {
    final viewModel = context.watch<ChiTietMonAnViewModel>();
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Số lượng",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildQuantityButton(Icons.remove, () => viewModel.updateQuantity(false)),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 32),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  viewModel.quantity.toString(),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              _buildQuantityButton(Icons.add, () => viewModel.updateQuantity(true)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityButton(IconData icon, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange[300]!),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.orange[700]),
        style: IconButton.styleFrom(
          padding: EdgeInsets.all(12),
          minimumSize: Size(48, 48),
        ),
      ),
    );
  }

  Widget _buildBottomButton( ) {
    final viewModel = context.read<ChiTietMonAnViewModel>();
    final monAnData = viewModel.monAnData;
    if (monAnData == null) {
      return Container(height: 80, child: Center(child: Text("Đang tải dữ liệu món ăn...")));
    }
    final tenMonAn = monAnData.TenMonAn;
    final basePriceValue = viewModel.totalPrice;
    final imgUrl = monAnData.HinhAnh ?? "";
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange[600]!, Colors.orange[700]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.orange.withOpacity(0.3),
                blurRadius: 15,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(15),
              onTap: () {
                final GioHangModel newItem = GioHangModel(
                  monAnId: monAnData.id,
                  tenMonAn: tenMonAn,
                  basePrice: double.tryParse(basePriceValue.toString()) ?? 0.0,
                  note: viewModel.itemNote,
                  finalPrice: viewModel.totalPrice,
                  selectedOptions: viewModel.selectedOptionsByGroup,
                  imgUrl: imgUrl,
                );
                try {
                  context.read<GioHangViewModel>().addItem(newItem);
                  Navigator.pop(context, true);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Lỗi: Thêm món thất bại.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  Navigator.pop(context, false);
                  print('Lỗi khi thêm món vào giỏ: $e');
                }
              },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shopping_cart, color: Colors.white),
                    SizedBox(width: 12),
                    Text(
                      "Thêm vào giỏ",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 20),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _formatPrice(viewModel.totalPrice),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
