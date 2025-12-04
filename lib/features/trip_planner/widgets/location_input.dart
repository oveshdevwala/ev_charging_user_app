/// File: lib/features/trip_planner/widgets/location_input.dart
/// Purpose: Location input widget with autocomplete
/// Belongs To: trip_planner feature
/// Customization Guide:
///    - Customize appearance via parameters
///    - Hook up to places API for real autocomplete
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/theme/app_colors.dart';
import '../models/models.dart';

/// Location input type.
enum LocationInputType {
  origin,
  destination,
  waypoint,
}

/// Location input widget with search and autocomplete.
class LocationInput extends StatelessWidget {
  const LocationInput({
    required this.type, required this.onTap, super.key,
    this.location,
    this.onClear,
    this.placeholder,
    this.enabled = true,
  });

  final LocationInputType type;
  final LocationModel? location;
  final VoidCallback onTap;
  final VoidCallback? onClear;
  final String? placeholder;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final hasLocation = location != null;
    
    final IconData icon;
    final Color iconColor;
    final String defaultPlaceholder;
    
    switch (type) {
      case LocationInputType.origin:
        icon = Iconsax.location;
        iconColor = AppColors.primary;
        defaultPlaceholder = 'Enter origin';
        break;
      case LocationInputType.destination:
        icon = Iconsax.flag;
        iconColor = AppColors.error;
        defaultPlaceholder = 'Enter destination';
        break;
      case LocationInputType.waypoint:
        icon = Iconsax.add_circle;
        iconColor = AppColors.secondary;
        defaultPlaceholder = 'Add waypoint';
        break;
    }

    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: enabled
              ? Theme.of(context).cardColor
              : AppColors.surfaceVariantLight,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: hasLocation
                ? iconColor.withValues(alpha: 0.5)
                : AppColors.outlineLight,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 36.r,
              height: 36.r,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                icon,
                size: 18.r,
                color: iconColor,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (hasLocation) ...[
                    Text(
                      location!.name ?? location!.shortDisplay,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimaryLight,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (location!.address != null) ...[
                      SizedBox(height: 2.h),
                      Text(
                        location!.address!,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.textSecondaryLight,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ] else ...[
                    Text(
                      placeholder ?? defaultPlaceholder,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.textTertiaryLight,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (hasLocation && onClear != null)
              GestureDetector(
                onTap: onClear,
                child: Container(
                  padding: EdgeInsets.all(4.r),
                  child: Icon(
                    Iconsax.close_circle,
                    size: 20.r,
                    color: AppColors.textSecondaryLight,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Origin/Destination input pair with swap button.
class LocationInputPair extends StatelessWidget {
  const LocationInputPair({
    required this.onOriginTap, required this.onDestinationTap, super.key,
    this.origin,
    this.destination,
    this.onSwap,
    this.onOriginClear,
    this.onDestinationClear,
  });

  final LocationModel? origin;
  final LocationModel? destination;
  final VoidCallback onOriginTap;
  final VoidCallback onDestinationTap;
  final VoidCallback? onSwap;
  final VoidCallback? onOriginClear;
  final VoidCallback? onDestinationClear;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Inputs
        Expanded(
          child: Column(
            children: [
              LocationInput(
                type: LocationInputType.origin,
                location: origin,
                onTap: onOriginTap,
                onClear: onOriginClear,
              ),
              // Connector line
              Container(
                margin: EdgeInsets.only(left: 34.w),
                child: Row(
                  children: [
                    Container(
                      width: 2,
                      height: 16.h,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppColors.primary,
                            AppColors.error,
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              LocationInput(
                type: LocationInputType.destination,
                location: destination,
                onTap: onDestinationTap,
                onClear: onDestinationClear,
              ),
            ],
          ),
        ),
        // Swap button
        if (onSwap != null) ...[
          SizedBox(width: 8.w),
          Padding(
            padding: EdgeInsets.only(top: 45.h),
            child: GestureDetector(
              onTap: onSwap,
              child: Container(
                width: 40.r,
                height: 40.r,
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariantLight,
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(
                    color: AppColors.outlineLight,
                  ),
                ),
                child: Icon(
                  Iconsax.arrow_swap_horizontal,
                  size: 18.r,
                  color: AppColors.textSecondaryLight,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

/// Location search results list.
class LocationSearchResults extends StatelessWidget {
  const LocationSearchResults({
    required this.results, required this.onLocationSelected, super.key,
    this.isLoading = false,
  });

  final List<LocationModel> results;
  final ValueChanged<LocationModel> onLocationSelected;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Padding(
        padding: EdgeInsets.all(24.r),
        child: const Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.primary,
          ),
        ),
      );
    }

    if (results.isEmpty) {
      return Padding(
        padding: EdgeInsets.all(24.r),
        child: Center(
          child: Text(
            'No locations found',
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textSecondaryLight,
            ),
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: results.length,
      separatorBuilder: (_, _) => const Divider(
        height: 1,
        color: AppColors.outlineLight,
      ),
      itemBuilder: (context, index) {
        final location = results[index];
        return ListTile(
          onTap: () => onLocationSelected(location),
          leading: Container(
            width: 36.r,
            height: 36.r,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              Iconsax.location,
              size: 18.r,
              color: AppColors.primary,
            ),
          ),
          title: Text(
            location.name ?? location.shortDisplay,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimaryLight,
            ),
          ),
          subtitle: location.address != null
              ? Text(
                  location.address!,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.textSecondaryLight,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )
              : null,
          trailing: Icon(
            Iconsax.arrow_right_3,
            size: 16.r,
            color: AppColors.textTertiaryLight,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
        );
      },
    );
  }
}

