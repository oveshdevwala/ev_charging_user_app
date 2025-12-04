/// File: lib/features/trip_planner/ui/trip_planner_page.dart
/// Purpose: Main trip planner page that handles step navigation
/// Belongs To: trip_planner feature
/// Route: AppRoutes.tripPlanner
/// Customization Guide:
///    - Add animation transitions between steps
///    - Add step indicator
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/bloc.dart';
import '../repositories/trip_planner_repository.dart';
import 'charging_stops_page.dart';
import 'insights_page.dart';
import 'trip_create_page.dart';
import 'trip_detail_page.dart';
import 'trip_planner_home_page.dart';
import 'trip_summary_page.dart';

/// Main trip planner page with step-based navigation.
class TripPlannerPage extends StatelessWidget {
  const TripPlannerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TripPlannerCubit(
        repository: DummyTripPlannerRepository(),
      )..initialize(),
      child: BlocBuilder<TripPlannerCubit, TripPlannerState>(
        buildWhen: (prev, curr) => prev.step != curr.step,
        builder: (context, state) {
          return PopScope(
            canPop: state.step == TripPlanningStep.home,
            onPopInvokedWithResult: (didPop, result) {
              if (!didPop) {
                // Handle back navigation within trip planner
                _handleBackNavigation(context, state.step);
              }
            },
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _buildPage(state.step),
            ),
          );
        },
      ),
    );
  }

  void _handleBackNavigation(BuildContext context, TripPlanningStep step) {
    final cubit = context.read<TripPlannerCubit>();
    
    switch (step) {
      case TripPlanningStep.home:
        // Already at home, system will handle pop
        break;
      case TripPlanningStep.input:
        cubit.goToHome();
      case TripPlanningStep.calculating:
        cubit.goBackToInput();
      case TripPlanningStep.summary:
        cubit.goBackToInput();
      case TripPlanningStep.stops:
      case TripPlanningStep.insights:
      case TripPlanningStep.detail:
        cubit.goToSummary();
    }
  }

  Widget _buildPage(TripPlanningStep step) {
    switch (step) {
      case TripPlanningStep.home:
        return const TripPlannerHomePage(key: ValueKey('home'));
      case TripPlanningStep.input:
        return const TripCreatePage(key: ValueKey('create'));
      case TripPlanningStep.calculating:
        return const _CalculatingPage(key: ValueKey('calculating'));
      case TripPlanningStep.summary:
        return const TripSummaryPage(key: ValueKey('summary'));
      case TripPlanningStep.stops:
        return const ChargingStopsPage(key: ValueKey('stops'));
      case TripPlanningStep.insights:
        return const InsightsPage(key: ValueKey('insights'));
      case TripPlanningStep.detail:
        return const TripDetailPage(key: ValueKey('detail'));
    }
  }
}

/// Calculating/loading page shown during trip calculation.
class _CalculatingPage extends StatelessWidget {
  const _CalculatingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 24),
            Text(
              'Calculating your trip...',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Finding the best charging stops',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
