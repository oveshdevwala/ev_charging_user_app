/// File: lib/features/settings/presentation/widgets/profile_avatar.dart
/// Purpose: Profile avatar widget with upload capability
/// Belongs To: settings feature
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../core/core.dart';

/// Profile avatar widget.
class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    this.imageUrl,
    this.initials,
    this.onTap,
    this.size = 80,
    super.key,
  });

  final String? imageUrl;
  final String? initials;
  final VoidCallback? onTap;
  final double size;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          CircleAvatar(
            radius: size.r,
            backgroundColor: context.colors.primaryContainer,
            backgroundImage: imageUrl != null ? NetworkImage(imageUrl!) : null,
            child: imageUrl == null
                ? Text(
                    initials ?? '?',
                    style: context.text.headlineSmall?.copyWith(
                      color: context.colors.onPrimaryContainer,
                      fontSize: (size * 0.4).sp,
                    ),
                  )
                : null,
          ),
          if (onTap != null)
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.all(4.r),
                decoration: BoxDecoration(
                  color: context.colors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: context.colors.surface, width: 2.w),
                ),
                child: Icon(
                  Iconsax.camera,
                  size: 16.r,
                  color: context.colors.onPrimary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
