/// File: lib/admin/features/sessions/presentation/bloc/session_detail_bloc.dart
/// Purpose: BLoC for session detail, telemetry streaming, incidents
/// Belongs To: admin/features/sessions
/// Customization Guide:
///    - Wire real-time stream to telemetry chart
///    - Extend incident handling with RBAC checks
library;

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/session_models.dart';
import '../../domain/sessions_usecases.dart';

part 'session_detail_event.dart';
part 'session_detail_state.dart';

class SessionDetailBloc extends Bloc<SessionDetailEvent, SessionDetailState> {
  SessionDetailBloc({
    required this.getDetail,
    required this.streamLive,
    required this.createIncident,
  }) : super(const SessionDetailState()) {
    on<SessionDetailLoadRequested>(_onLoad);
    on<SessionTelemetryStreamStarted>(_onStreamStart);
    on<SessionTelemetryStreamStopped>(_onStreamStop);
    on<SessionIncidentRequested>(_onIncident);
  }

  final GetSessionDetailUseCase getDetail;
  final StreamLiveSessionsUseCase streamLive;
  final CreateIncidentUseCase createIncident;
  StreamSubscription<AdminLiveSessionEventDto>? _subscription;

  Future<void> _onLoad(
    SessionDetailLoadRequested event,
    Emitter<SessionDetailState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final detail = await getDetail(event.sessionId);
      emit(state.copyWith(isLoading: false, detail: detail));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onStreamStart(
    SessionTelemetryStreamStarted event,
    Emitter<SessionDetailState> emit,
  ) async {
    await _subscription?.cancel();
    _subscription = streamLive().listen((event) {
      final currentTelemetry = List<AdminTelemetryPointDto>.from(
        state.detail?.telemetry ?? [],
      );
      if (event.payload != null && event.payload!['powerKw'] != null) {
        currentTelemetry.add(
          AdminTelemetryPointDto(
            timestamp: event.timestamp,
            powerKw: (event.payload!['powerKw'] as num?)?.toDouble(),
            voltage: (event.payload!['voltage'] as num?)?.toDouble(),
            currentA: (event.payload!['currentA'] as num?)?.toDouble(),
            socPercent: (event.payload!['socPercent'] as num?)?.toDouble(),
            meterReading: (event.payload!['meterReading'] as num?)?.toDouble(),
          ),
        );
      }
      emit(
        state.copyWith(
          liveEvents: [...state.liveEvents, event],
          detail: state.detail?.copyWith(telemetry: currentTelemetry),
          streaming: true,
        ),
      );
    });
    emit(state.copyWith(streaming: true));
  }

  Future<void> _onStreamStop(
    SessionTelemetryStreamStopped event,
    Emitter<SessionDetailState> emit,
  ) async {
    await _subscription?.cancel();
    emit(state.copyWith(streaming: false));
  }

  Future<void> _onIncident(
    SessionIncidentRequested event,
    Emitter<SessionDetailState> emit,
  ) async {
    emit(state.copyWith(isSubmittingIncident: true));
    try {
      final incident = await createIncident(event.payload);
      emit(
        state.copyWith(
          isSubmittingIncident: false,
          lastIncident: incident,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isSubmittingIncident: false, error: e.toString()));
    }
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    await super.close();
  }
}

