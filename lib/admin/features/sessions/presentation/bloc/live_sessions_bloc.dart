/// File: lib/admin/features/sessions/presentation/bloc/live_sessions_bloc.dart
/// Purpose: Live sessions stream BLoC for realtime monitor
/// Belongs To: admin/features/sessions
/// Customization Guide:
///    - Swap stream source for MQTT/Socket as needed
///    - Use throttling for UI friendly updates
library;

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/session_models.dart';
import '../../domain/sessions_usecases.dart';

part 'live_sessions_event.dart';
part 'live_sessions_state.dart';

class LiveSessionsBloc extends Bloc<LiveSessionsEvent, LiveSessionsState> {
  LiveSessionsBloc({required this.streamLive})
    : super(const LiveSessionsState()) {
    on<LiveSessionsConnectRequested>(_onConnect);
    on<LiveSessionsDisconnectRequested>(_onDisconnect);
    on<LiveSessionsPinRequested>(_onPin);
    on<LiveSessionsStreamEventReceived>(_onStreamEvent);
    on<LiveSessionsStreamErrorReceived>(_onStreamError);
  }

  final StreamLiveSessionsUseCase streamLive;
  StreamSubscription<AdminLiveSessionEventDto>? _subscription;

  Future<void> _onConnect(
    LiveSessionsConnectRequested event,
    Emitter<LiveSessionsState> emit,
  ) async {
    emit(state.copyWith(status: LiveSessionsStatus.connecting));
    await _subscription?.cancel();

    _subscription = streamLive().listen(
      (streamEvent) {
        // Dispatch a new event instead of emitting directly
        add(LiveSessionsStreamEventReceived(streamEvent));
      },
      onError: (Object error, StackTrace stack) {
        // Dispatch a new event instead of emitting directly
        add(LiveSessionsStreamErrorReceived(error.toString()));
      },
    );

    // Emit connected status after subscription is set up
    emit(state.copyWith(status: LiveSessionsStatus.connected));
  }

  void _onStreamEvent(
    LiveSessionsStreamEventReceived event,
    Emitter<LiveSessionsState> emit,
  ) {
    emit(
      state.copyWith(
        status: LiveSessionsStatus.connected,
        events: [...state.events, event.event],
        pinnedSessionId: state.pinnedSessionId,
      ),
    );
  }

  void _onStreamError(
    LiveSessionsStreamErrorReceived event,
    Emitter<LiveSessionsState> emit,
  ) {
    emit(state.copyWith(status: LiveSessionsStatus.error, error: event.error));
  }

  Future<void> _onDisconnect(
    LiveSessionsDisconnectRequested event,
    Emitter<LiveSessionsState> emit,
  ) async {
    await _subscription?.cancel();
    emit(state.copyWith(status: LiveSessionsStatus.disconnected));
  }

  void _onPin(LiveSessionsPinRequested event, Emitter<LiveSessionsState> emit) {
    emit(state.copyWith(pinnedSessionId: event.sessionId));
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    await super.close();
  }
}
