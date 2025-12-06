/// File: lib/features/value_packs/presentation/screens/value_pack_detail_screen.dart
/// Purpose: Value pack detail screen with full information
/// Belongs To: value_packs feature
/// Route: AppRoutes.valuePackDetail
/// Customization Guide:
///    - Add more sections as needed
///    - Customize hero image display
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/extensions/context_ext.dart';
import '../../../../routes/app_routes.dart';
import '../../../../widgets/app_app_bar.dart';
import '../../../../widgets/common_button.dart';
import '../../../../widgets/loading_wrapper.dart';
import '../../domain/entities/value_pack.dart';
import '../cubits/cubits.dart';
import '../widgets/widgets.dart';

/// Value pack detail screen.
class ValuePackDetailScreen extends StatelessWidget {
  const ValuePackDetailScreen({required this.packId, super.key});

  final String packId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ValuePackDetailCubit(
            sl(),
            sl(),
          )..load(packId),
      child: _ValuePackDetailView(packId: packId),
    );
  }
}

class _ValuePackDetailView extends StatelessWidget {
  const _ValuePackDetailView({required this.packId});

  final String packId;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = context.text;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppAppBar(
        title: AppStrings.valuePackDetails,
        actions: [
          BlocBuilder<ValuePackDetailCubit, ValuePackDetailState>(
            builder: (context, state) {
              return IconButton(
                icon: Icon(state.isSaved ? Iconsax.heart5 : Iconsax.heart),
                onPressed: () =>
                    context.read<ValuePackDetailCubit>().toggleSave(),
              );
            },
          ),
          IconButton(
            icon: const Icon(Iconsax.share),
            onPressed: () {
              // TODO: Implement share
            },
          ),
        ],
      ),
      body: BlocBuilder<ValuePackDetailCubit, ValuePackDetailState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const LoadingWrapper(
              isLoading: true,
              child: SizedBox.shrink(),
            );
          }

          if (state.hasError || state.pack == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Iconsax.danger, size: 64.r, color: context.colors.error),
                  SizedBox(height: 16.h),
                  Text(
                    state.error ?? 'Value pack not found',
                    style: textTheme.bodyLarge?.copyWith(
                      color: colors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24.h),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<ValuePackDetailCubit>().load(packId),
                    child: const Text(AppStrings.retry),
                  ),
                ],
              ),
            );
          }

          final pack = state.pack!;

          return CustomScrollView(
            slivers: [
              // Hero Image
              if (pack.heroImageUrl != null)
                SliverToBoxAdapter(
                  child: Container(
                    height: 250.h,
                    decoration: BoxDecoration(
                      color: colors.surfaceContainer,
                    ),
                    child: Image.network(
                      pack.heroImageUrl!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Icon(
                            Iconsax.image,
                            size: 64.r,
                            color: colors.textTertiary,
                          ),
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        }
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                    ),
                  ),
                ),

              // Content
              SliverPadding(
                padding: EdgeInsets.all(16.r),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Title and Rating
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                pack.title,
                                style: textTheme.headlineSmall?.copyWith(
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.bold,
                                  color: colors.textPrimary,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                pack.subtitle,
                                style: textTheme.bodyLarge?.copyWith(
                                  fontSize: 16.sp,
                                  color: colors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Rating
                        Row(
                          children: [
                            Icon(
                              Iconsax.star1,
                              size: 20.r,
                              color: colors.warning,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              pack.rating.toStringAsFixed(1),
                              style: textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              '(${pack.reviewsCount})',
                              style: textTheme.bodySmall?.copyWith(
                                color: colors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    SizedBox(height: 16.h),

                    // Price Badge
                    PriceBadge(
                      price: pack.price,
                      currency: pack.priceCurrency,
                      oldPrice: pack.oldPrice,
                      billingCycle: pack.billingCycle,
                    ),

                    SizedBox(height: 24.h),

                    // Description
                    Text(
                      pack.description,
                      style: textTheme.bodyMedium?.copyWith(
                        fontSize: 15.sp,
                        color: colors.textPrimary,
                        height: 1.5,
                      ),
                    ),

                    SizedBox(height: 24.h),

                    // Features
                    Text(
                      'Features',
                      style: textTheme.titleMedium?.copyWith(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: pack.features.map((feature) {
                        return FeatureChip(label: feature);
                      }).toList(),
                    ),

                    SizedBox(height: 24.h),

                    // Tags
                    if (pack.tags.isNotEmpty) ...[
                      Wrap(
                        spacing: 8.w,
                        runSpacing: 8.h,
                        children: pack.tags.map((tag) {
                          return TagBadge(label: tag);
                        }).toList(),
                      ),
                      SizedBox(height: 24.h),
                    ],

                    // Related Packs
                    if (state.relatedPacks.isNotEmpty) ...[
                      Text(
                        'Related Packs',
                        style: textTheme.titleMedium?.copyWith(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      SizedBox(
                        height: 200.h,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: state.relatedPacks.length,
                          itemBuilder: (context, index) {
                            final relatedPack = state.relatedPacks[index];
                            return SizedBox(
                              width: 280.w,
                              child: Padding(
                                padding: EdgeInsets.only(right: 12.w),
                                child: ValuePackCard(
                                  pack: relatedPack,
                                  onTap: () {
                                    // Navigate to related pack detail
                                  },
                                  isCompact: true,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 24.h),
                    ],
                  ]),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar:
          BlocBuilder<ValuePackDetailCubit, ValuePackDetailState>(
            builder: (context, state) {
              if (state.pack == null) {
                return const SizedBox.shrink();
              }

              final pack = state.pack!;

              return Container(
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: colors.surface,
                  boxShadow: [
                    BoxShadow(
                      color: colors.shadow,
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Row(
                    children: [
                      Expanded(
                        child: CommonButton(
                          label: pack.billingCycle == BillingCycle.oneTime
                              ? AppStrings.buyNow
                              : AppStrings.subscribe,
                           onPressed: pack.isAvailable
                               ? () {
                                   context.pushToWithId(
                                     AppRoutes.purchasePack,
                                     pack.id,
                                   );
                                 }
                               : null,
                          isDisabled: !pack.isAvailable,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      IconButton(
                        icon: const Icon(Iconsax.document),
                        onPressed: () {
                          // Show preview invoice
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
    );
  }
}
