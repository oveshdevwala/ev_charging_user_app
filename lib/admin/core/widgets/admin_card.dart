/// File: lib/admin/core/widgets/admin_card.dart
/// Purpose: Reusable card widgets for admin panel
/// Belongs To: admin/core/widgets
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../extensions/admin_context_ext.dart';

/// Admin panel card widget.
class AdminCard extends StatelessWidget {
  const AdminCard({
    required this.child,
    super.key,
    this.padding,
    this.margin,
    this.borderRadius,
    this.color,
    this.borderColor,
    this.elevation,
    this.onTap,
  });

  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? borderRadius;
  final Color? color;
  final Color? borderColor;
  final double? elevation;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.adminColors;

    Widget card = Container(
      margin: margin,
      decoration: BoxDecoration(
        color: color ?? colors.surface,
        borderRadius: BorderRadius.circular(borderRadius ?? 12.r),
        border: Border.all(
          color: borderColor ?? colors.outline,
        ),
        boxShadow: elevation != null && elevation! > 0
            ? [
                BoxShadow(
                  color: colors.shadow,
                  blurRadius: elevation! * 2,
                  offset: Offset(0, elevation!),
                ),
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius ?? 12.r),
        child: Padding(
          padding: padding ?? EdgeInsets.all(20.r),
          child: child,
        ),
      ),
    );

    if (onTap != null) {
      card = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius ?? 12.r),
          child: card,
        ),
      );
    }

    return card;
  }
}

/// Admin card with header.
class AdminCardWithHeader extends StatelessWidget {
  const AdminCardWithHeader({
    required this.title,
    required this.child,
    super.key,
    this.subtitle,
    this.actions,
    this.padding,
    this.contentPadding,
  });

  final String title;
  final String? subtitle;
  final Widget child;
  final List<Widget>? actions;
  final EdgeInsets? padding;
  final EdgeInsets? contentPadding;

  @override
  Widget build(BuildContext context) {
    final colors = context.adminColors;

    return AdminCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: padding ?? EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: colors.divider,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: colors.textPrimary,
                        ),
                      ),
                      if (subtitle != null) ...[
                        SizedBox(height: 2.h),
                        Text(
                          subtitle!,
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: colors.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (actions != null && actions!.isNotEmpty) ...[
                  ...actions!,
                ],
              ],
            ),
          ),

          // Content
          Padding(
            padding: contentPadding ?? EdgeInsets.all(16.r),
            child: child,
          ),
        ],
      ),
    );
  }
}

/// Clickable card with hover effect.
class AdminClickableCard extends StatefulWidget {
  const AdminClickableCard({
    required this.child,
    super.key,
    this.onTap,
    this.padding,
    this.borderRadius,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets? padding;
  final double? borderRadius;

  @override
  State<AdminClickableCard> createState() => _AdminClickableCardState();
}

class _AdminClickableCardState extends State<AdminClickableCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.adminColors;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: _isHovered ? colors.surfaceVariant : colors.surface,
          borderRadius: BorderRadius.circular(widget.borderRadius ?? 12.r),
          border: Border.all(
            color: _isHovered ? colors.primary.withValues(alpha: 0.3) : colors.outline,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 12.r),
            child: Padding(
              padding: widget.padding ?? EdgeInsets.all(16.r),
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}

