/// File: lib/features/bookings/ui/bookings_page.dart
/// Purpose: User bookings screen
/// Belongs To: bookings feature
/// Route: /userBookings
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/extensions/context_ext.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/booking_model.dart';
import '../../../repositories/booking_repository.dart';
import '../../../routes/app_routes.dart';
import '../../../widgets/booking_card.dart';
import '../../../widgets/loading_wrapper.dart';

/// Bookings page showing user's charging session reservations.
class BookingsPage extends StatefulWidget {
  const BookingsPage({super.key});

  @override
  State<BookingsPage> createState() => _BookingsPageState();
}

class _BookingsPageState extends State<BookingsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _bookingRepository = DummyBookingRepository();
  List<BookingModel> _upcomingBookings = [];
  List<BookingModel> _pastBookings = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadBookings();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadBookings() async {
    final upcoming = await _bookingRepository.getUpcomingBookings();
    final past = await _bookingRepository.getPastBookings();
    if (mounted) {
      setState(() {
        _upcomingBookings = upcoming;
        _pastBookings = past;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            _buildTabBar(context),
            SizedBox(height: 16.h),
            Expanded(child: _buildTabContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final colors = context.appColors;

    return Padding(
      padding: EdgeInsets.all(20.r),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            AppStrings.myBookings,
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
              color: colors.textPrimary,
            ),
          ),
          TextButton.icon(
            onPressed: () => context.push(AppRoutes.tripHistory.path),
            icon: Icon(Iconsax.chart_1, size: 18.r),
            label: Text('Trip History', style: TextStyle(fontSize: 14.sp)),
            style: TextButton.styleFrom(foregroundColor: colors.primary),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(BuildContext context) {
    final colors = context.appColors;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        color: colors.surfaceVariant,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: colors.primary,
          borderRadius: BorderRadius.circular(10.r),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: colors.textPrimary,
        unselectedLabelColor: colors.textSecondary,
        labelStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
        tabs: const [
          Tab(text: 'Upcoming'),
          Tab(text: 'Past'),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    return LoadingWrapper(
      isLoading: _isLoading,
      child: TabBarView(
        controller: _tabController,
        children: [
          _buildBookingList(_upcomingBookings, isUpcoming: true),
          _buildBookingList(_pastBookings, isUpcoming: false),
        ],
      ),
    );
  }

  Widget _buildBookingList(
    List<BookingModel> bookings, {
    required bool isUpcoming,
  }) {
    if (bookings.isEmpty) {
      return EmptyStateWidget(
        title: AppStrings.noBookingsFound,
        message: isUpcoming
            ? 'Book a charging session to get started'
            : 'Your completed sessions will appear here',
        icon: Iconsax.calendar,
        onAction: !isUpcoming
            ? () => context.push(AppRoutes.tripHistory.path)
            : null,
        actionLabel: !isUpcoming ? 'View Trip History' : null,
      );
    }

    return RefreshIndicator(
      onRefresh: _loadBookings,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          final booking = bookings[index];
          return Padding(
            padding: EdgeInsets.only(bottom: 16.h),
            child: BookingCard(
              booking: booking,
              onTap: () =>
                  context.push(AppRoutes.bookingDetails.id(booking.id)),
              onCancelTap: isUpcoming
                  ? () async {
                      await _bookingRepository.cancelBooking(booking.id);
                      await _loadBookings();
                    }
                  : null,
            ),
          );
        },
      ),
    );
  }
}
