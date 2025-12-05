/// File: lib/features/activity/ui/session_detail_page.dart
/// Purpose: Detailed view of a charging session
/// Belongs To: activity feature
/// Route: /sessionDetail/:id
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/theme/app_colors.dart';
import '../../../models/charging_session_model.dart';
import '../../../repositories/activity_repository.dart';

/// Session detail page showing full charging session information.
class SessionDetailPage extends StatelessWidget {
  const SessionDetailPage({required this.sessionId, super.key});

  final String sessionId;

  @override
  Widget build(BuildContext context) {
    // Get session from repository
    final session = DummyActivityRepository().getSessionById(sessionId);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: session == null
          ? _buildNotFound(context)
          : _buildContent(context, session),
    );
  }

  Widget _buildNotFound(BuildContext context) {
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
                    color: AppColors.textTertiaryLight,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'Session not found',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: AppColors.textSecondaryLight,
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
    return CustomScrollView(
      slivers: [
        // App Bar
        SliverAppBar(
          expandedHeight: 180.h,
          pinned: true,
          backgroundColor: AppColors.primary,
          leading: IconButton(
            icon: Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(Iconsax.arrow_left, size: 20.r, color: Colors.white),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text(
            'Session Details',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
          flexibleSpace: FlexibleSpaceBar(background: _buildHeader(session)),
        ),

        // Content
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(20.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Station Info Card
                _buildStationCard(session),
                SizedBox(height: 20.h),

                // Session Stats
                _buildSectionTitle('Session Statistics'),
                SizedBox(height: 12.h),
                _buildStatsGrid(session),
                SizedBox(height: 24.h),

                // Timeline
                _buildSectionTitle('Session Timeline'),
                SizedBox(height: 12.h),
                _buildTimeline(session),
                SizedBox(height: 24.h),

                // Payment Info
                _buildSectionTitle('Payment Details'),
                SizedBox(height: 12.h),
                _buildPaymentCard(session),
                SizedBox(height: 100.h),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAppBar(BuildContext context, String title) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      child: Row(
        children: [
          IconButton(
            icon: Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                Iconsax.arrow_left,
                size: 20.r,
                color: AppColors.textPrimaryLight,
              ),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          SizedBox(width: 8.w),
          Text(
            title,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimaryLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(ChargingSessionModel session) {
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
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                children: [
                  _buildStatusBadge(session.status),
                  const Spacer(),
                  Text(
                    '\$${session.cost.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Text(
                '${session.formattedDate} · ${session.formattedTime}',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(SessionStatus status) {
    Color bgColor;
    String text;

    switch (status) {
      case SessionStatus.completed:
        bgColor = AppColors.success;
        text = 'Completed';
      case SessionStatus.inProgress:
        bgColor = AppColors.primary;
        text = 'Charging';
      case SessionStatus.cancelled:
        bgColor = AppColors.warning;
        text = 'Cancelled';
      case SessionStatus.failed:
        bgColor = AppColors.error;
        text = 'Failed';
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildStationCard(ChargingSessionModel session) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.outlineLight),
      ),
      child: Row(
        children: [
          Container(
            width: 56.r,
            height: 56.r,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Iconsax.gas_station,
              size: 28.r,
              color: AppColors.primary,
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  session.stationName,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimaryLight,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Charger ${session.chargerId} · ${session.chargerType}',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Iconsax.arrow_right_3,
            size: 20.r,
            color: AppColors.textTertiaryLight,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimaryLight,
      ),
    );
  }

  Widget _buildStatsGrid(ChargingSessionModel session) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.outlineLight),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  icon: Iconsax.flash_1,
                  label: 'Energy',
                  value: '${session.energyKwh.toStringAsFixed(1)} kWh',
                  color: AppColors.primary,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  icon: Iconsax.clock,
                  label: 'Duration',
                  value: session.formattedDuration,
                  color: AppColors.secondary,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  icon: Iconsax.speedometer,
                  label: 'Avg. Power',
                  value:
                      '${(session.energyKwh / (session.duration.inMinutes / 60)).toStringAsFixed(1)} kW',
                  color: AppColors.tertiary,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  icon: Iconsax.tree,
                  label: 'CO₂ Saved',
                  value: '${(session.energyKwh * 0.5).toStringAsFixed(1)} kg',
                  color: AppColors.success,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          width: 44.r,
          height: 44.r,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(icon, size: 22.r, color: color),
        ),
        SizedBox(height: 10.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimaryLight,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: AppColors.textSecondaryLight,
          ),
        ),
      ],
    );
  }

  Widget _buildTimeline(ChargingSessionModel session) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.outlineLight),
      ),
      child: Column(
        children: [
          _buildTimelineItem(
            icon: Iconsax.play_circle,
            title: 'Session Started',
            subtitle: session.formattedTime,
            color: AppColors.primary,
            isFirst: true,
          ),
          _buildTimelineItem(
            icon: Iconsax.flash_1,
            title: 'Charging',
            subtitle: '${session.energyKwh.toStringAsFixed(1)} kWh delivered',
            color: AppColors.secondary,
          ),
          _buildTimelineItem(
            icon: Iconsax.tick_circle,
            title: 'Session Completed',
            subtitle: '${session.formattedDuration} total',
            color: AppColors.success,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 36.r,
              height: 36.r,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 18.r, color: color),
            ),
            if (!isLast)
              Container(width: 2, height: 30.h, color: AppColors.outlineLight),
          ],
        ),
        SizedBox(width: 14.w),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimaryLight,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentCard(ChargingSessionModel session) {
    final energyCost = session.energyKwh * 0.35;
    final serviceFee = session.cost - energyCost;

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.outlineLight),
      ),
      child: Column(
        children: [
          _buildPaymentRow('Energy Cost', '\$${energyCost.toStringAsFixed(2)}'),
          SizedBox(height: 10.h),
          _buildPaymentRow('Service Fee', '\$${serviceFee.toStringAsFixed(2)}'),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: const Divider(height: 1, color: AppColors.outlineLight),
          ),
          _buildPaymentRow(
            'Total',
            '\$${session.cost.toStringAsFixed(2)}',
            isTotal: true,
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Icon(
                Iconsax.card,
                size: 18.r,
                color: AppColors.textSecondaryLight,
              ),
              SizedBox(width: 8.w),
              Text(
                'Paid via Wallet',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: AppColors.textSecondaryLight,
                ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  'Paid',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.success,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 15.sp : 14.sp,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
            color: isTotal
                ? AppColors.textPrimaryLight
                : AppColors.textSecondaryLight,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 18.sp : 14.sp,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w600,
            color: isTotal ? AppColors.primary : AppColors.textPrimaryLight,
          ),
        ),
      ],
    );
  }
}
