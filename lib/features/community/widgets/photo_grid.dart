/// File: lib/features/community/widgets/photo_grid.dart
/// Purpose: Photo grid and gallery widgets
/// Belongs To: community feature
/// Customization Guide:
///    - Adjust grid columns, spacing via parameters
///    - Supports full-screen viewer with gestures
library;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/theme/app_colors.dart';
import '../models/models.dart';

/// Photo grid widget for displaying community photos.
class PhotoGrid extends StatelessWidget {
  const PhotoGrid({
    required this.photos, super.key,
    this.crossAxisCount = 3,
    this.spacing = 8,
    this.onPhotoTap,
    this.onLoadMore,
    this.hasMore = false,
    this.isLoading = false,
  });

  final List<CommunityPhotoModel> photos;
  final int crossAxisCount;
  final double spacing;
  final ValueChanged<int>? onPhotoTap;
  final VoidCallback? onLoadMore;
  final bool hasMore;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    if (photos.isEmpty) {
      return const EmptyPhotosWidget();
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: spacing.w,
        mainAxisSpacing: spacing.h,
      ),
      itemCount: photos.length + (hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == photos.length && hasMore) {
          return _buildLoadMore();
        }
        return _PhotoTile(
          photo: photos[index],
          onTap: () => onPhotoTap?.call(index),
        );
      },
    );
  }

  Widget _buildLoadMore() {
    return GestureDetector(
      onTap: isLoading ? null : onLoadMore,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.surfaceVariantLight,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Center(
          child: isLoading
              ? SizedBox(
                  width: 24.r,
                  height: 24.r,
                  child: const CircularProgressIndicator(strokeWidth: 2),
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Iconsax.arrow_down,
                      size: 24.r,
                      color: AppColors.textSecondaryLight,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Load more',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

/// Single photo tile in grid.
class _PhotoTile extends StatelessWidget {
  const _PhotoTile({
    required this.photo,
    required this.onTap,
  });

  final CommunityPhotoModel photo;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.r),
        child: CachedNetworkImage(
          imageUrl: photo.thumbnailUrl ?? photo.url,
          fit: BoxFit.cover,
          placeholder: (context, url) => ColoredBox(
            color: AppColors.outlineLight,
            child: Center(
              child: SizedBox(
                width: 20.r,
                height: 20.r,
                child: const CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          ),
          errorWidget: (context, url, error) => ColoredBox(
            color: AppColors.outlineLight,
            child: Icon(
              Iconsax.image,
              size: 24.r,
              color: AppColors.textTertiaryLight,
            ),
          ),
        ),
      ),
    );
  }
}

/// Full-screen photo viewer.
class PhotoViewer extends StatefulWidget {
  const PhotoViewer({
    required this.photos, required this.initialIndex, super.key,
    this.onReport,
    this.onDownload,
  });

  final List<CommunityPhotoModel> photos;
  final int initialIndex;
  final ValueChanged<CommunityPhotoModel>? onReport;
  final ValueChanged<CommunityPhotoModel>? onDownload;

  @override
  State<PhotoViewer> createState() => _PhotoViewerState();
}

class _PhotoViewerState extends State<PhotoViewer> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Photo viewer
          PageView.builder(
            controller: _pageController,
            itemCount: widget.photos.length,
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
            },
            itemBuilder: (context, index) {
              return InteractiveViewer(
                minScale: 0.5,
                maxScale: 4,
                child: Center(
                  child: CachedNetworkImage(
                    imageUrl: widget.photos[index].url,
                    fit: BoxFit.contain,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                    errorWidget: (context, url, error) => Icon(
                      Iconsax.image,
                      size: 64.r,
                      color: Colors.white54,
                    ),
                  ),
                ),
              );
            },
          ),

          // Top bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(
                        Iconsax.close_circle,
                        size: 28.r,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${_currentIndex + 1} / ${widget.photos.length}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => _showOptions(context),
                      icon: Icon(
                        Iconsax.more,
                        size: 24.r,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Caption (if any)
          if (widget.photos[_currentIndex].caption != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Container(
                  padding: EdgeInsets.all(16.r),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black87],
                    ),
                  ),
                  child: Text(
                    widget.photos[_currentIndex].caption!,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showOptions(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        margin: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.onDownload != null)
              ListTile(
                leading: Icon(Iconsax.arrow_down, size: 24.r),
                title: const Text('Download'),
                onTap: () {
                  Navigator.pop(context);
                  widget.onDownload?.call(widget.photos[_currentIndex]);
                },
              ),
            if (widget.onReport != null)
              ListTile(
                leading: Icon(Iconsax.flag, size: 24.r, color: AppColors.error),
                title: const Text(
                  'Report',
                  style: TextStyle(color: AppColors.error),
                ),
                onTap: () {
                  Navigator.pop(context);
                  widget.onReport?.call(widget.photos[_currentIndex]);
                },
              ),
            SizedBox(height: 8.h),
          ],
        ),
      ),
    );
  }
}

/// Empty photos placeholder.
class EmptyPhotosWidget extends StatelessWidget {
  const EmptyPhotosWidget({
    super.key,
    this.onUpload,
  });

  final VoidCallback? onUpload;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Iconsax.gallery,
              size: 64.r,
              color: AppColors.outlineLight,
            ),
            SizedBox(height: 16.h),
            Text(
              'No photos yet',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimaryLight,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Be the first to share a photo of this station',
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textSecondaryLight,
              ),
              textAlign: TextAlign.center,
            ),
            if (onUpload != null) ...[
              SizedBox(height: 24.h),
              ElevatedButton.icon(
                onPressed: onUpload,
                icon: Icon(Iconsax.camera, size: 18.r),
                label: const Text('Upload Photo'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

