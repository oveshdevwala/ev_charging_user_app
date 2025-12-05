/// File: lib/features/profile/models/support_ticket_model.dart
/// Purpose: Support ticket model with JSON serialization
/// Belongs To: profile feature
/// Customization Guide:
///    - Add new status types as needed
///    - Run build_runner to generate JSON code
library;

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'support_ticket_model.g.dart';

/// Support ticket status.
enum TicketStatus {
  open,
  inProgress,
  resolved,
  closed,
}

/// Support ticket model.
@JsonSerializable()
class SupportTicketModel extends Equatable {
  const SupportTicketModel({
    required this.id,
    required this.subject,
    required this.message,
    this.attachments = const [],
    this.status = TicketStatus.open,
    required this.createdAt,
    this.updatedAt,
    this.ticketNumber,
  });

  factory SupportTicketModel.fromJson(Map<String, dynamic> json) =>
      _$SupportTicketModelFromJson(json);

  final String id;
  final String subject;
  final String message;
  final List<String> attachments;

  @JsonKey(fromJson: _statusFromJson, toJson: _statusToJson)
  final TicketStatus status;

  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime createdAt;

  @JsonKey(fromJson: _dateTimeFromJsonNullable, toJson: _dateTimeToJsonNullable)
  final DateTime? updatedAt;

  final String? ticketNumber;

  Map<String, dynamic> toJson() => _$SupportTicketModelToJson(this);

  /// Copy with new values.
  SupportTicketModel copyWith({
    String? id,
    String? subject,
    String? message,
    List<String>? attachments,
    TicketStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? ticketNumber,
  }) {
    return SupportTicketModel(
      id: id ?? this.id,
      subject: subject ?? this.subject,
      message: message ?? this.message,
      attachments: attachments ?? this.attachments,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      ticketNumber: ticketNumber ?? this.ticketNumber,
    );
  }

  static TicketStatus _statusFromJson(String value) {
    return TicketStatus.values.firstWhere(
      (e) => e.name == value,
      orElse: () => TicketStatus.open,
    );
  }

  static String _statusToJson(TicketStatus status) => status.name;

  static DateTime _dateTimeFromJson(dynamic value) {
    if (value is String) {
      return DateTime.parse(value);
    }
    return DateTime.now();
  }

  static String _dateTimeToJson(DateTime date) => date.toIso8601String();

  static DateTime? _dateTimeFromJsonNullable(dynamic value) {
    if (value == null) return null;
    if (value is String) {
      return DateTime.tryParse(value);
    }
    return null;
  }

  static String? _dateTimeToJsonNullable(DateTime? date) =>
      date?.toIso8601String();

  @override
  List<Object?> get props => [
        id,
        subject,
        message,
        attachments,
        status,
        createdAt,
        updatedAt,
        ticketNumber,
      ];
}

