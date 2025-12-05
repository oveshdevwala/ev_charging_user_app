import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/di/injection.dart';
import '../bloc/trip_history_bloc.dart';
import '../bloc/trip_history_event.dart';
import '../bloc/trip_history_state.dart';
import '../widgets/cost_trend_chart.dart';
import '../widgets/energy_bar_chart.dart';
import '../widgets/monthly_summary_card.dart';
import '../widgets/trip_list_item.dart';

class TripHistoryScreen extends StatelessWidget {
  const TripHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<TripHistoryBloc>()..add(FetchTripHistory()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Trip History & Analytics'),
          actions: [
            BlocConsumer<TripHistoryBloc, TripHistoryState>(
              listener: (context, state) {
                if (state is TripHistoryExported) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Report exported to ${state.file.path}'),
                      action: SnackBarAction(
                        label: 'Open',
                        onPressed: () {
                          // Open file logic
                        },
                      ),
                    ),
                  );
                } else if (state is TripHistoryError) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.message)));
                }
              },
              builder: (context, state) {
                if (state is TripHistoryExporting) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.only(right: 16.0),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  );
                }
                return IconButton(
                  icon: const Icon(Icons.download),
                  onPressed: () {
                    final currentMonth = DateTime.now()
                        .toIso8601String()
                        .substring(0, 7);
                    context.read<TripHistoryBloc>().add(
                      ExportReportPDF(currentMonth),
                    );
                  },
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<TripHistoryBloc, TripHistoryState>(
          builder: (context, state) {
            if (state is TripHistoryLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is TripHistoryLoaded) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<TripHistoryBloc>().add(FetchTripHistory());
                },
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (state.analytics != null) ...[
                              MonthlySummaryCard(analytics: state.analytics!),
                              SizedBox(height: 24.h),
                              CostTrendChart(
                                trendData: state.analytics!.trendData,
                              ),
                              SizedBox(height: 24.h),
                              EnergyBarChart(
                                trendData: state.analytics!.trendData,
                              ),
                              SizedBox(height: 24.h),
                            ],
                            Text(
                              'Recent Trips',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 12.h),
                          ],
                        ),
                      ),
                    ),
                    if (state.trips.isEmpty)
                      SliverToBoxAdapter(
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.all(32.w),
                            child: const Text('No trips found'),
                          ),
                        ),
                      )
                    else
                      SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: TripListItem(trip: state.trips[index]),
                          );
                        }, childCount: state.trips.length),
                      ),
                    SliverPadding(padding: EdgeInsets.only(bottom: 24.h)),
                  ],
                ),
              );
            } else if (state is TripHistoryError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
