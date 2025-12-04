/// File: lib/features/community/models/report_model.dart
/// Purpose: Report and moderation models for community content
/// Belongs To: community feature
/// Customization Guide:
///    - Add new report categories as needed
///    - Update moderation actions accordingly
library;

import 'package:equatable/equatable.dart';

/// Target type for reports.
enum ReportTargetType {
  review,
  photo,
  question,
  answer,
  station,
  user,
}

/// Report category.
enum ReportCategory {
  socketBroken,
  slowCharging,
  paymentFailed,
  inaccurateInfo,
  spam,
  harassment,
  inappropriate,
  copyright,
  other,
}

/// Report status.
enum ReportStatus {
  open,
  triaged,
  inProgress,
  resolved,
  rejected,
  escalated,
}

/// Report priority.
enum ReportPriority {
  low,
  medium,
  high,
  critical,
}

/// Report model for issue reporting.
class ReportModel extends Equatable {
  const ReportModel({
    required this.id,
    required this.targetType,
    required this.targetId,
    required this.category, this.reporterId,
    this.description,
    this.photoUrl,
    this.isAnonymous = false,
    this.status = ReportStatus.open,
    this.priority = ReportPriority.medium,
    this.assignedTo,
    this.resolution,
    this.createdAt,
    this.updatedAt,
    this.resolvedAt,
    this.ticketId,
  });

  /// Create from JSON map.
  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      id: json['id'] as String? ?? '',
      targetType: ReportTargetType.values.firstWhere(
        (t) => t.name == (json['targetType'] as String? ?? json['target_type'] as String?),
        orElse: () => ReportTargetType.station,
      ),
      targetId: json['targetId'] as String? ?? json['target_id'] as String? ?? '',
      reporterId: json['reporterId'] as String? ?? json['reporter_id'] as String?,
      category: ReportCategory.values.firstWhere(
        (c) => c.name == (json['category'] as String?),
        orElse: () => ReportCategory.other,
      ),
      description: json['description'] as String?,
      photoUrl: json['photoUrl'] as String? ?? json['photo_url'] as String?,
      isAnonymous: json['isAnonymous'] as bool? ?? json['is_anonymous'] as bool? ?? false,
      status: ReportStatus.values.firstWhere(
        (s) => s.name == (json['status'] as String?),
        orElse: () => ReportStatus.open,
      ),
      priority: ReportPriority.values.firstWhere(
        (p) => p.name == (json['priority'] as String?),
        orElse: () => ReportPriority.medium,
      ),
      assignedTo: json['assignedTo'] as String? ?? json['assigned_to'] as String?,
      resolution: json['resolution'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'] as String)
          : null,
      resolvedAt: json['resolvedAt'] != null
          ? DateTime.tryParse(json['resolvedAt'] as String)
          : null,
      ticketId: json['ticketId'] as String? ?? json['ticket_id'] as String?,
    );
  }

  final String id;
  final ReportTargetType targetType;
  final String targetId;
  final String? reporterId;
  final ReportCategory category;
  final String? description;
  final String? photoUrl;
  final bool isAnonymous;
  final ReportStatus status;
  final ReportPriority priority;
  final String? assignedTo;
  final String? resolution;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? resolvedAt;
  final String? ticketId;

  /// Get display category name.
  String get categoryDisplayName {
    switch (category) {
      case ReportCategory.socketBroken:
        return 'Socket Broken';
      case ReportCategory.slowCharging:
        return 'Slow Charging';
      case ReportCategory.paymentFailed:
        return 'Payment Failed';
      case ReportCategory.inaccurateInfo:
        return 'Inaccurate Information';
      case ReportCategory.spam:
        return 'Spam';
      case ReportCategory.harassment:
        return 'Harassment';
      case ReportCategory.inappropriate:
        return 'Inappropriate Content';
      case ReportCategory.copyright:
        return 'Copyright Violation';
      case ReportCategory.other:
        return 'Other';
    }
  }

  /// Get status display name.
  String get statusDisplayName {
    switch (status) {
      case ReportStatus.open:
        return 'Open';
      case ReportStatus.triaged:
        return 'Triaged';
      case ReportStatus.inProgress:
        return 'In Progress';
      case ReportStatus.resolved:
        return 'Resolved';
      case ReportStatus.rejected:
        return 'Rejected';
      case ReportStatus.escalated:
        return 'Escalated';
    }
  }

  /// Check if report is resolved.
  bool get isResolved =>
      status == ReportStatus.resolved || status == ReportStatus.rejected;

  /// Convert to JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'targetType': targetType.name,
      'targetId': targetId,
      'reporterId': reporterId,
      'category': category.name,
      'description': description,
      'photoUrl': photoUrl,
      'isAnonymous': isAnonymous,
      'status': status.name,
      'priority': priority.name,
      'assignedTo': assignedTo,
      'resolution': resolution,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'resolvedAt': resolvedAt?.toIso8601String(),
      'ticketId': ticketId,
    };
  }

  /// Copy with new values.
  ReportModel copyWith({
    String? id,
    ReportTargetType? targetType,
    String? targetId,
    String? reporterId,
    ReportCategory? category,
    String? description,
    String? photoUrl,
    bool? isAnonymous,
    ReportStatus? status,
    ReportPriority? priority,
    String? assignedTo,
    String? resolution,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? resolvedAt,
    String? ticketId,
  }) {
    return ReportModel(
      id: id ?? this.id,
      targetType: targetType ?? this.targetType,
      targetId: targetId ?? this.targetId,
      reporterId: reporterId ?? this.reporterId,
      category: category ?? this.category,
      description: description ?? this.description,
      photoUrl: photoUrl ?? this.photoUrl,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      assignedTo: assignedTo ?? this.assignedTo,
      resolution: resolution ?? this.resolution,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      resolvedAt: resolvedAt ?? this.resolvedAt,
      ticketId: ticketId ?? this.ticketId,
    );
  }

  @override
  List<Object?> get props => [
        id,
        targetType,
        targetId,
        reporterId,
        category,
        description,
        photoUrl,
        isAnonymous,
        status,
        priority,
        assignedTo,
        resolution,
        createdAt,
        updatedAt,
        resolvedAt,
        ticketId,
      ];
}

/// Moderation action type.
enum ModerationActionType {
  approve,
  reject,
  remove,
  hide,
  restore,
  warn,
  suspend,
  ban,
  escalate,
}

/// Moderation action model.
class ModerationActionModel extends Equatable {
  const ModerationActionModel({
    required this.id,
    required this.moderatorId,
    required this.actionType,
    required this.targetType,
    required this.targetId,
    this.reason,
    this.notes,
    this.createdAt,
    this.expiresAt,
    this.isReverted = false,
  });

  /// Create from JSON map.
  factory ModerationActionModel.fromJson(Map<String, dynamic> json) {
    return ModerationActionModel(
      id: json['id'] as String? ?? '',
      moderatorId: json['moderatorId'] as String? ?? json['moderator_id'] as String? ?? '',
      actionType: ModerationActionType.values.firstWhere(
        (a) => a.name == (json['actionType'] as String? ?? json['action_type'] as String?),
        orElse: () => ModerationActionType.approve,
      ),
      targetType: ReportTargetType.values.firstWhere(
        (t) => t.name == (json['targetType'] as String? ?? json['target_type'] as String?),
        orElse: () => ReportTargetType.review,
      ),
      targetId: json['targetId'] as String? ?? json['target_id'] as String? ?? '',
      reason: json['reason'] as String?,
      notes: json['notes'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
      expiresAt: json['expiresAt'] != null
          ? DateTime.tryParse(json['expiresAt'] as String)
          : null,
      isReverted: json['isReverted'] as bool? ?? json['is_reverted'] as bool? ?? false,
    );
  }

  final String id;
  final String moderatorId;
  final ModerationActionType actionType;
  final ReportTargetType targetType;
  final String targetId;
  final String? reason;
  final String? notes;
  final DateTime? createdAt;
  final DateTime? expiresAt;
  final bool isReverted;

  /// Get action display name.
  String get actionDisplayName {
    switch (actionType) {
      case ModerationActionType.approve:
        return 'Approved';
      case ModerationActionType.reject:
        return 'Rejected';
      case ModerationActionType.remove:
        return 'Removed';
      case ModerationActionType.hide:
        return 'Hidden';
      case ModerationActionType.restore:
        return 'Restored';
      case ModerationActionType.warn:
        return 'Warning Issued';
      case ModerationActionType.suspend:
        return 'Suspended';
      case ModerationActionType.ban:
        return 'Banned';
      case ModerationActionType.escalate:
        return 'Escalated';
    }
  }

  /// Convert to JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'moderatorId': moderatorId,
      'actionType': actionType.name,
      'targetType': targetType.name,
      'targetId': targetId,
      'reason': reason,
      'notes': notes,
      'createdAt': createdAt?.toIso8601String(),
      'expiresAt': expiresAt?.toIso8601String(),
      'isReverted': isReverted,
    };
  }

  /// Copy with new values.
  ModerationActionModel copyWith({
    String? id,
    String? moderatorId,
    ModerationActionType? actionType,
    ReportTargetType? targetType,
    String? targetId,
    String? reason,
    String? notes,
    DateTime? createdAt,
    DateTime? expiresAt,
    bool? isReverted,
  }) {
    return ModerationActionModel(
      id: id ?? this.id,
      moderatorId: moderatorId ?? this.moderatorId,
      actionType: actionType ?? this.actionType,
      targetType: targetType ?? this.targetType,
      targetId: targetId ?? this.targetId,
      reason: reason ?? this.reason,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      isReverted: isReverted ?? this.isReverted,
    );
  }

  @override
  List<Object?> get props => [
        id,
        moderatorId,
        actionType,
        targetType,
        targetId,
        reason,
        notes,
        createdAt,
        expiresAt,
        isReverted,
      ];
}

