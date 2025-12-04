/// File: lib/features/stations/bloc/booking_cubit.dart
/// Purpose: Booking Cubit for managing booking operations
/// Belongs To: stations feature
/// Customization Guide:
///    - Add payment integration methods
///    - Extend for promo codes and discounts
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/charger_model.dart';
import '../../../repositories/station_repository.dart';
import 'booking_state.dart';

/// Booking Cubit managing all booking operations.
class BookingCubit extends Cubit<BookingState> {
  BookingCubit({required StationRepository stationRepository})
    : _stationRepository = stationRepository,
      super(BookingState.initial());

  final StationRepository _stationRepository;

  // ============================================================
  // INITIALIZATION
  // ============================================================

  /// Load station for booking.
  Future<void> loadStation(String stationId) async {
    emit(state.copyWith(status: BookingPageStatus.loading, clearError: true));

    try {
      final station = await _stationRepository.getStationById(stationId);

      if (station == null) {
        emit(state.copyWith(status: BookingPageStatus.stationNotFound));
        return;
      }

      // Auto-select first available charger
      ChargerModel? selectedCharger;
      if (station.chargers.isNotEmpty) {
        selectedCharger = station.chargers.firstWhere(
          (c) => c.isAvailable,
          orElse: () => station.chargers.first,
        );
      }

      emit(
        state.copyWith(
          status: BookingPageStatus.loaded,
          station: station,
          selectedCharger: selectedCharger,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: BookingPageStatus.stationNotFound,
          error: e.toString(),
        ),
      );
    }
  }

  // ============================================================
  // CHARGER SELECTION
  // ============================================================

  /// Select a charger.
  void selectCharger(ChargerModel charger) {
    emit(state.copyWith(selectedCharger: charger));
  }

  // ============================================================
  // DATE & TIME SELECTION
  // ============================================================

  /// Set booking date.
  void setDate(DateTime date) {
    emit(state.copyWith(selectedDate: date));
  }

  /// Set booking time.
  void setTime(TimeOfDay time) {
    emit(state.copyWith(selectedTime: time));
  }

  // ============================================================
  // DURATION SELECTION
  // ============================================================

  /// Set booking duration in minutes.
  void setDuration(int minutes) {
    emit(state.copyWith(duration: minutes.clamp(15, 240)));
  }

  /// Increase duration by 15 minutes.
  void increaseDuration() {
    final newDuration = (state.duration + 15).clamp(15, 240);
    emit(state.copyWith(duration: newDuration));
  }

  /// Decrease duration by 15 minutes.
  void decreaseDuration() {
    final newDuration = (state.duration - 15).clamp(15, 240);
    emit(state.copyWith(duration: newDuration));
  }

  // ============================================================
  // BOOKING SUBMISSION
  // ============================================================

  /// Submit the booking.
  Future<void> submitBooking() async {
    if (state.station == null || state.selectedCharger == null) {
      emit(state.copyWith(error: 'Please select a charger'));
      return;
    }

    if (state.selectedDate == null || state.selectedTime == null) {
      emit(state.copyWith(error: 'Please select date and time'));
      return;
    }

    emit(
      state.copyWith(status: BookingPageStatus.submitting, clearError: true),
    );

    try {
      // Simulate API call
      await Future<void>.delayed(const Duration(seconds: 2));

      // Generate booking ID
      final bookingId = 'BK${DateTime.now().millisecondsSinceEpoch}';

      emit(
        state.copyWith(status: BookingPageStatus.success, bookingId: bookingId),
      );
    } catch (e) {
      emit(
        state.copyWith(status: BookingPageStatus.loaded, error: e.toString()),
      );
    }
  }

  // ============================================================
  // UTILITY
  // ============================================================

  /// Clear error.
  void clearError() {
    emit(state.copyWith(clearError: true));
  }

  /// Reset booking state.
  void reset() {
    emit(BookingState.initial());
  }
}
