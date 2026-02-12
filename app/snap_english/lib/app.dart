import 'package:flutter/material.dart';
import 'config/theme.dart';
import 'config/constants.dart';
import 'screens/home_screen.dart';

class SnapEnglishApp extends StatelessWidget {
  const SnapEnglishApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      theme: AppTheme.lightTheme,
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
