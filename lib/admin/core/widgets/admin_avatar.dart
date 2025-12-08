/// File: lib/admin/core/widgets/admin_avatar.dart
/// Purpose: Avatar widget for admin panel
/// Belongs To: admin/core/widgets
library;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../extensions/admin_context_ext.dart';
import '../utils/admin_formatters.dart';

/// Admin avatar widget.
class AdminAvatar extends StatelessWidget {
  const AdminAvatar({
    super.key,
    this.imageUrl,
    this.name,
    this.size = 40,
    this.borderRadius,
    this.backgroundColor,
    this.foregroundColor,
  });

  final String? imageUrl;
  final String? name;
  final double size;
  final double? borderRadius;
  final Color? backgroundColor;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    final effectiveBorderRadius = borderRadius ?? size / 2;

    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(effectiveBorderRadius.r),
        child: CachedNetworkImage(
          imageUrl: imageUrl!,
          width: size.r,
          height: size.r,
          fit: BoxFit.cover,
          placeholder: (_, __) => _buildPlaceholder(context),
          errorWidget: (_, __, ___) => _buildPlaceholder(context),
        ),
      );
    }

    return _buildPlaceholder(context);
  }

  Widget _buildPlaceholder(BuildContext context) {
    final colors = context.adminColors;
    final initials = name != null 
        ? AdminFormatters.initials(name!) 
        : '?';
    final effectiveBorderRadius = borderRadius ?? size / 2;

    return Container(
      width: size.r,
      height: size.r,
      decoration: BoxDecoration(
        color: backgroundColor ?? colors.primaryContainer,
        borderRadius: BorderRadius.circular(effectiveBorderRadius.r),
      ),
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            fontSize: (size / 2.5).sp,
            fontWeight: FontWeight.w600,
            color: foregroundColor ?? colors.primary,
          ),
        ),
      ),
    );
  }
}

/// Avatar with status indicator.
class AdminAvatarWithStatus extends StatelessWidget {
  const AdminAvatarWithStatus({
    super.key,
    this.imageUrl,
    this.name,
    this.size = 40,
    this.isOnline = false,
    this.statusColor,
  });

  final String? imageUrl;
  final String? name;
  final double size;
  final bool isOnline;
  final Color? statusColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.adminColors;
    final dotSize = size * 0.25;

    return Stack(
      children: [
        AdminAvatar(
          imageUrl: imageUrl,
          name: name,
          size: size,
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: Container(
            width: dotSize.r,
            height: dotSize.r,
            decoration: BoxDecoration(
              color: statusColor ?? (isOnline ? colors.success : colors.textTertiary),
              shape: BoxShape.circle,
              border: Border.all(
                color: colors.surface,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Avatar group for showing multiple avatars.
class AdminAvatarGroup extends StatelessWidget {
  const AdminAvatarGroup({
    required this.avatars,
    super.key,
    this.size = 32,
    this.maxVisible = 4,
    this.overlap = 0.3,
  });

  final List<AvatarData> avatars;
  final double size;
  final int maxVisible;
  final double overlap;

  @override
  Widget build(BuildContext context) {
    final colors = context.adminColors;
    final visibleCount = avatars.length.clamp(0, maxVisible);
    final remainingCount = avatars.length - visibleCount;
    final effectiveSize = size.r;
    final overlapAmount = effectiveSize * overlap;

    return SizedBox(
      height: effectiveSize,
      width: effectiveSize + (visibleCount - 1 + (remainingCount > 0 ? 1 : 0)) * (effectiveSize - overlapAmount),
      child: Stack(
        children: [
          for (var i = 0; i < visibleCount; i++)
            Positioned(
              left: i * (effectiveSize - overlapAmount),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: colors.surface,
                    width: 2,
                  ),
                ),
                child: AdminAvatar(
                  imageUrl: avatars[i].imageUrl,
                  name: avatars[i].name,
                  size: size - 4,
                ),
              ),
            ),
          if (remainingCount > 0)
            Positioned(
              left: visibleCount * (effectiveSize - overlapAmount),
              child: Container(
                width: effectiveSize,
                height: effectiveSize,
                decoration: BoxDecoration(
                  color: colors.surfaceVariant,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: colors.surface,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    '+$remainingCount',
                    style: TextStyle(
                      fontSize: (size / 3).sp,
                      fontWeight: FontWeight.w600,
                      color: colors.textSecondary,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Avatar data class.
class AvatarData {
  const AvatarData({
    this.imageUrl,
    this.name,
  });

  final String? imageUrl;
  final String? name;
}

