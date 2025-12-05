/// File: lib/features/nearby_offers/presentation/screens/partner_detail_screen.dart
/// Purpose: Partner details screen with offers and check-in
/// Belongs To: nearby_offers feature
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../routes/app_routes.dart';
import '../blocs/checkin_rewards/checkin_rewards.dart';
import '../blocs/partner_detail/partner_detail.dart';
import '../widgets/widgets.dart';
import 'check_in_success_screen.dart';

class PartnerDetailScreen extends StatelessWidget {
  const PartnerDetailScreen({required this.partnerId, super.key});

  final String partnerId;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              PartnerDetailBloc(partnerRepository: sl())
                ..add(LoadPartnerDetail(partnerId)),
        ),
        BlocProvider(
          create: (context) =>
              CheckInRewardsBloc(checkInPartner: sl(), analyticsService: sl()),
        ),
      ],
      child: const _PartnerDetailView(),
    );
  }
}

class _PartnerDetailView extends StatelessWidget {
  const _PartnerDetailView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<CheckInRewardsBloc, CheckInRewardsState>(
      listener: (context, state) {
        if (state.status == CheckInStatus.success &&
            state.checkInResult != null) {
          // Navigate to success screen
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) =>
                  CheckInSuccessScreen(checkIn: state.checkInResult!),
            ),
          );
        } else if (state.status == CheckInStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage ?? 'Check-in failed')),
          );
        }
      },
      child: Scaffold(
        body: BlocBuilder<PartnerDetailBloc, PartnerDetailState>(
          builder: (context, state) {
            if (state.status == PartnerDetailStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.status == PartnerDetailStatus.error ||
                state.partner == null) {
              return const Center(child: Text('Partner not found'));
            }

            final partner = state.partner!;

            return CustomScrollView(
              slivers: [
                // App Bar with Image
                SliverAppBar(
                  expandedHeight: 250.h,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(partner.name),
                    background: partner.imageUrl != null
                        ? Image.network(partner.imageUrl!, fit: BoxFit.cover)
                        : Container(color: theme.colorScheme.primaryContainer),
                  ),
                ),

                // Content
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(16.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Partner Info
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.amber, size: 20.sp),
                            SizedBox(width: 4.w),
                            Text(
                              '${partner.rating} (${partner.reviewCount} reviews)',
                              style: theme.textTheme.bodyMedium,
                            ),
                            const Spacer(),
                            if (partner.distance != null)
                              DistanceChip(distanceKm: partner.distance),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          partner.description ?? '',
                          style: theme.textTheme.bodyMedium,
                        ),
                        SizedBox(height: 24.h),

                        // Check-in Button
                        BlocBuilder<CheckInRewardsBloc, CheckInRewardsState>(
                          builder: (context, checkInState) {
                            return CheckInButton(
                              isLoading:
                                  checkInState.status == CheckInStatus.loading,
                              onTap: () {
                                context.read<CheckInRewardsBloc>().add(
                                  PerformCheckIn(
                                    partnerId: partner.id,
                                    userId:
                                        'user_123', // TODO: Get real user ID
                                    userLatitude:
                                        37.7749, // TODO: Get real location
                                    userLongitude: -122.4194,
                                  ),
                                );
                              },
                            );
                          },
                        ),
                        SizedBox(height: 24.h),

                        // Map Preview
                        Text(
                          'Location',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        MapPreviewWidget(
                          latitude: partner.latitude,
                          longitude: partner.longitude,
                        ),
                        SizedBox(height: 24.h),

                        // Offers
                        if (state.offers.isNotEmpty) ...[
                          Text(
                            'Active Offers',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          ...state.offers.map(
                            (offer) => OfferCard(
                              offer: offer,
                              onTap: () {
                                context.push(
                                  AppRoutes.offerRedeem.id(offer.id),
                                  extra: offer.id, // Pass ID as extra if needed
                                );
                              },
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
