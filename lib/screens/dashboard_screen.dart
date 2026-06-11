import 'package:flutter/material.dart';
import 'package:seva_meal/core/app_colors.dart';
import 'package:seva_meal/screens/donor/donor_account_screen.dart';
import 'package:seva_meal/screens/donor/donor_create_screen.dart';
import 'package:seva_meal/screens/donor/donor_history_screen.dart';
import 'package:seva_meal/screens/donor/donor_home_screen.dart';
import 'package:seva_meal/screens/donor/donor_notifiication_screen.dart';

class DashboardScreen extends StatefulWidget {
  final String role;
  const DashboardScreen({super.key, required this.role});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final PageController _pageController = PageController();
  int index = 0;

  @override
  void initState() {
    super.initState();
  }

  List<Widget> donorList = const [
    DonorHomeScreen(),
    DonorCreateScreen(),
    DonorHistoryScreen(),
    DonorNotificatoinScreen(),
    DonorAccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (pageIndex) {
          setState(() {
            index = pageIndex;
          });
        },
        children: donorList,
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (int selectedIndex) => {
          setState(() {
            index = selectedIndex;
            _pageController.jumpToPage(selectedIndex);
          }),
        },
        type: BottomNavigationBarType.fixed,
        currentIndex: index,
        backgroundColor: Colors.white,
        selectedFontSize: 10.0,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.grayDark,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home, size: 25), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.history, size: 25), label: "History"),
          BottomNavigationBarItem(icon: Icon(Icons.add, size: 25), label: "Create"),
          BottomNavigationBarItem(icon: Icon(Icons.notifications, size: 25), label: "Nofication"),
          BottomNavigationBarItem(icon: Icon(Icons.person, size: 25), label: "Account"),
        ],
      ),
    );
  }
}
