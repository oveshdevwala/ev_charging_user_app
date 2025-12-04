/// File: lib/features/profile/ui/profile_page.dart
/// Purpose: User profile screen
/// Belongs To: profile feature
/// Route: /userProfile
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../routes/app_routes.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_menu_item.dart';
import '../widgets/profile_menu_section.dart';

/// Profile page showing user information and settings.
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.r),
          child: Column(
            children: [
              const ProfileHeader(name: 'John Doe', email: 'john.doe@example.com'),
              SizedBox(height: 32.h),
              _buildAccountSection(context),
              SizedBox(height: 24.h),
              _buildSettingsSection(context),
              SizedBox(height: 24.h),
              _buildSupportSection(context),
              SizedBox(height: 24.h),
              _buildLogoutButton(context),
              SizedBox(height: 16.h),
              Text(
                'Version 1.0.0',
                style: TextStyle(fontSize: 12.sp, color: AppColors.textTertiaryLight),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAccountSection(BuildContext context) {
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
          icon: Iconsax.car,
          title: 'My Vehicles',
          onTap: () {},
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
          icon: Iconsax.setting_2,
          title: AppStrings.settings,
          onTap: () => context.push(AppRoutes.userSettings.path),
        ),
        ProfileMenuItem(
          icon: Iconsax.global,
          title: 'Language',
          trailing: 'English',
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildSupportSection(BuildContext context) {
    return ProfileMenuSection(
      title: 'Support',
      items: [
        ProfileMenuItem(icon: Iconsax.message_question, title: AppStrings.helpSupport, onTap: () {}),
        ProfileMenuItem(icon: Iconsax.info_circle, title: AppStrings.aboutUs, onTap: () {}),
        ProfileMenuItem(icon: Iconsax.document_text, title: AppStrings.termsConditions, onTap: () {}),
        ProfileMenuItem(icon: Iconsax.shield_tick, title: AppStrings.privacyPolicy, onTap: () {}),
      ],
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return GestureDetector(
      onTap: () => _showLogoutDialog(context),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: AppColors.errorContainer,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Iconsax.logout, size: 20.r, color: AppColors.error),
            SizedBox(width: 8.w),
            Text(
              AppStrings.logout,
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: AppColors.error),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.go(AppRoutes.login.path);
            },
            child: const Text('Logout', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}

