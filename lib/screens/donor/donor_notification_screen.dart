import 'package:flutter/material.dart';
import 'package:seva_meal/core/app_colors.dart';

class DonorNotificationScreen extends StatefulWidget {
  const DonorNotificationScreen({super.key});

  @override
  State<DonorNotificationScreen> createState() => _DonorNotificationScreenState();
}

class _DonorNotificationScreenState extends State<DonorNotificationScreen> {
  final List<NotificationModel> _notifications = [
    NotificationModel(
      id: '1',
      title: '🚴 Volunteer on the way!',
      body: 'Arjun Kumar accepted your Biryani pickup. He is 1.2 km away — ETA 8 minutes.',
      type: 'volunteer_assigned',
      donationId: 'FD-2024-0847',
      createdAt: DateTime.now().subtract(const Duration(minutes: 3)),
      isRead: false,
    ),
    NotificationModel(
      id: '2',
      title: '👥 2nd volunteer joined!',
      body: 'Priya Mehta also joined your Biryani mission. 2 of 3 volunteers are now ready.',
      type: 'volunteer_joined',
      donationId: 'FD-2024-0847',
      createdAt: DateTime.now().subtract(const Duration(minutes: 18)),
      isRead: false,
    ),
    NotificationModel(
      id: '3',
      title: '⏰ Donation expiring soon',
      body: 'Your Bread & Baked Goods donation expires in 45 minutes and has no volunteer yet.',
      type: 'expiry_warning',
      donationId: 'FD-2024-0819',
      createdAt: DateTime.now().subtract(const Duration(minutes: 45)),
      isRead: false,
    ),
    NotificationModel(
      id: '4',
      title: '✅ Food collected!',
      body: 'Arjun Kumar collected your Dal Rice + Sabzi. It is heading to Roti Bank Mumbai.',
      type: 'food_collected',
      donationId: 'FD-2024-0831',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: true,
    ),
    NotificationModel(
      id: '5',
      title: '🎉 Delivered successfully!',
      body: 'Your Dal Rice reached Roti Bank Mumbai. You helped feed 40 people today. Thank you!',
      type: 'food_delivered',
      donationId: 'FD-2024-0831',
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
      isRead: true,
    ),
    NotificationModel(
      id: '6',
      title: '⭐ Volunteer rated you',
      body: 'Arjun Kumar rated your donation experience 5 stars. Great packaging and punctuality!',
      type: 'rating_received',
      donationId: null,
      createdAt: DateTime.now().subtract(const Duration(hours: 4)),
      isRead: true,
    ),
    NotificationModel(
      id: '7',
      title: '🎉 Delivered successfully!',
      body:
          'Your Mixed Salads reached Aasra Shelter. 30 people were served because of your kindness.',
      type: 'food_delivered',
      donationId: 'FD-2024-0801',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
    ),
    NotificationModel(
      id: '8',
      title: '⏰ Donation expired',
      body:
          'Your Cakes & Desserts donation expired with no volunteer assigned. Consider reposting.',
      type: 'donation_expired',
      donationId: 'FD-2024-0788',
      createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
      isRead: true,
    ),
    NotificationModel(
      id: '9',
      title: '🏆 Monthly impact report',
      body:
          'This month you donated 5 times, helped feed 240 people, and involved 8 volunteers. Amazing!',
      type: 'impact_report',
      donationId: null,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      isRead: true,
    ),
  ];

  int get _unreadCount => _notifications.where((n) => !n.isRead).length;

  void _markAllRead() {
    setState(() {
      for (var i = 0; i < _notifications.length; i++) {
        _notifications[i] = NotificationModel(
          id: _notifications[i].id,
          title: _notifications[i].title,
          body: _notifications[i].body,
          type: _notifications[i].type,
          donationId: _notifications[i].donationId,
          createdAt: _notifications[i].createdAt,
          isRead: true,
        );
      }
    });
  }

  void _markRead(String id) {
    setState(() {
      final index = _notifications.indexWhere((n) => n.id == id);
      if (index != -1) {
        _notifications[index] = NotificationModel(
          id: _notifications[index].id,
          title: _notifications[index].title,
          body: _notifications[index].body,
          type: _notifications[index].type,
          donationId: _notifications[index].donationId,
          createdAt: _notifications[index].createdAt,
          isRead: true,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final today = _notifications.where((n) => _isToday(n.createdAt)).toList();
    final yesterday = _notifications.where((n) => _isYesterday(n.createdAt)).toList();
    final older = _notifications
        .where((n) => !_isToday(n.createdAt) && !_isYesterday(n.createdAt))
        .toList();

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            // impact banner — donor specific
            if (_unreadCount > 0) _buildImpactBanner(),
            Expanded(
              child: _notifications.isEmpty
                  ? _buildEmptyState()
                  : ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      children: [
                        if (today.isNotEmpty) ...[
                          _buildGroupLabel('Today', today.where((n) => !n.isRead).length),
                          ...today.map((n) => _buildNotificationCard(n)),
                        ],
                        if (yesterday.isNotEmpty) ...[
                          _buildGroupLabel('Yesterday', 0),
                          ...yesterday.map((n) => _buildNotificationCard(n)),
                        ],
                        if (older.isNotEmpty) ...[
                          _buildGroupLabel('Older', 0),
                          ...older.map((n) => _buildNotificationCard(n)),
                        ],
                        const SizedBox(height: 20),
                      ],
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
            child: Icon(Icons.arrow_back_rounded, color: AppColors.primaryLightest, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Notifications',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
                ),
                if (_unreadCount > 0)
                  Text(
                    '$_unreadCount unread',
                    style: TextStyle(
                      color: AppColors.primaryLightest.withOpacity(0.7),
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),
          if (_unreadCount > 0)
            GestureDetector(
              onTap: _markAllRead,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primaryDeep.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.primaryLight.withOpacity(0.3)),
                ),
                child: Text(
                  'Mark all read',
                  style: TextStyle(
                    color: AppColors.primaryLightest,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ─── IMPACT BANNER — donor specific ───
  Widget _buildImpactBanner() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryDeep, AppColors.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Text('🎯', style: TextStyle(fontSize: 28)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'You are on a roll!',
                  style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                ),
                Text(
                  '3 active updates on your donations today',
                  style: TextStyle(
                    color: AppColors.primaryLightest.withOpacity(0.8),
                    fontSize: 11,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── GROUP LABEL ───
  Widget _buildGroupLabel(String label, int unread) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryLight,
              letterSpacing: 0.5,
            ),
          ),
          if (unread > 0) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '$unread new',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
          const SizedBox(width: 8),
          Expanded(child: Divider(color: AppColors.primaryLightest, height: 1)),
        ],
      ),
    );
  }

  // ─── NOTIFICATION CARD ───
  Widget _buildNotificationCard(NotificationModel notification) {
    final config = _getTypeConfig(notification.type);

    return GestureDetector(
      onTap: () {
        _markRead(notification.id);
        if (notification.donationId != null) {
          // Navigator.push to DonationDetailDonorScreen
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: notification.isRead ? Colors.white : AppColors.primaryLightest.withOpacity(0.25),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: notification.isRead
                ? AppColors.primaryLightest
                : AppColors.primaryLight.withOpacity(0.4),
            width: notification.isRead ? 0.5 : 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // icon
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: config['bgColor'] as Color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(config['emoji'] as String, style: const TextStyle(fontSize: 20)),
                ),
              ),
              const SizedBox(width: 12),

              // content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: notification.isRead ? FontWeight.w500 : FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _formatTime(notification.createdAt),
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.primaryLight.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.body,
                      style: TextStyle(
                        fontSize: 12,
                        color: notification.isRead ? AppColors.primaryLight : AppColors.primaryDeep,
                        height: 1.5,
                      ),
                    ),

                    // CTA
                    if (!notification.isRead) _buildCTA(notification),
                  ],
                ),
              ),

              // unread dot
              if (!notification.isRead) ...[
                const SizedBox(width: 8),
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.primaryLight),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // ─── CTA PER TYPE ───
  Widget _buildCTA(NotificationModel notification) {
    switch (notification.type) {
      // volunteer assigned — show track button
      case 'volunteer_assigned':
        return Padding(
          padding: const EdgeInsets.only(top: 10),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.location_on_rounded, size: 14),
              label: const Text(
                'Track volunteer',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(vertical: 8),
                elevation: 0,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ),
        );

      // expiry warning — repost or cancel
      case 'expiry_warning':
        return Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFC62828),
                    side: const BorderSide(color: Color(0xFFEF9A9A)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(vertical: 7),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text('Cancel', style: TextStyle(fontSize: 12)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(vertical: 7),
                    elevation: 0,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    'View donation',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        );

      // food delivered — view proof photo
      case 'food_delivered':
        return Padding(
          padding: const EdgeInsets.only(top: 10),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.verified_rounded, size: 14),
              label: const Text(
                'View proof photo',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE8F5E9),
                foregroundColor: const Color(0xFF2E7D32),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(vertical: 8),
                elevation: 0,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ),
        );

      // expired — repost option
      case 'donation_expired':
        return Padding(
          padding: const EdgeInsets.only(top: 10),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryLightest,
                foregroundColor: AppColors.primaryDeep,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(vertical: 8),
                elevation: 0,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                'Repost donation',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        );

      default:
        return const SizedBox.shrink();
    }
  }

  // ─── EMPTY STATE ───
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.primaryLightest.withOpacity(0.4),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.notifications_off_rounded, color: AppColors.primaryLight, size: 36),
          ),
          const SizedBox(height: 16),
          Text(
            'No notifications yet',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.primary),
          ),
          const SizedBox(height: 6),
          Text(
            'Updates about your donations\nwill appear here.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: AppColors.primaryLight, height: 1.5),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              elevation: 0,
            ),
            child: const Text('Post a donation'),
          ),
        ],
      ),
    );
  }

  // ─── HELPERS ───
  Map<String, dynamic> _getTypeConfig(String type) {
    switch (type) {
      case 'volunteer_assigned':
        return {'emoji': '🚴', 'bgColor': AppColors.primaryLightest};
      case 'volunteer_joined':
        return {'emoji': '👥', 'bgColor': const Color(0xFFE8F5E9)};
      case 'expiry_warning':
        return {'emoji': '⏰', 'bgColor': const Color(0xFFFFF3E0)};
      case 'food_collected':
        return {'emoji': '📦', 'bgColor': const Color(0xFFE8F5E9)};
      case 'food_delivered':
        return {'emoji': '🎉', 'bgColor': const Color(0xFFE8F5E9)};
      case 'rating_received':
        return {'emoji': '⭐', 'bgColor': const Color(0xFFFFF8E1)};
      case 'donation_expired':
        return {'emoji': '❌', 'bgColor': const Color(0xFFFFEBEE)};
      case 'impact_report':
        return {'emoji': '🏆', 'bgColor': const Color(0xFFFFF8E1)};
      default:
        return {'emoji': '🔔', 'bgColor': AppColors.primaryLightest};
    }
  }

  bool _isToday(DateTime dt) {
    final now = DateTime.now();
    return dt.year == now.year && dt.month == now.month && dt.day == now.day;
  }

  bool _isYesterday(DateTime dt) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return dt.year == yesterday.year && dt.month == yesterday.month && dt.day == yesterday.day;
  }

  String _formatTime(DateTime dt) {
    if (_isToday(dt)) {
      final diff = DateTime.now().difference(dt);
      if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
      return '${diff.inHours}h ago';
    }
    if (_isYesterday(dt)) return 'Yesterday';
    return '${dt.day}/${dt.month}';
  }
}

// ─── NOTIFICATION MODEL ───
class NotificationModel {
  final String id;
  final String title;
  final String body;
  final String type;
  final String? donationId;
  final DateTime createdAt;
  final bool isRead;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    this.donationId,
    required this.createdAt,
    required this.isRead,
  });
}
