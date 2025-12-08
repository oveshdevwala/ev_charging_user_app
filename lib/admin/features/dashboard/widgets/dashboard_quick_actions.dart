/// File: lib/admin/features/dashboard/widgets/dashboard_quick_actions.dart
/// Purpose: Dashboard quick actions widget
/// Belongs To: admin/features/dashboard/widgets
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/core.dart';
import '../../../routes/admin_routes.dart';

/// Dashboard quick actions.
class DashboardQuickActions extends StatelessWidget {
  const DashboardQuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.adminColors;

    return AdminCardWithHeader(
      title: AdminStrings.dashboardQuickActions,
      contentPadding: EdgeInsets.all(12.r),
      child: Column(
        children: [
          _QuickActionButton(
            icon: Iconsax.add_circle,
            label: 'Add New Station',
            onTap: () => context.push(AdminRoutes.stationCreate.path),
          ),
          SizedBox(height: 8.h),
          _QuickActionButton(
            icon: Iconsax.user_add,
            label: 'Add New Manager',
            onTap: () {},
          ),
          SizedBox(height: 8.h),
          _QuickActionButton(
            icon: Iconsax.discount_shape,
            label: 'Create Offer',
            onTap: () {},
          ),
          SizedBox(height: 8.h),
          _QuickActionButton(
            icon: Iconsax.document_download,
            label: 'Export Report',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _QuickActionButton extends StatefulWidget {
  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  State<_QuickActionButton> createState() => _QuickActionButtonState();
}

class _QuickActionButtonState extends State<_QuickActionButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.adminColors;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(8.r),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: _isHovered ? colors.primaryContainer : colors.surfaceVariant,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            children: [
              Icon(
                widget.icon,
                size: 20.r,
                color: _isHovered ? colors.primary : colors.textSecondary,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: _isHovered ? colors.primary : colors.textPrimary,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                size: 18.r,
                color: _isHovered ? colors.primary : colors.textTertiary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

