/// File: lib/features/settings/presentation/ui/screens/notifications_screen.dart
/// Purpose: Notifications settings screen
/// Belongs To: settings feature
/// Route: /settings/notifications
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../core/core.dart';
import '../../../../../widgets/widgets.dart';
import '../../../data/repositories/repositories.dart';
import '../../blocs/blocs.dart';
import '../../widgets/safe_scroll_area.dart';
import '../../widgets/settings_section_card.dart';
import '../../widgets/settings_toggle_tile.dart';

/// Notifications settings screen.
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

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
        appBar: const AppAppBar(title: 'Notifications'),
        body: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            if (state is SettingsLoadSuccess) {
              final notifications = state.settings.notifications;

              return SafeScrollArea(
                child: Column(
                  children: [
                    // Global Toggle
                    SettingsSectionCard(
                      title: 'Notification Settings',
                      children: [
                        SettingsToggleTile(
                          title: 'Enable Notifications',
                          subtitle: 'Turn on/off all notifications',
                          icon: Iconsax.notification,
                          value: notifications.enabled,
                          onChanged: (value) {
                            final updated = state.settings.copyWith(
                              notifications: notifications.copyWith(
                                enabled: value,
                              ),
                            );
                            context.read<SettingsBloc>().add(
                              UpdateSettings(updated),
                            );
                          },
                        ),
                      ],
                    ),

                    // Notification Types
                    SettingsSectionCard(
                      title: 'Notification Types',
                      children: [
                        SettingsToggleTile(
                          title: 'Charging Alerts',
                          subtitle: 'Get notified about charging status',
                          icon: Iconsax.flash,
                          value: notifications.chargingAlerts,
                          enabled: notifications.enabled,
                          onChanged: (value) {
                            final updated = state.settings.copyWith(
                              notifications: notifications.copyWith(
                                chargingAlerts: value,
                              ),
                            );
                            context.read<SettingsBloc>().add(
                              UpdateSettings(updated),
                            );
                          },
                        ),
                        SettingsToggleTile(
                          title: 'Trip Reminders',
                          subtitle: 'Reminders for planned trips',
                          icon: Iconsax.route_square,
                          value: notifications.tripReminders,
                          enabled: notifications.enabled,
                          onChanged: (value) {
                            final updated = state.settings.copyWith(
                              notifications: notifications.copyWith(
                                tripReminders: value,
                              ),
                            );
                            context.read<SettingsBloc>().add(
                              UpdateSettings(updated),
                            );
                          },
                        ),
                        SettingsToggleTile(
                          title: 'Promotions',
                          subtitle: 'Special offers and deals',
                          icon: Iconsax.tag,
                          value: notifications.promotions,
                          enabled: notifications.enabled,
                          onChanged: (value) {
                            final updated = state.settings.copyWith(
                              notifications: notifications.copyWith(
                                promotions: value,
                              ),
                            );
                            context.read<SettingsBloc>().add(
                              UpdateSettings(updated),
                            );
                          },
                        ),
                      ],
                    ),

                    // Sound & Quiet Hours
                    SettingsSectionCard(
                      title: 'Sound & Schedule',
                      children: [
                        SettingsToggleTile(
                          title: 'Sound',
                          subtitle: 'Play sound for notifications',
                          icon: Iconsax.music,
                          value: notifications.soundEnabled,
                          enabled: notifications.enabled,
                          onChanged: (value) {
                            final updated = state.settings.copyWith(
                              notifications: notifications.copyWith(
                                soundEnabled: value,
                              ),
                            );
                            context.read<SettingsBloc>().add(
                              UpdateSettings(updated),
                            );
                          },
                        ),
                        ListTile(
                          leading: Icon(Iconsax.clock, size: 24.r),
                          title: Text(
                            'Quiet Hours',
                            style: context.text.bodyLarge?.copyWith(
                              fontSize: 14.sp,
                            ),
                          ),
                          subtitle: Text(
                            notifications.quietHoursStart != null &&
                                    notifications.quietHoursEnd != null
                                ? '${notifications.quietHoursStart} - ${notifications.quietHoursEnd}'
                                : 'Not set',
                            style: context.text.bodySmall?.copyWith(
                              fontSize: 12.sp,
                            ),
                          ),
                          trailing: Icon(Iconsax.arrow_right_3, size: 20.r),
                          enabled: notifications.enabled,
                          onTap: notifications.enabled
                              ? () => _showQuietHoursPicker(
                                  context,
                                  state.settings,
                                )
                              : null,
                        ),
                      ],
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

  void _showQuietHoursPicker(BuildContext context, settings) {
    // TODO: Implement quiet hours time picker
    context.showSnackBar('Quiet hours picker to be implemented');
  }
}
