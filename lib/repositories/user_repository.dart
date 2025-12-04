/// File: lib/repositories/user_repository.dart
/// Purpose: User repository interface and dummy implementation
/// Belongs To: shared
/// Customization Guide:
///    - Implement the interface with actual backend API
///    - Replace DummyUserRepository with real implementation

import '../models/models.dart';

/// User repository interface.
/// Implement this for actual backend integration.
abstract class UserRepository {
  /// Get current user profile.
  Future<UserModel?> getProfile();
  
  /// Update user profile.
  Future<UserModel?> updateProfile({
    String? fullName,
    String? phone,
    String? avatarUrl,
  });
  
  /// Change password.
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  });
  
  /// Upload avatar.
  Future<String?> uploadAvatar(String filePath);
  
  /// Delete account.
  Future<bool> deleteAccount();
  
  /// Get user notifications.
  Future<List<NotificationModel>> getNotifications({
    int page = 1,
    int limit = 20,
  });
  
  /// Mark notification as read.
  Future<bool> markNotificationAsRead(String notificationId);
  
  /// Mark all notifications as read.
  Future<bool> markAllNotificationsAsRead();
  
  /// Get unread notification count.
  Future<int> getUnreadNotificationCount();
}

/// Dummy user repository for development/testing.
class DummyUserRepository implements UserRepository {
  UserModel? _currentUser = const UserModel(
    id: 'user_1',
    email: 'john.doe@example.com',
    fullName: 'John Doe',
    phone: '+1234567890',
    role: UserRole.user,
    isVerified: true,
  );
  
  final List<NotificationModel> _notifications = _generateDummyNotifications();
  
  static List<NotificationModel> _generateDummyNotifications() {
    return [
      NotificationModel(
        id: 'notif_1',
        userId: 'user_1',
        title: 'Booking Confirmed',
        message: 'Your booking at Downtown EV Hub has been confirmed for today at 3:00 PM.',
        type: NotificationType.booking,
        isRead: false,
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      NotificationModel(
        id: 'notif_2',
        userId: 'user_1',
        title: 'Charging Complete',
        message: 'Your charging session is complete. Total cost: \$15.50',
        type: NotificationType.payment,
        isRead: false,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      NotificationModel(
        id: 'notif_3',
        userId: 'user_1',
        title: 'Special Offer',
        message: 'Get 20% off on your next charging session! Use code: EV20',
        type: NotificationType.promotion,
        isRead: true,
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
      NotificationModel(
        id: 'notif_4',
        userId: 'user_1',
        title: 'New Station Nearby',
        message: 'A new charging station has opened near your location!',
        type: NotificationType.system,
        isRead: true,
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
    ];
  }
  
  @override
  Future<UserModel?> getProfile() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _currentUser;
  }
  
  @override
  Future<UserModel?> updateProfile({
    String? fullName,
    String? phone,
    String? avatarUrl,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(
        fullName: fullName ?? _currentUser!.fullName,
        phone: phone ?? _currentUser!.phone,
        avatarUrl: avatarUrl ?? _currentUser!.avatarUrl,
        updatedAt: DateTime.now(),
      );
      return _currentUser;
    }
    return null;
  }
  
  @override
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    // Dummy validation
    return currentPassword.isNotEmpty && newPassword.length >= 8;
  }
  
  @override
  Future<String?> uploadAvatar(String filePath) async {
    await Future.delayed(const Duration(seconds: 2));
    // Return a dummy URL
    return 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e';
  }
  
  @override
  Future<bool> deleteAccount() async {
    await Future.delayed(const Duration(seconds: 1));
    _currentUser = null;
    return true;
  }
  
  @override
  Future<List<NotificationModel>> getNotifications({
    int page = 1,
    int limit = 20,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final start = (page - 1) * limit;
    if (start >= _notifications.length) return [];
    final end = (start + limit) > _notifications.length ? _notifications.length : start + limit;
    return _notifications.sublist(start, end);
  }
  
  @override
  Future<bool> markNotificationAsRead(String notificationId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
      return true;
    }
    return false;
  }
  
  @override
  Future<bool> markAllNotificationsAsRead() async {
    await Future.delayed(const Duration(milliseconds: 500));
    for (var i = 0; i < _notifications.length; i++) {
      _notifications[i] = _notifications[i].copyWith(isRead: true);
    }
    return true;
  }
  
  @override
  Future<int> getUnreadNotificationCount() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _notifications.where((n) => !n.isRead).length;
  }
}

