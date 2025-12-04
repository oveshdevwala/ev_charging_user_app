/// File: lib/features/notifications/ui/notifications_page.dart
/// Purpose: User notifications screen
/// Belongs To: notifications feature
/// Route: /userNotifications
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/extensions/date_ext.dart';
import '../../../models/notification_model.dart';
import '../../../repositories/user_repository.dart';
import '../../../widgets/app_app_bar.dart';
import '../../../widgets/loading_wrapper.dart';
import '../widgets/notification_item.dart';

/// Notifications page showing user notifications.
class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final _userRepository = DummyUserRepository();
  List<NotificationModel> _notifications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    final notifications = await _userRepository.getNotifications();
    if (mounted) {
      setState(() {
        _notifications = notifications;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(
        title: AppStrings.notifications,
        actions: [
          if (_notifications.any((n) => !n.isRead))
            TextButton(
              onPressed: () async {
                await _userRepository.markAllNotificationsAsRead();
                _loadNotifications();
              },
              child: Text('Mark all read', style: TextStyle(fontSize: 14.sp, color: AppColors.primary)),
            ),
        ],
      ),
      body: LoadingWrapper(
        isLoading: _isLoading,
        isEmpty: _notifications.isEmpty,
        emptyTitle: AppStrings.noNotifications,
        emptyIcon: Iconsax.notification,
        child: RefreshIndicator(
          onRefresh: _loadNotifications,
          child: ListView.separated(
            padding: EdgeInsets.all(20.r),
            itemCount: _notifications.length,
            separatorBuilder: (_, __) => SizedBox(height: 12.h),
            itemBuilder: (context, index) {
              final notification = _notifications[index];
              return NotificationItem(
                notification: notification,
                onTap: () async {
                  if (!notification.isRead) {
                    await _userRepository.markNotificationAsRead(notification.id);
                    _loadNotifications();
                  }
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

