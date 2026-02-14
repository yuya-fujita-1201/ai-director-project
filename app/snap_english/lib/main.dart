import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'services/purchase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await PurchaseService().init(); // RevenueCat SDK初期化
  runApp(
    const ProviderScope(
      child: SnapEnglishApp(),
    ),
  );
}
