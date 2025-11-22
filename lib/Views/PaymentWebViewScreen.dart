import 'package:fastfoodgo/ViewModels/ThanhToanViewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../ViewModels/GioHangViewModel.dart';

class PaymentWebViewScreen extends StatefulWidget {
  final String paymentUrl;
  final Function(String callbackUrl)? onPaymentCompleted;

  const PaymentWebViewScreen({
    Key? key,
    required this.paymentUrl,
    this.onPaymentCompleted, // Thêm vào constructor
  }) : super(key: key);

  @override
  State<PaymentWebViewScreen> createState() => _PaymentWebViewScreenState();
}

class _PaymentWebViewScreenState extends State<PaymentWebViewScreen> {
  late WebViewController _controller;
  bool _isLoading = true;
  GioHangViewModel? gioHangVM;
  ThanhToanViewModel? thanhToanVM;
  final String _vnpayCallbackHost = 'localhost:7156';

  // Cờ để đảm bảo logic callback chỉ chạy 1 lần
  bool _isCallbackHandled = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Sử dụng context.read để lấy ViewModel mà không cần rebuild
    gioHangVM ??= context.read<GioHangViewModel>();
    thanhToanVM ??= context.read<ThanhToanViewModel>();
  }

  @override
  void initState() {
    super.initState();
    _initWebViewController();
  }

  /// Khởi tạo WebViewController và cấu hình các callback
  void _initWebViewController() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => setState(() => _isLoading = true),
          onPageFinished: (_) => setState(() => _isLoading = false),
          onNavigationRequest: (nav) async {
            // Chỉ gọi hàm xử lý nếu chưa xử lý callback lần nào
            if (!_isCallbackHandled) {
              return await _handleVNPayCallback(nav.url);
            }
            // Nếu đã xử lý, ngăn chặn mọi điều hướng khác
            return NavigationDecision.prevent;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  /// Xử lý callback VNPay trả về
  Future<NavigationDecision> _handleVNPayCallback(String url) async {
    print('🔹 Toàn bộ URL callback: $url');
    final uri = Uri.parse(url);

    if (uri.host.contains(_vnpayCallbackHost) ||
        (uri.query.contains('vnp_ResponseCode') && uri.query.contains('vnp_TxnRef'))) {

      _isCallbackHandled = true;

      final responseCode = uri.queryParameters['vnp_ResponseCode'] ?? "-1";
      final maDH = uri.queryParameters['vnp_TxnRef'] ?? "";

      print("🔍 Mã đơn hàng: $maDH");
      print("🔍 ResponseCode: $responseCode");

      // ✔️ 1. Xử lý tài chính + backend
      widget.onPaymentCompleted?.call(url);

      // ✔️ 2. Kiểm tra trạng thái thanh toán
      if (responseCode == "00") {
        // ====== THANH TOÁN THÀNH CÔNG ======
        gioHangVM?.resetCart();

        if (mounted) {
          Navigator.pop(context); // Đóng WebView
          Future.delayed(const Duration(milliseconds: 300), () {
            Navigator.pop(context, true); // Trả về với kết quả success
          });
        }

      } else {
        // ====== THANH TOÁN THẤT BẠI ======
        print("Thanh toán thất bại");

        // ❗ Hiện dialog báo lỗi
        // if (mounted) {
        //   showDialog(
        //     context: context,
        //     builder: (_) => AlertDialog(
        //       title: const Text("Thanh toán thất bại"),
        //       content: Text(message),
        //       actions: [
        //         TextButton(
        //           onPressed: () {
        //             Navigator.pop(context); // đóng dialog
        //             Navigator.pop(context); // đóng WebView
        //           },
        //           child: const Text("OK"),
        //         )
        //       ],
        //     ),
        //   );
        // }
      }

      return NavigationDecision.prevent;
    }

    return NavigationDecision.navigate;
  }



  @override
  Widget build(BuildContext context) {
    return PopScope(
      // Khi người dùng nhấn nút Back trên AppBar hoặc nút Back vật lý
      canPop: true,
      onPopInvoked: (didPop) {
        if (didPop) {
          // Nếu người dùng pop màn hình, cần thông báo cho ViewModel reset trạng thái
          // Tuy nhiên, logic này thường được xử lý khi completePayment thất bại hoặc khi WebView bị đóng.
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Thanh toán qua VNPay'),
          backgroundColor: Colors.blue,
        ),
        body: Stack(
          children: [
            WebViewWidget(controller: _controller),
            if (_isLoading)
              const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}