/// File: lib/features/stations/widgets/station_info_cards.dart
/// Purpose: Station info cards widget
/// Belongs To: stations feature
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/extensions/context_ext.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/station_model.dart';

/// Station info cards showing hours, chargers, and distance.
class StationInfoCards extends StatelessWidget {
  const StationInfoCards({required this.station, super.key});

  final StationModel station;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _InfoCard(
            icon: Iconsax.clock,
            title: 'Hours',
            value: station.operatingHours,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _InfoCard(
            icon: Iconsax.flash_1,
            title: 'Chargers',
            value: '${station.availableChargers}/${station.totalChargers}',
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _InfoCard(
            icon: Iconsax.location,
            title: 'Distance',
            value: '${station.distance?.toStringAsFixed(1) ?? '?'} km',
          ),
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: colors.surfaceVariant,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          Icon(icon, size: 24.r, color: colors.primary),
          SizedBox(height: 8.h),
          Text(
            title,
            style: TextStyle(fontSize: 11.sp, color: colors.textSecondary),
          ),
          SizedBox(height: 2.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: colors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
