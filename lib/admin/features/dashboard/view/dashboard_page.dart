/// File: lib/admin/features/dashboard/view/dashboard_page.dart
/// Purpose: Admin dashboard main page
/// Belongs To: admin/features/dashboard
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/core.dart';
import '../../../routes/admin_routes.dart';
import '../widgets/widgets.dart';

/// Admin dashboard page.
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminShell(
      currentRoute: AdminRoutes.dashboard.path,
      title: AdminStrings.navDashboard,
      child: AdminPageContent(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            const AdminPageHeader(
              title: AdminStrings.dashboardWelcome,
              subtitle:
                  "Here's what's happening with your EV charging network today.",
            ),
            SizedBox(height: 24.h),

            // Metric cards
            const DashboardMetrics(),
            SizedBox(height: 24.h),

            // Charts and activity
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      const DashboardRevenueChart(),
                      SizedBox(height: 24.h),
                      const DashboardSessionsChart(),
                    ],
                  ),
                ),
                SizedBox(width: 24.w),
                Expanded(
                  child: Column(
                    children: [
                      const DashboardRecentActivity(),
                      SizedBox(height: 24.h),
                      const DashboardQuickActions(),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
