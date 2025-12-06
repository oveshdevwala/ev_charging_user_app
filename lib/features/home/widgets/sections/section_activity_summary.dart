// /// File: lib/features/home/widgets/sections/section_activity_summary.dart
// /// Purpose: Activity summary dashboard section
// /// Belongs To: home feature
// /// Customization Guide:
// ///    - Customize stat cards via ActivityStatCard
// ///    - Add more metrics as needed
// library;

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:iconsax/iconsax.dart';

// import '../../../../core/constants/app_strings.dart';
// import '../../../../core/theme/app_colors.dart';
// import '../../../../models/user_activity_model.dart';
// import '../components/activity_stat_card.dart';
// import '../section_header.dart';

// /// Activity summary section with quick metrics.
// class SectionActivitySummary extends StatelessWidget {
//   const SectionActivitySummary({
//     required this.summary, super.key,
//     this.onViewDetailsTap,
//   });

//   /// User activity summary data.
//   final UserActivitySummary summary;

//   /// Callback when view details is tapped.
//   final VoidCallback? onViewDetailsTap;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         SectionHeader(
//           title: AppStrings.activityTitle,
//           onViewAll: onViewDetailsTap,
//           actionText: AppStrings.viewDetails,
//           showAction: onViewDetailsTap != null,
//         ),
//         SizedBox(height: 16.h),
//         Padding(
//           padding: EdgeInsets.symmetric(horizontal: 20.w),
//           child: Column(
//             children: [
//               // Streak badge
//               if (summary.hasStreak) ...[
//                 StreakBadge(streaks: summary.streaks),
//                 SizedBox(height: 16.h),
//               ],

//               // Stats grid
//               Row(
//                 children: [
//                   Expanded(
//                     child: ActivityStatCard(
//                       icon: Iconsax.flash_1,
//                       label: AppStrings.activitySessionsToday,
//                       value: summary.sessionsToday.toString(),
//                       iconColor: AppColors.primary,
//                       isCompact: true,
//                     ),
//                   ),
//                   SizedBox(width: 12.w),
//                   Expanded(
//                     child: ActivityStatCard(
//                       icon: Iconsax.electricity,
//                       label: AppStrings.activityEnergy,
//                       value: summary.energyUsedKwh.toStringAsFixed(1),
//                       unit: 'kWh',
//                       iconColor: AppColors.secondary,
//                       isCompact: true,
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 12.h),
//               Row(
//                 children: [
//                   Expanded(
//                     child: ActivityStatCard(
//                       icon: Iconsax.wallet_2,
//                       label: AppStrings.activitySpent,
//                       value: '\$${summary.moneySpent.toStringAsFixed(0)}',
//                       iconColor: AppColors.warning,
//                       isCompact: true,
//                     ),
//                   ),
//                   SizedBox(width: 12.w),
//                   Expanded(
//                     child: ActivityStatCard(
//                       icon: Iconsax.tree,
//                       label: AppStrings.activityCo2Saved,
//                       value: summary.co2SavedKg.toStringAsFixed(1),
//                       unit: 'kg',
//                       iconColor: AppColors.success,
//                       isCompact: true,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

