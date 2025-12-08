/// File: lib/admin/core/widgets/admin_breadcrumb.dart
/// Purpose: Breadcrumb navigation widget for admin panel
/// Belongs To: admin/core/widgets
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../extensions/admin_context_ext.dart';

/// Breadcrumb item data.
class BreadcrumbItem {
  const BreadcrumbItem({
    required this.label,
    this.onTap,
  });

  final String label;
  final VoidCallback? onTap;
}

/// Admin breadcrumb widget.
class AdminBreadcrumb extends StatelessWidget {
  const AdminBreadcrumb({
    required this.items,
    super.key,
  });

  final List<BreadcrumbItem> items;

  @override
  Widget build(BuildContext context) {
    final colors = context.adminColors;

    return Row(
      children: [
        for (var i = 0; i < items.length; i++) ...[
          if (i > 0)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Icon(
                Icons.chevron_right,
                size: 16.r,
                color: colors.textTertiary,
              ),
            ),
          _BreadcrumbItemWidget(
            item: items[i],
            isLast: i == items.length - 1,
          ),
        ],
      ],
    );
  }
}

class _BreadcrumbItemWidget extends StatefulWidget {
  const _BreadcrumbItemWidget({
    required this.item,
    required this.isLast,
  });

  final BreadcrumbItem item;
  final bool isLast;

  @override
  State<_BreadcrumbItemWidget> createState() => _BreadcrumbItemWidgetState();
}

class _BreadcrumbItemWidgetState extends State<_BreadcrumbItemWidget> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.adminColors;
    final isClickable = widget.item.onTap != null && !widget.isLast;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: isClickable ? widget.item.onTap : null,
        child: Text(
          widget.item.label,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: widget.isLast ? FontWeight.w600 : FontWeight.w400,
            color: widget.isLast
                ? colors.textPrimary
                : _isHovered && isClickable
                    ? colors.primary
                    : colors.textSecondary,
            decoration: _isHovered && isClickable
                ? TextDecoration.underline
                : TextDecoration.none,
          ),
        ),
      ),
    );
  }
}

