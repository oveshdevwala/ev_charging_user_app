/// File: lib/admin/features/sessions/presentation/screens/sessions_dashboard_screen.dart
/// Purpose: Lightweight dashboard surface for sessions KPIs
/// Belongs To: admin/features/sessions
/// Customization Guide:
///    - Replace placeholder content with real charts/aggregation
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../admin.dart';

/// Dashboard overview for sessions.
class SessionsDashboardScreen extends StatelessWidget {
  const SessionsDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminPageContent(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AdminPageHeader(
            title: AdminStrings.sessionsDashboard,
            subtitle: AdminStrings.sessionsTitle,
          ),
          SizedBox(height: 16.h),
          AdminCardWithHeader(
            title: AdminStrings.sessionsDashboard,
            child: Text(
              AdminStrings.msgNoData,
              style: TextStyle(fontSize: 14.sp),
            ),
          ),
        ],
      ),
    );
  }
}
