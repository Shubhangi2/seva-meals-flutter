import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seva_meal/core/app_colors.dart';
import 'package:seva_meal/core/app_service.dart';
import 'package:seva_meal/firebase_options.dart';
import 'package:seva_meal/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MultiProvider(providers: AppService.provideMultiProviders(), child: const MyApp()));
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
