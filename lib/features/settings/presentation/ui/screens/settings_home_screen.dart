/// File: lib/features/settings/presentation/ui/screens/settings_home_screen.dart
/// Purpose: Settings home screen with category list
/// Belongs To: settings feature
/// Route: /userSettings
/// Customization Guide:
///    - Add/remove categories as needed
///    - Customize icons and navigation
library;

import 'package:ev_charging_user_app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../core/core.dart';
import '../../../../../widgets/widgets.dart';
import '../../../data/repositories/repositories.dart';
import '../../blocs/blocs.dart';
import '../../widgets/widgets.dart';

/// Settings home screen.
class SettingsHomeScreen extends StatelessWidget {
  const SettingsHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              SettingsBloc(repository: sl<SettingsRepository>())
                ..add(const LoadSettings()),
        ),
      ],
      child: Scaffold(
        appBar: const AppAppBar(title: AppStrings.settings),
        body: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            if (state is SettingsLoadSuccess) {
              return SafeScrollArea(
                child: Column(
                  children: [
                    // Account & Profile
                    SettingsSectionCard(
                      title: 'Account & Profile',
                      subtitle: 'Manage your account settings',
                      onTap: () => context.pushTo(AppRoutes.userSettings),
                      children: [
                        ListTile(
                          leading: Icon(Iconsax.profile_circle, size: 24.r),
                          title: Text(
                            'Edit Profile',
                            style: context.text.bodyLarge?.copyWith(
                              fontSize: 14.sp,
                            ),
                          ),
                          trailing: Icon(Iconsax.arrow_right_3, size: 20.r),
                          onTap: () => context.pushTo(AppRoutes.editProfile),
                        ),
                      ],
                    ),

                    // Appearance
                    SettingsSectionCard(
                      title: 'Appearance',
                      subtitle: 'Customize theme and display',
                      onTap: () => context.pushTo(AppRoutes.settingsAppearance),
                      children: [
                        ListTile(
                          leading: Icon(Iconsax.moon, size: 24.r),
                          title: Text(
                            'Theme & Colors',
                            style: context.text.bodyLarge?.copyWith(
                              fontSize: 14.sp,
                            ),
                          ),
                          trailing: Icon(Iconsax.arrow_right_3, size: 20.r),
                          onTap: () =>
                              context.pushTo(AppRoutes.settingsAppearance),
                        ),
                      ],
                    ),

                    // Notifications
                    SettingsSectionCard(
                      title: 'Notifications',
                      subtitle: 'Manage notification preferences',
                      onTap: () =>
                          context.pushTo(AppRoutes.settingsNotifications),
                      children: [
                        ListTile(
                          leading: Icon(Iconsax.notification, size: 24.r),
                          title: Text(
                            'Notification Settings',
                            style: context.text.bodyLarge?.copyWith(
                              fontSize: 14.sp,
                            ),
                          ),
                          trailing: Icon(Iconsax.arrow_right_3, size: 20.r),
                          onTap: () =>
                              context.pushTo(AppRoutes.settingsNotifications),
                        ),
                      ],
                    ),

                    // Privacy & Security
                    SettingsSectionCard(
                      title: 'Privacy & Security',
                      subtitle: 'Control your privacy and security',
                      onTap: () => context.pushTo(AppRoutes.settingsPrivacy),
                      children: [
                        ListTile(
                          leading: Icon(Iconsax.lock, size: 24.r),
                          title: Text(
                            'Privacy & Security',
                            style: context.text.bodyLarge?.copyWith(
                              fontSize: 14.sp,
                            ),
                          ),
                          trailing: Icon(Iconsax.arrow_right_3, size: 20.r),
                          onTap: () =>
                              context.pushTo(AppRoutes.settingsPrivacy),
                        ),
                      ],
                    ),

                    // Data & Backup
                    SettingsSectionCard(
                      title: 'Data & Backup',
                      subtitle: 'Export, import, and manage data',
                      onTap: () => context.pushTo(AppRoutes.settingsDataBackup),
                      children: [
                        ListTile(
                          leading: Icon(Iconsax.document_download, size: 24.r),
                          title: Text(
                            'Data Management',
                            style: context.text.bodyLarge?.copyWith(
                              fontSize: 14.sp,
                            ),
                          ),
                          trailing: Icon(Iconsax.arrow_right_3, size: 20.r),
                          onTap: () =>
                              context.pushTo(AppRoutes.settingsDataBackup),
                        ),
                      ],
                    ),

                    // Language & Locale
                    SettingsSectionCard(
                      title: 'Language & Locale',
                      subtitle: 'Change app language',
                      children: [
                        ListTile(
                          leading: Icon(Iconsax.global, size: 24.r),
                          title: Text(
                            'Language',
                            style: context.text.bodyLarge?.copyWith(
                              fontSize: 14.sp,
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                state.settings.locale.languageCode
                                    .toUpperCase(),
                                style: context.text.bodyMedium?.copyWith(
                                  fontSize: 14.sp,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Icon(Iconsax.arrow_right_3, size: 20.r),
                            ],
                          ),
                          onTap: () =>
                              context.pushTo(AppRoutes.languageSettings),
                        ),
                      ],
                    ),

                    // Accessibility
                    SettingsSectionCard(
                      title: 'Accessibility',
                      subtitle: 'Make the app more accessible',
                      children: [
                        SettingsToggleTile(
                          title: 'Larger Text',
                          value: state.settings.accessibility.largerText,
                          onChanged: (value) {
                            // : Update accessibility settings
                          },
                        ),
                        SettingsToggleTile(
                          title: 'High Contrast',
                          value: state.settings.accessibility.highContrast,
                          onChanged: (value) {
                            // Update accessibility settings
                          },
                        ),
                      ],
                    ),

                    // About & Legal
                    SettingsSectionCard(
                      title: 'About & Legal',
                      children: [
                        ListTile(
                          leading: Icon(Iconsax.info_circle, size: 24.r),
                          title: Text(
                            'App Version',
                            style: context.text.bodyLarge?.copyWith(
                              fontSize: 14.sp,
                            ),
                          ),
                          trailing: Text(
                            '1.0.0',
                            style: context.text.bodyMedium?.copyWith(
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                        ListTile(
                          leading: Icon(Iconsax.document_text, size: 24.r),
                          title: Text(
                            'Privacy Policy',
                            style: context.text.bodyLarge?.copyWith(
                              fontSize: 14.sp,
                            ),
                          ),
                          trailing: Icon(Iconsax.arrow_right_3, size: 20.r),
                          onTap: () => context.pushTo(AppRoutes.privacyPolicy),
                        ),
                        ListTile(
                          leading: Icon(Iconsax.document, size: 24.r),
                          title: Text(
                            'Terms of Service',
                            style: context.text.bodyLarge?.copyWith(
                              fontSize: 14.sp,
                            ),
                          ),
                          trailing: Icon(Iconsax.arrow_right_3, size: 20.r),
                          onTap: () => context.pushTo(AppRoutes.termsOfService),
                        ),
                      ],
                    ),

                    // Sign Out
                    Padding(
                      padding: EdgeInsets.all(16.r),
                      child: OutlinedButton.icon(
                        onPressed: () => _showSignOutDialog(context),
                        icon: Icon(Iconsax.logout, size: 20.r),
                        label: Text(
                          AppStrings.logout,
                          style: context.text.bodyLarge?.copyWith(
                            fontSize: 14.sp,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: context.colors.error,
                          side: BorderSide(color: context.colors.error),
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                        ),
                      ),
                    ),

                    SizedBox(height: 16.h),
                  ],
                ),
              );
            }

            if (state is SettingsFailure) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64.r,
                      color: context.colors.error,
                    ),
                    SizedBox(height: 16.h),
                    Text(state.error, style: context.text.bodyLarge),
                    SizedBox(height: 16.h),
                    ElevatedButton(
                      onPressed: () => context.read<SettingsBloc>().add(
                        const LoadSettings(),
                      ),
                      child: const Text(AppStrings.retry),
                    ),
                  ],
                ),
              );
            }

            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              //  Implement sign out
              context.showSnackBar('Sign out functionality to be implemented');
            },
            child: const Text(AppStrings.confirm),
          ),
        ],
      ),
    );
  }
}
