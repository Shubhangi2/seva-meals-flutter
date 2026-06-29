import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seva_meal/core/app_colors.dart';
import 'package:seva_meal/core/constants.dart';
import 'package:seva_meal/core/utils/user_session.dart';
import 'package:seva_meal/models/user_model.dart';
import 'package:seva_meal/providers/user_auth_provider.dart';
import 'package:seva_meal/screens/login_screen.dart';
import 'package:seva_meal/screens/shared_screen/edit_profile_screen.dart';
import 'package:seva_meal/screens/shared_widgets/wave_clip_banner.dart';
import 'package:url_launcher/url_launcher.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  UserModel? user;
  @override
  void initState() {
    super.initState();

    callAsyncTask();
  }

  Future<void> callAsyncTask() async {
    user = await UserSession().user;
    setState(() => {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 250, 250, 250),
        appBar: AppBar(
          toolbarHeight: 46,
          backgroundColor: AppColors.primaryDeep,
          title: Text(
            "My ${user?.role} Account",
            style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white, fontSize: 18),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  WaveClipBanner(height: 190),
                  Column(children: [profileHeader(), legalAndSupportWidget()]),
                ],
              ),
              accountWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget legalAndSupportWidget() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 12),
          Text(
            "Legal & support",
            style: TextStyle(color: AppColors.primary, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          actionCard(
            title: "Privacy policy",
            iconData: Icons.security_outlined,
            onTap: () async {
              final Uri uri = Uri.parse(Constants.PRIVACY_POLICY_URL);
              if (!await launchUrl(uri)) throw 'Could not launch $uri';
            },
          ),
          actionCard(
            title: "Terms of use",
            iconData: Icons.document_scanner_outlined,
            onTap: () async {
              final Uri uri = Uri.parse(Constants.TERMS_OF_USE_URL);
              if (!await launchUrl(uri)) throw 'Could not launch $uri';
            },
          ),
          actionCard(
            title: "Help",
            iconData: Icons.help_outline_rounded,
            onTap: () async {
              final Uri uri = Uri.parse(Constants.HELP);
              if (!await launchUrl(uri)) throw 'Could not launch $uri';
            },
          ),
        ],
      ),
    );
  }

  Widget accountWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Account",
            style: TextStyle(color: AppColors.primary, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          actionCard(title: "Change Password", iconData: Icons.lock_outline),
          actionCard(
            title: "Delete account",
            iconData: Icons.delete_outline,
            bgcolor: AppColors.redLightest,
            color: AppColors.red,
          ),
          SizedBox(height: 12),
          actionCard(
            title: "Logout",
            iconData: Icons.logout,
            bgcolor: AppColors.redLightest,
            color: AppColors.red,
            onTap: () {
              context.read<UserAuthProvider>().signOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
                (_) => false,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget profileHeader() {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.grayBrightest, width: 1),
              ),
              child: ClipOval(
                child: Image.asset('assets/profile.png', height: 90, width: 90, fit: BoxFit.cover),
              ),
            ),
            Expanded(
              child: Column(
                spacing: 6,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user?.fullName ?? '',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Row(
                    spacing: 8,
                    children: [
                      Icon(Icons.email_outlined, color: AppColors.grayDarkest, size: 20),
                      Text(user?.email ?? '', style: TextStyle(color: AppColors.grayDarkest)),
                    ],
                  ),
                  Row(
                    spacing: 8,
                    children: [
                      Icon(Icons.location_city_outlined, color: AppColors.grayDarkest, size: 20),
                      Text(user?.city ?? '', style: TextStyle(color: AppColors.grayDarkest)),
                    ],
                  ),
                  Row(
                    spacing: 8,
                    children: [
                      Icon(Icons.location_on_outlined, color: AppColors.grayDarkest, size: 20),
                      Text(user?.region ?? '', style: TextStyle(color: AppColors.grayDarkest)),
                    ],
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () async {
                if (user == null) return;
                bool? result = await Navigator.push<bool?>(
                  context,
                  MaterialPageRoute(builder: (context) => EditProfileScreen(user: user!)),
                );
                if (result != null && result == true) {
                  UserModel? updatedUser = UserSession().user;
                  if (updatedUser == null) return;
                  setState(() {
                    user = updatedUser;
                  });
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8, right: 8),
                child: Icon(Icons.edit_rounded, color: AppColors.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget actionCard({
    required String title,
    required IconData iconData,
    Color? bgcolor,
    Color? color,
    Function()? onTap,
  }) {
    return InkWell(
      onTap: () {
        if (onTap != null) {
          onTap();
        }
      },
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.grayBrightest, width: 1),
        ),
        width: double.infinity,
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: bgcolor ?? AppColors.primaryLightestIcon,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(iconData, color: color ?? AppColors.primary),
              ),
            ),
            SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(color: color ?? AppColors.grayDarkest, fontWeight: FontWeight.bold),
            ),
            Spacer(),
            Icon(Icons.chevron_right, color: bgcolor ?? AppColors.primaryLight),
          ],
        ),
      ),
    );
  }
}
