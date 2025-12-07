/// File: lib/features/trip_history/presentation/screens/trip_history_screen.dart
/// Purpose: Trip history screen displaying completed trips
/// Belongs To: trip_history feature
/// Route: AppRoutes.tripHistory
/// Customization Guide:
///    - Adjust list item spacing and padding
///    - Customize empty state message
library;

import 'package:ev_charging_user_app/core/di/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/extensions/context_ext.dart';
import '../../../../routes/app_routes.dart';
import '../../../../widgets/app_app_bar.dart';
import '../bloc/trip_history_bloc.dart';
import '../bloc/trip_history_event.dart';
import '../bloc/trip_history_state.dart';
import '../widgets/trip_tile.dart';

/// Trip history screen showing all completed trips.
class TripHistoryScreen extends StatelessWidget {
  const TripHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<TripHistoryBloc>()..add(FetchCompletedTrips()),
      child: Scaffold(
        appBar: AppAppBar(
          title: AppStrings.tripPlannerRecentTrips,
        ),
        body: BlocBuilder<TripHistoryBloc, TripHistoryState>(
          builder: (context, state) {
            if (state is TripHistoryLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is TripHistoryLoaded) {
              final trips = state.completedTrips;
              
              if (trips.isEmpty) {
                return _buildEmptyState(context);
              }

              return RefreshIndicator(
                onRefresh: () async {
                  context.read<TripHistoryBloc>().add(FetchCompletedTrips());
                },
                child: ListView.builder(
                  padding: EdgeInsets.all(16.r),
                  itemCount: trips.length,
                  itemBuilder: (context, index) {
                    final trip = trips[index];
                    return TripTile(
                      trip: trip,
                      onTap: () {
                        context.pushToWithId(AppRoutes.tripSummary, trip.id);
                      },
                      onFavoriteTap: () {
                        context.read<TripHistoryBloc>().add(
                              ToggleTripFavorite(trip.id),
                            );
                      },
                    );
                  },
                ),
              );
            } else if (state is TripHistoryError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      state.message,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: context.appColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    ElevatedButton(
                      onPressed: () {
                        context.read<TripHistoryBloc>().add(FetchCompletedTrips());
                      },
                      child: const Text(AppStrings.retry),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final colors = context.appColors;
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.route_outlined,
              size: 64.r,
              color: colors.textSecondary,
            ),
            SizedBox(height: 16.h),
            Text(
              'No trips yet',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: colors.textPrimary,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Your completed trips will appear here',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: colors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}