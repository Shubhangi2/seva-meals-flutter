import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seva_meal/core/app_colors.dart';
import 'package:seva_meal/core/constants.dart';
import 'package:seva_meal/db/shared_prefs.dart';
import 'package:seva_meal/models/user_model.dart';
import 'package:seva_meal/providers/user_auth_provider.dart';
import 'package:seva_meal/screens/dashboard_screen.dart';

import 'package:seva_meal/screens/shared_widgets/custom_button.dart';

class SelectRoleScreen extends StatefulWidget {
  final UserModel user;
  const SelectRoleScreen({super.key, required this.user});

  @override
  State<SelectRoleScreen> createState() => _SelectRoleScreenState();
}

class _SelectRoleScreenState extends State<SelectRoleScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            SizedBox(height: 40),
            Center(
              child: Text(
                'Select your role',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20),
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 38),
                  height: 230,
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  alignment: Alignment.centerRight,
                  color: AppColors.primaryLightest,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: Column(
                      spacing: 12,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'I Have Food to Share',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, height: 1),
                        ),

                        Text(
                          'Restaurants, hotels, homes & events - post your surplus food in minutes and we\'ll make sure it reaches someone who needs it',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14, height: 1.3),
                        ),
                        CustomButton(
                          text: "Donor",
                          onPressed: () async {
                            context.read<UserAuthProvider>().updateRoleToFirebase(
                              Constants.ROLE_DONOR,
                              widget.user.id,
                            );

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DashboardScreen(role: Constants.ROLE_DONOR),
                              ),
                            );
                          },
                          height: 42,
                        ),
                      ],
                    ),
                  ),
                ),

                Positioned(
                  left: -122,
                  child: ClipOval(
                    child: Image.asset(
                      'assets/donor.jpg',
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.width * 0.8,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 50),
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 38),
                  height: 230,
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  alignment: Alignment.centerLeft,
                  color: AppColors.primaryLightest,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: Column(
                      spacing: 12,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'I Want to Volunteer',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, height: 1),
                        ),

                        Text(
                          'Pick up food from donors nearby and deliver it to shelters and NGOs. Give an hour, Give an hour, feed a family, spread the kindness.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14, height: 1.3),
                        ),
                        CustomButton(
                          text: "Volunteer",
                          onPressed: () async {
                            context.read<UserAuthProvider>().updateRoleToFirebase(
                              Constants.ROLE_VOLUNTEER,
                              widget.user.id,
                            );
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DashboardScreen(role: Constants.ROLE_VOLUNTEER),
                              ),
                            );
                          },
                          height: 42,
                        ),
                      ],
                    ),
                  ),
                ),

                Positioned(
                  right: -122,
                  child: ClipOval(
                    child: Image.asset(
                      'assets/volunteer.jpg',
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.width * 0.8,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
