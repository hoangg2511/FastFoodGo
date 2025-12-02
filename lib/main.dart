import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import 'Service/ApiService.dart';

import 'Models/DiaChiModel.dart';
import 'ViewModels/ChiTietMonAnViewModel.dart';
import 'ViewModels/DangNhapViewModel.dart';
import 'ViewModels/NguoiDungViewModel.dart';
import 'Views/DangNhap.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: DangNhap(),
    );
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Khởi tạo Firebase
  await Firebase.initializeApp();

  // Override Http nếu cần
  HttpOverrides.global = MyHttpOverrides();
  ApiService().init();
  // Load file .env từ thư mục assets
  try {
    await dotenv.load(fileName: "assets/.env");
    print(".env loaded successfully");
  } catch (e) {
    print("Error loading .env file: $e");
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NguoiDungViewModel()),
        ChangeNotifierProvider(create: (_) => DangNhapViewModel()),
      ],
      child: MyApp(),
    ),
  );

}
