import 'package:flutter/material.dart';
import 'package:seva_meal/core/app_colors.dart';
import 'package:seva_meal/models/post_model.dart';

class DonationDetailScreen extends StatefulWidget {
  final PostModel post;
  const DonationDetailScreen({super.key, required this.post});

  @override
  State<DonationDetailScreen> createState() => _DonationDetailScreenState();
}

class _DonationDetailScreenState extends State<DonationDetailScreen> {
  bool _hasJoined = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                _buildSliverAppBar(),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTitleRow(),
                        const SizedBox(height: 16),
                        _buildInfoGrid(),
                        const SizedBox(height: 16),
                        _buildVolunteersSection(),
                        const SizedBox(height: 16),
                        _buildPickupLocation(),
                        const SizedBox(height: 16),
                        if (_hasJoined) _buildDonorContact(),
                        const SizedBox(height: 16),
                        _buildSpecialInstructions(),
                        const SizedBox(height: 16),
                        _buildFoodSafetyNote(),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          _buildBottomCTA(),
        ],
      ),
    );
  }

  // ─── SLIVER APP BAR WITH FOOD PHOTO ───
  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 220,
      pinned: true,
      backgroundColor: AppColors.primary,
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: Colors.black26, shape: BoxShape.circle),
          child: const Icon(Icons.arrow_back_rounded, color: Colors.white),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // food photo
            Image.network(
              widget.post.pickupFoodPictureUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: AppColors.primaryDeep,
                child: Icon(Icons.fastfood_rounded, color: AppColors.primaryLightest, size: 60),
              ),
            ),
            // gradient overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, AppColors.primary.withOpacity(0.7)],
                ),
              ),
            ),
            // urgent badge on photo
            Positioned(
              bottom: 14,
              left: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.bolt_rounded, color: Colors.white, size: 14),
                    SizedBox(width: 4),
                    Text(
                      'Expires in 3 hrs',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── TITLE ROW ───
  Widget _buildTitleRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.post.title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  _buildChip(
                    widget.post.foodType,
                    AppColors.primaryLightest,
                    AppColors.primaryDeep,
                  ),
                  const SizedBox(width: 6),
                  _buildChip('🌿 Veg', const Color(0xFFDCFCE7), const Color(0xFF166534)),
                ],
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'Posted 20 min ago',
              style: TextStyle(fontSize: 11, color: AppColors.primaryLight),
            ),
            const SizedBox(height: 4),
            Text(
              '#FD-2024-0847',
              style: TextStyle(fontSize: 11, color: AppColors.primaryLight.withOpacity(0.6)),
            ),
          ],
        ),
      ],
    );
  }

  // ─── INFO GRID ───
  Widget _buildInfoGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 2.8,
      children: [
        _buildInfoTile(Icons.fastfood_rounded, 'Quantity', '60 portions'),
        _buildInfoTile(Icons.access_time_rounded, 'Expires', '3 hours'),
        _buildInfoTile(Icons.location_on_rounded, 'Distance', '1.2 km away'),
        _buildInfoTile(Icons.storefront_rounded, 'Donor', 'Hotel Regent'),
      ],
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryLightest),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primaryLight),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(label, style: TextStyle(fontSize: 10, color: AppColors.primaryLight)),
              Text(
                value,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── VOLUNTEERS SECTION ───
  Widget _buildVolunteersSection() {
    final joined = 1;
    final needed = 3;

    return Container(
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Volunteers',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
              Text(
                '$joined of $needed joined',
                style: TextStyle(fontSize: 12, color: AppColors.primaryLight),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: joined / needed,
              backgroundColor: AppColors.primaryLightest,
              valueColor: AlwaysStoppedAnimation(AppColors.primaryLight),
              minHeight: 5,
            ),
          ),
          const SizedBox(height: 12),

          // volunteer avatars
          Row(
            children: [
              // joined volunteer
              _buildVolunteerAvatar('AK', true),
              const SizedBox(width: 8),
              // empty slots
              for (var i = 0; i < needed - joined; i++) ...[
                _buildEmptySlot(),
                const SizedBox(width: 8),
              ],
              const Spacer(),
              Text(
                '${needed - joined} slots open',
                style: TextStyle(fontSize: 11, color: AppColors.primaryLight),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVolunteerAvatar(String initials, bool filled) {
    return Column(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: filled ? AppColors.primary : AppColors.primaryLightest,
            border: Border.all(
              color: filled ? AppColors.primaryLight : AppColors.primaryLightest,
              width: 1.5,
            ),
          ),
          child: Center(
            child: Text(
              initials,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: filled ? Colors.white : AppColors.primaryLight,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(filled ? 'Arjun' : '', style: TextStyle(fontSize: 9, color: AppColors.primaryLight)),
      ],
    );
  }

  Widget _buildEmptySlot() {
    return Column(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primaryLightest.withOpacity(0.4),
            border: Border.all(
              color: AppColors.primaryLightest,
              width: 1.5,
              style: BorderStyle.solid,
            ),
          ),
          child: Icon(Icons.add_rounded, size: 16, color: AppColors.primaryLight.withOpacity(0.5)),
        ),
        const SizedBox(height: 4),
        Text('Open', style: TextStyle(fontSize: 9, color: AppColors.primaryLight.withOpacity(0.5))),
      ],
    );
  }

  // ─── PICKUP LOCATION ───
  Widget _buildPickupLocation() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primaryLightest),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pickup Location',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primary),
          ),
          const SizedBox(height: 10),

          // map placeholder
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              height: 120,
              color: AppColors.primaryLightest.withOpacity(0.3),
              child: Stack(
                children: [
                  // grid lines to simulate map
                  CustomPaint(size: const Size(double.infinity, 120), painter: _MapGridPainter()),
                  Center(
                    child: Icon(Icons.location_on_rounded, color: AppColors.primary, size: 36),
                  ),
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.navigation_rounded, color: Colors.white, size: 12),
                          const SizedBox(width: 4),
                          const Text(
                            'Navigate',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.location_on_rounded, size: 14, color: AppColors.primaryLight),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  widget.post.pickupAddress,
                  style: TextStyle(fontSize: 13, color: AppColors.primaryDeep),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── DONOR CONTACT (visible after joining) ───
  Widget _buildDonorContact() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primaryLightest.withOpacity(0.3),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primaryLightest),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lock_open_rounded, size: 14, color: AppColors.primaryLight),
              const SizedBox(width: 6),
              Text(
                'Donor Contact',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.primary),
                child: const Center(
                  child: Text(
                    'RJ',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Riya Jadhav',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      '+91 98765 43210',
                      style: TextStyle(fontSize: 12, color: AppColors.primaryLight),
                    ),
                  ],
                ),
              ),
              // call button
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.call_rounded, color: Colors.white, size: 18),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── SPECIAL INSTRUCTIONS ───
  Widget _buildSpecialInstructions() {
    return Container(
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
            children: [
              Icon(Icons.info_outline_rounded, size: 15, color: AppColors.primaryLight),
              const SizedBox(width: 6),
              Text(
                'Special Instructions',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Bring containers. Call on arrival. Gate code: 1234.',
            style: TextStyle(fontSize: 13, color: AppColors.primaryDeep, height: 1.5),
          ),
        ],
      ),
    );
  }

  // ─── FOOD SAFETY NOTE ───
  Widget _buildFoodSafetyNote() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFFE082)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('⚠️', style: TextStyle(fontSize: 16)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Please inspect the food at pickup. If anything looks or smells unsafe, reject the donation and report it.',
              style: TextStyle(fontSize: 12, color: const Color(0xFF5D4037), height: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  // ─── BOTTOM CTA ───
  Widget _buildBottomCTA() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.primaryLightest, width: 0.5)),
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            setState(() => _hasJoined = !_hasJoined);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: _hasJoined ? const Color(0xFFFFEBEE) : AppColors.primary,
            foregroundColor: _hasJoined ? const Color(0xFFC62828) : Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            padding: const EdgeInsets.symmetric(vertical: 15),
            elevation: 0,
          ),
          child: Text(
            _hasJoined ? '✕  Leave Mission' : '🚴  Join Mission',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          ),
        ),
      ),
    );
  }

  // ─── CHIP ───
  Widget _buildChip(String text, Color bg, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(
        text,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: textColor),
      ),
    );
  }
}

// ─── MAP GRID PAINTER ───
class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primaryLightest.withOpacity(0.6)
      ..strokeWidth = 0.5;

    for (double x = 0; x < size.width; x += 30) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += 30) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
