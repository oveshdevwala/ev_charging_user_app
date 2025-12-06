/// File: lib/features/home/ui/home_page.dart
/// Purpose: Advanced home screen with 6 high-value sections
/// Belongs To: home feature
/// Route: /userHome
/// Customization Guide:
///    - Add/remove sections by modifying the CustomScrollView slivers
///    - Customize section order and spacing
///    - All sections are modular and reusable
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/extensions/context_ext.dart';
import '../../../core/theme/app_colors.dart';
import '../../../features/nearby_offers/data/models/partner_offer_model.dart';
import '../../../models/bundle_model.dart';
import '../../../models/charging_session_model.dart';
import '../../../models/offer_model.dart';
import '../../../models/station_model.dart';
import '../../../models/trip_route_model.dart';
import '../../../repositories/home_repository.dart';
import '../../../repositories/station_repository.dart';
import '../../../routes/app_routes.dart';
import '../../../widgets/loading_wrapper.dart';
import '../bloc/home_cubit.dart';
import '../bloc/home_state.dart';
import '../widgets/home_header.dart';
import '../widgets/home_search_bar.dart';
import '../widgets/sections/sections.dart';

/// Advanced home page with 6 high-value sections.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(
        homeRepository: DummyHomeRepository(),
        stationRepository: DummyStationRepository(),
      )..loadHomeData(),
      child: const _HomePageContent(),
    );
  }
}

/// Home page content with BLoC consumer.
class _HomePageContent extends StatelessWidget {
  const _HomePageContent();

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state.isLoading && !state.hasData) {
              return const Center(child: LoadingIndicator());
            }

            if (state.hasError && !state.hasData) {
              return _buildErrorState(context, state.error!);
            }

            return RefreshIndicator(
              onRefresh: () => context.read<HomeCubit>().refreshHomeData(),
              color: colors.primary,
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                slivers: [
                  // Header Section
                  SliverToBoxAdapter(child: _buildHeader(context)),
                  // SECTION 1: Activity Summary
                  if (state.activitySummary != null)
                    SliverToBoxAdapter(
                      child: SectionActivityEnhanced(
                        summary: state.activitySummary!,
                        weeklyData: _getWeeklyData(),
                        onViewDetailsTap: () => _onActivityDetails(context),
                      ),
                    ),

                  // SECTION 2: Quick Actions (compact grid - FIRST after search)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(top: 24.h),
                      child: SectionCategoriesGrid(
                        onCategoryTap: (category) =>
                            _onCategoryTap(context, category),
                      ),
                    ),
                  ),

                  // SECTION 3: Nearby Stations
                  if (state.nearbyStations.isNotEmpty)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(top: 28.h),
                        child: SectionNearbyStations(
                          stations: state.nearbyStations,
                          onStationTap: (station) =>
                              _onStationTap(context, station),
                          onViewAllTap: () => _onStationsViewAll(context),
                          onFavoriteTap: (id) =>
                              context.read<HomeCubit>().toggleFavorite(id),
                        ),
                      ),
                    ),

                  // SECTION 3.5: Nearby Offers
                  if (state.nearbyOffers.isNotEmpty)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(top: 28.h),
                        child: SectionNearbyOffers(
                          offers: state.nearbyOffers,
                          onOfferTap: (offer) =>
                              _onNearbyOfferTap(context, offer),
                          onViewAllTap: () => _onNearbyOffersViewAll(context),
                        ),
                      ),
                    ),

                  // SECTION 4: Trip Planner
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(top: 28.h),
                      child: SectionTripPlanner(
                        savedRoutes: state.savedRoutes,
                        onRouteTap: (route) => _onRouteTap(context, route),
                        onPlanTripTap: () => _onPlanTrip(context),
                        onViewAllTap: () => _onTripsViewAll(context),
                      ),
                    ),
                  ),

                  // SECTION 5: Value Bundles
                  if (state.bundles.isNotEmpty)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(top: 28.h),
                        child: SectionBundles(
                          bundles: state.bundles,
                          onBundleTap: (bundle) =>
                              _onBundleTap(context, bundle),
                          onViewAllTap: () => _onBundlesViewAll(context),
                        ),
                      ),
                    ),

                  // SECTION 6: Offers (simple list - LAST section)
                  if (state.offers.isNotEmpty)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(top: 28.h),
                        child: SectionOffersCarousel(
                          offers: state.offers,
                          onOfferTap: (offer) => _onOfferTap(context, offer),
                          onViewAllTap: () => _onOffersViewAll(context),
                        ),
                      ),
                    ),

                  // Bottom spacing
                  SliverToBoxAdapter(child: SizedBox(height: 100.h)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  /// Generate weekly data for the activity chart.
  List<DailyChargingSummary> _getWeeklyData() {
    // For demo, return sample data - in production, fetch this in HomeCubit
    final now = DateTime.now();
    return List.generate(7, (index) {
      final date = now.subtract(Duration(days: 6 - index));
      return DailyChargingSummary(
        date: date,
        sessions: index == 6 ? 2 : (index % 3),
        energyKwh: index == 6 ? 45.5 : (15.0 + (index * 8)),
        cost: (15.0 + (index * 8)) * 0.35,
        co2SavedKg: (15.0 + (index * 8)) * 0.5,
        totalMinutes: 30 + (index * 10),
      );
    });
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.r),
      child: Column(
        children: [
          HomeHeader(
            userName: 'John Doe',
            onNotificationTap: () =>
                context.push(AppRoutes.userNotifications.path),
          ),
          SizedBox(height: 20.h),
          HomeSearchBar(onTap: () => context.go(AppRoutes.userSearch.path)),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String error) {
    final colors = context.appColors;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline_rounded, size: 64.r, color: colors.danger),
            SizedBox(height: 16.h),
            Text(
              'Something went wrong',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: colors.textPrimary,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              error,
              style: TextStyle(fontSize: 14.sp, color: colors.textSecondary),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            ElevatedButton(
              onPressed: () => context.read<HomeCubit>().loadHomeData(),
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primary,
                foregroundColor: colors.textPrimary,
                padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text(
                'Retry',
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Navigation handlers
  void _onActivityDetails(BuildContext context) {
    context.push(AppRoutes.activityDetails.path);
  }

  void _onOfferTap(BuildContext context, OfferModel offer) {
    context.read<HomeCubit>().selectOffer(offer.id);
    _showSnackBar(context, 'Offer: ${offer.titleKey}');
  }

  void _onOffersViewAll(BuildContext context) {
    _showSnackBar(context, 'View all offers');
  }

  void _onStationTap(BuildContext context, StationModel station) {
    context.push(AppRoutes.stationDetails.id(station.id));
  }

  void _onStationsViewAll(BuildContext context) {
    context.go(AppRoutes.userSearch.path);
  }

  void _onRouteTap(BuildContext context, TripRouteModel route) {
    // Navigate directly to standalone trip summary page
    context.push(AppRoutes.tripSummary.id(route.id));
  }

  void _onPlanTrip(BuildContext context) {
    // Navigate to trip planner to create a new trip
    context.push(AppRoutes.tripPlanner.path);
  }

  void _onTripsViewAll(BuildContext context) {
    // Navigate to trip history to see all completed trips
    context.push(AppRoutes.tripHistory.path);
  }

  void _onBundleTap(BuildContext context, BundleModel bundle) {
    // Navigate to value packs list screen
    // TODO: Map bundle to value pack ID if needed
    context.push(AppRoutes.valuePacksList.path);
  }

  void _onBundlesViewAll(BuildContext context) {
    // Navigate to value packs list screen
    context.push(AppRoutes.valuePacksList.path);
  }

  void _onCategoryTap(BuildContext context, HomeCategory category) {
    switch (category) {
      case HomeCategory.findCharger:
        context.go(AppRoutes.userSearch.path);
      case HomeCategory.bookSlot:
        context.go(AppRoutes.userSearch.path);
      case HomeCategory.myBookings:
        context.go(AppRoutes.userBookings.path);
      case HomeCategory.myVehicles:
        _showSnackBar(context, 'My Vehicles');
      case HomeCategory.chargingHistory:
        context.push(AppRoutes.activityDetails.path);
      case HomeCategory.tripPlanner:
        context.push(AppRoutes.tripPlanner.path);
    }
  }

  void _onNearbyOfferTap(BuildContext context, PartnerOfferModel offer) {
    context.push(AppRoutes.partnerDetail.id(offer.partnerId));
  }

  void _onNearbyOffersViewAll(BuildContext context) {
    context.push(AppRoutes.nearbyOffers.path);
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: EdgeInsets.all(16.r),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
