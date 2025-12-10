/// File: lib/admin/features/sessions/presentation/screens/session_replay_screen.dart
/// Purpose: Session replay UI with playback controls
/// Belongs To: admin/features/sessions
/// Customization Guide:
///    - Replace with chart + map synchronization when telemetry available
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../admin.dart';
import '../../sessions.dart';

/// Replay screen for a session.
class SessionReplayScreen extends StatelessWidget {
  const SessionReplayScreen({required this.useCases, super.key, this.session});

  final ({
    GetSessionsUseCase getSessions,
    GetSessionDetailUseCase getDetail,
    StreamLiveSessionsUseCase streamLive,
    ExportSessionsUseCase exportSessions,
    CreateIncidentUseCase createIncident,
  })
  useCases;
  final AdminSessionDetailDto? session;

  @override
  Widget build(BuildContext context) {
    final telemetry = session?.telemetry ?? [];
    return BlocProvider(
      create: (_) =>
          SessionReplayBloc(engine: TelemetryPlaybackEngine())
            ..add(SessionReplayDataLoaded(telemetry)),
      child: const _ReplayView(),
    );
  }
}

class _ReplayView extends StatelessWidget {
  const _ReplayView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionReplayBloc, SessionReplayState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AdminStrings.sessionsReplay,
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 12.h),
            SessionsTelemetryChart(telemetry: state.telemetry),
            SizedBox(height: 12.h),
            Row(
              children: [
                AdminButton(
                  label: state.status == SessionReplayStatus.playing
                      ? AdminStrings.sessionsReplayPause
                      : AdminStrings.sessionsReplayPlay,
                  onPressed: () {
                    context.read<SessionReplayBloc>().add(
                      state.status == SessionReplayStatus.playing
                          ? const SessionReplayPauseRequested()
                          : const SessionReplayPlayRequested(),
                    );
                  },
                ),
                SizedBox(width: 8.w),
                AdminButton(
                  label: AdminStrings.sessionsReplaySpeed,
                  icon: Icons.slow_motion_video,
                  variant: AdminButtonVariant.outlined,
                  onPressed: () => context.read<SessionReplayBloc>().add(
                    const SessionReplaySpeedChanged(2),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
