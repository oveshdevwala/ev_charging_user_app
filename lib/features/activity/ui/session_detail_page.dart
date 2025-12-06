/// File: lib/features/activity/ui/session_detail_page.dart
/// Purpose: Detailed view of a charging session
/// Belongs To: activity feature
/// Route: /sessionDetail/:id
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/extensions/context_ext.dart';
import '../../../core/extensions/date_ext.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/charging_session_model.dart';
import '../../../repositories/activity_repository.dart';

/// Session detail page showing full charging session information.
class SessionDetailPage extends StatelessWidget {
  const SessionDetailPage({required this.sessionId, super.key});

  final String sessionId;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    // Get session from repository
    final session = DummyActivityRepository().getSessionById(sessionId);

    return Scaffold(
      backgroundColor: colors.background,
      body: session == null
          ? _buildNotFound(context)
          : _buildContent(context, session),
    );
  }

  Widget _buildNotFound(BuildContext context) {
    final colors = context.appColors;

    return SafeArea(
      child: Column(
        children: [
          _buildAppBar(context, 'Session Details'),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Iconsax.warning_2,
                    size: 64.r,
                    color: colors.textTertiary,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'Session not found',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, ChargingSessionModel session) {
    final colors = context.appColors;

    return CustomScrollView(
      slivers: [
        // App Bar
        SliverAppBar(
          expandedHeight: 180.h,
          pinned: true,
          backgroundColor: colors.primary,
          leading: IconButton(
            icon: Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: colors.surface.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                Iconsax.arrow_left,
                size: 20.r,
                color: colors.surface,
              ),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            'Session Details',
            style: TextStyle(
              color: colors.surface,
              fontWeight: FontWeight.w600,
            ),
          ),
          flexibleSpace: FlexibleSpaceBar(
            background: _buildHeader(session, context),
          ),
        ),

        // Content
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(20.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Station Info Card
                _buildStationCard(context, session),
                SizedBox(height: 20.h),

                // Session Stats
                _buildSectionTitle(context, 'Session Statistics'),
                SizedBox(height: 12.h),
                _buildStatsGrid(context, session),
                SizedBox(height: 24.h),

                // Timeline
                _buildSectionTitle(context, 'Session Timeline'),
                SizedBox(height: 12.h),
                _buildTimeline(context, session),
                SizedBox(height: 24.h),

                // Payment Info
                _buildSectionTitle(context, 'Payment Details'),
                SizedBox(height: 12.h),
                _buildPaymentCard(context, session),
                SizedBox(height: 100.h),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAppBar(BuildContext context, String title) {
    final colors = context.appColors;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      child: Row(
        children: [
          IconButton(
            icon: Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                Iconsax.arrow_left,
                size: 20.r,
                color: colors.textPrimary,
              ),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: colors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(ChargingSessionModel session, BuildContext context) {
    final colors = context.appColors;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colors.primary, colors.primaryContainer],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.r),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${session.energyKwh.toStringAsFixed(1)} kWh',
                style: TextStyle(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.w800,
                  color: colors.surface,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'Charged on ${session.formattedDate}',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: colors.surface.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStationCard(BuildContext context, ChargingSessionModel session) {
    final colors = context.appColors;

    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Iconsax.flash_1, size: 24.r, color: colors.primary),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      session.stationName,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                      ),
                    ),
                    if (session.stationName.isNotEmpty) ...[
                      SizedBox(height: 4.h),
                      Text(
                        session.stationName,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    final colors = context.appColors;

    return Text(
      title,
      style: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.w700,
        color: colors.textPrimary,
      ),
    );
  }

  Widget _buildStatsGrid(BuildContext context, ChargingSessionModel session) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12.w,
      mainAxisSpacing: 12.h,
      childAspectRatio: 1.5,
      children: [
        _buildStatCard(
          context,
          'Duration',
          session.formattedDuration,
          Iconsax.clock,
        ),
        _buildStatCard(
          context,
          'Cost',
          '\$${session.cost.toStringAsFixed(2)}',
          Iconsax.dollar_circle,
        ),
        _buildStatCard(
          context,
          'Power',
          '${session.powerKw.toStringAsFixed(1)} kW',
          Iconsax.flash_1,
        ),
        _buildStatCard(
          context,
          'Energy',
          '${session.energyKwh.toStringAsFixed(1)} kWh',
          Iconsax.chart_2,
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    final colors = context.appColors;

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: colors.surfaceVariant,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, size: 24.r, color: colors.primary),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 12.sp, color: colors.textSecondary),
              ),
              SizedBox(height: 4.h),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline(BuildContext context, ChargingSessionModel session) {
    final colors = context.appColors;

    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colors.outline),
      ),
      child: Column(
        children: [
          _buildTimelineItem(
            context,
            'Started',
            session.formattedTime,
            Iconsax.play_circle,
            colors.success,
          ),
          if (session.endTime != null) ...[
            SizedBox(height: 16.h),
            Divider(color: colors.outline),
            SizedBox(height: 16.h),
            _buildTimelineItem(
              context,
              'Completed',
              session.endTime!.formattedTime,
              Iconsax.tick_circle,
              colors.primary,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTimelineItem(
    BuildContext context,
    String label,
    String time,
    IconData icon,
    Color color,
  ) {
    final colors = context.appColors;

    return Row(
      children: [
        Container(
          width: 40.r,
          height: 40.r,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 20.r, color: color),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                time,
                style: TextStyle(fontSize: 12.sp, color: colors.textSecondary),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentCard(BuildContext context, ChargingSessionModel session) {
    final colors = context.appColors;

    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colors.outline),
      ),
      child: Column(
        children: [
          _buildPaymentRow(
            context,
            'Energy',
            '${session.energyKwh.toStringAsFixed(1)} kWh',
          ),
          SizedBox(height: 12.h),
          Divider(color: colors.outline),
          SizedBox(height: 12.h),
          if (session.energyKwh > 0) ...[
            _buildPaymentRow(
              context,
              'Rate',
              '\$${(session.cost / session.energyKwh).toStringAsFixed(2)}/kWh',
            ),
            SizedBox(height: 12.h),
            Divider(color: colors.outline),
            SizedBox(height: 12.h),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                ),
              ),
              Text(
                '\$${session.cost.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w800,
                  color: colors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentRow(BuildContext context, String label, String value) {
    final colors = context.appColors;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14.sp, color: colors.textSecondary),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: colors.textPrimary,
          ),
        ),
      ],
    );
  }
}
