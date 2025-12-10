/// File: lib/admin/features/sessions/presentation/screens/sessions_list_screen.dart
/// Purpose: Main sessions monitoring surface (dashboard + list + live feed)
/// Belongs To: admin/features/sessions
/// Customization Guide:
///    - Wire real analytics and charts
///    - Use go_router only for deep links; keep tab switching in shell
library;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../admin.dart';
import '../../sessions.dart';

/// Sessions list screen that bundles dashboard KPIs, table, and live feed.
class SessionsListScreen extends StatelessWidget {
  const SessionsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = SessionsModule.buildRepository(Dio());
    final useCases = SessionsModule.useCases(repository);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => SessionsListBloc(
            getSessions: useCases.getSessions,
            exportSessions: useCases.exportSessions,
          )..add(const SessionsLoadRequested()),
        ),
        BlocProvider(
          create: (_) =>
              LiveSessionsBloc(streamLive: useCases.streamLive)
                ..add(const LiveSessionsConnectRequested()),
        ),
      ],
      child: _SessionsListView(useCases: useCases),
    );
  }
}

class _SessionsListView extends StatelessWidget {
  const _SessionsListView({required this.useCases});

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
    return BlocBuilder<SessionsListBloc, SessionsListState>(
      builder: (context, state) {
        final active = state.sessions
            .where((s) => s.status == AdminSessionStatusDto.active)
            .length;
        final completed = state.sessions
            .where((s) => s.status == AdminSessionStatusDto.completed)
            .length;
        final energy = state.sessions.fold<double>(
          0,
          (sum, s) => sum + (s.energyKwh ?? 0),
        );
        final revenue = state.sessions.fold<double>(
          0,
          (sum, s) => sum + (s.cost ?? 0),
        );
        final duration = state.sessions.isEmpty
            ? 0.0
            : state.sessions
                      .map((s) => s.durationSec ?? 0)
                      .fold<int>(0, (a, b) => a + b) /
                  60.0 /
                  state.sessions.length;

        return AdminPageContent(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AdminPageHeader(
                title: AdminStrings.sessionsTitle,
                subtitle: AdminStrings.sessionsDashboard,
                actions: [
                  AdminButton(
                    label: AdminStrings.sessionsExportCsv,
                    variant: AdminButtonVariant.outlined,
                    icon: Iconsax.document_download,
                    onPressed: state.selectedIds.isEmpty
                        ? null
                        : () => context.read<SessionsListBloc>().add(
                            const SessionsExportRequested('csv'),
                          ),
                  ),
                  AdminButton(
                    label: AdminStrings.sessionsCreateIncident,
                    icon: Iconsax.security_user,
                    onPressed: () {},
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              SessionsKpiRow(
                active: active,
                completed: completed,
                energy: energy,
                revenue: revenue,
                duration: duration,
                faults: state.sessions
                    .where((s) => s.status == AdminSessionStatusDto.failed)
                    .length,
              ),
              SizedBox(height: 16.h),
              // Search and filters row - responsive layout
              AdminResponsiveFilterBar(
                searchHint: AdminStrings.sessionsSearchHint,
                onSearchChanged: (query) => context
                    .read<SessionsListBloc>()
                    .add(SessionsSearchChanged(query)),
                filterCount: state.filters.isNotEmpty
                    ? state.filters.length
                    : 0,
                filterItems: [
                  AdminFilterItem<AdminSessionStatusDto?>(
                    id: 'status',
                    label: AdminStrings.filterStatus,
                    value: state.filters['status'] != null
                        ? AdminSessionStatusDto.values.firstWhere(
                            (s) => s.name == state.filters['status'],
                            orElse: () => AdminSessionStatusDto.active,
                          )
                        : null,
                    width: 160.w,
                    items: [
                      const DropdownMenuItem<AdminSessionStatusDto?>(
                        child: Text('All Status'),
                      ),
                      ...AdminSessionStatusDto.values.map(
                        (status) => DropdownMenuItem<AdminSessionStatusDto?>(
                          value: status,
                          child: Text(status.name.toUpperCase()),
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      final filters = Map<String, dynamic>.from(state.filters);
                      if (value == null) {
                        filters.remove('status');
                      } else {
                        filters['status'] = value.name;
                      }
                      context.read<SessionsListBloc>().add(
                        SessionsFiltersChanged(filters),
                      );
                    },
                  ),
                ],
                actions: [
                  AdminButton(
                    label: AdminStrings.actionRefresh,
                    icon: Iconsax.refresh,
                    onPressed: () => context.read<SessionsListBloc>().add(
                      const SessionsRefreshRequested(),
                    ),
                  ),
                ],
                onReset: () {
                  context.read<SessionsListBloc>().add(
                    const SessionsFiltersChanged({}),
                  );
                },
              ),
              SizedBox(height: 16.h),
              // Sessions table - full width with fixed height
              SizedBox(
                height: 400.h,
                child: AdminCard(
                  padding: EdgeInsets.zero,
                  child: state.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : SessionsTable(
                          sessions: state.sessions,
                          selectedIds: state.selectedIds,
                          onToggleSelect: (id) => context
                              .read<SessionsListBloc>()
                              .add(SessionsSelectionToggled(id)),
                          onViewDetail: (AdminSessionSummaryDto session) =>
                              context.showAdminModal<void>(
                                title: AdminStrings.sessionsDetailTitle,
                                maxWidth: 1100,
                                child: SessionDetailScreen(
                                  sessionId: session.id,
                                  useCases: useCases,
                                ),
                              ),
                        ),
                ),
              ),
              SizedBox(height: 16.h),
              // Live Monitor and Session Replay - side by side with equal width
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: BlocBuilder<LiveSessionsBloc, LiveSessionsState>(
                      builder: (context, liveState) => SessionsLiveFeed(
                        events: liveState.events,
                        pinnedId: liveState.pinnedSessionId,
                        onPin: (id) => context.read<LiveSessionsBloc>().add(
                          LiveSessionsPinRequested(id),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: AdminCardWithHeader(
                      title: AdminStrings.sessionsReplay,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AdminStrings.sessionsReplaySpeed,
                            style: TextStyle(fontSize: 13.sp),
                          ),
                          SizedBox(height: 8.h),
                          Slider(value: 1, min: 0.5, max: 2, onChanged: (_) {}),
                          SizedBox(height: 8.h),
                          AdminButton(
                            label: AdminStrings.sessionsReplay,
                            onPressed: () => context.showAdminModal<void>(
                              title: AdminStrings.sessionsReplay,
                              maxWidth: 1000,
                              child: SessionReplayScreen(useCases: useCases),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
