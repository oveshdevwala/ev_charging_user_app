/// File: lib/features/profile/bloc/support_state.dart
/// Purpose: Support BLoC state
/// Belongs To: profile feature
library;

import 'package:equatable/equatable.dart';

import '../models/models.dart';

/// Support state.
class SupportState extends Equatable {
  const SupportState({
    this.isLoadingFAQ = false,
    this.isSubmitting = false,
    this.isLoadingTickets = false,
    this.isLoadingPolicy = false,
    this.isLoadingTerms = false,
    this.faq = const [],
    this.tickets = const [],
    this.submittedTicket,
    this.privacyPolicy,
    this.termsOfService,
    this.error,
  });

  /// Initial state.
  factory SupportState.initial() => const SupportState();

  final bool isLoadingFAQ;
  final bool isSubmitting;
  final bool isLoadingTickets;
  final bool isLoadingPolicy;
  final bool isLoadingTerms;
  final List<Map<String, String>> faq;
  final List<SupportTicketModel> tickets;
  final SupportTicketModel? submittedTicket;
  final String? privacyPolicy;
  final String? termsOfService;
  final String? error;

  /// Copy with new values.
  SupportState copyWith({
    bool? isLoadingFAQ,
    bool? isSubmitting,
    bool? isLoadingTickets,
    bool? isLoadingPolicy,
    bool? isLoadingTerms,
    List<Map<String, String>>? faq,
    List<SupportTicketModel>? tickets,
    SupportTicketModel? submittedTicket,
    String? privacyPolicy,
    String? termsOfService,
    String? error,
  }) {
    return SupportState(
      isLoadingFAQ: isLoadingFAQ ?? this.isLoadingFAQ,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isLoadingTickets: isLoadingTickets ?? this.isLoadingTickets,
      isLoadingPolicy: isLoadingPolicy ?? this.isLoadingPolicy,
      isLoadingTerms: isLoadingTerms ?? this.isLoadingTerms,
      faq: faq ?? this.faq,
      tickets: tickets ?? this.tickets,
      submittedTicket: submittedTicket ?? this.submittedTicket,
      privacyPolicy: privacyPolicy ?? this.privacyPolicy,
      termsOfService: termsOfService ?? this.termsOfService,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
        isLoadingFAQ,
        isSubmitting,
        isLoadingTickets,
        isLoadingPolicy,
        isLoadingTerms,
        faq,
        tickets,
        submittedTicket,
        privacyPolicy,
        termsOfService,
        error,
      ];
}

