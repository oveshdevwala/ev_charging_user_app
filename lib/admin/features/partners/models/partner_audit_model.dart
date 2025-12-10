/// File: lib/admin/features/partners/models/partner_audit_model.dart
/// Purpose: Partner audit log domain model
/// Belongs To: admin/features/partners
/// Customization Guide:
///    - Add additional audit fields as needed
library;

import 'package:equatable/equatable.dart';

import 'partner_enums.dart';

/// Partner audit log model.
class PartnerAuditModel extends Equatable {
  const PartnerAuditModel({
    required this.id,
    required this.partnerId,
    required this.actionType,
    required this.adminUser,
    required this.timestamp,
    this.memo,
  });

  factory PartnerAuditModel.fromJson(Map<String, dynamic> json) {
    return PartnerAuditModel(
      id: json['id'] as String? ?? '',
      partnerId: json['partnerId'] as String? ?? '',
      actionType: auditActionTypeFromString(json['actionType'] as String?),
      adminUser: json['adminUser'] as String? ?? '',
      timestamp: DateTime.tryParse(json['timestamp'] as String? ?? '') ??
          DateTime.now(),
      memo: json['memo'] as String?,
    );
  }

  final String id;
  final String partnerId;
  final AuditActionType actionType;
  final String adminUser;
  final DateTime timestamp;
  final String? memo;

  /// Formatted action name.
  String get actionName {
    switch (actionType) {
      case AuditActionType.created:
        return 'Created';
      case AuditActionType.updated:
        return 'Updated';
      case AuditActionType.approved:
        return 'Approved';
      case AuditActionType.rejected:
        return 'Rejected';
      case AuditActionType.suspended:
        return 'Suspended';
      case AuditActionType.activated:
        return 'Activated';
      case AuditActionType.contractAdded:
        return 'Contract Added';
      case AuditActionType.contractUpdated:
        return 'Contract Updated';
      case AuditActionType.locationAdded:
        return 'Location Added';
      case AuditActionType.locationUpdated:
        return 'Location Updated';
      case AuditActionType.locationRemoved:
        return 'Location Removed';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'partnerId': partnerId,
      'actionType': actionType.name,
      'adminUser': adminUser,
      'timestamp': timestamp.toIso8601String(),
      'memo': memo,
    };
  }

  PartnerAuditModel copyWith({
    String? id,
    String? partnerId,
    AuditActionType? actionType,
    String? adminUser,
    DateTime? timestamp,
    String? memo,
  }) {
    return PartnerAuditModel(
      id: id ?? this.id,
      partnerId: partnerId ?? this.partnerId,
      actionType: actionType ?? this.actionType,
      adminUser: adminUser ?? this.adminUser,
      timestamp: timestamp ?? this.timestamp,
      memo: memo ?? this.memo,
    );
  }

  @override
  List<Object?> get props => [
        id,
        partnerId,
        actionType,
        adminUser,
        timestamp,
        memo,
      ];
}
