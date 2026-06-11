import 'package:flutter/material.dart';
import 'package:seva_meal/core/app_colors.dart';
import 'package:seva_meal/screens/shared_widgets/utility_widgets.dart';
import 'package:seva_meal/screens/shared_widgets/wave_clip_banner.dart';

class DonorAccountScreen extends StatefulWidget {
  const DonorAccountScreen({super.key});

  @override
  State<DonorAccountScreen> createState() => _DonorAccountScreenState();
}

class _DonorAccountScreenState extends State<DonorAccountScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            "My Donor Account",
            style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 18),
          ),
        ),
        body: Column(
          children: [
            Stack(
              children: [
                WaveClipBanner(height: 190),
                SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      spacing: 4,

                      children: [
                        Row(
                          spacing: 16,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColors.primary, width: 1),
                              ),
                              child: ClipOval(
                                child: Image.asset(
                                  'assets/profile.png',
                                  height: 90,
                                  width: 90,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Column(
                              spacing: 6,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Shubhangi Jadhav",
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                Row(
                                  spacing: 8,
                                  children: [
                                    Icon(Icons.email_outlined, color: AppColors.grayDark, size: 20),
                                    Text(
                                      "jshubhangi958@gmail.com",
                                      style: TextStyle(color: AppColors.grayDark),
                                    ),
                                  ],
                                ),
                                Row(
                                  spacing: 8,
                                  children: [
                                    Icon(Icons.phone_outlined, color: AppColors.grayDark, size: 20),
                                    Text(
                                      "+91 9702212438",
                                      style: TextStyle(color: AppColors.grayDark),
                                    ),
                                  ],
                                ),
                                Row(
                                  spacing: 8,
                                  children: [
                                    Icon(
                                      Icons.location_on_outlined,
                                      color: AppColors.grayDark,
                                      size: 20,
                                    ),
                                    Text("Airoli", style: TextStyle(color: AppColors.grayDark)),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
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
