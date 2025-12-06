/// File: lib/features/nearby_offers/presentation/screens/nearby_offers_screen.dart
/// Purpose: Main screen for displaying nearby offers
/// Belongs To: nearby_offers feature
/// Customization Guide:
///    - Customize filter sheet appearance
///    - Adjust grid/list layout
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../routes/app_routes.dart';
import '../../data/datasources/partner_remote_datasource.dart';
import '../blocs/nearby_offers/nearby_offers.dart';
import '../widgets/widgets.dart';

class NearbyOffersScreen extends StatelessWidget {
  const NearbyOffersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NearbyOffersBloc(getNearbyOffers: sl())
        ..add(
          const FetchNearbyOffers(latitude: 37.7749, longitude: -122.4194),
        ), // Dummy location
      child: const _NearbyOffersView(),
    );
  }
}

class _NearbyOffersView extends StatelessWidget {
  const _NearbyOffersView();

  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby Offers'),
        actions: [
          IconButton(
            icon: const Icon(Icons.map_outlined),
            onPressed: () {
              // Toggle map view (future implementation)
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Filters
          BlocBuilder<NearbyOffersBloc, NearbyOffersState>(
            builder: (context, state) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CategoryFilterBar(
                    selectedCategory: state.filterParams.category,
                    onCategorySelected: (category) {
                      context.read<NearbyOffersBloc>().add(
                        ApplyOfferFilters(category: category),
                      );
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Row(
                      children: [
                        ActionChip(
                          avatar: const Icon(Icons.tune, size: 16),
                          label: Text(
                            '${state.filterParams.radiusKm.toInt()} km',
                          ),
                          onPressed: () {
                            showModalBottomSheet<void>(
                              context: context,
                              builder: (_) => RadiusFilterSheet(
                                currentRadiusKm: state.filterParams.radiusKm,
                                onRadiusSelected: (radius) {
                                  context.read<NearbyOffersBloc>().add(
                                    ApplyOfferFilters(radiusKm: radius),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                        SizedBox(width: 8.w),
                        ActionChip(
                          avatar: const Icon(Icons.sort, size: 16),
                          label: Text(_getSortLabel(state.filterParams.sortBy)),
                          onPressed: () {
                            _showSortSheet(context);
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8.h),
                ],
              );
            },
          ),

          // List
          Expanded(
            child: BlocBuilder<NearbyOffersBloc, NearbyOffersState>(
              builder: (context, state) {
                if (state.status == NearbyOffersStatus.loading &&
                    state.offers.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.status == NearbyOffersStatus.error &&
                    state.offers.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 48,
                          color: Theme.of(context).colorScheme.error,
                        ),
                        SizedBox(height: 16.h),
                        Text(state.errorMessage ?? 'Something went wrong'),
                        SizedBox(height: 16.h),
                        ElevatedButton(
                          onPressed: () {
                            context.read<NearbyOffersBloc>().add(
                              const RefreshNearbyOffers(),
                            );
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                if (state.offers.isEmpty) {
                  return const Center(child: Text('No offers found nearby'));
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<NearbyOffersBloc>().add(
                      const RefreshNearbyOffers(),
                    );
                  },
                  child: ListView.builder(
                    padding: EdgeInsets.all(16.r),
                    itemCount:
                        state.offers.length + (state.hasReachedMax ? 0 : 1),
                    itemBuilder: (context, index) {
                      if (index >= state.offers.length) {
                        context.read<NearbyOffersBloc>().add(
                          const LoadMoreOffers(),
                        );
                        return const Center(child: CircularProgressIndicator());
                      }

                      final offer = state.offers[index];
                      return OfferCard(
                        offer: offer,
                        onTap: () {
                          // Navigate to partner detail
                          context.push(
                            AppRoutes.partnerDetail.id(offer.partnerId),
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _getSortLabel(OfferSortType type) {
    switch (type) {
      case OfferSortType.distance:
        return 'Distance';
      case OfferSortType.discount:
        return 'Discount';
      case OfferSortType.trending:
        return 'Trending';
      case OfferSortType.newest:
        return 'Newest';
      case OfferSortType.expiringSoon:
        return 'Expiring';
    }
  }

  void _showSortSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (_) => Container(
        padding: EdgeInsets.all(24.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Sort By', style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 16.h),
            ...OfferSortType.values.map(
              (type) => ListTile(
                title: Text(_getSortLabel(type)),
                onTap: () {
                  context.read<NearbyOffersBloc>().add(
                    ApplyOfferFilters(sortBy: type),
                  );
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
