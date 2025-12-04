/// File: lib/features/bookings/bloc/bookings_state.dart
/// Purpose: Bookings page state for BLoC
/// Belongs To: bookings feature
library;

import 'package:equatable/equatable.dart';

import '../../../models/booking_model.dart';

/// Bookings page state.
class BookingsState extends Equatable {
  const BookingsState({
    this.isLoading = false,
    this.upcomingBookings = const [],
    this.pastBookings = const [],
    this.error,
  });

  final bool isLoading;
  final List<BookingModel> upcomingBookings;
  final List<BookingModel> pastBookings;
  final String? error;

  /// Initial state.
  factory BookingsState.initial() => const BookingsState(isLoading: true);

  /// Copy with new values.
  BookingsState copyWith({
    bool? isLoading,
    List<BookingModel>? upcomingBookings,
    List<BookingModel>? pastBookings,
    String? error,
  }) {
    return BookingsState(
      isLoading: isLoading ?? this.isLoading,
      upcomingBookings: upcomingBookings ?? this.upcomingBookings,
      pastBookings: pastBookings ?? this.pastBookings,
      error: error,
    );
  }

  @override
  List<Object?> get props => [isLoading, upcomingBookings, pastBookings, error];
}

