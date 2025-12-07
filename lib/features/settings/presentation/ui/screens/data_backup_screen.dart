/// File: lib/features/settings/presentation/ui/screens/data_backup_screen.dart
/// Purpose: Data & Backup settings screen
/// Belongs To: settings feature
/// Route: /settings/dataBackup
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

/// Data & Backup settings screen.
class DataBackupScreen extends StatelessWidget {
  const DataBackupScreen({super.key});

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
        appBar: const AppAppBar(title: 'Data & Backup'),
        body: BlocListener<SettingsBloc, SettingsState>(
          listener: (context, state) {
            if (state is SettingsExportSuccess) {
              context.showSuccessSnackBar('Settings exported successfully');
            } else if (state is SettingsImportSuccess) {
              context.showSuccessSnackBar('Settings imported successfully');
            } else if (state is SettingsResetSuccess) {
              context.showSuccessSnackBar('Settings reset to defaults');
            } else if (state is SettingsFailure) {
              context.showErrorSnackBar(state.error);
            }
          },
          child: BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, state) {
              if (state is SettingsLoadSuccess) {
                final viewModel = SettingsViewModel(state.settings);

                return SafeScrollArea(
                  child: Column(
                    children: [
                      // Export & Import
                      SettingsSectionCard(
                        title: 'Backup & Restore',
                        children: [
                          ListTile(
                            leading: Icon(
                              Iconsax.document_download,
                              size: 24.r,
                            ),
                            title: Text(
                              'Export Settings',
                              style: context.text.bodyLarge?.copyWith(
                                fontSize: 14.sp,
                              ),
                            ),
                            subtitle: Text(
                              'Last exported: ${viewModel.lastExportDisplay}',
                              style: context.text.bodySmall?.copyWith(
                                fontSize: 12.sp,
                              ),
                            ),
                            trailing: Icon(Iconsax.arrow_right_3, size: 20.r),
                            onTap: () => _exportSettings(context),
                          ),
                          ListTile(
                            leading: Icon(Iconsax.document_upload, size: 24.r),
                            title: Text(
                              'Import Settings',
                              style: context.text.bodyLarge?.copyWith(
                                fontSize: 14.sp,
                              ),
                            ),
                            subtitle: Text(
                              'Restore from JSON file',
                              style: context.text.bodySmall?.copyWith(
                                fontSize: 12.sp,
                              ),
                            ),
                            trailing: Icon(Iconsax.arrow_right_3, size: 20.r),
                            onTap: () => _importSettings(context),
                          ),
                        ],
                      ),

                      // Reset & Clear
                      SettingsSectionCard(
                        title: 'Reset',
                        children: [
                          ListTile(
                            leading: Icon(
                              Iconsax.refresh,
                              size: 24.r,
                              color: context.colors.error,
                            ),
                            title: Text(
                              'Reset to Defaults',
                              style: context.text.bodyLarge?.copyWith(
                                fontSize: 14.sp,
                                color: context.colors.error,
                              ),
                            ),
                            subtitle: Text(
                              'Restore all settings to default values',
                              style: context.text.bodySmall?.copyWith(
                                fontSize: 12.sp,
                              ),
                            ),
                            trailing: Icon(Iconsax.arrow_right_3, size: 20.r),
                            onTap: () => _showResetDialog(context),
                          ),
                          ListTile(
                            leading: Icon(
                              Iconsax.trash,
                              size: 24.r,
                              color: context.colors.error,
                            ),
                            title: Text(
                              'Clear Cache',
                              style: context.text.bodyLarge?.copyWith(
                                fontSize: 14.sp,
                                color: context.colors.error,
                              ),
                            ),
                            subtitle: Text(
                              'Clear all cached data',
                              style: context.text.bodySmall?.copyWith(
                                fontSize: 12.sp,
                              ),
                            ),
                            trailing: Icon(Iconsax.arrow_right_3, size: 20.r),
                            onTap: () => _showClearCacheDialog(context),
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
      ),
    );
  }

  void _exportSettings(BuildContext context) {
    context.read<SettingsBloc>().add(const ExportSettings());

    // Copy to clipboard and show success
    BlocListener<SettingsBloc, SettingsState>(
      listener: (context, state) {
        if (state is SettingsExportSuccess) {
          Clipboard.setData(ClipboardData(text: state.json));
          context.showSuccessSnackBar('Settings copied to clipboard');
        }
      },
      child: const SizedBox.shrink(),
    );
  }

  void _importSettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Import Settings'),
        content: const Text('Paste JSON settings below:'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () async {
              // TODO: Implement JSON paste and import
              Navigator.of(context).pop();
              context.showSnackBar('Import functionality to be implemented');
            },
            child: const Text('Import'),
          ),
        ],
      ),
    );
  }

  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Settings'),
        content: const Text(
          'Are you sure you want to reset all settings to defaults? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<SettingsBloc>().add(const ResetSettings());
            },
            style: TextButton.styleFrom(foregroundColor: context.colors.error),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  void _showClearCacheDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cache'),
        content: const Text(
          'Are you sure you want to clear all cached data? This may improve app performance.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Implement cache clearing
              context.showSnackBar('Cache clearing to be implemented');
            },
            style: TextButton.styleFrom(foregroundColor: context.colors.error),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
}
