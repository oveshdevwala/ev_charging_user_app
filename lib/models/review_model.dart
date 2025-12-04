/// File: lib/models/review_model.dart
/// Purpose: Review data model for station ratings
/// Belongs To: shared
/// Customization Guide:
///    - Add new fields as needed
///    - Update copyWith and JSON methods accordingly
library;

import 'package:equatable/equatable.dart';

/// Review model for station ratings and feedback.
class ReviewModel extends Equatable {
  const ReviewModel({
    required this.id,
    required this.userId,
    required this.stationId,
    required this.rating,
    this.userName,
    this.userAvatar,
    this.comment,
    this.images = const [],
    this.isVerified = false,
    this.helpfulCount = 0,
    this.createdAt,
    this.updatedAt,
  });
  
  /// Create from JSON map.
  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] as String? ?? '',
      userId: json['userId'] as String? ?? json['user_id'] as String? ?? '',
      stationId: json['stationId'] as String? ?? json['station_id'] as String? ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      userName: json['userName'] as String? ?? json['user_name'] as String?,
      userAvatar: json['userAvatar'] as String? ?? json['user_avatar'] as String?,
      comment: json['comment'] as String?,
      images: (json['images'] as List<dynamic>?)?.cast<String>() ?? [],
      isVerified: json['isVerified'] as bool? ?? json['is_verified'] as bool? ?? false,
      helpfulCount: json['helpfulCount'] as int? ?? json['helpful_count'] as int? ?? 0,
      createdAt: json['createdAt'] != null 
          ? DateTime.tryParse(json['createdAt'] as String) 
          : null,
      updatedAt: json['updatedAt'] != null 
          ? DateTime.tryParse(json['updatedAt'] as String) 
          : null,
    );
  }
  
  final String id;
  final String userId;
  final String stationId;
  final double rating;
  final String? userName;
  final String? userAvatar;
  final String? comment;
  final List<String> images;
  final bool isVerified;
  final int helpfulCount;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  
  /// Convert to JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'stationId': stationId,
      'rating': rating,
      'userName': userName,
      'userAvatar': userAvatar,
      'comment': comment,
      'images': images,
      'isVerified': isVerified,
      'helpfulCount': helpfulCount,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
  
  /// Copy with new values.
  ReviewModel copyWith({
    String? id,
    String? userId,
    String? stationId,
    double? rating,
    String? userName,
    String? userAvatar,
    String? comment,
    List<String>? images,
    bool? isVerified,
    int? helpfulCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ReviewModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      stationId: stationId ?? this.stationId,
      rating: rating ?? this.rating,
      userName: userName ?? this.userName,
      userAvatar: userAvatar ?? this.userAvatar,
      comment: comment ?? this.comment,
      images: images ?? this.images,
      isVerified: isVerified ?? this.isVerified,
      helpfulCount: helpfulCount ?? this.helpfulCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
  
  @override
  List<Object?> get props => [
    id,
    userId,
    stationId,
    rating,
    userName,
    userAvatar,
    comment,
    images,
    isVerified,
    helpfulCount,
    createdAt,
    updatedAt,
  ];
}

