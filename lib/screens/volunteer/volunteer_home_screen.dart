import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seva_meal/core/app_colors.dart';
import 'package:seva_meal/db/shared_prefs.dart';
import 'package:seva_meal/models/post_model.dart';
import 'package:seva_meal/providers/donor_provider.dart';
import 'package:seva_meal/providers/volunteer_provider.dart';
import 'package:seva_meal/screens/volunteer/donation_detail_screen.dart';
import 'package:seva_meal/screens/volunteer/build_active_mission_card.dart';
import 'package:seva_meal/services/fcm_service.dart';

class VolunteerHomeScreen extends StatefulWidget {
  const VolunteerHomeScreen({super.key});

  @override
  State<VolunteerHomeScreen> createState() => _VolunteerHomeScreenState();
}

class _VolunteerHomeScreenState extends State<VolunteerHomeScreen> {
  int _selectedFilter = 0;
  final List<String> _filters = ['All', 'Urgent', 'Cooked', 'Bakery', 'Veg only'];
  List<PostModel> activePosts = [];
  List<PostModel> myMissions = [];
  @override
  void initState() {
    super.initState();
    SharedPrefs().getFcmToken();
    callAsyncTask();
  }

  Future<void> callAsyncTask() async {
    final activePosts = await context.read<VolunteerProvider>().getActivePostsByRegion();
    activePosts.fold((l) => print(l.message), (r) {
      setState(() {
        this.activePosts = r;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildHeader(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  BuildActiveMissionCardWidget(),
                  const SizedBox(height: 20),
                  _buildFilters(),
                  const SizedBox(height: 16),
                  _buildSectionHeader('Available Near You', '6 missions'),
                  const SizedBox(height: 10),
                ],
              ),

              Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) => _buildDonationCard(post: activePosts[index]),
                  itemCount: activePosts.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return SizedBox(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Hello", style: TextStyle(fontSize: 12)),
              Spacer(),
              Text("Shubhangi Jadhav", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          Image.asset('assets/app_logo.png', height: 60),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final selected = _selectedFilter == index;
          return GestureDetector(
            onTap: () => setState(() => _selectedFilter = index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: selected ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: selected ? AppColors.primary : AppColors.primaryLightest),
              ),
              child: Text(
                _filters[index],
                style: TextStyle(
                  color: selected ? Colors.white : AppColors.primaryDeep,
                  fontSize: 12,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title, String count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.primary),
        ),
        Text(count, style: TextStyle(fontSize: 12, color: AppColors.primaryLight)),
      ],
    );
  }

  Widget _buildDonationCard({required PostModel post}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primaryLightest),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.bgColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Image.network(post.pickupFoodPictureUrl, fit: BoxFit.cover, height: 40),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            post.title,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      post.foodType,
                      style: TextStyle(fontSize: 11, color: AppColors.primaryLight),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(height: 1, color: Color(0xFFEEF5FB)),
          const SizedBox(height: 10),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DonationDetailScreen(post: post)),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                disabledBackgroundColor: AppColors.primaryLightest,
                disabledForegroundColor: AppColors.primaryDeep,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(vertical: 10),
                elevation: 0,
              ),
              child: Text(
                'View & Join Mission',
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
