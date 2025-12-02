import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../ViewModels/GioHangViewModel.dart';
import '../ViewModels/QRCodeViewModel.dart';

class QRCodeView extends StatelessWidget {
  final int amount;
  final String description;
  GioHangViewModel? gioHangVM;
  QRCodeView({
    required this.amount,
    required this.description,
  });

  // Hàm này sẽ pop 3 màn hình
  void _popThreeScreens(BuildContext context) {
    int count = 0;
    // Sử dụng popUntil với kiểm tra route
    Navigator.of(context).popUntil((_) => count++ >= 3);

    // *Lưu ý: Cách phổ biến hơn là dùng tên route nếu bạn có đặt tên
    // Navigator.of(context).popUntil(ModalRoute.withName('/home'));
    // Nếu màn hình muốn quay về là '/home'
  }

  @override
  Widget build(BuildContext context) {
    // Lấy instance GioHangViewModel từ Provider
    gioHangVM ??= Provider.of<GioHangViewModel>(context, listen: false);

    return ChangeNotifierProvider(
      create: (context) => QRCodeViewModel()..loadQRCode(amount, description),
      child: Scaffold(
        appBar: AppBar(title: Text("QR Thanh Toán")),
        body: Consumer<QRCodeViewModel>(
          builder: (context, model, _) {
            return StreamBuilder<String>(
              stream: model.paymentStatusStream,
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data == "new_transaction") {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    // Reset giỏ hàng
                    gioHangVM?.resetCart();

                    // Pop 3 màn hình
                    _popThreeScreens(context);
                  });

                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle, color: Colors.green, size: 80),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            "Thanh toán thành công!",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // --- Logic hiển thị QR Code ---
                if (model.isLoading) return Center(child: CircularProgressIndicator());
                if (model.errorMessage != null) return Center(child: Text("Lỗi: ${model.errorMessage}"));
                if (model.qrUrl == null) return Center(child: Text("Đang tạo mã QR..."));

                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(model.qrUrl!),
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          "Vui lòng quét mã để thanh toán...",
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

}