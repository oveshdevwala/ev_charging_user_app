/// File: lib/features/profile/widgets/profile_header.dart
/// Purpose: Profile header widget
/// Belongs To: profile feature
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/extensions/context_ext.dart';

/// Profile header showing user avatar and info.
class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    required this.name,
    required this.email,
    this.avatarUrl,
    super.key,
  });

  final String name;
  final String email;
  final String? avatarUrl;

  @override
  Widget build(BuildContext context) {
    final initials = name.split(' ').take(2).map((n) => n[0]).join();
    
    return Column(
      children: [
        if (avatarUrl != null && avatarUrl!.isNotEmpty) CircleAvatar(
                radius: 50.r,
                backgroundImage: NetworkImage(avatarUrl!),
                onBackgroundImageError: (_, __) {},
              ) else Container(
                width: 100.r,
                height: 100.r,
                decoration: BoxDecoration(
                  color: context.appColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    initials,
                    style: TextStyle(
                      fontSize: 32.sp,
                      fontWeight: FontWeight.w700,
                      color: context.appColors.surface,
                    ),
                  ),
                ),
              ),
        SizedBox(height: 16.h),
        Text(
          name,
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.w700,
            color: context.appColors.textPrimary,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          email,
          style: TextStyle(
            fontSize: 14.sp,
            color: context.appColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

