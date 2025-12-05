/// File: lib/features/profile/ui/language_settings_page.dart
/// Purpose: Language settings screen
/// Belongs To: profile feature
/// Route: /languageSettings
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/di/injection.dart';
import '../../../core/theme/app_colors.dart';
import '../bloc/bloc.dart';
import '../repositories/repositories.dart';

/// Language settings page.
class LanguageSettingsPage extends StatelessWidget {
  const LanguageSettingsPage({super.key});

  final List<Map<String, String>> _languages = const [
    {'code': 'en', 'name': 'English', 'native': 'English'},
    {'code': 'hi', 'name': 'Hindi', 'native': 'हिन्दी'},
    {'code': 'es', 'name': 'Spanish', 'native': 'Español'},
    {'code': 'fr', 'name': 'French', 'native': 'Français'},
    {'code': 'de', 'name': 'German', 'native': 'Deutsch'},
  ];

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LanguageBloc(
            repository: sl<ProfileRepository>(),
            prefs: sl<SharedPreferences>(),
          )..add(const LoadLanguage()),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Language Settings'),
        ),
        body: BlocBuilder<LanguageBloc, LanguageState>(
          builder: (context, state) {
            return ListView.builder(
              padding: EdgeInsets.all(20.r),
              itemCount: _languages.length,
              itemBuilder: (context, index) {
                final lang = _languages[index];
                final isSelected = state.language == lang['code'];
                return Card(
                  margin: EdgeInsets.only(bottom: 12.h),
                  child: ListTile(
                    leading: Icon(
                      Iconsax.global,
                      size: 24.r,
                      color: AppColors.primary,
                    ),
                    title: Text(
                      lang['name']!,
                      style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      lang['native']!,
                      style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondaryLight),
                    ),
                    trailing: isSelected
                        ? Icon(Iconsax.tick_circle, size: 24.r, color: AppColors.primary)
                        : const SizedBox.shrink(),
                    onTap: () {
                      context.read<LanguageBloc>().add(SetLanguage(lang['code']!));
                      // TODO: Reload app locale
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

