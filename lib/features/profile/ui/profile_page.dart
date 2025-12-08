/// File: lib/features/profile/ui/profile_page.dart
/// Purpose: User profile screen with BLoC integration
/// Belongs To: profile feature
/// Route: /userProfile
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/di/injection.dart';
import '../../../core/extensions/context_ext.dart';
import '../../../core/theme/app_colors.dart';
import '../../../routes/app_routes.dart';
import '../bloc/bloc.dart';
import '../repositories/repositories.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_menu_item.dart';
import '../widgets/profile_menu_section.dart';

/// Profile page showing user information and settings.
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              ProfileBloc(repository: sl<ProfileRepository>())
                ..add(const LoadProfile()),
        ),
      ],
      child: Scaffold(
        backgroundColor: context.appColors.background,
        body: SafeArea(
          child: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              if (state.isLoading && state.profile == null) {
                return const Center(child: CircularProgressIndicator());
              }

              final profile = state.profile;
              final name = profile?.name ?? 'User';
              final email = profile?.email ?? 'user@example.com';
              final avatarUrl = profile?.avatarUrl;

              return SingleChildScrollView(
                padding: EdgeInsets.all(8.r),
                child: Column(
                  children: [
                    ProfileHeader(
                      name: name,
                      email: email,
                      avatarUrl: avatarUrl,
                    ),
                    SizedBox(height: 32.h),
                    _buildAccountSection(context, profile),
                    SizedBox(height: 24.h),
                    _buildSettingsSection(context),
                    SizedBox(height: 24.h),
                    _buildSupportSection(context),
                    SizedBox(height: 24.h),
                    _buildLogoutButton(context),
                    SizedBox(height: 16.h),
                    Text(
                      'Version 1.0.0',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: context.appColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAccountSection(BuildContext context, profile) {
    return ProfileMenuSection(
      title: 'Account',
      items: [
        ProfileMenuItem(
          icon: Iconsax.user_edit,
          title: 'Edit Profile',
          onTap: () => context.push(AppRoutes.editProfile.path),
        ),
        ProfileMenuItem(
          icon: Iconsax.wallet,
          title: AppStrings.wallet,
          trailing: r'$125.00',
          onTap: () => context.push(AppRoutes.wallet.path),
        ),
        ProfileMenuItem(
          icon: Iconsax.card,
          title: 'Payment Methods',
          onTap: () => context.push(AppRoutes.paymentMethods.path),
        ),
        ProfileMenuItem(
          icon: Iconsax.car,
          title: AppStrings.vehicleList,
          onTap: () => context.push(
            AppRoutes.vehicleList.path,
            extra: 'user_abc', // TODO: Get actual userId from profile
          ),
        ),
        ProfileMenuItem(
          icon: Iconsax.shield_tick,
          title: 'Security',
          onTap: () => context.push(AppRoutes.changePassword.path),
        ),
      ],
    );
  }

  Widget _buildSettingsSection(BuildContext context) {
    return ProfileMenuSection(
      title: 'Settings',
      items: [
        ProfileMenuItem(
          icon: Iconsax.notification,
          title: AppStrings.notifications,
          onTap: () => context.push(AppRoutes.userNotifications.path),
        ),
        ProfileMenuItem(
          icon: Iconsax.moon,
          title: 'Theme',
          trailing: 'System',
          onTap: () => context.push(AppRoutes.themeSettings.path),
        ),
        ProfileMenuItem(
          icon: Iconsax.global,
          title: 'Language',
          trailing: 'English',
          onTap: () => context.push(AppRoutes.languageSettings.path),
        ),
        ProfileMenuItem(
          icon: Iconsax.setting_2,
          title: AppStrings.settings,
          onTap: () => context.push(AppRoutes.userSettings.path),
        ),
      ],
    );
  }

  Widget _buildSupportSection(BuildContext context) {
    return ProfileMenuSection(
      title: 'Support',
      items: [
        ProfileMenuItem(
          icon: Iconsax.message_question,
          title: AppStrings.helpSupport,
          onTap: () => context.push(AppRoutes.helpSupport.path),
        ),
        ProfileMenuItem(
          icon: Iconsax.message,
          title: 'Contact Us',
          onTap: () => context.push(AppRoutes.contactUs.path),
        ),
        ProfileMenuItem(
          icon: Iconsax.info_circle,
          title: AppStrings.aboutUs,
          onTap: () {},
        ),
        ProfileMenuItem(
          icon: Iconsax.document_text,
          title: AppStrings.termsConditions,
          onTap: () => context.push(AppRoutes.termsOfService.path),
        ),
        ProfileMenuItem(
          icon: Iconsax.shield_tick,
          title: AppStrings.privacyPolicy,
          onTap: () => context.push(AppRoutes.privacyPolicy.path),
        ),
      ],
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    final colors = context.appColors;

    return GestureDetector(
      onTap: () => _showLogoutDialog(context),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: colors.dangerContainer,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Iconsax.logout, size: 20.r, color: colors.danger),
            SizedBox(width: 8.w),
            Text(
              AppStrings.logout,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: colors.danger,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final colors = context.appColors;

    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: colors.surface,
        title: Text('Logout', style: TextStyle(color: colors.textPrimary)),
        content: Text(
          'Are you sure you want to logout?',
          style: TextStyle(color: colors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancel',
              style: TextStyle(color: colors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.go(AppRoutes.login.path);
            },
            child: Text('Logout', style: TextStyle(color: colors.danger)),
          ),
        ],
      ),
    );
  }
}
