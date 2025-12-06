/// File: lib/features/value_packs/domain/entities/review.dart
/// Purpose: Review domain entity for value packs
/// Belongs To: value_packs feature
/// Customization Guide:
///    - Add new fields as needed
///    - Update copyWith and props accordingly
library;

import 'package:equatable/equatable.dart';

/// Review domain entity.
class Review extends Equatable {
  const Review({
    required this.id,
    required this.userId,
    required this.userName,
    required this.rating,
    required this.title,
    required this.message,
    this.images = const [],
    this.createdAt,
  });

  final String id;
  final String userId;
  final String userName;
  final double rating;
  final String title;
  final String message;
  final List<String> images;
  final DateTime? createdAt;

  /// Copy with new values.
  Review copyWith({
    String? id,
    String? userId,
    String? userName,
    double? rating,
    String? title,
    String? message,
    List<String>? images,
    DateTime? createdAt,
  }) {
    return Review(
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

