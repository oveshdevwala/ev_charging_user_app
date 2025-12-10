/// File: lib/admin/features/sessions/presentation/bloc/session_replay_bloc.dart
/// Purpose: BLoC for session replay controls
/// Belongs To: admin/features/sessions
/// Customization Guide:
///    - Integrate with real playback engine when available
library;

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/session_models.dart';
import '../../util/sessions_util.dart';

part 'session_replay_event.dart';
part 'session_replay_state.dart';

class SessionReplayBloc extends Bloc<SessionReplayEvent, SessionReplayState> {
  SessionReplayBloc({required this.engine})
      : super(const SessionReplayState()) {
    on<SessionReplayDataLoaded>(_onDataLoaded);
    on<SessionReplayPlayRequested>(_onPlay);
    on<SessionReplayPauseRequested>(_onPause);
    on<SessionReplaySeekRequested>(_onSeek);
    on<SessionReplaySpeedChanged>(_onSpeedChanged);
  }

  final TelemetryPlaybackEngine engine;

  void _onDataLoaded(
    SessionReplayDataLoaded event,
    Emitter<SessionReplayState> emit,
  ) {
    emit(
      state.copyWith(
        telemetry: event.telemetry,
        status: SessionReplayStatus.ready,
        playhead: Duration.zero,
      ),
    );
  }

  void _onPlay(
    SessionReplayPlayRequested event,
    Emitter<SessionReplayState> emit,
  ) {
    emit(state.copyWith(status: SessionReplayStatus.playing));
  }

  void _onPause(
    SessionReplayPauseRequested event,
    Emitter<SessionReplayState> emit,
  ) {
    emit(state.copyWith(status: SessionReplayStatus.paused));
  }

  void _onSeek(
    SessionReplaySeekRequested event,
    Emitter<SessionReplayState> emit,
  ) {
    engine.seek(event.position);
    emit(state.copyWith(playhead: event.position));
  }

  void _onSpeedChanged(
    SessionReplaySpeedChanged event,
    Emitter<SessionReplayState> emit,
  ) {
    engine.speed = event.speed;
    emit(state.copyWith(speed: event.speed));
  }
}

