/// File: lib/admin/features/dashboard/widgets/dashboard_metrics.dart
/// Purpose: Dashboard metric cards widget
/// Belongs To: admin/features/dashboard/widgets
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/core.dart';

/// Dashboard metrics grid.
class DashboardMetrics extends StatelessWidget {
  const DashboardMetrics({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.adminColors;

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = adminResponsiveValue<int>(
          context,
          mobile: 2,
          tablet: 2,
          desktop: 4,
        );

        return GridView.count(
          crossAxisCount: crossAxisCount,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 16.h,
          crossAxisSpacing: 16.w,
          childAspectRatio: constraints.maxWidth / crossAxisCount / 160,
          children: [
            AdminMetricCard(
              title: AdminStrings.dashboardTotalStations,
              value: '25',
              icon: Iconsax.gas_station,
              iconColor: colors.primary,
              iconBackgroundColor: colors.primaryContainer,
              change: '+8.5%',
              changeLabel: 'vs last month',
              isPositiveChange: true,
            ),
            AdminMetricCard(
              title: AdminStrings.dashboardActiveUsers,
              value: '1,250',
              icon: Iconsax.people,
              iconColor: colors.info,
              iconBackgroundColor: colors.infoContainer,
              change: '+12.3%',
              changeLabel: 'vs last month',
              isPositiveChange: true,
            ),
            AdminMetricCard(
              title: AdminStrings.dashboardTodaySessions,
              value: '342',
              icon: Iconsax.flash_1,
              iconColor: colors.warning,
              iconBackgroundColor: colors.warningContainer,
              change: '-2.1%',
              changeLabel: 'vs yesterday',
              isPositiveChange: false,
            ),
            AdminMetricCard(
              title: AdminStrings.dashboardRevenue,
              value: '\$5,680',
              icon: Iconsax.dollar_circle,
              iconColor: colors.success,
              iconBackgroundColor: colors.successContainer,
              change: '+15.7%',
              changeLabel: 'vs last week',
              isPositiveChange: true,
            ),
          ],
        );
      },
    );
  }
}

