// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_review_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminReview _$AdminReviewFromJson(Map<String, dynamic> json) => AdminReview(
  id: json['id'] as String,
  userId: json['userId'] as String,
  stationId: json['stationId'] as String,
  rating: (json['rating'] as num).toDouble(),
  status: $enumDecode(_$AdminReviewStatusEnumMap, json['status']),
  createdAt: DateTime.parse(json['createdAt'] as String),
  userName: json['userName'] as String?,
  userAvatarUrl: json['userAvatarUrl'] as String?,
  stationName: json['stationName'] as String?,
  comment: json['comment'] as String?,
  reply: json['reply'] as String?,
  replyAt: json['replyAt'] == null
      ? null
      : DateTime.parse(json['replyAt'] as String),
  moderatedBy: json['moderatedBy'] as String?,
  moderatedAt: json['moderatedAt'] == null
      ? null
      : DateTime.parse(json['moderatedAt'] as String),
  moderationNote: json['moderationNote'] as String?,
);

Map<String, dynamic> _$AdminReviewToJson(AdminReview instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'stationId': instance.stationId,
      'rating': instance.rating,
      'status': _$AdminReviewStatusEnumMap[instance.status]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'userName': instance.userName,
      'userAvatarUrl': instance.userAvatarUrl,
      'stationName': instance.stationName,
      'comment': instance.comment,
      'reply': instance.reply,
      'replyAt': instance.replyAt?.toIso8601String(),
      'moderatedBy': instance.moderatedBy,
      'moderatedAt': instance.moderatedAt?.toIso8601String(),
      'moderationNote': instance.moderationNote,
    };

const _$AdminReviewStatusEnumMap = {
  AdminReviewStatus.pending: 'pending',
  AdminReviewStatus.approved: 'approved',
  AdminReviewStatus.rejected: 'rejected',
  AdminReviewStatus.flagged: 'flagged',
};
