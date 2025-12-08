/// File: lib/admin/core/widgets/admin_status_badge.dart
/// Purpose: Status badge/chip widget for admin panel
/// Belongs To: admin/core/widgets
library;

import 'package:ev_charging_user_app/admin/core/theme/admin_theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../extensions/admin_context_ext.dart';
import '../theme/admin_colors.dart';

/// Status types with predefined colors.
enum AdminStatusType {
  active,
  inactive,
  pending,
  approved,
  rejected,
  completed,
  cancelled,
  online,
  offline,
  maintenance,
  warning,
  error,
  info,
  success,
}

/// Admin status badge widget.
class AdminStatusBadge extends StatelessWidget {
  const AdminStatusBadge({
    required this.label,
    super.key,
    this.type,
    this.backgroundColor,
    this.foregroundColor,
    this.icon,
    this.size = AdminBadgeSize.medium,
  });

  /// Create status badge from type.
  factory AdminStatusBadge.fromType(
    AdminStatusType type, {
    AdminBadgeSize size = AdminBadgeSize.medium,
  }) {
    return AdminStatusBadge(
      label: _getLabelForType(type),
      type: type,
      size: size,
    );
  }

  final String label;
  final AdminStatusType? type;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final IconData? icon;
  final AdminBadgeSize size;

  static String _getLabelForType(AdminStatusType type) {
    switch (type) {
      case AdminStatusType.active:
        return 'Active';
      case AdminStatusType.inactive:
        return 'Inactive';
      case AdminStatusType.pending:
        return 'Pending';
      case AdminStatusType.approved:
        return 'Approved';
      case AdminStatusType.rejected:
        return 'Rejected';
      case AdminStatusType.completed:
        return 'Completed';
      case AdminStatusType.cancelled:
        return 'Cancelled';
      case AdminStatusType.online:
        return 'Online';
      case AdminStatusType.offline:
        return 'Offline';
      case AdminStatusType.maintenance:
        return 'Maintenance';
      case AdminStatusType.warning:
        return 'Warning';
      case AdminStatusType.error:
        return 'Error';
      case AdminStatusType.info:
        return 'Info';
      case AdminStatusType.success:
        return 'Success';
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.adminColors;
    final (bgColor, fgColor) = _getColors(colors);

    final double paddingH;
    final double paddingV;
    final double fontSize;
    final double iconSize;

    switch (size) {
      case AdminBadgeSize.small:
        paddingH = 6.w;
        paddingV = 2.h;
        fontSize = 10.sp;
        iconSize = 10.r;
        break;
      case AdminBadgeSize.medium:
        paddingH = 10.w;
        paddingV = 4.h;
        fontSize = 12.sp;
        iconSize = 12.r;
        break;
      case AdminBadgeSize.large:
        paddingH = 12.w;
        paddingV = 6.h;
        fontSize = 13.sp;
        iconSize = 14.r;
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: paddingH, vertical: paddingV),
      decoration: BoxDecoration(
        color: backgroundColor ?? bgColor,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: iconSize, color: foregroundColor ?? fgColor),
            SizedBox(width: 4.w),
          ],
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
                color: foregroundColor ?? fgColor,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  (Color, Color) _getColors(AdminAppColors colors) {
    if (type == null) {
      return (colors.surfaceVariant, colors.textPrimary);
    }

    switch (type!) {
      case AdminStatusType.active:
      case AdminStatusType.approved:
      case AdminStatusType.online:
      case AdminStatusType.success:
      case AdminStatusType.completed:
        return (colors.successContainer, colors.success);
      case AdminStatusType.inactive:
      case AdminStatusType.offline:
        return (colors.surfaceVariant, colors.textSecondary);
      case AdminStatusType.pending:
      case AdminStatusType.warning:
      case AdminStatusType.maintenance:
        return (colors.warningContainer, AdminColors.warningDark);
      case AdminStatusType.rejected:
      case AdminStatusType.cancelled:
      case AdminStatusType.error:
        return (colors.errorContainer, colors.error);
      case AdminStatusType.info:
        return (colors.infoContainer, AdminColors.infoDark);
    }
  }
}

/// Badge size.
enum AdminBadgeSize { small, medium, large }

/// Dot status indicator.
class AdminStatusDot extends StatelessWidget {
  const AdminStatusDot({
    super.key,
    this.color,
    this.type,
    this.size = 8,
    this.animate = false,
  });

  factory AdminStatusDot.fromType(
    AdminStatusType type, {
    bool animate = false,
  }) {
    return AdminStatusDot(type: type, animate: animate);
  }

  final Color? color;
  final AdminStatusType? type;
  final double size;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    final colors = context.adminColors;
    final dotColor = color ?? _getColorForType(colors);

    if (animate) {
      return _AnimatedDot(color: dotColor, size: size);
    }

    return Container(
      width: size.r,
      height: size.r,
      decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
    );
  }

  Color _getColorForType(AdminAppColors colors) {
    if (type == null) return colors.textTertiary;

    switch (type!) {
      case AdminStatusType.active:
      case AdminStatusType.approved:
      case AdminStatusType.online:
      case AdminStatusType.success:
      case AdminStatusType.completed:
        return colors.success;
      case AdminStatusType.inactive:
      case AdminStatusType.offline:
        return colors.textTertiary;
      case AdminStatusType.pending:
      case AdminStatusType.warning:
      case AdminStatusType.maintenance:
        return colors.warning;
      case AdminStatusType.rejected:
      case AdminStatusType.cancelled:
      case AdminStatusType.error:
        return colors.error;
      case AdminStatusType.info:
        return colors.info;
    }
  }
}

class _AnimatedDot extends StatefulWidget {
  const _AnimatedDot({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  State<_AnimatedDot> createState() => _AnimatedDotState();
}

class _AnimatedDotState extends State<_AnimatedDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.5, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.size.r,
          height: widget.size.r,
          decoration: BoxDecoration(
            color: widget.color.withValues(alpha: _animation.value),
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }
}
