/// File: lib/admin/core/widgets/admin_image_picker.dart
/// Purpose: Admin image picker widget for station/product images
/// Belongs To: admin/core/widgets
/// Customization Guide:
///    - Adjust aspectRatio for different image types
///    - Modify maxSize for file size validation
library;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';

import '../extensions/admin_context_ext.dart';
import '../theme/admin_theme_extensions.dart';

/// Admin image picker widget.
class AdminImagePicker extends StatefulWidget {
  const AdminImagePicker({
    required this.onImagePicked,
    required this.onImageRemoved,
    super.key,
    this.imageFile,
    this.imageUrl,
    this.aspectRatio = 16 / 9,
    this.height,
    this.label,
    this.helperText,
  });

  final File? imageFile;
  final String? imageUrl;
  final ValueChanged<File> onImagePicked;
  final VoidCallback onImageRemoved;
  final double aspectRatio;
  final double? height;
  final String? label;
  final String? helperText;

  @override
  State<AdminImagePicker> createState() => _AdminImagePickerState();
}

class _AdminImagePickerState extends State<AdminImagePicker> {
  final ImagePicker _picker = ImagePicker();
  bool _isPicking = false;

  Future<void> _pickImage(ImageSource source) async {
    try {
      setState(() => _isPicking = true);
      final pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1920,
        maxHeight: 1080,
      );

      if (pickedFile != null && mounted) {
        final file = File(pickedFile.path);
        widget.onImagePicked(file);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error picking image: $e'),
            backgroundColor: context.adminColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isPicking = false);
      }
    }
  }

  void _showImageSourceDialog() {
    final colors = context.adminColors;

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40.w,
                height: 4.h,
                margin: EdgeInsets.only(bottom: 16.h),
                decoration: BoxDecoration(
                  color: colors.outline.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              _SourceOption(
                icon: Iconsax.camera,
                title: 'Take Photo',
                subtitle: 'Use camera to capture',
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              _SourceOption(
                icon: Iconsax.gallery,
                title: 'Choose from Gallery',
                subtitle: 'Select from device',
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              if (widget.imageFile != null || widget.imageUrl != null)
                Divider(height: 32.h),
              if (widget.imageFile != null || widget.imageUrl != null)
                _SourceOption(
                  icon: Iconsax.trash,
                  title: 'Remove Image',
                  subtitle: 'Clear current image',
                  iconColor: colors.error,
                  textColor: colors.error,
                  onTap: () {
                    Navigator.pop(context);
                    widget.onImageRemoved();
                  },
                ),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.adminColors;
    final hasImage = widget.imageFile != null || widget.imageUrl != null;
    final effectiveHeight = widget.height ?? 280.h;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: colors.textPrimary,
            ),
          ),
          SizedBox(height: 8.h),
        ],
        GestureDetector(
          onTap: _isPicking ? null : _showImageSourceDialog,
          child: Container(
            width: double.infinity,
            height: effectiveHeight,
            decoration: BoxDecoration(
              color: hasImage ? Colors.transparent : colors.surfaceVariant,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: hasImage
                    ? colors.outline.withValues(alpha: 0.2)
                    : colors.outline.withValues(alpha: 0.3),
                width: 2.r,
              ),
            ),
            child: _isPicking
                ? _buildLoadingState(colors)
                : hasImage
                ? _buildImagePreview(colors, effectiveHeight)
                : _buildPlaceholder(colors),
          ),
        ),
        if (widget.helperText != null && !hasImage) ...[
          SizedBox(height: 8.h),
          Text(
            widget.helperText!,
            style: TextStyle(fontSize: 12.sp, color: colors.textTertiary),
          ),
        ],
      ],
    );
  }

  Widget _buildLoadingState(AdminAppColors colors) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: colors.primary),
          SizedBox(height: 16.h),
          Text(
            'Processing image...',
            style: TextStyle(fontSize: 14.sp, color: colors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePreview(AdminAppColors colors, double height) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(14.r),
          child: widget.imageFile != null
              ? Image.file(
                  widget.imageFile!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      _buildErrorPlaceholder(colors),
                )
              : widget.imageUrl != null
              ? Image.network(
                  widget.imageUrl!,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                            : null,
                        color: colors.primary,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) =>
                      _buildErrorPlaceholder(colors),
                )
              : _buildErrorPlaceholder(colors),
        ),
        // Overlay gradient for better button visibility
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14.r),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.3),
                ],
                stops: const [0.5, 1.0],
              ),
            ),
          ),
        ),
        // Edit button
        Positioned(
          top: 12.h,
          right: 12.w,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
                width: 1.r,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _showImageSourceDialog,
                borderRadius: BorderRadius.circular(12.r),
                child: Padding(
                  padding: EdgeInsets.all(10.r),
                  child: Icon(Iconsax.edit_2, size: 20.r, color: Colors.white),
                ),
              ),
            ),
          ),
        ),
        // Remove button
        Positioned(
          bottom: 12.h,
          right: 12.w,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: colors.error.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.onImageRemoved,
                borderRadius: BorderRadius.circular(12.r),
                child: Padding(
                  padding: EdgeInsets.all(10.r),
                  child: Icon(Iconsax.trash, size: 20.r, color: Colors.white),
                ),
              ),
            ),
          ),
        ),
        // Image info overlay (bottom left)
        Positioned(
          bottom: 12.h,
          left: 12.w,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Iconsax.image, size: 14.r, color: Colors.white),
                SizedBox(width: 6.w),
                Text(
                  widget.imageFile != null ? 'New Image' : 'Current Image',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholder(AdminAppColors colors) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(20.r),
          decoration: BoxDecoration(
            color: colors.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(Iconsax.gallery_add, size: 48.r, color: colors.primary),
        ),
        SizedBox(height: 16.h),
        Text(
          'Station Image',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: colors.textPrimary,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          'Tap to upload image',
          style: TextStyle(fontSize: 13.sp, color: colors.textSecondary),
        ),
        SizedBox(height: 8.h),
        Text(
          'Recommended: 1920x1080px, Max 5MB',
          style: TextStyle(fontSize: 11.sp, color: colors.textTertiary),
        ),
      ],
    );
  }

  Widget _buildErrorPlaceholder(AdminAppColors colors) {
    return ColoredBox(
      color: colors.surfaceVariant,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Iconsax.gallery_remove, size: 48.r, color: colors.textTertiary),
          SizedBox(height: 8.h),
          Text(
            'Failed to load image',
            style: TextStyle(fontSize: 14.sp, color: colors.textSecondary),
          ),
        ],
      ),
    );
  }
}

/// Source option widget for image picker bottom sheet.
class _SourceOption extends StatelessWidget {
  const _SourceOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.iconColor,
    this.textColor,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.adminColors;
    final effectiveIconColor = iconColor ?? colors.primary;
    final effectiveTextColor = textColor ?? colors.textPrimary;

    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(10.r),
        decoration: BoxDecoration(
          color: effectiveIconColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Icon(icon, size: 24.r, color: effectiveIconColor),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          color: effectiveTextColor,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 13.sp, color: colors.textSecondary),
      ),
      trailing: Icon(
        Iconsax.arrow_right_3,
        size: 20.r,
        color: colors.textTertiary,
      ),
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
    );
  }
}
