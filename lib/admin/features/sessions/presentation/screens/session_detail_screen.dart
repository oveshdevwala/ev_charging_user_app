/// File: lib/admin/features/sessions/presentation/screens/session_detail_screen.dart
/// Purpose: Session detail panel for modal sheet
/// Belongs To: admin/features/sessions
/// Customization Guide:
///    - Replace placeholders with full charts and map integration
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../admin.dart';

/// Detail screen to be shown inside AdminModalSheet.
class SessionDetailScreen extends StatelessWidget {
  const SessionDetailScreen({
    required this.sessionId,
    required this.useCases,
    super.key,
  });

  final String sessionId;
  final ({
    GetSessionsUseCase getSessions,
    GetSessionDetailUseCase getDetail,
    StreamLiveSessionsUseCase streamLive,
    ExportSessionsUseCase exportSessions,
    CreateIncidentUseCase createIncident,
  })
  useCases;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SessionDetailBloc(
        getDetail: useCases.getDetail,
        streamLive: useCases.streamLive,
        createIncident: useCases.createIncident,
      )..add(SessionDetailLoadRequested(sessionId)),
      child: _SessionDetailView(sessionId: sessionId),
    );
  }
}

class _SessionDetailView extends StatelessWidget {
  const _SessionDetailView({required this.sessionId});

  final String sessionId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionDetailBloc, SessionDetailState>(
      builder: (context, state) {
        if (state.isLoading || state.detail == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final detail = state.detail!;
        final summary = detail.summary;

        return SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        summary.id,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Builder(
                        builder: (context) {
                          AdminStatusType statusType;
                          switch (summary.status) {
                            case AdminSessionStatusDto.active:
                              statusType = AdminStatusType.active;
                              break;
                            case AdminSessionStatusDto.completed:
                              statusType = AdminStatusType.completed;
                              break;
                            case AdminSessionStatusDto.interrupted:
                              statusType = AdminStatusType.warning;
                              break;
                            case AdminSessionStatusDto.cancelled:
                              statusType = AdminStatusType.cancelled;
                              break;
                            case AdminSessionStatusDto.failed:
                              statusType = AdminStatusType.error;
                              break;
                          }
                          return AdminStatusBadge(
                            label: summary.status.name,
                            type: statusType,
                          );
                        },
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      AdminButton(
                        label: AdminStrings.sessionsStop,
                        icon: Iconsax.close_circle,
                        variant: AdminButtonVariant.outlined,
                        onPressed: () {},
                      ),
                      SizedBox(width: 8.w),
                      AdminButton(
                        label: AdminStrings.sessionsCreateIncident,
                        onPressed: () {
                          context.read<SessionDetailBloc>().add(
                            SessionIncidentRequested(
                              AdminIncidentDto(
                                id: 'inc_$sessionId',
                                sessionId: sessionId,
                                status: 'open',
                                severity: 'medium',
                                createdBy: 'admin',
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              AdminCardWithHeader(
                title: AdminStrings.sessionsTimeline,
                child: Row(
                  children: [
                    Expanded(child: SessionsTimeline(events: detail.timeline)),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: SessionsTelemetryChart(
                        telemetry: detail.telemetry,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12.h),
              AdminCardWithHeader(
                title: AdminStrings.sessionsEvents,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: detail.events.length,
                  itemBuilder: (context, index) {
                    final event = detail.events[index];
                    return ListTile(
                      leading: Icon(Iconsax.note_text, size: 18.r),
                      title: Text(event.message),
                      subtitle: Text(event.timestamp.toIso8601String()),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
