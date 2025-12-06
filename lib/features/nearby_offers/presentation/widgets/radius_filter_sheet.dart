/// File: lib/features/nearby_offers/presentation/widgets/radius_filter_sheet.dart
/// Purpose: Bottom sheet for radius selection
/// Belongs To: nearby_offers feature
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class RadiusFilterSheet extends StatelessWidget {
  const RadiusFilterSheet({
    required this.currentRadiusKm,
    required this.onRadiusSelected,
    super.key,
  });

  final double currentRadiusKm;
  final ValueChanged<double> onRadiusSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(24.r),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Radius',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 24.h),
          _buildOption(context, 1, 'Walking distance (1 km)'),
          _buildOption(context, 3, 'Short drive (3 km)'),
          _buildOption(context, 5, 'Nearby area (5 km)'),
          _buildOption(context, 10, 'Wider area (10 km)'),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  Widget _buildOption(BuildContext context, double radius, String label) {
    final isSelected = currentRadiusKm == radius;
    final theme = Theme.of(context);

    return InkWell(
      onTap: () {
        onRadiusSelected(radius);
        context.pop();
      },
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.outline,
            ),
            SizedBox(width: 16.w),
            Text(
              label,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
