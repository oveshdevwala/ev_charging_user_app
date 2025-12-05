/// File: lib/features/profile/bloc/support_bloc.dart
/// Purpose: Support and help BLoC
/// Belongs To: profile feature
library;

import 'package:flutter_bloc/flutter_bloc.dart';

import '../repositories/repositories.dart';
import 'support_event.dart';
import 'support_state.dart';

/// Support BLoC for managing help and support features.
class SupportBloc extends Bloc<SupportEvent, SupportState> {
  SupportBloc({required ProfileRepository repository})
      : _repository = repository,
        super(SupportState.initial()) {
    on<LoadFAQ>(_onLoadFAQ);
    on<SubmitTicket>(_onSubmitTicket);
    on<LoadTickets>(_onLoadTickets);
    on<LoadPrivacyPolicy>(_onLoadPrivacyPolicy);
    on<LoadTermsOfService>(_onLoadTermsOfService);
    on<ClearSupportError>(_onClearSupportError);
  }

  final ProfileRepository _repository;

  Future<void> _onLoadFAQ(
    LoadFAQ event,
    Emitter<SupportState> emit,
  ) async {
    emit(state.copyWith(isLoadingFAQ: true, error: null));
    try {
      final faq = await _repository.getFAQ();
      emit(state.copyWith(
        isLoadingFAQ: false,
        faq: faq,
        error: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoadingFAQ: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onSubmitTicket(
    SubmitTicket event,
    Emitter<SupportState> emit,
  ) async {
    emit(state.copyWith(isSubmitting: true, error: null));
    try {
      final ticket = await _repository.submitSupportTicket(
        subject: event.subject,
        message: event.message,
        attachments: event.attachments,
      );
      emit(state.copyWith(
        isSubmitting: false,
        submittedTicket: ticket,
        error: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        isSubmitting: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onLoadTickets(
    LoadTickets event,
    Emitter<SupportState> emit,
  ) async {
    emit(state.copyWith(isLoadingTickets: true, error: null));
    try {
      final tickets = await _repository.getSupportTickets();
      emit(state.copyWith(
        isLoadingTickets: false,
        tickets: tickets,
        error: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoadingTickets: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onLoadPrivacyPolicy(
    LoadPrivacyPolicy event,
    Emitter<SupportState> emit,
  ) async {
    emit(state.copyWith(isLoadingPolicy: true, error: null));
    try {
      final policy = await _repository.getPrivacyPolicy();
      emit(state.copyWith(
        isLoadingPolicy: false,
        privacyPolicy: policy,
        error: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoadingPolicy: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onLoadTermsOfService(
    LoadTermsOfService event,
    Emitter<SupportState> emit,
  ) async {
    emit(state.copyWith(isLoadingTerms: true, error: null));
    try {
      final terms = await _repository.getTermsOfService();
      emit(state.copyWith(
        isLoadingTerms: false,
        termsOfService: terms,
        error: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoadingTerms: false,
        error: e.toString(),
      ));
    }
  }

  void _onClearSupportError(
    ClearSupportError event,
    Emitter<SupportState> emit,
  ) {
    emit(state.copyWith(error: null));
  }
}

