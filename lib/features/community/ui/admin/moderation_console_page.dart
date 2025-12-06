/// File: lib/features/community/ui/admin/moderation_console_page.dart
/// Purpose: Admin moderation console for managing community content
/// Belongs To: community feature (admin)
/// Route: /admin/moderation
/// Customization Guide:
///    - Add new moderation actions as needed
///    - Customize filtering and bulk actions
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/theme/app_colors.dart';
import '../../models/models.dart';

/// Moderation console page for admins.
class ModerationConsolePage extends StatefulWidget {
  const ModerationConsolePage({super.key});

  @override
  State<ModerationConsolePage> createState() => _ModerationConsolePageState();
}

class _ModerationConsolePageState extends State<ModerationConsolePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  ModerationFilter _filter = ModerationFilter.all;
  final List<ReportModel> _reports = _generateDummyReports();
  final Set<String> _selectedIds = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Moderation Console'),
        centerTitle: true,
        actions: [
          if (_selectedIds.isNotEmpty)
            TextButton(
              onPressed: _showBulkActionsSheet,
              child: Text(
                'Actions (${_selectedIds.length})',
                style: const TextStyle(color: AppColors.primary),
              ),
            ),
          IconButton(
            icon: const Icon(Iconsax.export),
            onPressed: () {
              // Export functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Export feature coming soon')),
              );
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: colors.textSecondary,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: 'Reports'),
            Tab(text: 'Reviews'),
            Tab(text: 'Photos'),
            Tab(text: 'Users'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Filter bar
          _buildFilterBar(),

          // Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildReportsTab(),
                _buildReviewsTab(),
                _buildPhotosTab(),
                _buildUsersTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    final colors = context.appColors;
    return Container(
      padding: EdgeInsets.all(12.r),
      color: colors.surfaceVariant,
      child: Row(
        children: [
          Text(
            'Filter:',
            style: TextStyle(fontSize: 13.sp, color: colors.textSecondary),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ModerationFilter.values.map((filter) {
                  final isSelected = _filter == filter;
                  return Padding(
                    padding: EdgeInsets.only(right: 8.w),
                    child: FilterChip(
                      selected: isSelected,
                      label: Text(_getFilterLabel(filter)),
                      onSelected: (selected) {
                        setState(() => _filter = filter);
                      },
                      selectedColor: AppColors.primary.withValues(alpha: 0.2),
                      checkmarkColor: AppColors.primary,
                      labelStyle: TextStyle(
                        fontSize: 12.sp,
                        color: isSelected
                            ? AppColors.primary
                            : colors.textSecondary,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getFilterLabel(ModerationFilter filter) {
    switch (filter) {
      case ModerationFilter.all:
        return 'All';
      case ModerationFilter.pending:
        return 'Pending';
      case ModerationFilter.highPriority:
        return 'High Priority';
      case ModerationFilter.resolved:
        return 'Resolved';
    }
  }

  Widget _buildReportsTab() {
    final filteredReports = _getFilteredReports();

    if (filteredReports.isEmpty) {
      return _buildEmptyState('No reports', 'All caught up!');
    }

    return ListView.separated(
      padding: EdgeInsets.all(16.r),
      itemCount: filteredReports.length,
      separatorBuilder: (_, _) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        final report = filteredReports[index];
        return _ReportCard(
          report: report,
          isSelected: _selectedIds.contains(report.id),
          onSelect: (selected) {
            setState(() {
              if (selected) {
                _selectedIds.add(report.id);
              } else {
                _selectedIds.remove(report.id);
              }
            });
          },
          onAction: (action) => _handleReportAction(report, action),
        );
      },
    );
  }

  List<ReportModel> _getFilteredReports() {
    switch (_filter) {
      case ModerationFilter.all:
        return _reports;
      case ModerationFilter.pending:
        return _reports.where((r) => r.status == ReportStatus.open).toList();
      case ModerationFilter.highPriority:
        return _reports
            .where(
              (r) =>
                  r.priority == ReportPriority.high ||
                  r.priority == ReportPriority.critical,
            )
            .toList();
      case ModerationFilter.resolved:
        return _reports.where((r) => r.isResolved).toList();
    }
  }

  Widget _buildReviewsTab() {
    return _buildEmptyState(
      'Review Moderation',
      'Flagged reviews will appear here',
    );
  }

  Widget _buildPhotosTab() {
    return _buildEmptyState(
      'Photo Moderation',
      'Flagged photos will appear here',
    );
  }

  Widget _buildUsersTab() {
    return _buildEmptyState('User Management', 'Manage user bans and warnings');
  }

  Widget _buildEmptyState(String title, String subtitle) {
    final colors = context.appColors;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Iconsax.tick_circle, size: 64.r, color: AppColors.success),
          SizedBox(height: 16.h),
          Text(
            title,
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 8.h),
          Text(
            subtitle,
            style: TextStyle(fontSize: 14.sp, color: colors.textSecondary),
          ),
        ],
      ),
    );
  }

  void _handleReportAction(ReportModel report, ReportAction action) {
    // Handle individual report action
    setState(() {
      final index = _reports.indexWhere((r) => r.id == report.id);
      if (index != -1) {
        switch (action) {
          case ReportAction.approve:
            _reports[index] = report.copyWith(status: ReportStatus.resolved);
            break;
          case ReportAction.remove:
            _reports[index] = report.copyWith(status: ReportStatus.resolved);
            break;
          case ReportAction.reject:
            _reports[index] = report.copyWith(status: ReportStatus.rejected);
            break;
          case ReportAction.escalate:
            _reports[index] = report.copyWith(status: ReportStatus.escalated);
            break;
        }
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Report ${action.name}d successfully'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            // Undo action
          },
        ),
      ),
    );
  }

  void _showBulkActionsSheet() {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        final colors = context.appColors;
        return Container(
          padding: EdgeInsets.all(20.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bulk Actions (${_selectedIds.length} selected)',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                ),
              ),
              SizedBox(height: 20.h),
              ListTile(
                leading: Icon(Iconsax.tick_circle, color: colors.success),
                title: const Text('Approve All'),
                onTap: () {
                  Navigator.pop(context);
                  _bulkAction(ReportAction.approve);
                },
              ),
              ListTile(
                leading: Icon(Iconsax.trash, color: colors.danger),
                title: const Text('Remove All'),
                onTap: () {
                  Navigator.pop(context);
                  _bulkAction(ReportAction.remove);
                },
              ),
              ListTile(
                leading: Icon(Iconsax.close_circle, color: colors.warning),
                title: const Text('Reject All'),
                onTap: () {
                  Navigator.pop(context);
                  _bulkAction(ReportAction.reject);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _bulkAction(ReportAction action) {
    setState(() {
      for (final id in _selectedIds) {
        final index = _reports.indexWhere((r) => r.id == id);
        if (index != -1) {
          final report = _reports[index];
          switch (action) {
            case ReportAction.approve:
            case ReportAction.remove:
              _reports[index] = report.copyWith(status: ReportStatus.resolved);
              break;
            case ReportAction.reject:
              _reports[index] = report.copyWith(status: ReportStatus.rejected);
              break;
            case ReportAction.escalate:
              _reports[index] = report.copyWith(status: ReportStatus.escalated);
              break;
          }
        }
      }
      _selectedIds.clear();
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Bulk action completed')));
  }

  static List<ReportModel> _generateDummyReports() {
    return [
      ReportModel(
        id: 'report_1',
        targetType: ReportTargetType.station,
        targetId: 'station_1',
        reporterId: 'user_1',
        category: ReportCategory.socketBroken,
        description: 'The CCS connector on charger #2 has a broken latch.',
        priority: ReportPriority.high,
        ticketId: 'TKT-001234',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      ReportModel(
        id: 'report_2',
        targetType: ReportTargetType.review,
        targetId: 'review_1',
        reporterId: 'user_2',
        category: ReportCategory.spam,
        description: 'This review appears to be promotional spam.',
        ticketId: 'TKT-001235',
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      ),
      ReportModel(
        id: 'report_3',
        targetType: ReportTargetType.station,
        targetId: 'station_2',
        reporterId: 'user_3',
        category: ReportCategory.paymentFailed,
        description: 'Payment terminal not accepting cards.',
        status: ReportStatus.triaged,
        priority: ReportPriority.high,
        ticketId: 'TKT-001236',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      ReportModel(
        id: 'report_4',
        targetType: ReportTargetType.photo,
        targetId: 'photo_1',
        reporterId: 'user_4',
        category: ReportCategory.inappropriate,
        description: 'Photo contains inappropriate content.',
        priority: ReportPriority.critical,
        ticketId: 'TKT-001237',
        createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
      ),
      ReportModel(
        id: 'report_5',
        targetType: ReportTargetType.station,
        targetId: 'station_3',
        reporterId: 'user_5',
        category: ReportCategory.inaccurateInfo,
        description: 'Operating hours listed are incorrect.',
        status: ReportStatus.resolved,
        priority: ReportPriority.low,
        ticketId: 'TKT-001230',
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        resolvedAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ];
  }
}

/// Moderation filter options.
enum ModerationFilter { all, pending, highPriority, resolved }

/// Report actions.
enum ReportAction { approve, remove, reject, escalate }

/// Report card for moderation.
class _ReportCard extends StatelessWidget {
  const _ReportCard({
    required this.report,
    required this.isSelected,
    required this.onSelect,
    required this.onAction,
  });

  final ReportModel report;
  final bool isSelected;
  final ValueChanged<bool> onSelect;
  final ValueChanged<ReportAction> onAction;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.primary.withValues(alpha: 0.05)
            : Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isSelected ? AppColors.primary : colors.outline,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: EdgeInsets.all(12.r),
            child: Row(
              children: [
                Checkbox(
                  value: isSelected,
                  onChanged: (value) => onSelect(value ?? false),
                  activeColor: AppColors.primary,
                ),
                _buildPriorityBadge(context),
                SizedBox(width: 8.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        report.categoryDisplayName,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Ticket: ${report.ticketId ?? 'N/A'}',
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: colors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildStatusBadge(context),
              ],
            ),
          ),

          // Description
          if (report.description != null)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Text(
                report.description!,
                style: TextStyle(fontSize: 13.sp, color: colors.textSecondary),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),

          SizedBox(height: 12.h),

          // Actions
          if (!report.isResolved)
            Container(
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: colors.surfaceVariant,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(12.r),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildActionButton(
                    'Approve',
                    Iconsax.tick_circle,
                    AppColors.success,
                    () => onAction(ReportAction.approve),
                  ),
                  _buildActionButton(
                    'Remove',
                    Iconsax.trash,
                    colors.danger,
                    () => onAction(ReportAction.remove),
                  ),
                  _buildActionButton(
                    'Reject',
                    Iconsax.close_circle,
                    AppColors.warning,
                    () => onAction(ReportAction.reject),
                  ),
                  _buildActionButton(
                    'Escalate',
                    Iconsax.arrow_up,
                    AppColors.info,
                    () => onAction(ReportAction.escalate),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPriorityBadge(BuildContext context) {
    final colors = context.appColors;
    Color color;
    String label;

    switch (report.priority) {
      case ReportPriority.critical:
        color = colors.danger;
        label = 'CRITICAL';
        break;
      case ReportPriority.high:
        color = colors.warning;
        label = 'HIGH';
        break;
      case ReportPriority.medium:
        color = colors.info;
        label = 'MEDIUM';
        break;
      case ReportPriority.low:
        color = colors.success;
        label = 'LOW';
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 9.sp,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    final colors = context.appColors;
    Color color;
    switch (report.status) {
      case ReportStatus.open:
        color = colors.warning;
        break;
      case ReportStatus.triaged:
        color = colors.info;
        break;
      case ReportStatus.inProgress:
        color = colors.primary;
        break;
      case ReportStatus.resolved:
        color = colors.success;
        break;
      case ReportStatus.rejected:
        color = colors.textTertiary;
        break;
      case ReportStatus.escalated:
        color = colors.danger;
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        report.statusDisplayName,
        style: TextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildActionButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20.r, color: color),
          SizedBox(height: 4.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 10.sp,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
