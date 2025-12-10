part of 'session_replay_bloc.dart';

/// Playback status.
enum SessionReplayStatus { loading, ready, playing, paused, error }

/// State for session replay.
class SessionReplayState extends Equatable {
  const SessionReplayState({
    this.status = SessionReplayStatus.loading,
    this.playhead = Duration.zero,
    this.speed = 1.0,
    this.telemetry = const [],
    this.error,
  });

  final SessionReplayStatus status;
  final Duration playhead;
  final double speed;
  final List<AdminTelemetryPointDto> telemetry;
  final String? error;

  SessionReplayState copyWith({
    SessionReplayStatus? status,
    Duration? playhead,
    double? speed,
    List<AdminTelemetryPointDto>? telemetry,
    String? error,
  }) {
    return SessionReplayState(
      status: status ?? this.status,
      playhead: playhead ?? this.playhead,
      speed: speed ?? this.speed,
      telemetry: telemetry ?? this.telemetry,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, playhead, speed, telemetry, error];
}

