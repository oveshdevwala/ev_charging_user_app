/// File: lib/features/home/widgets/sections/section_bundles.dart
/// Purpose: Recommended bundles/subscriptions section
/// Belongs To: home feature
/// Customization Guide:
///    - Customize bundle cards via BundleCard component
///    - Add more bundle types as needed
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../models/bundle_model.dart';
import '../components/bundle_card.dart';
import '../section_header.dart';

/// Recommended bundles section.
class SectionBundles extends StatelessWidget {
  const SectionBundles({
    required this.bundles,
    required this.onBundleTap,
    required this.onViewAllTap,
    super.key,
  });

  /// List of bundles.
  final List<BundleModel> bundles;

  /// Callback when a bundle is tapped.
  final void Function(BundleModel bundle) onBundleTap;

  /// Callback when view all is tapped.
  final VoidCallback onViewAllTap;

  @override
  Widget build(BuildContext context) {
    if (bundles.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: AppStrings.bundlesTitle, onViewAll: onViewAllTap),
        SizedBox(height: 16.h),
        SizedBox(
          height: 235.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            physics: const BouncingScrollPhysics(),
            itemCount: bundles.length,
            itemBuilder: (context, index) {
              final bundle = bundles[index];
              return Padding(
                padding: EdgeInsets.only(right: 16.w),
                child: BundleCard(
                  bundle: bundle,
                  onTap: () => onBundleTap(bundle),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
