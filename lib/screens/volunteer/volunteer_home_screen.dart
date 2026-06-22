import 'package:flutter/material.dart';
import 'package:seva_meal/core/app_colors.dart';

class VolunteerHomeScreen extends StatefulWidget {
  const VolunteerHomeScreen({super.key});

  @override
  State<VolunteerHomeScreen> createState() => _VolunteerHomeScreenState();
}

class _VolunteerHomeScreenState extends State<VolunteerHomeScreen> {
  int _selectedFilter = 0;
  final List<String> _filters = ['All', 'Urgent', 'Cooked', 'Bakery', 'Veg only'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    _buildActiveMissionCard(),
                    const SizedBox(height: 20),
                    _buildFilters(),
                    const SizedBox(height: 16),
                    _buildSectionHeader('Available Near You', '6 missions'),
                    const SizedBox(height: 10),
                    _buildDonationCard(
                      emoji: '🍛',
                      title: 'Biryani — 60 portions',
                      foodType: 'Cooked · Veg',
                      distance: '1.2 km',
                      expiry: '3 hrs left',
                      volunteersJoined: 1,
                      volunteersNeeded: 3,
                      isUrgent: false,
                    ),
                    _buildDonationCard(
                      emoji: '🍞',
                      title: 'Bread & Baked Goods',
                      foodType: 'Bakery · Veg',
                      distance: '2.4 km',
                      expiry: '1 hr left',
                      volunteersJoined: 0,
                      volunteersNeeded: 2,
                      isUrgent: true,
                    ),
                    _buildDonationCard(
                      emoji: '🥗',
                      title: 'Mixed Salads — 30 pcs',
                      foodType: 'Raw · Veg',
                      distance: '3.1 km',
                      expiry: '5 hrs left',
                      volunteersJoined: 2,
                      volunteersNeeded: 2,
                      isUrgent: false,
                    ),
                    _buildDonationCard(
                      emoji: '🍲',
                      title: 'Dal Tadka — 40 portions',
                      foodType: 'Cooked · Veg',
                      distance: '4.0 km',
                      expiry: '2 hrs left',
                      volunteersJoined: 0,
                      volunteersNeeded: 1,
                      isUrgent: false,
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // bottomNavigationBar: _buildBottomNav(),
    );
  }

  // ─── HEADER ───
  Widget _buildHeader() {
    return Container(
      color: AppColors.primary,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Good morning',
                  style: TextStyle(color: AppColors.primaryLightest.withOpacity(0.7), fontSize: 12),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Arjun Kumar',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.location_on_rounded, size: 12, color: AppColors.primaryLight),
                    const SizedBox(width: 3),
                    Text(
                      'Mumbai · 6 missions available',
                      style: TextStyle(color: AppColors.primaryLight, fontSize: 11),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // availability toggle
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A4A2E),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFF2D7A4A)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 7,
                        height: 7,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF4CAF50),
                        ),
                      ),
                      const SizedBox(width: 5),
                      const Text(
                        'Available',
                        style: TextStyle(
                          color: Color(0xFF4CAF50),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 6),
              // notification bell
              Stack(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryDeep.withOpacity(0.5),
                    ),
                    child: Icon(
                      Icons.notifications_rounded,
                      color: AppColors.primaryLightest,
                      size: 18,
                    ),
                  ),
                  Positioned(
                    top: 6,
                    right: 7,
                    child: Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.orange,
                        border: Border.all(color: AppColors.primary, width: 1.2),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── ACTIVE MISSION CARD ───
  Widget _buildActiveMissionCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryDeep, AppColors.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryLight.withOpacity(0.3)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.orange.withOpacity(0.5)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.circle, size: 7, color: Colors.orange),
                    SizedBox(width: 5),
                    Text(
                      'Active Mission',
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Text(
                '#FM-2024-047',
                style: TextStyle(color: AppColors.primaryLightest.withOpacity(0.6), fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Dal Rice + Sabzi — 40 portions',
            style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.location_on_rounded, size: 12, color: AppColors.primaryLight),
              const SizedBox(width: 3),
              Text(
                'Hotel Regent, Andheri East',
                style: TextStyle(color: AppColors.primaryLight, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // step tracker
          Row(
            children: [
              _buildStep('Go to\nDonor', true, false),
              _buildStepLine(true),
              _buildStep('Collect\nFood', true, true),
              _buildStepLine(false),
              _buildStep('Go to\nNGO', false, false),
              _buildStepLine(false),
              _buildStep('Deliver', false, false),
            ],
          ),
          const SizedBox(height: 14),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryLightest,
                foregroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(vertical: 10),
                elevation: 0,
              ),
              child: const Text(
                'Continue Mission →',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep(String label, bool done, bool active) {
    return Column(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: done ? (active ? Colors.orange : AppColors.primaryLight) : AppColors.primaryDeep,
            border: Border.all(
              color: active
                  ? Colors.orange
                  : done
                  ? AppColors.primaryLight
                  : AppColors.primaryLight.withOpacity(0.3),
              width: 1.5,
            ),
          ),
          child: Icon(
            done
                ? (active ? Icons.pedal_bike_rounded : Icons.check_rounded)
                : Icons.circle_outlined,
            size: 14,
            color: done ? Colors.white : AppColors.primaryLight.withOpacity(0.4),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: done ? Colors.white : AppColors.primaryLight.withOpacity(0.4),
            fontSize: 9,
            height: 1.3,
          ),
        ),
      ],
    );
  }

  Widget _buildStepLine(bool done) {
    return Expanded(
      child: Container(
        height: 1.5,
        margin: const EdgeInsets.only(bottom: 20),
        color: done ? AppColors.primaryLight : AppColors.primaryLight.withOpacity(0.2),
      ),
    );
  }

  // ─── FILTER CHIPS ───
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

  // ─── SECTION HEADER ───
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

  // ─── DONATION CARD ───
  Widget _buildDonationCard({
    required String emoji,
    required String title,
    required String foodType,
    required String distance,
    required String expiry,
    required int volunteersJoined,
    required int volunteersNeeded,
    required bool isUrgent,
  }) {
    final bool full = volunteersJoined >= volunteersNeeded;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isUrgent ? Colors.orange.withOpacity(0.4) : AppColors.primaryLightest,
        ),
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
                child: Center(child: Text(emoji, style: const TextStyle(fontSize: 22))),
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
                            title,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        if (isUrgent)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.orange.withOpacity(0.4)),
                            ),
                            child: const Text(
                              '⚡ Urgent',
                              style: TextStyle(
                                color: Colors.orange,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(foodType, style: TextStyle(fontSize: 11, color: AppColors.primaryLight)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(height: 1, color: Color(0xFFEEF5FB)),
          const SizedBox(height: 10),

          // meta row
          Row(
            children: [
              _buildMeta(Icons.location_on_rounded, distance),
              const SizedBox(width: 14),
              _buildMeta(Icons.access_time_rounded, expiry, color: isUrgent ? Colors.orange : null),
              const Spacer(),
              // volunteer count
              Row(
                children: [
                  Icon(Icons.group_rounded, size: 13, color: AppColors.primaryLight),
                  const SizedBox(width: 4),
                  Text(
                    '$volunteersJoined/$volunteersNeeded joined',
                    style: TextStyle(
                      fontSize: 11,
                      color: full ? const Color(0xFF2D7A4A) : AppColors.primaryLight,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // volunteer progress bar
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: volunteersNeeded > 0 ? volunteersJoined / volunteersNeeded : 0,
              backgroundColor: AppColors.primaryLightest,
              valueColor: AlwaysStoppedAnimation(
                full ? const Color(0xFF2D7A4A) : AppColors.primaryLight,
              ),
              minHeight: 4,
            ),
          ),

          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: full ? null : () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: full ? AppColors.primaryLightest : AppColors.primary,
                foregroundColor: full ? AppColors.primaryDeep : Colors.white,
                disabledBackgroundColor: AppColors.primaryLightest,
                disabledForegroundColor: AppColors.primaryDeep,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(vertical: 10),
                elevation: 0,
              ),
              child: Text(
                full ? 'Mission Full' : 'View & Join Mission',
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMeta(IconData icon, String text, {Color? color}) {
    return Row(
      children: [
        Icon(icon, size: 13, color: color ?? AppColors.primaryLight),
        const SizedBox(width: 3),
        Text(text, style: TextStyle(fontSize: 11, color: color ?? AppColors.primaryLight)),
      ],
    );
  }

  // ─── BOTTOM NAV ───
  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.primaryLightest, width: 0.5)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          _buildNavItem(Icons.home_rounded, 'Home', true),
          _buildNavItem(Icons.assignment_rounded, 'Missions', false),
          _buildNavItem(Icons.notifications_rounded, 'Alerts', false),
          _buildNavItem(Icons.person_rounded, 'Profile', false),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool active) {
    return Expanded(
      child: GestureDetector(
        onTap: () {},
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 22,
              color: active ? AppColors.primary : AppColors.primaryLight.withOpacity(0.5),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                color: active ? AppColors.primary : AppColors.primaryLight.withOpacity(0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
