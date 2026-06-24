import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seva_meal/core/app_colors.dart';
import 'package:seva_meal/core/app_service.dart';
import 'package:seva_meal/core/utils/user_session.dart';
import 'package:seva_meal/firebase_options.dart';
import 'package:seva_meal/screens/shared_screen/select_city_screen.dart';
import 'package:seva_meal/screens/splash_screen.dart';
import 'package:seva_meal/services/fcm_service.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  var FcmMessageProcessor;
  FcmMessageProcessor.processMessage(message, false);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await UserSession().loadUser();
  await FCMService().init();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

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
      // home: const LoginScreen(),
      home: const SplashScreen(),
    );
  }
}
