/// File: lib/features/settings/presentation/widgets/settings_select_tile.dart
/// Purpose: Reusable settings select tile widget
/// Belongs To: settings feature
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../core/core.dart';

/// Reusable settings select tile.
class SettingsSelectTile extends StatelessWidget {
  const SettingsSelectTile({
    required this.title,
    required this.currentValue,
    required this.onTap,
    this.subtitle,
    this.icon,
    this.enabled = true,
    super.key,
  });

  final String title;
  final String? subtitle;
  final IconData? icon;
  final String currentValue;
  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      enabled: enabled,
      leading: icon != null
          ? Icon(icon, size: 24.r, color: context.colors.primary)
          : null,
      title: Text(
        title,
        style: context.text.bodyLarge?.copyWith(
          fontSize: 14.sp,
          color: enabled ? null : context.colors.onSurface.withOpacity(0.38),
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: context.text.bodySmall?.copyWith(
                fontSize: 12.sp,
                color: enabled
                    ? context.colors.onSurfaceVariant
                    : context.colors.onSurface.withOpacity(0.38),
              ),
            )
          : null,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            currentValue,
            style: context.text.bodyMedium?.copyWith(
              fontSize: 14.sp,
              color: enabled
                  ? context.colors.onSurfaceVariant
                  : context.colors.onSurface.withOpacity(0.38),
            ),
          ),
          SizedBox(width: 8.w),
          Icon(
            Iconsax.arrow_right_3,
            size: 20.r,
            color: enabled
                ? context.colors.onSurfaceVariant
                : context.colors.onSurface.withOpacity(0.38),
          ),
        ],
      ),
      onTap: enabled ? onTap : null,
    );
  }
}
