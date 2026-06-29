import 'package:flutter/material.dart';
import 'package:seva_meal/core/app_colors.dart';
import 'package:seva_meal/core/constants.dart';
import 'package:seva_meal/models/user_model.dart';
import 'package:seva_meal/screens/donor/donor_notification_screen.dart';
import 'package:seva_meal/screens/shared_screen/account_screen.dart';
import 'package:seva_meal/screens/donor/donor_create_screen.dart';
import 'package:seva_meal/screens/shared_screen/history_screen.dart';
import 'package:seva_meal/screens/donor/donor_home_screen.dart';
import 'package:seva_meal/screens/volunteer/volunteer_home_screen.dart';
import 'package:seva_meal/screens/volunteer/volunteer_notification_screen.dart';

class DashboardScreen extends StatefulWidget {
  final UserModel user;
  const DashboardScreen({super.key, required this.user});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final PageController _pageController = PageController();
  int index = 0;

  @override
  void initState() {
    super.initState();
    print(widget.user);
  }

  @override
  Widget build(BuildContext context) {
    print(widget.user.role == Constants.ROLE_DONOR);
    List<Widget> screenList = widget.user.role == Constants.ROLE_DONOR
        ? [
            DonorHomeScreen(user: widget.user),
            HistoryScreen(role: widget.user.role),
            DonorCreateScreen(),
            DonorNotificationScreen(),
            AccountScreen(role: widget.user.role),
          ]
        : [
            VolunteerHomeScreen(),
            HistoryScreen(role: widget.user.role),
            VolunteerNotificationScreen(),
            AccountScreen(role: widget.user.role),
          ];

    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (pageIndex) {
          setState(() {
            index = pageIndex;
          });
        },
        children: screenList,
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
        items: widget.user == Constants.ROLE_DONOR
            ? [
                BottomNavigationBarItem(icon: Icon(Icons.home, size: 25), label: "Home"),
                BottomNavigationBarItem(icon: Icon(Icons.history, size: 25), label: "History"),
                BottomNavigationBarItem(icon: Icon(Icons.add, size: 25), label: "Create"),
                BottomNavigationBarItem(
                  icon: Icon(Icons.notifications, size: 25),
                  label: "Nofication",
                ),
                BottomNavigationBarItem(icon: Icon(Icons.person, size: 25), label: "Account"),
              ]
            : [
                BottomNavigationBarItem(icon: Icon(Icons.home, size: 25), label: "Home"),
                BottomNavigationBarItem(icon: Icon(Icons.history, size: 25), label: "History"),
                BottomNavigationBarItem(
                  icon: Icon(Icons.notifications, size: 25),
                  label: "Nofication",
                ),
                BottomNavigationBarItem(icon: Icon(Icons.person, size: 25), label: "Account"),
              ],
      ),
    );
  }
}
