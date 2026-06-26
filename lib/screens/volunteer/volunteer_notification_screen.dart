import 'package:flutter/material.dart';
import 'package:seva_meal/core/app_colors.dart';

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

class VolunteerNotificationScreen extends StatefulWidget {
  const VolunteerNotificationScreen({super.key});

  @override
  State<VolunteerNotificationScreen> createState() => _VolunteerNotificationScreenState();
}

class _VolunteerNotificationScreenState extends State<VolunteerNotificationScreen> {
  // mock data — replace with Firestore stream
  final List<NotificationModel> _notifications = [
    NotificationModel(
      id: '1',
      title: '🍱 New donation nearby!',
      body:
          'Biryani — 60 portions available 1.2 km away in Andheri East. Pick it up before it expires!',
      type: 'new_donation',
      donationId: 'FD-2024-0847',
      createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
      isRead: false,
    ),
    NotificationModel(
      id: '2',
      title: '👥 Priya joined your mission!',
      body: 'Priya Mehta joined the Dal Rice + Sabzi mission. You now have 2 of 3 volunteers.',
      type: 'volunteer_joined',
      donationId: 'FD-2024-0831',
      createdAt: DateTime.now().subtract(const Duration(minutes: 22)),
      isRead: false,
    ),
    NotificationModel(
      id: '3',
      title: '⏰ Mission expiring soon',
      body: 'Bread & Baked Goods donation expires in 45 minutes and still needs 1 more volunteer.',
      type: 'expiry_warning',
      donationId: 'FD-2024-0819',
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
      isRead: false,
    ),
    NotificationModel(
      id: '4',
      title: '✅ Mission completed!',
      body:
          'Great work! You delivered Mixed Salads to Roti Bank Mumbai. You helped feed 30 people today.',
      type: 'mission_complete',
      donationId: 'FD-2024-0801',
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
      isRead: true,
    ),
    NotificationModel(
      id: '5',
      title: '⭐ Donor rated you',
      body: 'Hotel Regent gave you a 5-star rating for the Biryani pickup. Keep it up!',
      type: 'rating',
      donationId: null,
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      isRead: true,
    ),
    NotificationModel(
      id: '6',
      title: '🍱 New donation nearby!',
      body: 'Cakes & Desserts — 25 pieces available 3.4 km away in Powai.',
      type: 'new_donation',
      donationId: 'FD-2024-0788',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
    ),
    NotificationModel(
      id: '7',
      title: '✅ Mission completed!',
      body: 'You delivered Dal Rice to Aasra Shelter. 40 people were fed because of you!',
      type: 'mission_complete',
      donationId: 'FD-2024-0772',
      createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
      isRead: true,
    ),
    NotificationModel(
      id: '8',
      title: '🍱 New donation nearby!',
      body: 'Rajma Chawal — 70 portions available 4.0 km away in Borivali.',
      type: 'new_donation',
      donationId: 'FD-2024-0755',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      isRead: true,
    ),
  ];

  int get _unreadCount => _notifications.where((n) => !n.isRead).length;

  void _markAllRead() {
    setState(() {
      for (final n in _notifications) {
        // mark all read
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
    // group by today / yesterday / older
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
          // navigate to donation detail
          // Navigator.push(context, ...);
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

                    // CTA row for actionable notifications
                    if (!notification.isRead && notification.donationId != null) ...[
                      const SizedBox(height: 10),
                      _buildNotificationCTA(notification),
                    ],
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

  // ─── NOTIFICATION CTA ───
  Widget _buildNotificationCTA(NotificationModel notification) {
    if (notification.type == 'new_donation') {
      return Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primaryLight,
                side: BorderSide(color: AppColors.primaryLightest),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(vertical: 7),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text('Ignore', style: TextStyle(fontSize: 12)),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
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
      );
    }

    if (notification.type == 'expiry_warning') {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange.withOpacity(0.15),
            foregroundColor: Colors.orange.shade800,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.symmetric(vertical: 7),
            elevation: 0,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text(
            'Pick up now →',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ),
      );
    }

    if (notification.type == 'volunteer_joined') {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryLightest,
            foregroundColor: AppColors.primaryDeep,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.symmetric(vertical: 7),
            elevation: 0,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text(
            'View mission →',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ),
      );
    }

    return const SizedBox.shrink();
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
            'When donors post food near you,\nyou will be notified here.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: AppColors.primaryLight, height: 1.5),
          ),
        ],
      ),
    );
  }

  // ─── HELPERS ───
  Map<String, dynamic> _getTypeConfig(String type) {
    switch (type) {
      case 'new_donation':
        return {'emoji': '🍱', 'bgColor': AppColors.primaryLightest};
      case 'volunteer_joined':
        return {'emoji': '👥', 'bgColor': const Color(0xFFE8F5E9)};
      case 'expiry_warning':
        return {'emoji': '⏰', 'bgColor': const Color(0xFFFFF3E0)};
      case 'mission_complete':
        return {'emoji': '✅', 'bgColor': const Color(0xFFE8F5E9)};
      case 'rating':
        return {'emoji': '⭐', 'bgColor': const Color(0xFFFFF8E1)};
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
