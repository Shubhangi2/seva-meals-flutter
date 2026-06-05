import 'package:flutter/material.dart';
import 'package:seva_meal/core/app_colors.dart';
import 'package:seva_meal/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Seva Meals',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: AppColors.primary, scaffoldBackgroundColor: Colors.white),
      home: const LoginScreen(),
    );
  }
}
