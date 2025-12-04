/// File: lib/models/notification_model.dart
/// Purpose: Notification data model
/// Belongs To: shared
/// Customization Guide:
///    - Add new notification types as needed
///    - Update copyWith and JSON methods accordingly
library;

import 'package:equatable/equatable.dart';

/// Notification type enum.
enum NotificationType {
  booking,
  payment,
  promotion,
  system,
  reminder,
  alert,
}

/// Notification model for in-app notifications.
class NotificationModel extends Equatable {
  const NotificationModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.message,
    this.type = NotificationType.system,
    this.imageUrl,
    this.actionUrl,
    this.data,
    this.isRead = false,
    this.createdAt,
  });
  
  /// Create from JSON map.
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String? ?? '',
      userId: json['userId'] as String? ?? json['user_id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      message: json['message'] as String? ?? '',
      type: NotificationType.values.firstWhere(
        (t) => t.name == (json['type'] as String?),
        orElse: () => NotificationType.system,
      ),
      imageUrl: json['imageUrl'] as String? ?? json['image_url'] as String?,
      actionUrl: json['actionUrl'] as String? ?? json['action_url'] as String?,
      data: json['data'] as Map<String, dynamic>?,
      isRead: json['isRead'] as bool? ?? json['is_read'] as bool? ?? false,
      createdAt: json['createdAt'] != null 
          ? DateTime.tryParse(json['createdAt'] as String) 
          : null,
    );
  }
  
  final String id;
  final String userId;
  final String title;
  final String message;
  final NotificationType type;
  final String? imageUrl;
  final String? actionUrl;
  final Map<String, dynamic>? data;
  final bool isRead;
  final DateTime? createdAt;
  
  /// Convert to JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'message': message,
      'type': type.name,
      'imageUrl': imageUrl,
      'actionUrl': actionUrl,
      'data': data,
      'isRead': isRead,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
  
  /// Copy with new values.
  NotificationModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? message,
    NotificationType? type,
    String? imageUrl,
    String? actionUrl,
    Map<String, dynamic>? data,
    bool? isRead,
    DateTime? createdAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      imageUrl: imageUrl ?? this.imageUrl,
      actionUrl: actionUrl ?? this.actionUrl,
      data: data ?? this.data,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }
  
  @override
  List<Object?> get props => [
    id,
    userId,
    title,
    message,
    type,
    imageUrl,
    actionUrl,
    data,
    isRead,
    createdAt,
  ];
}

