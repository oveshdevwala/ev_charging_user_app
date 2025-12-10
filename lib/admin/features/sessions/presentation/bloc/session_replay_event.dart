part of 'session_replay_bloc.dart';

/// Base event.
abstract class SessionReplayEvent extends Equatable {
  const SessionReplayEvent();

  @override
  List<Object?> get props => [];
}

/// Load telemetry data.
class SessionReplayDataLoaded extends SessionReplayEvent {
  const SessionReplayDataLoaded(this.telemetry);

  final List<AdminTelemetryPointDto> telemetry;

  @override
  List<Object?> get props => [telemetry];
}

/// Play request.
class SessionReplayPlayRequested extends SessionReplayEvent {
  const SessionReplayPlayRequested();
}

/// Pause request.
class SessionReplayPauseRequested extends SessionReplayEvent {
  const SessionReplayPauseRequested();
}

/// Seek request.
class SessionReplaySeekRequested extends SessionReplayEvent {
  const SessionReplaySeekRequested(this.position);

  final Duration position;

  @override
  List<Object?> get props => [position];
}

/// Change playback speed.
class SessionReplaySpeedChanged extends SessionReplayEvent {
  const SessionReplaySpeedChanged(this.speed);

  final double speed;

  @override
  List<Object?> get props => [speed];
}

