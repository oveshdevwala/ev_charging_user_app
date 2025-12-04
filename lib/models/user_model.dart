/// File: lib/models/user_model.dart
/// Purpose: User data model with copyWith and JSON serialization
/// Belongs To: shared
/// Customization Guide:
///    - Add new fields as needed
///    - Update copyWith and JSON methods accordingly
library;

import 'package:equatable/equatable.dart';

/// User roles in the app.
enum UserRole {
  user,
  owner,
  admin,
}

/// User model representing app users.
class UserModel extends Equatable {
  const UserModel({
    required this.id,
    required this.email,
    required this.fullName,
    this.phone,
    this.avatarUrl,
    this.role = UserRole.user,
    this.isVerified = false,
    this.createdAt,
    this.updatedAt,
  });
  
  /// Create empty user.
  factory UserModel.empty() => const UserModel(
    id: '',
    email: '',
    fullName: '',
  );
  
  /// Create from JSON map.
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String? ?? '',
      email: json['email'] as String? ?? '',
      fullName: json['fullName'] as String? ?? json['full_name'] as String? ?? '',
      phone: json['phone'] as String?,
      avatarUrl: json['avatarUrl'] as String? ?? json['avatar_url'] as String?,
      role: UserRole.values.firstWhere(
        (r) => r.name == (json['role'] as String?),
        orElse: () => UserRole.user,
      ),
      isVerified: json['isVerified'] as bool? ?? json['is_verified'] as bool? ?? false,
      createdAt: json['createdAt'] != null 
          ? DateTime.tryParse(json['createdAt'] as String) 
          : json['created_at'] != null 
              ? DateTime.tryParse(json['created_at'] as String) 
              : null,
      updatedAt: json['updatedAt'] != null 
          ? DateTime.tryParse(json['updatedAt'] as String) 
          : json['updated_at'] != null 
              ? DateTime.tryParse(json['updated_at'] as String) 
              : null,
    );
  }
  
  final String id;
  final String email;
  final String fullName;
  final String? phone;
  final String? avatarUrl;
  final UserRole role;
  final bool isVerified;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  
  /// Check if user is empty.
  bool get isEmpty => id.isEmpty;
  
  /// Check if user is not empty.
  bool get isNotEmpty => id.isNotEmpty;
  
  /// Get user initials.
  String get initials {
    final words = fullName.trim().split(' ');
    if (words.isEmpty) {
      return '';
    }
    if (words.length == 1) {
      return words.first.isNotEmpty ? words.first[0].toUpperCase() : '';
    }
    return '${words.first[0]}${words.last[0]}'.toUpperCase();
  }
  
  /// Convert to JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'fullName': fullName,
      'phone': phone,
      'avatarUrl': avatarUrl,
      'role': role.name,
      'isVerified': isVerified,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
  
  /// Copy with new values.
  UserModel copyWith({
    String? id,
    String? email,
    String? fullName,
    String? phone,
    String? avatarUrl,
    UserRole? role,
    bool? isVerified,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role ?? this.role,
      isVerified: isVerified ?? this.isVerified,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
  
  @override
  List<Object?> get props => [
    id,
    email,
    fullName,
    phone,
    avatarUrl,
    role,
    isVerified,
    createdAt,
    updatedAt,
  ];
}

