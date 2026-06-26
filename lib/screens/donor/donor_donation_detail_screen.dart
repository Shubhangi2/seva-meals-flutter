import 'package:flutter/material.dart';
import 'package:seva_meal/core/app_colors.dart';
import 'package:seva_meal/models/post_model.dart';

class DonationDetailDonorScreen extends StatefulWidget {
  final PostModel post;
  const DonationDetailDonorScreen({super.key, required this.post});

  @override
  State<DonationDetailDonorScreen> createState() => _DonationDetailDonorScreenState();
}

class _DonationDetailDonorScreenState extends State<DonationDetailDonorScreen> {
  // mock status — replace with real Firestore stream
  final String _status = 'assigned'; // open | assigned | collected | delivered

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
                        _buildStatusTracker(),
                        const SizedBox(height: 16),
                        _buildInfoGrid(),
                        const SizedBox(height: 16),
                        _buildVolunteersSection(),
                        const SizedBox(height: 16),
                        if (_status == 'delivered') _buildProofPhoto(),
                        if (_status == 'delivered') const SizedBox(height: 16),
                        _buildPickupLocation(),
                        const SizedBox(height: 16),
                        _buildDonationInfo(),
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

  // ─── SLIVER APP BAR ───
  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 220,
      pinned: true,
      backgroundColor: AppColors.primary,
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: const BoxDecoration(color: Colors.black26, shape: BoxShape.circle),
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
                  colors: [Colors.transparent, AppColors.primary.withOpacity(0.8)],
                ),
              ),
            ),
            // status badge on photo
            Positioned(bottom: 14, left: 16, child: _buildStatusBadge()),
            // donation id
            Positioned(
              bottom: 14,
              right: 16,
              child: Text(
                '#FD-2024-0847',
                style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 11),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge() {
    final map = {
      'open': ['Waiting for volunteer', Colors.orange],
      'assigned': ['Volunteer assigned', AppColors.primaryLight],
      'collected': ['Food collected', const Color(0xFF4CAF50)],
      'delivered': ['Delivered ✓', const Color(0xFF2E7D32)],
    };
    final data = map[_status]!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: (data[1] as Color).withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: (data[1] as Color).withOpacity(0.6)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(shape: BoxShape.circle, color: data[1] as Color),
          ),
          const SizedBox(width: 5),
          Text(
            data[0] as String,
            style: TextStyle(color: data[1] as Color, fontSize: 11, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  // ─── TITLE ROW ───
  Widget _buildTitleRow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.post.title,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.primary),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            _buildChip(widget.post.foodType, AppColors.primaryLightest, AppColors.primaryDeep),
            const SizedBox(width: 6),
            _buildChip('🌿 Veg', const Color(0xFFDCFCE7), const Color(0xFF166534)),
            const SizedBox(width: 6),
            _buildChip('Posted today', AppColors.bgColor, AppColors.primaryLight),
          ],
        ),
      ],
    );
  }

  // ─── STATUS TRACKER ───
  Widget _buildStatusTracker() {
    final steps = [
      {'label': 'Posted', 'icon': Icons.check_circle_rounded, 'status': 'open'},
      {'label': 'Assigned', 'icon': Icons.person_rounded, 'status': 'assigned'},
      {'label': 'Collected', 'icon': Icons.shopping_bag_rounded, 'status': 'collected'},
      {'label': 'Delivered', 'icon': Icons.favorite_rounded, 'status': 'delivered'},
    ];

    final statusOrder = ['open', 'assigned', 'collected', 'delivered'];
    final currentIndex = statusOrder.indexOf(_status);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryLightest),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Donation Status',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primary),
          ),
          const SizedBox(height: 16),
          Row(
            children: List.generate(steps.length * 2 - 1, (index) {
              // line between steps
              if (index.isOdd) {
                final lineIndex = index ~/ 2;
                final done = lineIndex < currentIndex;
                return Expanded(
                  child: Container(
                    height: 2,
                    margin: const EdgeInsets.only(bottom: 20),
                    color: done ? AppColors.primaryLight : AppColors.primaryLightest,
                  ),
                );
              }

              final stepIndex = index ~/ 2;
              final step = steps[stepIndex];
              final done = stepIndex <= currentIndex;
              final active = stepIndex == currentIndex;

              return Column(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: done ? AppColors.primary : AppColors.primaryLightest,
                      border: Border.all(
                        color: active
                            ? AppColors.primaryLight
                            : done
                            ? AppColors.primary
                            : AppColors.primaryLightest,
                        width: active ? 2 : 1,
                      ),
                    ),
                    child: Icon(
                      step['icon'] as IconData,
                      size: 16,
                      color: done ? Colors.white : AppColors.primaryLight.withOpacity(0.4),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    step['label'] as String,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                      color: done ? AppColors.primary : AppColors.primaryLight.withOpacity(0.5),
                    ),
                  ),
                ],
              );
            }),
          ),

          // status message
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.bgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline_rounded, size: 14, color: AppColors.primaryLight),
                const SizedBox(width: 8),
                Text(
                  _getStatusMessage(),
                  style: TextStyle(fontSize: 12, color: AppColors.primaryDeep),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getStatusMessage() {
    switch (_status) {
      case 'open':
        return 'Looking for a volunteer near you...';
      case 'assigned':
        return 'Arjun Kumar is on the way to collect your food';
      case 'collected':
        return 'Food has been collected and is heading to NGO';
      case 'delivered':
        return 'Your food was delivered successfully 🎉';
      default:
        return '';
    }
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
        _buildInfoTile(Icons.location_on_rounded, 'Location', 'Andheri East'),
        _buildInfoTile(Icons.group_rounded, 'Volunteers', '1 assigned'),
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
          Expanded(
            child: Column(
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
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── VOLUNTEERS SECTION ───
  Widget _buildVolunteersSection() {
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
            'Volunteers on this mission',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primary),
          ),
          const SizedBox(height: 12),

          // volunteer row
          if (_status != 'open')
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.primary),
                  child: const Center(
                    child: Text(
                      'AK',
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
                        'Arjun Kumar',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.star_rounded, size: 12, color: Colors.amber),
                          const SizedBox(width: 3),
                          Text(
                            '4.9 · 32 missions',
                            style: TextStyle(fontSize: 11, color: AppColors.primaryLight),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // volunteer status chip
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLightest,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _status == 'assigned' ? 'En route' : 'Active',
                    style: TextStyle(
                      fontSize: 10,
                      color: AppColors.primaryDeep,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            )
          else
            Row(
              children: [
                Icon(Icons.search_rounded, size: 16, color: AppColors.primaryLight),
                const SizedBox(width: 8),
                Text(
                  'Looking for volunteers nearby...',
                  style: TextStyle(fontSize: 13, color: AppColors.primaryLight),
                ),
              ],
            ),
        ],
      ),
    );
  }

  // ─── PROOF PHOTO (after delivery) ───
  Widget _buildProofPhoto() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFC8E6C9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.verified_rounded, size: 16, color: Color(0xFF2E7D32)),
              const SizedBox(width: 6),
              Text(
                'Proof of Delivery',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              height: 140,
              width: double.infinity,
              color: AppColors.primaryLightest.withOpacity(0.3),
              child: Icon(Icons.image_rounded, color: AppColors.primaryLight, size: 40),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Delivered to Roti Bank Mumbai · Today 2:30 PM',
            style: TextStyle(fontSize: 12, color: AppColors.primaryLight),
          ),
        ],
      ),
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
            'Pickup Address',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primary),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.location_on_rounded, size: 16, color: AppColors.primaryLight),
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

  // ─── DONATION INFO ───
  Widget _buildDonationInfo() {
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
            'Donation Details',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primary),
          ),
          const SizedBox(height: 10),
          _buildDetailRow('Special instructions', 'Bring containers. Call on arrival.'),
          _buildDetailRow('Preferred NGO', 'Any available'),
          _buildDetailRow('Max volunteers needed', '3'),
          _buildDetailRow('Posted at', 'Today, 10:34 AM'),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 160,
            child: Text(label, style: TextStyle(fontSize: 12, color: AppColors.primaryLight)),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  // ─── BOTTOM CTA ───
  Widget _buildBottomCTA() {
    // if delivered — no action needed
    if (_status == 'delivered') {
      return Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: AppColors.primaryLightest, width: 0.5)),
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F5E9),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Center(
            child: Text(
              '🎉  Donation delivered successfully',
              style: TextStyle(color: Color(0xFF2E7D32), fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ),
        ),
      );
    }

    // if open — show cancel button
    if (_status == 'open') {
      return Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: AppColors.primaryLightest, width: 0.5)),
        ),
        child: SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () => _showCancelDialog(),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFFC62828),
              side: const BorderSide(color: Color(0xFFEF9A9A)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              padding: const EdgeInsets.symmetric(vertical: 15),
            ),
            child: const Text(
              'Cancel Donation',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
            ),
          ),
        ),
      );
    }

    // if assigned or collected — show tracking info
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.primaryLightest, width: 0.5)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Volunteer en route',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
                Text(
                  'ETA: 8 minutes',
                  style: TextStyle(fontSize: 12, color: AppColors.primaryLight),
                ),
              ],
            ),
          ),
          // call volunteer button
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.call_rounded, size: 16),
            label: const Text('Call'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }

  // ─── CANCEL DIALOG ───
  void _showCancelDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Cancel donation?',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.primary),
        ),
        content: Text(
          'Are you sure you want to cancel this donation? This cannot be undone.',
          style: TextStyle(fontSize: 13, color: AppColors.primaryLight),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Keep it', style: TextStyle(color: AppColors.primaryLight)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              // call cancel function here
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFC62828),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 0,
            ),
            child: const Text('Cancel donation'),
          ),
        ],
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
