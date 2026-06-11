import 'package:flutter/material.dart';
import 'package:seva_meal/core/app_colors.dart';
import 'package:seva_meal/screens/shared_widgets/custom_button.dart';
import 'package:seva_meal/screens/shared_widgets/donation_card.dart';
import 'package:seva_meal/screens/shared_widgets/upsidedown_clipper.dart';
import 'package:seva_meal/screens/shared_widgets/wave_clip_banner.dart';

class DonorHomeScreen extends StatefulWidget {
  const DonorHomeScreen({super.key});

  @override
  State<DonorHomeScreen> createState() => _DonorHomeScreenState();
}

class _DonorHomeScreenState extends State<DonorHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Stack(
              children: [
                WaveClipBanner(height: MediaQuery.of(context).size.height * 0.33),

                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    spacing: 16,
                    children: [
                      SizedBox(),
                      SizedBox(
                        height: 40,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Hello", style: TextStyle(fontSize: 12)),
                                Spacer(),
                                Text(
                                  "Shubhangi Jadhav",
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Image.asset('assets/app_logo.png', height: 60),
                          ],
                        ),
                      ),
                      headerCardWidget(),
                      yourImpactWidget(),
                    ],
                  ),
                ),
              ],
            ),
            Expanded(child: recentDonationsWidget()),
          ],
        ),
      ),
    );
  }

  Widget recentDonationsWidget() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0, left: 16, right: 16),
      child: Column(
        spacing: 8,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Recent Donations",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),

              InkWell(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8),
                  child: Text("View All", style: TextStyle(color: AppColors.primary)),
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView.separated(
              itemBuilder: (context, index) => DonationCard(),
              itemCount: 4,
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(height: 16);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget yourImpactWidget() {
    return Column(
      spacing: 8,
      children: [
        SizedBox(
          width: double.infinity,
          child: Text(
            "Your Impact",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary),
          ),
        ),
        Row(
          spacing: 16,
          children: [
            impactCard("12", "Donations"),
            impactCard("150", "Meal Served"),
            impactCard("8", "Volunteers joined"),
          ],
        ),
      ],
    );
  }

  Widget impactCard(String count, String title) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primaryLightest,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 4),
          child: Column(
            children: [
              Text(
                count,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              Text(title, style: TextStyle(fontSize: 12, color: AppColors.primary)),
            ],
          ),
        ),
      ),
    );
  }

  Widget headerCardWidget() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [Color(0xff0D2A3C), Color(0xff2371A2)],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 12,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Have surplus food today?",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
                height: 1,
              ),
            ),
            Row(
              spacing: 16,
              children: [
                Image.asset('assets/donation.png', height: 50),
                Expanded(
                  child: Text(
                    "Post it now - volunteers pick it up soon and deliver warm meals to nearby shelters",
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ],
            ),

            SizedBox(
              height: 40,
              child: ElevatedButton(
                onPressed: () {},
                child: Text("Post Donation", style: TextStyle(color: AppColors.primary)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
