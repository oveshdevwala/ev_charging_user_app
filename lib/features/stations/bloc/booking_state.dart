/// File: lib/features/stations/bloc/booking_state.dart
/// Purpose: Booking state for managing booking flow
/// Belongs To: stations feature
/// Customization Guide:
///    - Add new fields for additional booking options
///    - Extend status enum for more states
library;

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../models/models.dart';

/// Booking page flow status.
enum BookingPageStatus {
  initial,
  loading,
  loaded,
  stationNotFound,
  submitting,
  success,
  error,
}

/// Booking state class with Equatable and copyWith.
class BookingState extends Equatable {
  const BookingState({
    this.status = BookingPageStatus.initial,
    this.station,
    this.selectedCharger,
    this.selectedDate,
    this.selectedTime,
    this.duration = 60,
    this.error,
    this.bookingId,
  });

  /// Initial state factory.
  factory BookingState.initial() =>
      BookingState(selectedDate: DateTime.now(), selectedTime: TimeOfDay.now());

  /// Current booking status.
  final BookingPageStatus status;

  /// Station being booked.
  final StationModel? station;

  /// Selected charger.
  final ChargerModel? selectedCharger;

  /// Selected booking date.
  final DateTime? selectedDate;

  /// Selected booking time.
  final TimeOfDay? selectedTime;

  /// Booking duration in minutes.
  final int duration;

  /// Error message if any.
  final String? error;

  /// Booking ID after successful booking.
  final String? bookingId;

  /// Whether station is loaded.
  bool get isLoaded => status == BookingPageStatus.loaded;

  /// Whether booking is being submitted.
  bool get isSubmitting => status == BookingPageStatus.submitting;

  /// Whether station was not found.
  bool get isStationNotFound => status == BookingPageStatus.stationNotFound;

  /// Whether booking was successful.
  bool get isSuccess => status == BookingPageStatus.success;

  /// Calculate total estimated cost.
  double get estimatedCost {
    if (station == null || selectedCharger == null) {
      return 0;
    }
    // Estimate based on charger power and duration
    final hoursCharging = duration / 60;
    final estimatedKwh =
        selectedCharger!.power * hoursCharging * 0.8; // 80% efficiency
    return estimatedKwh * station!.pricePerKwh;
  }

  /// Calculate estimated energy in kWh.
  double get estimatedEnergy {
    if (selectedCharger == null) {
      return 0;
    }
    final hoursCharging = duration / 60;
    return selectedCharger!.power * hoursCharging * 0.8;
  }

  /// Get formatted booking time string.
  String get formattedBookingTime {
    if (selectedDate == null || selectedTime == null) {
      return '--';
    }
    final date = selectedDate!;
    final time = selectedTime!;
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    final minute = time.minute.toString().padLeft(2, '0');
    return '${date.day}/${date.month}/${date.year} at $hour:$minute $period';
  }

  /// Create a copy with updated fields.
  BookingState copyWith({
    BookingPageStatus? status,
    StationModel? station,
    ChargerModel? selectedCharger,
    DateTime? selectedDate,
    TimeOfDay? selectedTime,
    int? duration,
    String? error,
    String? bookingId,
    bool clearError = false,
    bool clearStation = false,
  }) {
    return BookingState(
      status: status ?? this.status,
      station: clearStation ? null : (station ?? this.station),
      selectedCharger: selectedCharger ?? this.selectedCharger,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTime: selectedTime ?? this.selectedTime,
      duration: duration ?? this.duration,
      error: clearError ? null : (error ?? this.error),
      bookingId: bookingId ?? this.bookingId,
    );
  }

  @override
  List<Object?> get props => [
    status,
    station,
    selectedCharger,
    selectedDate,
    selectedTime,
    duration,
    error,
    bookingId,
  ];
}
