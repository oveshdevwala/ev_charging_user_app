/// File: lib/features/activity/ui/all_sessions_page.dart
/// Purpose: View all charging sessions with filter and sort
/// Belongs To: activity feature
/// Route: /allSessions
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/theme/app_colors.dart';
import '../../../models/charging_session_model.dart';
import '../../../repositories/activity_repository.dart';
import '../../../routes/app_routes.dart';
import '../widgets/session_card.dart';

/// Sort options for sessions.
enum SessionSortOption {
  dateDesc('Newest First'),
  dateAsc('Oldest First'),
  costDesc('Highest Cost'),
  costAsc('Lowest Cost'),
  energyDesc('Most Energy'),
  energyAsc('Least Energy');

  const SessionSortOption(this.label);
  final String label;
}

/// Filter options for session status.
enum SessionFilterStatus {
  all('All'),
  completed('Completed'),
  inProgress('In Progress'),
  cancelled('Cancelled'),
  failed('Failed');

  const SessionFilterStatus(this.label);
  final String label;
}

/// All sessions page with filter and sort.
class AllSessionsPage extends StatefulWidget {
  const AllSessionsPage({super.key});

  @override
  State<AllSessionsPage> createState() => _AllSessionsPageState();
}

class _AllSessionsPageState extends State<AllSessionsPage> {
  SessionSortOption _sortOption = SessionSortOption.dateDesc;
  SessionFilterStatus _filterStatus = SessionFilterStatus.all;
  late List<ChargingSessionModel> _allSessions;
  List<ChargingSessionModel> _filteredSessions = [];

  @override
  void initState() {
    super.initState();
    _allSessions = DummyActivityRepository().getSessions();
    _applyFiltersAndSort();
  }

  void _applyFiltersAndSort() {
    var sessions = List<ChargingSessionModel>.from(_allSessions);

    // Apply filter
    if (_filterStatus != SessionFilterStatus.all) {
      sessions = sessions.where((s) {
        switch (_filterStatus) {
          case SessionFilterStatus.completed:
            return s.status == SessionStatus.completed;
          case SessionFilterStatus.inProgress:
            return s.status == SessionStatus.inProgress;
          case SessionFilterStatus.cancelled:
            return s.status == SessionStatus.cancelled;
          case SessionFilterStatus.failed:
            return s.status == SessionStatus.failed;
          default:
            return true;
        }
      }).toList();
    }

    // Apply sort
    switch (_sortOption) {
      case SessionSortOption.dateDesc:
        sessions.sort((a, b) => b.startTime.compareTo(a.startTime));
      case SessionSortOption.dateAsc:
        sessions.sort((a, b) => a.startTime.compareTo(b.startTime));
      case SessionSortOption.costDesc:
        sessions.sort((a, b) => b.cost.compareTo(a.cost));
      case SessionSortOption.costAsc:
        sessions.sort((a, b) => a.cost.compareTo(b.cost));
      case SessionSortOption.energyDesc:
        sessions.sort((a, b) => b.energyKwh.compareTo(a.energyKwh));
      case SessionSortOption.energyAsc:
        sessions.sort((a, b) => a.energyKwh.compareTo(b.energyKwh));
    }

    setState(() {
      _filteredSessions = sessions;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundLight,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(Iconsax.arrow_left, size: 20.r, color: AppColors.textPrimaryLight),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'All Sessions',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimaryLight,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          // Filter & Sort Bar
          _buildFilterSortBar(),

          // Sessions List
          Expanded(
            child: _filteredSessions.isEmpty
                ? _buildEmptyState()
                : ListView.separated(
                    padding: EdgeInsets.all(20.r),
                    itemCount: _filteredSessions.length,
                    separatorBuilder: (_, __) => SizedBox(height: 12.h),
                    itemBuilder: (context, index) {
                      final session = _filteredSessions[index];
                      return SessionCard(
                        session: session,
                        onTap: () => context.push(
                          AppRoutes.sessionDetail.id(session.id),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSortBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        border: Border(
          bottom: BorderSide(color: AppColors.outlineLight),
        ),
      ),
      child: Row(
        children: [
          // Filter Button
          Expanded(
            child: _buildFilterChip(
              icon: Iconsax.filter,
              label: _filterStatus.label,
              onTap: _showFilterSheet,
            ),
          ),
          SizedBox(width: 12.w),
          // Sort Button
          Expanded(
            child: _buildFilterChip(
              icon: Iconsax.sort,
              label: _sortOption.label,
              onTap: _showSortSheet,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: AppColors.surfaceVariantLight,
      borderRadius: BorderRadius.circular(10.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18.r, color: AppColors.textSecondaryLight),
              SizedBox(width: 8.w),
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimaryLight,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 4.w),
              Icon(Iconsax.arrow_down_1, size: 14.r, color: AppColors.textTertiaryLight),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Iconsax.flash_slash, size: 64.r, color: AppColors.textTertiaryLight),
          SizedBox(height: 16.h),
          Text(
            'No sessions found',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondaryLight,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Try adjusting your filters',
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textTertiaryLight,
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterSheet() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              margin: EdgeInsets.only(top: 12.h),
              decoration: BoxDecoration(
                color: AppColors.outlineLight,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Filter by Status',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimaryLight,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  ...SessionFilterStatus.values.map(
                    (status) => _buildOptionTile(
                      label: status.label,
                      isSelected: _filterStatus == status,
                      onTap: () {
                        setState(() => _filterStatus = status);
                        _applyFiltersAndSort();
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  void _showSortSheet() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              margin: EdgeInsets.only(top: 12.h),
              decoration: BoxDecoration(
                color: AppColors.outlineLight,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sort by',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimaryLight,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  ...SessionSortOption.values.map(
                    (option) => _buildOptionTile(
                      label: option.label,
                      isSelected: _sortOption == option,
                      onTap: () {
                        setState(() => _sortOption = option);
                        _applyFiltersAndSort();
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTile({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 14.h),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? AppColors.primary : AppColors.textPrimaryLight,
                  ),
                ),
              ),
              if (isSelected)
                Icon(Iconsax.tick_circle5, size: 22.r, color: AppColors.primary),
            ],
          ),
        ),
      ),
    );
  }
}

