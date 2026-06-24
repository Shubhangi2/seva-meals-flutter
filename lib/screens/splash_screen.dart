import 'package:flutter/material.dart';
import 'package:seva_meal/core/utils/user_session.dart';
import 'package:seva_meal/db/shared_prefs.dart';
import 'package:seva_meal/models/user_model.dart';
import 'package:seva_meal/screens/dashboard_screen.dart';
import 'package:seva_meal/screens/login_screen.dart';
import 'package:seva_meal/screens/select_role_screen.dart';
import 'package:seva_meal/screens/shared_screen/select_city_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    callAsyncTask();
  }

  Future<void> callAsyncTask() async {
    UserModel? userModel = await SharedPrefs().getUserModel();
    // UserModel? userModel;
    print(userModel);
    if (userModel == null) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
    } else if (userModel.role.isEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SelectRoleScreen(user: userModel)),
      );
    } else if (userModel.city.isEmpty || userModel.region.isEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SelectCityScreen(user: userModel)),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DashboardScreen(role: userModel.role)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
