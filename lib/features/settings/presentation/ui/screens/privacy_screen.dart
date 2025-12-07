/// File: lib/features/settings/presentation/ui/screens/privacy_screen.dart
/// Purpose: Privacy & Security settings screen
/// Belongs To: settings feature
/// Route: /settings/privacy
library;

import 'package:ev_charging_user_app/features/settings/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../core/core.dart';
import '../../../../../widgets/widgets.dart';
import '../../../data/repositories/repositories.dart';
import '../../blocs/blocs.dart';
import '../../viewmodels/viewmodels.dart';
import '../../widgets/safe_scroll_area.dart';
import '../../widgets/settings_section_card.dart';
import '../../widgets/settings_select_tile.dart';
import '../../widgets/settings_toggle_tile.dart';

/// Privacy & Security settings screen.
class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              SettingsBloc(repository: sl<SettingsRepository>())
                ..add(const LoadSettings()),
        ),
        BlocProvider(
          create: (context) =>
              SecurityBloc(repository: sl<SettingsRepository>()),
        ),
      ],
      child: Scaffold(
        appBar: const AppAppBar(title: 'Privacy & Security'),
        body: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            if (state is SettingsLoadSuccess) {
              final viewModel = SettingsViewModel(state.settings);
              final privacy = state.settings.privacy;
              final security = state.settings.security;

              return SafeScrollArea(
                child: Column(
                  children: [
                    // Privacy Settings
                    SettingsSectionCard(
                      title: 'Privacy',
                      children: [
                        SettingsToggleTile(
                          title: 'Analytics',
                          subtitle: 'Help improve the app',
                          icon: Iconsax.chart,
                          value: privacy.analyticsOptIn,
                          onChanged: (value) {
                            final updated = state.settings.copyWith(
                              privacy: privacy.copyWith(analyticsOptIn: value),
                            );
                            context.read<SettingsBloc>().add(
                              UpdateSettings(updated),
                            );
                          },
                        ),
                        SettingsToggleTile(
                          title: 'Location Services',
                          subtitle: 'Use location for nearby stations',
                          icon: Iconsax.location,
                          value: privacy.locationUse,
                          onChanged: (value) {
                            final updated = state.settings.copyWith(
                              privacy: privacy.copyWith(locationUse: value),
                            );
                            context.read<SettingsBloc>().add(
                              UpdateSettings(updated),
                            );
                          },
                        ),
                      ],
                    ),

                    // Security Settings
                    SettingsSectionCard(
                      title: 'Security',
                      children: [
                        SettingsToggleTile(
                          title: 'Biometric Lock',
                          subtitle: 'Use fingerprint or face ID',
                          icon: Iconsax.finger_scan,
                          value: security.biometricsEnabled,
                          onChanged: (value) {
                            if (value) {
                              context.read<SecurityBloc>().add(
                                const EnableBiometrics(),
                              );
                            } else {
                              context.read<SecurityBloc>().add(
                                const DisableBiometrics(),
                              );
                            }
                          },
                        ),
                        ListTile(
                          leading: Icon(Iconsax.lock, size: 24.r),
                          title: Text(
                            'PIN Lock',
                            style: context.text.bodyLarge?.copyWith(
                              fontSize: 14.sp,
                            ),
                          ),
                          subtitle: Text(
                            viewModel.hasPin ? 'PIN is set' : 'No PIN set',
                            style: context.text.bodySmall?.copyWith(
                              fontSize: 12.sp,
                            ),
                          ),
                          trailing: Icon(Iconsax.arrow_right_3, size: 20.r),
                          onTap: () => _showPinSetup(context, viewModel.hasPin),
                        ),
                        SettingsSelectTile(
                          title: 'Session Timeout',
                          subtitle: 'Auto-lock after inactivity',
                          icon: Iconsax.timer,
                          currentValue: viewModel.sessionTimeoutDisplay,
                          onTap: () => _showSessionTimeoutPicker(
                            context,
                            security.sessionTimeoutMinutes,
                          ),
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

  void _showPinSetup(BuildContext context, bool hasPin) {
    if (hasPin) {
      // Show PIN change dialog
      context.showSnackBar('PIN change to be implemented');
    } else {
      // Show PIN setup dialog
      context.showSnackBar('PIN setup to be implemented');
    }
  }

  void _showSessionTimeoutPicker(BuildContext context, int currentMinutes) {
    final options = [15, 30, 60, 120, 240]; // minutes

    showAppBottomSheet<void>(
      context: context,
      title: 'Session Timeout',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: options.map((minutes) {
          final hours = minutes ~/ 60;
          final remainingMinutes = minutes % 60;
          String label;
          if (hours == 0) {
            label = '$minutes minutes';
          } else if (remainingMinutes == 0) {
            label = '$hours ${hours == 1 ? 'hour' : 'hours'}';
          } else {
            label = '$hours h $remainingMinutes m';
          }

          return ListTile(
            title: Text(label),
            trailing: currentMinutes == minutes
                ? Icon(Icons.check, color: context.colors.primary)
                : null,
            onTap: () {
              context.read<SecurityBloc>().add(ChangeSessionTimeout(minutes));
              Navigator.of(context).pop();
            },
          );
        }).toList(),
      ),
    );
  }
}
