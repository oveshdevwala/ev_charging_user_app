/// File: lib/features/settings/presentation/ui/screens/appearance_screen.dart
/// Purpose: Appearance settings screen
/// Belongs To: settings feature
/// Route: /settings/appearance
library;

import 'package:ev_charging_user_app/core/di/injection.dart';
import 'package:ev_charging_user_app/core/extensions/context_ext.dart';
import 'package:ev_charging_user_app/features/settings/data/models/settings_model.dart';
import 'package:ev_charging_user_app/features/settings/data/repositories/settings_repository.dart';
import 'package:ev_charging_user_app/widgets/app_app_bar.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../blocs/blocs.dart';
import '../../viewmodels/viewmodels.dart';
import '../../widgets/widgets.dart';

/// Appearance settings screen.
class AppearanceScreen extends StatelessWidget {
  const AppearanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AppearanceBloc(
            repository: sl<SettingsRepository>(),
            themeManager: sl(),
          ),
        ),
      ],
      child: Scaffold(
        appBar: const AppAppBar(title: 'Appearance'),
        body: BlocBuilder<AppearanceBloc, AppearanceState>(
          builder: (context, state) {
            if (state is AppearanceUpdated) {
              final viewModel = SettingsViewModel(
                SettingsModel(appearance: state.appearance),
              );

              return SafeScrollArea(
                child: Column(
                  children: [
                    // Theme Mode
                    SettingsSectionCard(
                      title: 'Theme',
                      children: [
                        SettingsSelectTile(
                          title: 'Theme Mode',
                          icon: Iconsax.moon,
                          currentValue: viewModel.getThemeModeLabel(
                            state.appearance.themeMode,
                          ),
                          onTap: () => _showThemeModePicker(
                            context,
                            state.appearance.themeMode,
                          ),
                        ),
                      ],
                    ),

                    // Accent Color
                    SettingsSectionCard(
                      title: 'Accent Color',

                      children: [
                        10.verticalSpace,
                        SizedBox(
                          width: double.infinity,
                          child: SettingsColorPicker(
                            selectedColorHex: state.appearance.accentColorHex,
                            onColorSelected: (colorHex) {
                              context.read<AppearanceBloc>().add(
                                ChangeAccentColor(colorHex),
                              );
                            },
                          ),
                        ),
                      ],
                    ),

                    // Font Size
                    SettingsSectionCard(
                      title: 'Font Size',
                      children: [
                        SettingsSelectTile(
                          title: 'Font Size',
                          icon: Iconsax.text,
                          currentValue: viewModel.getFontSizeLabel(
                            state.appearance.fontScale,
                          ),
                          onTap: () => _showFontSizePicker(
                            context,
                            state.appearance.fontScale,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 16.h),
                  ],
                ),
              );
            }

            if (state is AppearanceFailure) {
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

  void _showThemeModePicker(BuildContext context, ThemeModeOption current) {
    showAppBottomSheet<void>(
      context: context,
      title: 'Select Theme Mode',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: ThemeModeOption.values.map((mode) {
          final label = _getThemeModeLabel(mode);
          return ListTile(
            title: Text(label),
            trailing: current == mode
                ? Icon(Icons.check, color: context.colors.primary)
                : null,
            onTap: () {
              context.read<AppearanceBloc>().add(ChangeThemeMode(mode));
              Navigator.of(context).pop();
            },
          );
        }).toList(),
      ),
    );
  }

  void _showFontSizePicker(BuildContext context, FontSizeOption current) {
    showAppBottomSheet<void>(
      context: context,
      title: 'Select Font Size',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: FontSizeOption.values.map((size) {
          final label = _getFontSizeLabel(size);
          return ListTile(
            title: Text(label),
            trailing: current == size
                ? Icon(Icons.check, color: context.colors.primary)
                : null,
            onTap: () {
              context.read<AppearanceBloc>().add(ChangeFontScale(size));
              Navigator.of(context).pop();
            },
          );
        }).toList(),
      ),
    );
  }

  String _getThemeModeLabel(ThemeModeOption mode) {
    switch (mode) {
      case ThemeModeOption.system:
        return 'System';
      case ThemeModeOption.light:
        return 'Light';
      case ThemeModeOption.dark:
        return 'Dark';
    }
  }

  String _getFontSizeLabel(FontSizeOption size) {
    switch (size) {
      case FontSizeOption.small:
        return 'Small';
      case FontSizeOption.medium:
        return 'Medium';
      case FontSizeOption.large:
        return 'Large';
    }
  }
}
