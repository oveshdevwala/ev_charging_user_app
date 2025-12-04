/// File: lib/features/profile/ui/settings_page.dart
/// Purpose: App settings screen
/// Belongs To: profile feature
/// Route: /userSettings
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../widgets/app_app_bar.dart';
import '../widgets/settings_section.dart';
import '../widgets/settings_switch_tile.dart';
import '../widgets/settings_tile.dart';

/// Settings page for app preferences.
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  bool _darkMode = false;
  bool _locationEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBar(title: AppStrings.settings),
      body: ListView(
        padding: EdgeInsets.all(20.r),
        children: [
          SettingsSection(
            title: 'Preferences',
            children: [
              SettingsSwitchTile(
                icon: Iconsax.notification,
                title: 'Push Notifications',
                subtitle: 'Receive booking and promotion notifications',
                value: _notificationsEnabled,
                onChanged: (v) => setState(() => _notificationsEnabled = v),
              ),
              SettingsSwitchTile(
                icon: Iconsax.moon,
                title: 'Dark Mode',
                subtitle: 'Switch to dark theme',
                value: _darkMode,
                onChanged: (v) => setState(() => _darkMode = v),
              ),
              SettingsSwitchTile(
                icon: Iconsax.location,
                title: 'Location Services',
                subtitle: 'Enable location for nearby stations',
                value: _locationEnabled,
                onChanged: (v) => setState(() => _locationEnabled = v),
              ),
            ],
          ),
          SizedBox(height: 24.h),
          SettingsSection(
            title: 'Account',
            children: [
              SettingsTile(icon: Iconsax.lock, title: 'Change Password', onTap: () {}),
              SettingsTile(icon: Iconsax.card, title: 'Payment Methods', onTap: () {}),
              SettingsTile(
                icon: Iconsax.trash,
                title: 'Delete Account',
                titleColor: AppColors.error,
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}

