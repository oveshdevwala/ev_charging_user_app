/// File: lib/features/community/models/question_model.dart
/// Purpose: Q&A models for community questions and answers
/// Belongs To: community feature
/// Customization Guide:
///    - Add new fields for Q&A functionality
///    - Update copyWith and JSON methods accordingly
library;

import 'package:equatable/equatable.dart';

/// Question status for moderation.
enum QuestionStatus {
  pending,
  published,
  hidden,
  closed,
  rejected,
}

/// Question model for station Q&A.
class QuestionModel extends Equatable {
  const QuestionModel({
    required this.id,
    required this.stationId,
    required this.text, this.userId,
    this.photoUrl,
    this.isAnonymous = false,
    this.answersCount = 0,
    this.upvotesCount = 0,
    this.hasAcceptedAnswer = false,
    this.userName,
    this.userAvatar,
    this.status = QuestionStatus.published,
    this.answers = const [],
    this.createdAt,
    this.updatedAt,
    this.isUpvotedByMe = false,
  });

  /// Create from JSON map.
  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id'] as String? ?? '',
      stationId: json['stationId'] as String? ?? json['station_id'] as String? ?? '',
      userId: json['userId'] as String? ?? json['user_id'] as String?,
      text: json['text'] as String? ?? '',
      photoUrl: json['photoUrl'] as String? ?? json['photo_url'] as String?,
      isAnonymous: json['isAnonymous'] as bool? ?? json['is_anonymous'] as bool? ?? false,
      answersCount: json['answersCount'] as int? ?? json['answers_count'] as int? ?? 0,
      upvotesCount: json['upvotesCount'] as int? ?? json['upvotes_count'] as int? ?? 0,
      hasAcceptedAnswer: json['hasAcceptedAnswer'] as bool? ??
          json['has_accepted_answer'] as bool? ??
          false,
      userName: json['userName'] as String? ?? json['user_name'] as String?,
      userAvatar: json['userAvatar'] as String? ?? json['user_avatar'] as String?,
      status: QuestionStatus.values.firstWhere(
        (s) => s.name == (json['status'] as String?),
        orElse: () => QuestionStatus.published,
      ),
      answers: (json['answers'] as List<dynamic>?)
              ?.map((e) => AnswerModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'] as String)
          : null,
      isUpvotedByMe: json['isUpvotedByMe'] as bool? ?? false,
    );
  }

  final String id;
  final String stationId;
  final String? userId;
  final String text;
  final String? photoUrl;
  final bool isAnonymous;
  final int answersCount;
  final int upvotesCount;
  final bool hasAcceptedAnswer;
  final String? userName;
  final String? userAvatar;
  final QuestionStatus status;
  final List<AnswerModel> answers;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool isUpvotedByMe;

  /// Get display name (respects anonymity).
  String get displayName {
    if (isAnonymous) {
      return 'Anonymous';
    }
    return userName ?? 'User';
  }

  /// Get the accepted answer if any.
  AnswerModel? get acceptedAnswer {
    try {
      return answers.firstWhere((a) => a.isAccepted);
    } catch (_) {
      return null;
    }
  }

  /// Convert to JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'stationId': stationId,
      'userId': userId,
      'text': text,
      'photoUrl': photoUrl,
      'isAnonymous': isAnonymous,
      'answersCount': answersCount,
      'upvotesCount': upvotesCount,
      'hasAcceptedAnswer': hasAcceptedAnswer,
      'userName': userName,
      'userAvatar': userAvatar,
      'status': status.name,
      'answers': answers.map((e) => e.toJson()).toList(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isUpvotedByMe': isUpvotedByMe,
    };
  }

  /// Copy with new values.
  QuestionModel copyWith({
    String? id,
    String? stationId,
    String? userId,
    String? text,
    String? photoUrl,
    bool? isAnonymous,
    int? answersCount,
    int? upvotesCount,
    bool? hasAcceptedAnswer,
    String? userName,
    String? userAvatar,
    QuestionStatus? status,
    List<AnswerModel>? answers,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isUpvotedByMe,
  }) {
    return QuestionModel(
      id: id ?? this.id,
      stationId: stationId ?? this.stationId,
      userId: userId ?? this.userId,
      text: text ?? this.text,
      photoUrl: photoUrl ?? this.photoUrl,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      answersCount: answersCount ?? this.answersCount,
      upvotesCount: upvotesCount ?? this.upvotesCount,
      hasAcceptedAnswer: hasAcceptedAnswer ?? this.hasAcceptedAnswer,
      userName: userName ?? this.userName,
      userAvatar: userAvatar ?? this.userAvatar,
      status: status ?? this.status,
      answers: answers ?? this.answers,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isUpvotedByMe: isUpvotedByMe ?? this.isUpvotedByMe,
    );
  }

  @override
  List<Object?> get props => [
        id,
        stationId,
        userId,
        text,
        photoUrl,
        isAnonymous,
        answersCount,
        upvotesCount,
        hasAcceptedAnswer,
        userName,
        userAvatar,
        status,
        answers,
        createdAt,
        updatedAt,
        isUpvotedByMe,
      ];
}

/// Answer status for moderation.
enum AnswerStatus {
  pending,
  published,
  hidden,
  rejected,
}

/// Answer model for Q&A.
class AnswerModel extends Equatable {
  const AnswerModel({
    required this.id,
    required this.questionId,
    required this.text, this.userId,
    this.photoUrl,
    this.isAnonymous = false,
    this.isAccepted = false,
    this.helpfulCount = 0,
    this.userName,
    this.userAvatar,
    this.status = AnswerStatus.published,
    this.createdAt,
    this.updatedAt,
    this.isHelpfulByMe = false,
  });

  /// Create from JSON map.
  factory AnswerModel.fromJson(Map<String, dynamic> json) {
    return AnswerModel(
      id: json['id'] as String? ?? '',
      questionId: json['questionId'] as String? ?? json['question_id'] as String? ?? '',
      userId: json['userId'] as String? ?? json['user_id'] as String?,
      text: json['text'] as String? ?? '',
      photoUrl: json['photoUrl'] as String? ?? json['photo_url'] as String?,
      isAnonymous: json['isAnonymous'] as bool? ?? json['is_anonymous'] as bool? ?? false,
      isAccepted: json['isAccepted'] as bool? ?? json['is_accepted'] as bool? ?? false,
      helpfulCount: json['helpfulCount'] as int? ?? json['helpful_count'] as int? ?? 0,
      userName: json['userName'] as String? ?? json['user_name'] as String?,
      userAvatar: json['userAvatar'] as String? ?? json['user_avatar'] as String?,
      status: AnswerStatus.values.firstWhere(
        (s) => s.name == (json['status'] as String?),
        orElse: () => AnswerStatus.published,
      ),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'] as String)
          : null,
      isHelpfulByMe: json['isHelpfulByMe'] as bool? ?? false,
    );
  }

  final String id;
  final String questionId;
  final String? userId;
  final String text;
  final String? photoUrl;
  final bool isAnonymous;
  final bool isAccepted;
  final int helpfulCount;
  final String? userName;
  final String? userAvatar;
  final AnswerStatus status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool isHelpfulByMe;

  /// Get display name (respects anonymity).
  String get displayName {
    if (isAnonymous) {
      return 'Anonymous';
    }
    return userName ?? 'User';
  }

  /// Check if answer is editable (within 15 minutes).
  bool get isEditable {
    if (createdAt == null) {
      return false;
    }
    final diff = DateTime.now().difference(createdAt!);
    return diff.inMinutes <= 15;
  }

  /// Convert to JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'questionId': questionId,
      'userId': userId,
      'text': text,
      'photoUrl': photoUrl,
      'isAnonymous': isAnonymous,
      'isAccepted': isAccepted,
      'helpfulCount': helpfulCount,
      'userName': userName,
      'userAvatar': userAvatar,
      'status': status.name,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isHelpfulByMe': isHelpfulByMe,
    };
  }

  /// Copy with new values.
  AnswerModel copyWith({
    String? id,
    String? questionId,
    String? userId,
    String? text,
    String? photoUrl,
    bool? isAnonymous,
    bool? isAccepted,
    int? helpfulCount,
    String? userName,
    String? userAvatar,
    AnswerStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isHelpfulByMe,
  }) {
    return AnswerModel(
      id: id ?? this.id,
      questionId: questionId ?? this.questionId,
      userId: userId ?? this.userId,
      text: text ?? this.text,
      photoUrl: photoUrl ?? this.photoUrl,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      isAccepted: isAccepted ?? this.isAccepted,
      helpfulCount: helpfulCount ?? this.helpfulCount,
      userName: userName ?? this.userName,
      userAvatar: userAvatar ?? this.userAvatar,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isHelpfulByMe: isHelpfulByMe ?? this.isHelpfulByMe,
    );
  }

  @override
  List<Object?> get props => [
        id,
        questionId,
        userId,
        text,
        photoUrl,
        isAnonymous,
        isAccepted,
        helpfulCount,
        userName,
        userAvatar,
        status,
        createdAt,
        updatedAt,
        isHelpfulByMe,
      ];
}

