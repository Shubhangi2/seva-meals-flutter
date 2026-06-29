import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seva_meal/core/app_colors.dart';
import 'package:seva_meal/core/constants.dart';
import 'package:seva_meal/models/post_model.dart';
import 'package:seva_meal/providers/donor_provider.dart';
import 'package:seva_meal/screens/shared_widgets/loader.dart';
import 'package:seva_meal/screens/shared_widgets/show_snackbar.dart';

class DonorPostDetailScreen extends StatefulWidget {
  final PostModel post;
  const DonorPostDetailScreen({super.key, required this.post});

  @override
  State<DonorPostDetailScreen> createState() => _DonorPostDetailScreenState();
}

class _DonorPostDetailScreenState extends State<DonorPostDetailScreen> {
  bool _isLoading = false;

  bool get _canCancel =>
      widget.post.status == Constants.STATUS_PENDING ||
      widget.post.status == Constants.STATUS_ASSIGNED;

  // ─── CANCEL POST ───
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
          widget.post.status == Constants.STATUS_ASSIGNED
              ? 'A volunteer has already accepted this pickup. Cancelling will remove them from the mission.'
              : 'Are you sure you want to cancel this donation? This cannot be undone.',
          style: TextStyle(fontSize: 13, color: AppColors.primaryLight),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Keep it', style: TextStyle(color: AppColors.primaryLight)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await _cancelPost();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFC62828),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 0,
            ),
            child: const Text('Yes, cancel'),
          ),
        ],
      ),
    );
  }

  Future<void> _cancelPost() async {
    // setState(() => _isLoading = true);

    // final res = await context.read<DonorProvider>().cancelPost(widget.post.id);

    // res.fold((l) => showSnackBar(context, l.message, false), (r) {
    //   showSnackBar(context, "Donation cancelled", true);
    //   Navigator.pop(context);
    // });

    // setState(() => _isLoading = false);
  }

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
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPhotoSection(),
                    const SizedBox(height: 16),
                    _buildStatusTracker(),
                    const SizedBox(height: 16),
                    if (widget.post.status != Constants.STATUS_PENDING) _buildVolunteerCard(),
                    if (widget.post.status != Constants.STATUS_PENDING) const SizedBox(height: 16),
                    if (widget.post.status == Constants.STATUS_DELIVERED) _buildProofPhoto(),
                    if (widget.post.status == Constants.STATUS_DELIVERED)
                      const SizedBox(height: 16),
                    _buildFoodDetails(),
                    const SizedBox(height: 16),
                    _buildLocationDetails(),
                    const SizedBox(height: 16),
                    _buildPostMeta(),
                    const SizedBox(height: 24),
                    _buildBottomCTA(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── HEADER ───
  Widget _buildHeader() {
    return Container(
      color: AppColors.primary,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.arrow_back_rounded, color: AppColors.primaryLightest),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Donation Details',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
                ),
                Text(
                  'ID: ${widget.post.postId}',
                  style: TextStyle(color: AppColors.primaryLightest.withOpacity(0.6), fontSize: 11),
                ),
              ],
            ),
          ),
          _buildStatusBadge(),
        ],
      ),
    );
  }

  // ─── STATUS BADGE ───
  Widget _buildStatusBadge() {
    final config = _statusConfig(widget.post.status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: (config['color'] as Color).withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: (config['color'] as Color).withOpacity(0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(shape: BoxShape.circle, color: config['color'] as Color),
          ),
          const SizedBox(width: 5),
          Text(
            config['label'] as String,
            style: TextStyle(
              color: config['color'] as Color,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ─── PHOTO ───
  Widget _buildPhotoSection() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: 180,
        width: double.infinity,
        child: Image.network(
          widget.post.pickupFoodPictureUrl,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            color: AppColors.primaryLightest.withOpacity(0.3),
            child: Icon(Icons.fastfood_rounded, color: AppColors.primaryLight, size: 48),
          ),
        ),
      ),
    );
  }

  // ─── STATUS TRACKER ───
  Widget _buildStatusTracker() {
    final steps = [
      {'label': 'Posted', 'icon': Icons.check_circle_rounded},
      {'label': 'Assigned', 'icon': Icons.person_rounded},
      {'label': 'Collected', 'icon': Icons.shopping_bag_rounded},
      {'label': 'Delivered', 'icon': Icons.favorite_rounded},
    ];

    final statusOrder = [
      Constants.STATUS_PENDING,
      Constants.STATUS_ASSIGNED,
      Constants.STATUS_COLLECTED,
      Constants.STATUS_DELIVERED,
    ];

    final currentIndex = statusOrder.indexOf(widget.post.status).clamp(0, 3);

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
            'Status',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primary),
          ),
          const SizedBox(height: 16),
          Row(
            children: List.generate(steps.length * 2 - 1, (index) {
              if (index.isOdd) {
                final done = index ~/ 2 < currentIndex;
                return Expanded(
                  child: Container(
                    height: 2,
                    margin: const EdgeInsets.only(bottom: 22),
                    color: done ? AppColors.primaryLight : AppColors.primaryLightest,
                  ),
                );
              }
              final stepIndex = index ~/ 2;
              final done = stepIndex <= currentIndex;
              final active = stepIndex == currentIndex;
              return Column(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 34,
                    height: 34,
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
                      steps[stepIndex]['icon'] as IconData,
                      size: 15,
                      color: done ? Colors.white : AppColors.primaryLight.withOpacity(0.4),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    steps[stepIndex]['label'] as String,
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                      color: done ? AppColors.primary : AppColors.primaryLight.withOpacity(0.5),
                    ),
                  ),
                ],
              );
            }),
          ),
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
                Expanded(
                  child: Text(
                    _getStatusMessage(),
                    style: TextStyle(fontSize: 12, color: AppColors.primaryDeep),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── VOLUNTEER CARD ───
  Widget _buildVolunteerCard() {
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
            'Assigned Volunteer',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primary),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.primary),
                child: const Center(
                  child: Text(
                    'AK',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Arjun Kumar',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.star_rounded, size: 13, color: Colors.amber),
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
              if (widget.post.status == Constants.STATUS_ASSIGNED ||
                  widget.post.status == Constants.STATUS_COLLECTED)
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
          if (widget.post.status == Constants.STATUS_ASSIGNED) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.bgColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(Icons.directions_bike_rounded, size: 14, color: AppColors.primaryLight),
                  const SizedBox(width: 8),
                  Text(
                    'En route · ETA 8 minutes',
                    style: TextStyle(fontSize: 12, color: AppColors.primaryDeep),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ─── PROOF PHOTO ───
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

  // ─── FOOD DETAILS ───
  Widget _buildFoodDetails() {
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
          _buildSectionLabel('Food Details', Icons.fastfood_rounded),
          const SizedBox(height: 12),
          _buildDetailRow('Title', widget.post.title),
          _buildDetailRow('Description', widget.post.description),
          _buildDetailRow('Food Type', widget.post.foodType),
          _buildDetailRow('Quantity', '${widget.post.quantity} portions'),
        ],
      ),
    );
  }

  // ─── LOCATION DETAILS ───
  Widget _buildLocationDetails() {
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
          _buildSectionLabel('Pickup Location', Icons.location_on_rounded),
          const SizedBox(height: 12),
          _buildDetailRow('City', widget.post.city),
          _buildDetailRow('Area', widget.post.region),
          _buildDetailRow('Address', widget.post.pickupAddress),
        ],
      ),
    );
  }

  // ─── POST META ───
  Widget _buildPostMeta() {
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
          _buildSectionLabel('Post Info', Icons.info_outline_rounded),
          const SizedBox(height: 12),
          _buildDetailRow('Posted', _formatDate(widget.post.createdAt)),
          _buildDetailRow('Last updated', _formatDate(widget.post.updatedAt)),
          _buildDetailRow('Active', widget.post.isActive ? 'Yes' : 'No'),
        ],
      ),
    );
  }

  // ─── BOTTOM CTA ───
  Widget _buildBottomCTA() {
    if (_isLoading) return const Loader();

    if (widget.post.status == Constants.STATUS_DELIVERED) {
      return Container(
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
      );
    }

    if (widget.post.status == Constants.STATUS_COLLECTED) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.primaryLightest.withOpacity(0.4),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.primaryLightest),
        ),
        child: Center(
          child: Text(
            '📦  Food collected · heading to NGO',
            style: TextStyle(
              color: AppColors.primaryDeep,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      );
    }

    if (_canCancel) {
      return SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          onPressed: _showCancelDialog,
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFFC62828),
            side: const BorderSide(color: Color(0xFFEF9A9A)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
          child: const Text(
            'Cancel Donation',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  // ─── HELPERS ───
  Widget _buildSectionLabel(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 15, color: AppColors.primaryLight),
        const SizedBox(width: 6),
        Text(
          title,
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primaryDeep),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
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

  Map<String, dynamic> _statusConfig(String status) {
    switch (status) {
      case Constants.STATUS_PENDING:
        return {'label': 'Waiting', 'color': Colors.orange};
      case Constants.STATUS_ASSIGNED:
        return {'label': 'Assigned', 'color': AppColors.primaryLight};
      case Constants.STATUS_COLLECTED:
        return {'label': 'Collected', 'color': const Color(0xFF4CAF50)};
      case Constants.STATUS_DELIVERED:
        return {'label': 'Delivered ✓', 'color': const Color(0xFF2E7D32)};
      default:
        return {'label': 'Unknown', 'color': Colors.grey};
    }
  }

  String _getStatusMessage() {
    switch (widget.post.status) {
      case Constants.STATUS_PENDING:
        return 'Looking for a volunteer near you...';
      case Constants.STATUS_ASSIGNED:
        return 'Volunteer is on the way to collect your food';
      case Constants.STATUS_COLLECTED:
        return 'Food collected and heading to NGO';
      case Constants.STATUS_DELIVERED:
        return 'Your food was delivered successfully 🎉';
      default:
        return '';
    }
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final diff = now.difference(date);
      if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
      if (diff.inHours < 24) return '${diff.inHours}h ago';
      return '${date.day}/${date.month}/${date.year}';
    } catch (_) {
      return dateString;
    }
  }
}
