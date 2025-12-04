/// File: lib/features/community/models/community_review_model.dart
/// Purpose: Enhanced review data model for community features
/// Belongs To: community feature
/// Customization Guide:
///    - Add new fields as needed for review functionality
///    - Update copyWith and JSON methods accordingly
library;

import 'package:equatable/equatable.dart';

/// Review status for moderation.
enum ReviewStatus { draft, pending, published, hidden, moderation, rejected }

/// Enhanced review model for community features.
class CommunityReviewModel extends Equatable {
  const CommunityReviewModel({
    required this.id,
    required this.stationId,
    required this.rating,
    this.userId,
    this.title,
    this.body,
    this.photos = const [],
    this.isAnonymous = false,
    this.isVerifiedSession = false,
    this.helpfulCount = 0,
    this.flagsCount = 0,
    this.userName,
    this.userAvatar,
    this.status = ReviewStatus.published,
    this.createdAt,
    this.updatedAt,
    this.isHelpfulByMe = false,
    this.isFlaggedByMe = false,
  });

  /// Create from JSON map.
  factory CommunityReviewModel.fromJson(Map<String, dynamic> json) {
    return CommunityReviewModel(
      id: json['id'] as String? ?? '',
      stationId:
          json['stationId'] as String? ?? json['station_id'] as String? ?? '',
      userId: json['userId'] as String? ?? json['user_id'] as String?,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      title: json['title'] as String?,
      body: json['body'] as String?,
      photos:
          (json['photos'] as List<dynamic>?)
              ?.map(
                (e) => CommunityPhotoModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      isAnonymous:
          json['isAnonymous'] as bool? ??
          json['is_anonymous'] as bool? ??
          false,
      isVerifiedSession:
          json['isVerifiedSession'] as bool? ??
          json['is_verified_session'] as bool? ??
          false,
      helpfulCount:
          json['helpfulCount'] as int? ?? json['helpful_count'] as int? ?? 0,
      flagsCount:
          json['flagsCount'] as int? ?? json['flags_count'] as int? ?? 0,
      userName: json['userName'] as String? ?? json['user_name'] as String?,
      userAvatar:
          json['userAvatar'] as String? ?? json['user_avatar'] as String?,
      status: ReviewStatus.values.firstWhere(
        (s) => s.name == (json['status'] as String?),
        orElse: () => ReviewStatus.published,
      ),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'] as String)
          : null,
      isHelpfulByMe: json['isHelpfulByMe'] as bool? ?? false,
      isFlaggedByMe: json['isFlaggedByMe'] as bool? ?? false,
    );
  }

  final String id;
  final String stationId;
  final String? userId;
  final double rating;
  final String? title;
  final String? body;
  final List<CommunityPhotoModel> photos;
  final bool isAnonymous;
  final bool isVerifiedSession;
  final int helpfulCount;
  final int flagsCount;
  final String? userName;
  final String? userAvatar;
  final ReviewStatus status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool isHelpfulByMe;
  final bool isFlaggedByMe;

  /// Get display name (respects anonymity).
  String get displayName {
    if (isAnonymous) {
      return 'Anonymous';
    }
    return userName ?? 'User';
  }

  /// Get rating label.
  String get ratingLabel {
    if (rating >= 4.5) {
      return 'Excellent';
    }
    if (rating >= 3.5) {
      return 'Good';
    }
    if (rating >= 2.5) {
      return 'Average';
    }
    if (rating >= 1.5) {
      return 'Poor';
    }
    return 'Very Poor';
  }

  /// Check if review is editable (within time window).
  bool get isEditable {
    if (createdAt == null) {
      return false;
    }
    final diff = DateTime.now().difference(createdAt!);
    return diff.inMinutes <= 60; // Editable within 1 hour
  }

  /// Convert to JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'stationId': stationId,
      'userId': userId,
      'rating': rating,
      'title': title,
      'body': body,
      'photos': photos.map((e) => e.toJson()).toList(),
      'isAnonymous': isAnonymous,
      'isVerifiedSession': isVerifiedSession,
      'helpfulCount': helpfulCount,
      'flagsCount': flagsCount,
      'userName': userName,
      'userAvatar': userAvatar,
      'status': status.name,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isHelpfulByMe': isHelpfulByMe,
      'isFlaggedByMe': isFlaggedByMe,
    };
  }

  /// Copy with new values.
  CommunityReviewModel copyWith({
    String? id,
    String? stationId,
    String? userId,
    double? rating,
    String? title,
    String? body,
    List<CommunityPhotoModel>? photos,
    bool? isAnonymous,
    bool? isVerifiedSession,
    int? helpfulCount,
    int? flagsCount,
    String? userName,
    String? userAvatar,
    ReviewStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isHelpfulByMe,
    bool? isFlaggedByMe,
  }) {
    return CommunityReviewModel(
      id: id ?? this.id,
      stationId: stationId ?? this.stationId,
      userId: userId ?? this.userId,
      rating: rating ?? this.rating,
      title: title ?? this.title,
      body: body ?? this.body,
      photos: photos ?? this.photos,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      isVerifiedSession: isVerifiedSession ?? this.isVerifiedSession,
      helpfulCount: helpfulCount ?? this.helpfulCount,
      flagsCount: flagsCount ?? this.flagsCount,
      userName: userName ?? this.userName,
      userAvatar: userAvatar ?? this.userAvatar,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isHelpfulByMe: isHelpfulByMe ?? this.isHelpfulByMe,
      isFlaggedByMe: isFlaggedByMe ?? this.isFlaggedByMe,
    );
  }

  @override
  List<Object?> get props => [
    id,
    stationId,
    userId,
    rating,
    title,
    body,
    photos,
    isAnonymous,
    isVerifiedSession,
    helpfulCount,
    flagsCount,
    userName,
    userAvatar,
    status,
    createdAt,
    updatedAt,
    isHelpfulByMe,
    isFlaggedByMe,
  ];
}

/// Photo model for community uploads.
class CommunityPhotoModel extends Equatable {
  const CommunityPhotoModel({
    required this.id,
    required this.url,
    this.reviewId,
    this.stationId,
    this.userId,
    this.thumbnailUrl,
    this.width,
    this.height,
    this.status = PhotoStatus.published,
    this.createdAt,
    this.caption,
  });

  /// Create from JSON map.
  factory CommunityPhotoModel.fromJson(Map<String, dynamic> json) {
    return CommunityPhotoModel(
      id: json['id'] as String? ?? '',
      reviewId: json['reviewId'] as String? ?? json['review_id'] as String?,
      stationId: json['stationId'] as String? ?? json['station_id'] as String?,
      userId: json['userId'] as String? ?? json['user_id'] as String?,
      url: json['url'] as String? ?? '',
      thumbnailUrl:
          json['thumbnailUrl'] as String? ?? json['thumbnail_url'] as String?,
      width: json['width'] as int?,
      height: json['height'] as int?,
      status: PhotoStatus.values.firstWhere(
        (s) => s.name == (json['status'] as String?),
        orElse: () => PhotoStatus.published,
      ),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
      caption: json['caption'] as String?,
    );
  }

  final String id;
  final String? reviewId;
  final String? stationId;
  final String? userId;
  final String url;
  final String? thumbnailUrl;
  final int? width;
  final int? height;
  final PhotoStatus status;
  final DateTime? createdAt;
  final String? caption;

  /// Get effective URL (thumbnail or full).
  String get effectiveUrl => thumbnailUrl ?? url;

  /// Convert to JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reviewId': reviewId,
      'stationId': stationId,
      'userId': userId,
      'url': url,
      'thumbnailUrl': thumbnailUrl,
      'width': width,
      'height': height,
      'status': status.name,
      'createdAt': createdAt?.toIso8601String(),
      'caption': caption,
    };
  }

  /// Copy with new values.
  CommunityPhotoModel copyWith({
    String? id,
    String? reviewId,
    String? stationId,
    String? userId,
    String? url,
    String? thumbnailUrl,
    int? width,
    int? height,
    PhotoStatus? status,
    DateTime? createdAt,
    String? caption,
  }) {
    return CommunityPhotoModel(
      id: id ?? this.id,
      reviewId: reviewId ?? this.reviewId,
      stationId: stationId ?? this.stationId,
      userId: userId ?? this.userId,
      url: url ?? this.url,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      width: width ?? this.width,
      height: height ?? this.height,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      caption: caption ?? this.caption,
    );
  }

  @override
  List<Object?> get props => [
    id,
    reviewId,
    stationId,
    userId,
    url,
    thumbnailUrl,
    width,
    height,
    status,
    createdAt,
    caption,
  ];
}

/// Photo status for moderation.
enum PhotoStatus { pending, published, hidden, rejected }
