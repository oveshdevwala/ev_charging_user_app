/// File: lib/features/trip_planner/widgets/charging_stop_card.dart
/// Purpose: Expandable charging stop card widget for trip planning
/// Belongs To: trip_planner feature
/// Customization Guide:
///    - Customize via parameters
///    - Add action buttons as needed
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/extensions/context_ext.dart';
import '../../../core/theme/app_colors.dart';
import '../../../widgets/common_button.dart';
import '../models/models.dart';
import 'battery_graph.dart';

/// Expandable charging stop card widget.
class ChargingStopCard extends StatefulWidget {
  const ChargingStopCard({
    required this.stop,
    super.key,
    this.onNavigateTap,
    this.onReserveTap,
    this.onDetailsTap,
    this.initiallyExpanded = false,
    this.showTimeline = true,
    this.isFirst = false,
    this.isLast = false,
    this.timelineHeight,
  });

  /// Charging stop data.
  final ChargingStopModel stop;

  /// Callback when navigate button is tapped.
  final VoidCallback? onNavigateTap;

  /// Callback when reserve button is tapped.
  final VoidCallback? onReserveTap;

  /// Callback when details button is tapped.
  final VoidCallback? onDetailsTap;

  /// Whether card is initially expanded.
  final bool initiallyExpanded;

  /// Whether to show timeline indicator.
  final bool showTimeline;

  /// Whether this is the first stop.
  final bool isFirst;

  /// Whether this is the last stop.
  final bool isLast;

  /// Custom timeline height (for dynamic sizing).
  final double? timelineHeight;

  @override
  State<ChargingStopCard> createState() => _ChargingStopCardState();
}

class _ChargingStopCardState extends State<ChargingStopCard>
    with SingleTickerProviderStateMixin {
  late bool _isExpanded;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );

    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 0.5,
    ).animate(_expandAnimation);

    if (_isExpanded) {
      _animationController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline indicator
        if (widget.showTimeline) _buildTimelineIndicator(context),
        // Card content
        Expanded(
          child: Container(
            margin: EdgeInsets.only(bottom: 16.h),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: _isExpanded
                    ? context.appColors.primary.withValues(alpha: 0.3)
                    : context.appColors.outline,
                width: _isExpanded ? 1.5 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: _isExpanded
                      ? context.appColors.primary.withValues(alpha: 0.1)
                      : context.appColors.shadow,
                  blurRadius: _isExpanded ? 12 : 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header - tappable to expand/collapse
                GestureDetector(
                  onTap: _toggleExpanded,
                  child: _buildHeader(context),
                ),
                // Content
                Padding(
                  padding: EdgeInsets.all(8.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Station info row
                      _buildStationInfo(context),
                      SizedBox(height: 12.h),
                      // Stats row
                      _buildStatsRow(context),
                      // Expandable content
                      SizeTransition(
                        sizeFactor: _expandAnimation,
                        child: Column(
                          children: [
                            SizedBox(height: 16.h),
                            _buildExpandedContent(context),
                          ],
                        ),
                      ),
                      SizedBox(height: 16.h),
                      // Action buttons
                      _buildActionButtons(context),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineIndicator(BuildContext context) {
    return SizedBox(
      width: 52.w,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Top line connecting from previous
          if (!widget.isFirst)
            Container(
              width: 3,
              height: 24.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    context.appColors.primary.withValues(alpha: 0.2),
                    context.appColors.primary.withValues(alpha: 0.5),
                  ],
                ),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          // Stop number circle
          Container(
            width: 40.r,
            height: 40.r,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  context.appColors.primary,
                  context.appColors.primaryContainer,
                ],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: context.appColors.primary.withValues(alpha: 0.4),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Icon(
                Iconsax.flash_15,
                size: 20.r,
                color: context.appColors.surface,
              ),
            ),
          ),
          // Bottom line connecting to next (fixed height, not expanded)
          if (!widget.isLast)
            Container(
              width: 3,
              height: 100.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    context.appColors.primary.withValues(alpha: 0.5),
                    context.appColors.primary.withValues(alpha: 0.2),
                  ],
                ),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final colors = context.appColors;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: _isExpanded
            ? colors.primary.withValues(alpha: 0.15)
            : colors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      child: Row(
        children: [
          // Stop number badge - fixed size
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: colors.primary,
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Text(
              'Stop ${widget.stop.stopNumber}',
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w700,
                color: context.appColors.surface,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          // Station name - flexible to take remaining space
          Expanded(
            child: Text(
              widget.stop.stationName,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: context.appColors.textPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Network badge - constrained width
          if (widget.stop.network != null) ...[
            SizedBox(width: 6.w),
            Container(
              constraints: BoxConstraints(maxWidth: 90.w),
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
              decoration: BoxDecoration(
                color: context.appColors.secondary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(4.r),
                border: Border.all(
                  color: context.appColors.secondary.withValues(alpha: 0.3),
                ),
              ),
              child: Text(
                widget.stop.network!,
                style: TextStyle(
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w600,
                  color: context.appColors.secondary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
          SizedBox(width: 6.w),
          // Expand/collapse indicator
          RotationTransition(
            turns: _rotationAnimation,
            child: Icon(
              Iconsax.arrow_down_1,
              size: 18.r,
              color: context.appColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStationInfo(BuildContext context) {
    return Row(
      children: [
        Icon(
          Iconsax.location,
          size: 14.r,
          color: context.appColors.textSecondary,
        ),
        SizedBox(width: 4.w),
        Expanded(
          child: Text(
            widget.stop.location.address ?? widget.stop.location.displayName,
            style: TextStyle(
              fontSize: 12.sp,
              color: context.appColors.textSecondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow(BuildContext context) {
    return Row(
      children: [
        // Arrival SOC
        Expanded(
          child: _buildStatItem(
            context,
            icon: Iconsax.battery_empty_1,
            label: 'Arrive',
            value: '${widget.stop.arrivalSocPercent.toStringAsFixed(0)}%',
            valueColor: widget.stop.arrivalSocPercent < 20
                ? context.appColors.warning
                : context.appColors.textPrimary,
          ),
        ),
        // Departure SOC
        Expanded(
          child: _buildStatItem(
            context,
            icon: Iconsax.battery_full,
            label: 'Depart',
            value: '${widget.stop.departureSocPercent.toStringAsFixed(0)}%',
            valueColor: context.appColors.primary,
          ),
        ),
        // Charge time
        Expanded(
          child: _buildStatItem(
            context,
            icon: Iconsax.timer_1,
            label: 'Time',
            value: widget.stop.formattedChargeTime,
          ),
        ),
        // Cost
        Expanded(
          child: _buildStatItem(
            context,
            icon: Iconsax.dollar_circle,
            label: 'Cost',
            value: '\$${widget.stop.estimatedCost.toStringAsFixed(2)}',
            valueColor: context.appColors.secondary,
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Column(
      children: [
        Icon(icon, size: 18.r, color: context.appColors.textSecondary),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 10.sp,
            color: context.appColors.textTertiary,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: valueColor ?? context.appColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildExpandedContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(color: context.appColors.outline, height: 1),
        SizedBox(height: 16.h),
        // Charger info chips
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: [
            _buildInfoChip(
              context,
              Iconsax.flash_1,
              '${widget.stop.chargerPowerKw.toStringAsFixed(0)} kW',
            ),
            _buildInfoChip(
              context,
              Iconsax.cpu_charge,
              widget.stop.chargerTypeDisplay,
            ),
            _buildInfoChip(
              context,
              Iconsax.money,
              '\$${widget.stop.pricePerKwh.toStringAsFixed(2)}/kWh',
            ),
          ],
        ),
        if (widget.stop.amenities.isNotEmpty) ...[
          SizedBox(height: 14.h),
          Wrap(
            spacing: 6.w,
            runSpacing: 6.h,
            children: widget.stop.amenities.map((amenity) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: context.appColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  amenity,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: context.appColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
        if (widget.stop.arrivalTime != null) ...[
          SizedBox(height: 14.h),
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: context.appColors.surfaceVariant,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Row(
              children: [
                Icon(
                  Iconsax.clock,
                  size: 16.r,
                  color: context.appColors.textSecondary,
                ),
                SizedBox(width: 8.w),
                Text(
                  'Arrive ${_formatTime(widget.stop.arrivalTime!)}',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: context.appColors.textPrimary,
                  ),
                ),
                if (widget.stop.departureTime != null) ...[
                  Text(
                    '  •  ',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: context.appColors.textTertiary,
                    ),
                  ),
                  Text(
                    'Depart ${_formatTime(widget.stop.departureTime!)}',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: context.appColors.textPrimary,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
        // Battery progress visualization
        SizedBox(height: 16.h),
        Container(
          padding: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
            color: context.appColors.primary.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: context.appColors.primary.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            children: [
              BatteryProgressIndicator(
                socPercent: widget.stop.arrivalSocPercent,
                width: 45.w,
                height: 20.h,
                showLabel: false,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: Icon(
                  Iconsax.arrow_right_3,
                  size: 16.r,
                  color: context.appColors.primary,
                ),
              ),
              BatteryProgressIndicator(
                socPercent: widget.stop.departureSocPercent,
                width: 45.w,
                height: 20.h,
                showLabel: false,
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: context.appColors.primary,
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  '+${widget.stop.energyToChargeKwh.toStringAsFixed(0)} kWh',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    color: context.appColors.surface,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoChip(BuildContext context, IconData icon, String text) {
    final colors = context.appColors;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: colors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: colors.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.r, color: colors.primary),
          SizedBox(width: 5.w),
          Text(
            text,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: colors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        CommonButton(
          label: 'Navigate',
        
          onPressed: widget.onNavigateTap,
          size: ButtonSize.small,
          icon: Iconsax.direct_right,
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
        ),
        Row(
          children: [
            Expanded(
              child: CommonButton(
                label: 'Reserve',
                onPressed: widget.onReserveTap,
                variant: ButtonVariant.outlined,
                size: ButtonSize.small,
                icon: Iconsax.calendar,
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
              ),
            ),
            if (widget.onDetailsTap != null) ...[
              SizedBox(width: 6.w),
              Expanded(
                child: CommonButton(
                  label: 'Details',
                  onPressed: widget.onDetailsTap,
                  variant: ButtonVariant.tonal,
                  size: ButtonSize.small,
                  icon: Iconsax.info_circle,
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.w,
                    vertical: 8.h,
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  String _formatTime(DateTime time) {
    final hour = time.hour > 12 ? time.hour - 12 : time.hour;
    final period = time.hour >= 12 ? 'PM' : 'AM';
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute $period';
  }
}
