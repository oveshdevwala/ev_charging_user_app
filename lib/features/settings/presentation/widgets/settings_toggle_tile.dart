/// File: lib/features/settings/presentation/widgets/settings_toggle_tile.dart
/// Purpose: Reusable settings toggle tile widget
/// Belongs To: settings feature
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/core.dart';

/// Reusable settings toggle tile.
class SettingsToggleTile extends StatelessWidget {
  const SettingsToggleTile({
    required this.title,
    required this.value,
    required this.onChanged,
    this.subtitle,
    this.icon,
    this.enabled = true,
    super.key,
  });

  final String title;
  final String? subtitle;
  final IconData? icon;
  final bool value;
  final ValueChanged<bool> onChanged;
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
      trailing: Switch.adaptive(
        value: value,
        onChanged: enabled ? onChanged : null,
      ),
      onTap: enabled ? () => onChanged(!value) : null,
    );
  }
}
