/// File: lib/features/activity/ui/activity_details_page.dart
/// Purpose: Comprehensive activity details page with graphs and insights
/// Belongs To: activity feature
/// Route: /activityDetails
/// Customization Guide:
///    - Customize tabs and sections as needed
///    - Add more chart types for additional insights
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/theme/app_colors.dart';
import '../../../repositories/activity_repository.dart';
import '../../../routes/app_routes.dart';
import '../../../widgets/loading_wrapper.dart';
import '../bloc/activity_cubit.dart';
import '../bloc/activity_state.dart';
import '../widgets/energy_chart.dart';
import '../widgets/insights_card.dart';
import '../widgets/session_card.dart';
import '../widgets/transaction_card.dart';

/// Activity details page with graphs, sessions, and transactions.
class ActivityDetailsPage extends StatelessWidget {
  const ActivityDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ActivityCubit(activityRepository: DummyActivityRepository())
            ..loadActivityData(),
      child: const _ActivityDetailsContent(),
    );
  }
}

class _ActivityDetailsContent extends StatelessWidget {
  const _ActivityDetailsContent();

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Scaffold(
      backgroundColor: colors.background,
      body: BlocBuilder<ActivityCubit, ActivityState>(
        builder: (context, state) {
          if (state.isLoading && !state.hasData) {
            return const Center(child: LoadingIndicator());
          }

          return NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              _buildAppBar(context, state),
            ],
            body: RefreshIndicator(
              onRefresh: () =>
                  context.read<ActivityCubit>().refreshActivityData(),
              color: colors.primary,
              child: _buildContent(context, state),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, ActivityState state) {
    final colors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? colors.textPrimary : Colors.white;

    return SliverAppBar(
      expandedHeight: 200.h,
      pinned: true,
      backgroundColor: colors.primary,
      surfaceTintColor: Colors.transparent,
      title: Text(
        'Your Activity',
        style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
      ),
      leading: IconButton(
        icon: Container(
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: textColor.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(Iconsax.arrow_left, size: 20.r, color: textColor),
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: [
        IconButton(
          icon: Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: textColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(Iconsax.export_3, size: 20.r, color: textColor),
          ),
          onPressed: () {
            // Export functionality
          },
        ),
        SizedBox(width: 8.w),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: _buildHeaderStats(state, context),
      ),
    );
  }

  Widget _buildHeaderStats(ActivityState state, BuildContext context) {
    final colors = context.appColors;
    final summary = state.summary;
    if (summary == null) {
      return const SizedBox.shrink();
    }
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? colors.textPrimary : Colors.white;

    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primaryDark],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 60.h, 20.w, 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your Activity',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w800,
                  color: textColor,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'Level ${summary.level} · ${summary.xpPoints} XP',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: textColor.withValues(alpha: 0.9),
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  _buildHeaderStat(
                    'Sessions',
                    '${summary.totalSessions}',
                    textColor,
                  ),
                  SizedBox(width: 24.w),
                  _buildHeaderStat(
                    'Energy',
                    '${summary.totalEnergyKwh.toStringAsFixed(0)} kWh',
                    textColor,
                  ),
                  SizedBox(width: 24.w),
                  _buildHeaderStat(
                    'Saved',
                    '\$${summary.totalSpent.toStringAsFixed(0)}',
                    textColor,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderStat(String label, String value, Color textColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: textColor.withValues(alpha: 0.9),
          ),
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context, ActivityState state) {
    final colors = context.appColors;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.all(20.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Time range selector
          _buildTimeRangeSelector(context, state),
          SizedBox(height: 24.h),

          // Energy chart section
          _buildSectionHeader(context, 'Energy Usage', 'kWh consumed'),
          SizedBox(height: 16.h),
          _buildChartCard(
            context,
            child: EnergyChart(
              data: state.currentGraphData,
              barColor: colors.primary,
            ),
          ),
          SizedBox(height: 8.h),
          _buildChartSummary(context, state),
          SizedBox(height: 28.h),

          // Spending chart section
          _buildSectionHeader(context, 'Spending Trend', 'Amount spent'),
          SizedBox(height: 16.h),
          _buildChartCard(
            context,
            child: SpendingChart(
              data: state.currentGraphData,
              lineColor: colors.secondary,
            ),
          ),
          SizedBox(height: 28.h),

          // Insights panel
          if (state.insights != null) ...[
            InsightsPanel(insights: state.insights!),
            SizedBox(height: 28.h),
          ],

          // Environmental impact
          if (state.summary != null) ...[
            EnvironmentalImpactCard(
              co2SavedKg: state.summary!.co2SavedKg,
              treesEquivalent: state.summary!.co2SavedKg / 21.77,
            ),
            SizedBox(height: 28.h),
          ],

          // Recent sessions
          _buildSectionHeader(
            context,
            'Recent Sessions',
            '${state.sessions.length} sessions',
          ),
          SizedBox(height: 16.h),
          ...state.sessions
              .take(5)
              .map(
                (session) => Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: SessionCard(
                    session: session,
                    onTap: () =>
                        context.push(AppRoutes.sessionDetail.id(session.id)),
                  ),
                ),
              ),
          if (state.sessions.length > 5)
            _buildViewAllButton(context, 'View All Sessions', () {
              context.push(AppRoutes.allSessions.path);
            }),
          SizedBox(height: 28.h),

          // Recent transactions
          _buildSectionHeader(
            context,
            'Recent Transactions',
            '${state.transactions.length} transactions',
          ),
          SizedBox(height: 16.h),
          ...state.transactions
              .take(5)
              .map(
                (tx) => Padding(
                  padding: EdgeInsets.only(bottom: 10.h),
                  child: TransactionCard(
                    transaction: tx,
                    onTap: () =>
                        context.push(AppRoutes.transactionDetail.id(tx.id)),
                  ),
                ),
              ),
          if (state.transactions.length > 5)
            _buildViewAllButton(context, 'View All Transactions', () {
              context.push(AppRoutes.allTransactions.path);
            }),

          SizedBox(height: 100.h),
        ],
      ),
    );
  }

  Widget _buildTimeRangeSelector(BuildContext context, ActivityState state) {
    final colors = context.appColors;

    return Container(
      padding: EdgeInsets.all(4.r),
      decoration: BoxDecoration(
        color: colors.surfaceVariant,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        children: ActivityTimeRange.values.map((range) {
          final isSelected = state.selectedTimeRange == range;
          return Expanded(
            child: GestureDetector(
              onTap: () => context.read<ActivityCubit>().setTimeRange(range),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(vertical: 12.h),
                decoration: BoxDecoration(
                  color: isSelected ? colors.surface : Colors.transparent,
                  borderRadius: BorderRadius.circular(10.r),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: colors.shadow,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  range.name[0].toUpperCase() + range.name.substring(1),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected
                        ? colors.textPrimary
                        : colors.textSecondary,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    String subtitle,
  ) {
    final colors = context.appColors;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: colors.textPrimary,
          ),
        ),
        Text(
          subtitle,
          style: TextStyle(fontSize: 13.sp, color: colors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildChartCard(BuildContext context, {required Widget child}) {
    final colors = context.appColors;

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: colors.outline),
      ),
      child: child,
    );
  }

  Widget _buildChartSummary(BuildContext context, ActivityState state) {
    final colors = context.appColors;

    return Row(
      children: [
        Expanded(
          child: _buildSummaryItem(
            context,
            label: 'Total Energy',
            value: '${state.totalEnergy.toStringAsFixed(1)} kWh',
            color: colors.primary,
          ),
        ),
        Expanded(
          child: _buildSummaryItem(
            context,
            label: 'Total Spent',
            value: '\$${state.totalSpending.toStringAsFixed(2)}',
            color: colors.secondary,
          ),
        ),
        Expanded(
          child: _buildSummaryItem(
            context,
            label: 'Sessions',
            value: '${state.totalSessions}',
            color: AppColors.tertiary,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryItem(
    BuildContext context, {
    required String label,
    required String value,
    required Color color,
  }) {
    final colors = context.appColors;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            label,
            style: TextStyle(fontSize: 11.sp, color: colors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildViewAllButton(
    BuildContext context,
    String text,
    VoidCallback onTap,
  ) {
    final colors = context.appColors;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 14.h),
        decoration: BoxDecoration(
          color: colors.surfaceVariant,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: colors.primary,
              ),
            ),
            SizedBox(width: 6.w),
            Icon(Iconsax.arrow_right_3, size: 16.r, color: colors.primary),
          ],
        ),
      ),
    );
  }
}
