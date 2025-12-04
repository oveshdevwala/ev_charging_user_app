/// File: lib/features/profile/widgets/profile_menu_item.dart
/// Purpose: Profile menu item model
/// Belongs To: profile feature
library;

import 'package:flutter/widgets.dart';

/// Profile menu item model.
class ProfileMenuItem {
  const ProfileMenuItem({
    required this.icon,
    required this.title,
    required this.onTap, this.trailing,
  });

  final IconData icon;
  final String title;
  final String? trailing;
  final VoidCallback onTap;
}

