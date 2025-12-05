// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'support_ticket_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SupportTicketModel _$SupportTicketModelFromJson(Map<String, dynamic> json) =>
    SupportTicketModel(
      id: json['id'] as String,
      subject: json['subject'] as String,
      message: json['message'] as String,
      attachments:
          (json['attachments'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      status: json['status'] == null
          ? TicketStatus.open
          : SupportTicketModel._statusFromJson(json['status'] as String),
      createdAt: SupportTicketModel._dateTimeFromJson(json['createdAt']),
      updatedAt: SupportTicketModel._dateTimeFromJsonNullable(
        json['updatedAt'],
      ),
      ticketNumber: json['ticketNumber'] as String?,
    );

Map<String, dynamic> _$SupportTicketModelToJson(
  SupportTicketModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'subject': instance.subject,
  'message': instance.message,
  'attachments': instance.attachments,
  'status': SupportTicketModel._statusToJson(instance.status),
  'createdAt': SupportTicketModel._dateTimeToJson(instance.createdAt),
  'updatedAt': SupportTicketModel._dateTimeToJsonNullable(instance.updatedAt),
  'ticketNumber': instance.ticketNumber,
};
