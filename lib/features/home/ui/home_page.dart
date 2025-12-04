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

import '../../../core/theme/app_colors.dart';
import '../../../models/bundle_model.dart';
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
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
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
              color: AppColors.primary,
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                slivers: [
                  // Header Section
                  SliverToBoxAdapter(child: _buildHeader(context)),

                  // Offers Carousel
                  if (state.offers.isNotEmpty)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(top: 24.h),
                        child: SectionOffersCarousel(
                          offers: state.offers,
                          onOfferTap: (offer) => _onOfferTap(context, offer),
                          onViewAllTap: () => _onOffersViewAll(context),
                        ),
                      ),
                    ),

                  // Activity Summary
                  if (state.activitySummary != null)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(top: 28.h),
                        child: SectionActivitySummary(
                          summary: state.activitySummary!,
                          onViewDetailsTap: () => _onActivityDetails(context),
                        ),
                      ),
                    ),

                  // Nearby Stations
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

                  // Trip Planner
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

                  // Value Bundles
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

                  // Categories Grid
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(top: 28.h),
                      child: SectionCategoriesGrid(
                        onCategoryTap: (category) =>
                            _onCategoryTap(context, category),
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
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 64.r,
              color: AppColors.error,
            ),
            SizedBox(height: 16.h),
            Text(
              'Something went wrong',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimaryLight,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              error,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textSecondaryLight,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            ElevatedButton(
              onPressed: () => context.read<HomeCubit>().loadHomeData(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
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
  void _onOfferTap(BuildContext context, OfferModel offer) {
    context.read<HomeCubit>().selectOffer(offer.id);
    // TODO: Navigate to offer details when page is created
    context.showSnackBar('Offer: ${offer.titleKey}');
  }

  void _onOffersViewAll(BuildContext context) {
    // TODO: Navigate to offers page when created
    context.showSnackBar('View all offers');
  }

  void _onActivityDetails(BuildContext context) {
    // TODO: Navigate to activity details page when created
    context.showSnackBar('View activity details');
  }

  void _onStationTap(BuildContext context, StationModel station) {
    context.push(AppRoutes.stationDetails.id(station.id));
  }

  void _onStationsViewAll(BuildContext context) {
    context.go(AppRoutes.userSearch.path);
  }

  void _onRouteTap(BuildContext context, TripRouteModel route) {
    // TODO: Navigate to trip details when page is created
    context.showSnackBar('Route: ${route.displayName}');
  }

  void _onPlanTrip(BuildContext context) {
    // TODO: Navigate to trip planner when page is created
    context.showSnackBar('Plan a new trip');
  }

  void _onTripsViewAll(BuildContext context) {
    // TODO: Navigate to saved trips when page is created
    context.showSnackBar('View all trips');
  }

  void _onBundleTap(BuildContext context, BundleModel bundle) {
    // TODO: Navigate to bundle details when page is created
    context.showSnackBar('Bundle: ${bundle.titleKey}');
  }

  void _onBundlesViewAll(BuildContext context) {
    // TODO: Navigate to bundles page when created
    context.showSnackBar('View all bundles');
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
        // TODO: Navigate to vehicles page when created
        context.showSnackBar('My Vehicles');
      case HomeCategory.chargingHistory:
        context.go(AppRoutes.userBookings.path);
      case HomeCategory.support:
        // TODO: Navigate to support page when created
        context.showSnackBar('Support');
    }
  }
}

/// Extension for showing snackbars.
extension _SnackBarExt on BuildContext {
  void showSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
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
