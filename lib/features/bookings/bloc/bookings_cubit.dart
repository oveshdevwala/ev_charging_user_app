/// File: lib/features/bookings/bloc/bookings_cubit.dart
/// Purpose: Bookings page Cubit for managing bookings state
/// Belongs To: bookings feature
library;

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../repositories/booking_repository.dart';
import 'bookings_state.dart';

/// Bookings page Cubit.
class BookingsCubit extends Cubit<BookingsState> {
  BookingsCubit({required BookingRepository bookingRepository})
      : _bookingRepository = bookingRepository,
        super(BookingsState.initial());

  final BookingRepository _bookingRepository;

  /// Load all bookings.
  Future<void> loadBookings() async {
    emit(state.copyWith(isLoading: true));

    try {
      final upcoming = await _bookingRepository.getUpcomingBookings();
      final past = await _bookingRepository.getPastBookings();
      emit(state.copyWith(
        isLoading: false,
        upcomingBookings: upcoming,
        pastBookings: past,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  /// Cancel a booking.
  Future<void> cancelBooking(String bookingId) async {
    await _bookingRepository.cancelBooking(bookingId);
    await loadBookings();
  }
}

