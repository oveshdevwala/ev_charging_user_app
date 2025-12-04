/// File: lib/features/community/models/community_summary_model.dart
/// Purpose: Community summary and user profile models
/// Belongs To: community feature
/// Customization Guide:
///    - Adjust trust score weights as needed
///    - Add new reputation badges
library;

import 'package:equatable/equatable.dart';

/// Station community summary for aggregated data.
class StationCommunitySummary extends Equatable {
  const StationCommunitySummary({
    required this.stationId,
    this.avgRating = 0.0,
    this.ratingCount = 0,
    this.verifiedRatingCount = 0,
    this.trustScore = 0.0,
    this.photosCount = 0,
    this.questionsCount = 0,
    this.reportsCount = 0,
    this.lastReviewAt,
  });

  /// Create from JSON map.
  factory StationCommunitySummary.fromJson(Map<String, dynamic> json) {
    return StationCommunitySummary(
      stationId:
          json['stationId'] as String? ?? json['station_id'] as String? ?? '',
      avgRating:
          (json['avgRating'] as num?)?.toDouble() ??
          (json['avg_rating'] as num?)?.toDouble() ??
          0.0,
      ratingCount:
          json['ratingCount'] as int? ?? json['rating_count'] as int? ?? 0,
      verifiedRatingCount:
          json['verifiedRatingCount'] as int? ??
          json['verified_rating_count'] as int? ??
          0,
      trustScore:
          (json['trustScore'] as num?)?.toDouble() ??
          (json['trust_score'] as num?)?.toDouble() ??
          0.0,
      photosCount:
          json['photosCount'] as int? ?? json['photos_count'] as int? ?? 0,
      questionsCount:
          json['questionsCount'] as int? ??
          json['questions_count'] as int? ??
          0,
      reportsCount:
          json['reportsCount'] as int? ?? json['reports_count'] as int? ?? 0,
      lastReviewAt: json['lastReviewAt'] != null
          ? DateTime.tryParse(json['lastReviewAt'] as String)
          : null,
    );
  }

  final String stationId;
  final double avgRating;
  final int ratingCount;
  final int verifiedRatingCount;
  final double trustScore;
  final int photosCount;
  final int questionsCount;
  final int reportsCount;
  final DateTime? lastReviewAt;

  /// Get verified ratio (0-1).
  double get verifiedRatio {
    if (ratingCount == 0) {
      return 0;
    }
    return verifiedRatingCount / ratingCount;
  }

  /// Get trust level label.
  String get trustLevel {
    if (trustScore >= 0.8) {
      return 'Highly Trusted';
    }
    if (trustScore >= 0.6) {
      return 'Trusted';
    }
    if (trustScore >= 0.4) {
      return 'Moderate';
    }
    if (trustScore >= 0.2) {
      return 'Low Trust';
    }
    return 'Unverified';
  }

  /// Convert to JSON map.
  Map<String, dynamic> toJson() {
    return {
      'stationId': stationId,
      'avgRating': avgRating,
      'ratingCount': ratingCount,
      'verifiedRatingCount': verifiedRatingCount,
      'trustScore': trustScore,
      'photosCount': photosCount,
      'questionsCount': questionsCount,
      'reportsCount': reportsCount,
      'lastReviewAt': lastReviewAt?.toIso8601String(),
    };
  }

  /// Copy with new values.
  StationCommunitySummary copyWith({
    String? stationId,
    double? avgRating,
    int? ratingCount,
    int? verifiedRatingCount,
    double? trustScore,
    int? photosCount,
    int? questionsCount,
    int? reportsCount,
    DateTime? lastReviewAt,
  }) {
    return StationCommunitySummary(
      stationId: stationId ?? this.stationId,
      avgRating: avgRating ?? this.avgRating,
      ratingCount: ratingCount ?? this.ratingCount,
      verifiedRatingCount: verifiedRatingCount ?? this.verifiedRatingCount,
      trustScore: trustScore ?? this.trustScore,
      photosCount: photosCount ?? this.photosCount,
      questionsCount: questionsCount ?? this.questionsCount,
      reportsCount: reportsCount ?? this.reportsCount,
      lastReviewAt: lastReviewAt ?? this.lastReviewAt,
    );
  }

  @override
  List<Object?> get props => [
    stationId,
    avgRating,
    ratingCount,
    verifiedRatingCount,
    trustScore,
    photosCount,
    questionsCount,
    reportsCount,
    lastReviewAt,
  ];
}

/// User reputation badge.
enum ReputationBadge {
  newcomer,
  contributor,
  reviewer,
  expert,
  topContributor,
  verified,
  trusted,
  moderator,
}

/// User community profile.
class CommunityUserProfile extends Equatable {
  const CommunityUserProfile({
    required this.userId,
    this.displayName,
    this.avatarUrl,
    this.reputationScore = 0,
    this.verifiedChargesCount = 0,
    this.reviewsCount = 0,
    this.photosCount = 0,
    this.questionsCount = 0,
    this.answersCount = 0,
    this.helpfulVotesReceived = 0,
    this.badges = const [],
    this.isBanned = false,
    this.isAnonymousDefault = false,
    this.emailNotificationsEnabled = true,
    this.joinedAt,
  });

  /// Create from JSON map.
  factory CommunityUserProfile.fromJson(Map<String, dynamic> json) {
    return CommunityUserProfile(
      userId: json['userId'] as String? ?? json['user_id'] as String? ?? '',
      displayName:
          json['displayName'] as String? ?? json['display_name'] as String?,
      avatarUrl: json['avatarUrl'] as String? ?? json['avatar_url'] as String?,
      reputationScore:
          json['reputationScore'] as int? ??
          json['reputation_score'] as int? ??
          0,
      verifiedChargesCount:
          json['verifiedChargesCount'] as int? ??
          json['verified_charges_count'] as int? ??
          0,
      reviewsCount:
          json['reviewsCount'] as int? ?? json['reviews_count'] as int? ?? 0,
      photosCount:
          json['photosCount'] as int? ?? json['photos_count'] as int? ?? 0,
      questionsCount:
          json['questionsCount'] as int? ??
          json['questions_count'] as int? ??
          0,
      answersCount:
          json['answersCount'] as int? ?? json['answers_count'] as int? ?? 0,
      helpfulVotesReceived:
          json['helpfulVotesReceived'] as int? ??
          json['helpful_votes_received'] as int? ??
          0,
      badges:
          (json['badges'] as List<dynamic>?)
              ?.map(
                (e) => ReputationBadge.values.firstWhere(
                  (b) => b.name == e,
                  orElse: () => ReputationBadge.newcomer,
                ),
              )
              .toList() ??
          [],
      isBanned:
          json['isBanned'] as bool? ?? json['is_banned'] as bool? ?? false,
      isAnonymousDefault:
          json['isAnonymousDefault'] as bool? ??
          json['is_anonymous_default'] as bool? ??
          false,
      emailNotificationsEnabled:
          json['emailNotificationsEnabled'] as bool? ??
          json['email_notifications_enabled'] as bool? ??
          true,
      joinedAt: json['joinedAt'] != null
          ? DateTime.tryParse(json['joinedAt'] as String)
          : null,
    );
  }

  final String userId;
  final String? displayName;
  final String? avatarUrl;
  final int reputationScore;
  final int verifiedChargesCount;
  final int reviewsCount;
  final int photosCount;
  final int questionsCount;
  final int answersCount;
  final int helpfulVotesReceived;
  final List<ReputationBadge> badges;
  final bool isBanned;
  final bool isAnonymousDefault;
  final bool emailNotificationsEnabled;
  final DateTime? joinedAt;

  /// Get reputation level.
  String get reputationLevel {
    if (reputationScore >= 1000) {
      return 'Expert';
    }
    if (reputationScore >= 500) {
      return 'Advanced';
    }
    if (reputationScore >= 100) {
      return 'Intermediate';
    }
    if (reputationScore >= 10) {
      return 'Beginner';
    }
    return 'Newcomer';
  }

  /// Check if user is verified (has charged at least once).
  bool get isVerified => verifiedChargesCount > 0;

  /// Get primary badge.
  ReputationBadge? get primaryBadge {
    if (badges.isEmpty) {
      return null;
    }
    // Return highest priority badge
    if (badges.contains(ReputationBadge.moderator)) {
      return ReputationBadge.moderator;
    }
    if (badges.contains(ReputationBadge.topContributor)) {
      return ReputationBadge.topContributor;
    }
    if (badges.contains(ReputationBadge.expert)) {
      return ReputationBadge.expert;
    }
    if (badges.contains(ReputationBadge.trusted)) {
      return ReputationBadge.trusted;
    }
    if (badges.contains(ReputationBadge.verified)) {
      return ReputationBadge.verified;
    }
    return badges.first;
  }

  /// Convert to JSON map.
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'displayName': displayName,
      'avatarUrl': avatarUrl,
      'reputationScore': reputationScore,
      'verifiedChargesCount': verifiedChargesCount,
      'reviewsCount': reviewsCount,
      'photosCount': photosCount,
      'questionsCount': questionsCount,
      'answersCount': answersCount,
      'helpfulVotesReceived': helpfulVotesReceived,
      'badges': badges.map((e) => e.name).toList(),
      'isBanned': isBanned,
      'isAnonymousDefault': isAnonymousDefault,
      'emailNotificationsEnabled': emailNotificationsEnabled,
      'joinedAt': joinedAt?.toIso8601String(),
    };
  }

  /// Copy with new values.
  CommunityUserProfile copyWith({
    String? userId,
    String? displayName,
    String? avatarUrl,
    int? reputationScore,
    int? verifiedChargesCount,
    int? reviewsCount,
    int? photosCount,
    int? questionsCount,
    int? answersCount,
    int? helpfulVotesReceived,
    List<ReputationBadge>? badges,
    bool? isBanned,
    bool? isAnonymousDefault,
    bool? emailNotificationsEnabled,
    DateTime? joinedAt,
  }) {
    return CommunityUserProfile(
      userId: userId ?? this.userId,
      displayName: displayName ?? this.displayName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      reputationScore: reputationScore ?? this.reputationScore,
      verifiedChargesCount: verifiedChargesCount ?? this.verifiedChargesCount,
      reviewsCount: reviewsCount ?? this.reviewsCount,
      photosCount: photosCount ?? this.photosCount,
      questionsCount: questionsCount ?? this.questionsCount,
      answersCount: answersCount ?? this.answersCount,
      helpfulVotesReceived: helpfulVotesReceived ?? this.helpfulVotesReceived,
      badges: badges ?? this.badges,
      isBanned: isBanned ?? this.isBanned,
      isAnonymousDefault: isAnonymousDefault ?? this.isAnonymousDefault,
      emailNotificationsEnabled:
          emailNotificationsEnabled ?? this.emailNotificationsEnabled,
      joinedAt: joinedAt ?? this.joinedAt,
    );
  }

  @override
  List<Object?> get props => [
    userId,
    displayName,
    avatarUrl,
    reputationScore,
    verifiedChargesCount,
    reviewsCount,
    photosCount,
    questionsCount,
    answersCount,
    helpfulVotesReceived,
    badges,
    isBanned,
    isAnonymousDefault,
    emailNotificationsEnabled,
    joinedAt,
  ];
}
