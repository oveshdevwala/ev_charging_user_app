/// File: lib/features/value_packs/data/models/review_model.dart
/// Purpose: Review data model with JSON serialization
/// Belongs To: value_packs feature
library;

import 'package:equatable/equatable.dart';

import '../../domain/entities/review.dart';

/// Review data model.
class ReviewModel extends Equatable {
  const ReviewModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.rating,
    required this.title,
    required this.message,
    this.images = const [],
    this.createdAt,
  });

  /// Create from JSON map.
  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] as String? ?? '',
      userId: json['userId'] as String? ?? json['user_id'] as String? ?? '',
      userName: json['userName'] as String? ?? json['user_name'] as String? ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      title: json['title'] as String? ?? '',
      message: json['message'] as String? ?? '',
      images: (json['images'] as List<dynamic>?)?.cast<String>() ?? [],
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : json['created_at'] != null
              ? DateTime.tryParse(json['created_at'] as String)
              : null,
    );
  }

  final String id;
  final String userId;
  final String userName;
  final double rating;
  final String title;
  final String message;
  final List<String> images;
  final DateTime? createdAt;

  /// Convert to domain entity.
  Review toEntity() {
    return Review(
      id: id,
      userId: userId,
      userName: userName,
      rating: rating,
      title: title,
      message: message,
      images: images,
      createdAt: createdAt,
    );
  }

  /// Convert to JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'rating': rating,
      'title': title,
      'message': message,
      'images': images,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  /// Copy with new values.
  ReviewModel copyWith({
    String? id,
    String? userId,
    String? userName,
    double? rating,
    String? title,
    String? message,
    List<String>? images,
    DateTime? createdAt,
  }) {
    return ReviewModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      rating: rating ?? this.rating,
      title: title ?? this.title,
      message: message ?? this.message,
      images: images ?? this.images,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        userName,
        rating,
        title,
        message,
        images,
        createdAt,
      ];
}

