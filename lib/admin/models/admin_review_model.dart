/// File: lib/admin/models/admin_review_model.dart
/// Purpose: Review model for admin panel
/// Belongs To: admin/models
library;

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'admin_review_model.g.dart';

/// Review status enum.
enum AdminReviewStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('approved')
  approved,
  @JsonValue('rejected')
  rejected,
  @JsonValue('flagged')
  flagged,
}

/// Review model for admin panel.
@JsonSerializable()
class AdminReview extends Equatable {
  const AdminReview({
    required this.id,
    required this.userId,
    required this.stationId,
    required this.rating,
    required this.status,
    required this.createdAt,
    this.userName,
    this.userAvatarUrl,
    this.stationName,
    this.comment,
    this.reply,
    this.replyAt,
    this.moderatedBy,
    this.moderatedAt,
    this.moderationNote,
  });

  factory AdminReview.fromJson(Map<String, dynamic> json) =>
      _$AdminReviewFromJson(json);

  final String id;
  final String userId;
  final String stationId;
  final double rating;
  final AdminReviewStatus status;
  final DateTime createdAt;
  final String? userName;
  final String? userAvatarUrl;
  final String? stationName;
  final String? comment;
  final String? reply;
  final DateTime? replyAt;
  final String? moderatedBy;
  final DateTime? moderatedAt;
  final String? moderationNote;

  Map<String, dynamic> toJson() => _$AdminReviewToJson(this);

  /// Check if review has a reply.
  bool get hasReply => reply != null && reply!.isNotEmpty;

  /// Check if review is pending moderation.
  bool get isPending => status == AdminReviewStatus.pending;

  AdminReview copyWith({
    String? id,
    String? userId,
    String? stationId,
    double? rating,
    AdminReviewStatus? status,
    DateTime? createdAt,
    String? userName,
    String? userAvatarUrl,
    String? stationName,
    String? comment,
    String? reply,
    DateTime? replyAt,
    String? moderatedBy,
    DateTime? moderatedAt,
    String? moderationNote,
  }) {
    return AdminReview(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      stationId: stationId ?? this.stationId,
      rating: rating ?? this.rating,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      userName: userName ?? this.userName,
      userAvatarUrl: userAvatarUrl ?? this.userAvatarUrl,
      stationName: stationName ?? this.stationName,
      comment: comment ?? this.comment,
      reply: reply ?? this.reply,
      replyAt: replyAt ?? this.replyAt,
      moderatedBy: moderatedBy ?? this.moderatedBy,
      moderatedAt: moderatedAt ?? this.moderatedAt,
      moderationNote: moderationNote ?? this.moderationNote,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        stationId,
        rating,
        status,
        createdAt,
        userName,
        userAvatarUrl,
        stationName,
        comment,
        reply,
        replyAt,
        moderatedBy,
        moderatedAt,
        moderationNote,
      ];
}

