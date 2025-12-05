/// File: lib/features/profile/ui/theme_settings_page.dart
/// Purpose: Theme settings screen
/// Belongs To: profile feature
/// Route: /themeSettings
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/di/injection.dart';
import '../../../core/theme/app_colors.dart';
import '../bloc/bloc.dart';
import '../models/models.dart';
import '../repositories/repositories.dart';

/// Theme settings page.
class ThemeSettingsPage extends StatelessWidget {
  const ThemeSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ThemeBloc(
            repository: sl<ProfileRepository>(),
            prefs: sl<SharedPreferences>(),
          )..add(const LoadTheme()),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(title: const Text('Theme Settings')),
        body: BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, state) {
            return ListView(
              padding: EdgeInsets.all(20.r),
              children: [
                _buildThemeOption(
                  context,
                  ThemeModeOption.system,
                  'System Default',
                  'Follow system theme',
                  Iconsax.monitor,
                  state.themeMode == ThemeModeOption.system,
                ),
                SizedBox(height: 12.h),
                _buildThemeOption(
                  context,
                  ThemeModeOption.light,
                  'Light',
                  'Always use light theme',
                  Iconsax.sun_1,
                  state.themeMode == ThemeModeOption.light,
                ),
                SizedBox(height: 12.h),
                _buildThemeOption(
                  context,
                  ThemeModeOption.dark,
                  'Dark',
                  'Always use dark theme',
                  Iconsax.moon,
                  state.themeMode == ThemeModeOption.dark,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildThemeOption(
    BuildContext context,
    ThemeModeOption mode,
    String title,
    String subtitle,
    IconData icon,
    bool isSelected,
  ) {
    return Card(
      child: ListTile(
        leading: Icon(icon, size: 24.r, color: AppColors.primary),
        title: Text(
          title,
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 14.sp,
            color: AppColors.textSecondaryLight,
          ),
        ),
        trailing: isSelected
            ? Icon(Iconsax.tick_circle, size: 24.r, color: AppColors.primary)
            : const SizedBox.shrink(),
        onTap: () {
          context.read<ThemeBloc>().add(SetThemeMode(mode));
        },
      ),
    );
  }
}
