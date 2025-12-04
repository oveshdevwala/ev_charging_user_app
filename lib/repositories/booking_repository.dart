/// File: lib/repositories/booking_repository.dart
/// Purpose: Booking repository interface and dummy implementation
/// Belongs To: shared
/// Customization Guide:
///    - Implement the interface with actual backend API
///    - Replace DummyBookingRepository with real implementation

import '../models/models.dart';

/// Booking repository interface.
/// Implement this for actual backend integration.
abstract class BookingRepository {
  /// Get all bookings for user.
  Future<List<BookingModel>> getBookings({
    int page = 1,
    int limit = 20,
  });
  
  /// Get booking by ID.
  Future<BookingModel?> getBookingById(String id);
  
  /// Get upcoming bookings.
  Future<List<BookingModel>> getUpcomingBookings();
  
  /// Get past bookings.
  Future<List<BookingModel>> getPastBookings();
  
  /// Create new booking.
  Future<BookingModel?> createBooking({
    required String stationId,
    required String chargerId,
    required DateTime startTime,
    required int duration,
  });
  
  /// Cancel booking.
  Future<bool> cancelBooking(String bookingId);
  
  /// Start charging session.
  Future<bool> startCharging(String bookingId);
  
  /// Stop charging session.
  Future<bool> stopCharging(String bookingId);
  
  /// Get active charging session.
  Future<BookingModel?> getActiveSession();
}

/// Dummy booking repository for development/testing.
class DummyBookingRepository implements BookingRepository {
  final List<BookingModel> _bookings = _generateDummyBookings();
  
  static List<BookingModel> _generateDummyBookings() {
    return [
      BookingModel(
        id: 'booking_1',
        userId: 'user_1',
        stationId: 'station_1',
        chargerId: 'charger_1_1',
        stationName: 'Downtown EV Hub',
        stationAddress: '123 Main Street, San Francisco, CA 94102',
        chargerName: 'Charger 1',
        chargerType: 'CCS',
        startTime: DateTime.now().add(const Duration(hours: 2)),
        status: BookingStatus.confirmed,
        paymentStatus: PaymentStatus.paid,
        estimatedDuration: 45,
        estimatedCost: 15.75,
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      BookingModel(
        id: 'booking_2',
        userId: 'user_1',
        stationId: 'station_3',
        chargerId: 'charger_3_1',
        stationName: 'Tesla Supercharger - Mall',
        stationAddress: '789 Market Street, San Francisco, CA 94104',
        chargerName: 'V3-1',
        chargerType: 'Tesla',
        startTime: DateTime.now().subtract(const Duration(days: 2)),
        endTime: DateTime.now().subtract(const Duration(days: 2)).add(const Duration(minutes: 35)),
        status: BookingStatus.completed,
        paymentStatus: PaymentStatus.paid,
        estimatedDuration: 30,
        actualDuration: 35,
        estimatedCost: 14.00,
        actualCost: 15.50,
        energyDelivered: 45.2,
        createdAt: DateTime.now().subtract(const Duration(days: 2, hours: 1)),
      ),
      BookingModel(
        id: 'booking_3',
        userId: 'user_1',
        stationId: 'station_2',
        chargerId: 'charger_2_1',
        stationName: 'Green Valley Charge Point',
        stationAddress: '456 Oak Avenue, San Francisco, CA 94103',
        chargerName: 'Solar 1',
        chargerType: 'Type 2',
        startTime: DateTime.now().subtract(const Duration(days: 5)),
        endTime: DateTime.now().subtract(const Duration(days: 5)).add(const Duration(hours: 1)),
        status: BookingStatus.completed,
        paymentStatus: PaymentStatus.paid,
        estimatedDuration: 60,
        actualDuration: 58,
        estimatedCost: 18.00,
        actualCost: 17.40,
        energyDelivered: 58.0,
        createdAt: DateTime.now().subtract(const Duration(days: 5, hours: 2)),
      ),
      BookingModel(
        id: 'booking_4',
        userId: 'user_1',
        stationId: 'station_4',
        chargerId: 'charger_4_1',
        stationName: 'City Park Charging',
        stationAddress: '321 Park Boulevard, San Francisco, CA 94105',
        chargerName: 'Park 1',
        chargerType: 'CHAdeMO',
        startTime: DateTime.now().subtract(const Duration(days: 10)),
        status: BookingStatus.cancelled,
        paymentStatus: PaymentStatus.refunded,
        estimatedDuration: 45,
        estimatedCost: 12.60,
        notes: 'Cancelled due to schedule change',
        createdAt: DateTime.now().subtract(const Duration(days: 10, hours: 3)),
      ),
    ];
  }
  
  @override
  Future<List<BookingModel>> getBookings({
    int page = 1,
    int limit = 20,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final start = (page - 1) * limit;
    if (start >= _bookings.length) return [];
    final end = (start + limit) > _bookings.length ? _bookings.length : start + limit;
    return _bookings.sublist(start, end);
  }
  
  @override
  Future<BookingModel?> getBookingById(String id) async {
    await Future.delayed(const Duration(milliseconds: 400));
    try {
      return _bookings.firstWhere((b) => b.id == id);
    } catch (e) {
      return null;
    }
  }
  
  @override
  Future<List<BookingModel>> getUpcomingBookings() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _bookings.where((b) => 
      b.status == BookingStatus.confirmed && 
      b.startTime.isAfter(DateTime.now())
    ).toList();
  }
  
  @override
  Future<List<BookingModel>> getPastBookings() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _bookings.where((b) => 
      b.status == BookingStatus.completed || 
      b.status == BookingStatus.cancelled
    ).toList();
  }
  
  @override
  Future<BookingModel?> createBooking({
    required String stationId,
    required String chargerId,
    required DateTime startTime,
    required int duration,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    
    final booking = BookingModel(
      id: 'booking_${DateTime.now().millisecondsSinceEpoch}',
      userId: 'user_1',
      stationId: stationId,
      chargerId: chargerId,
      stationName: 'Charging Station',
      startTime: startTime,
      status: BookingStatus.confirmed,
      paymentStatus: PaymentStatus.paid,
      estimatedDuration: duration,
      estimatedCost: duration * 0.35,
      createdAt: DateTime.now(),
    );
    
    _bookings.insert(0, booking);
    return booking;
  }
  
  @override
  Future<bool> cancelBooking(String bookingId) async {
    await Future.delayed(const Duration(milliseconds: 800));
    final index = _bookings.indexWhere((b) => b.id == bookingId);
    if (index != -1) {
      _bookings[index] = _bookings[index].copyWith(
        status: BookingStatus.cancelled,
        paymentStatus: PaymentStatus.refunded,
      );
      return true;
    }
    return false;
  }
  
  @override
  Future<bool> startCharging(String bookingId) async {
    await Future.delayed(const Duration(milliseconds: 800));
    final index = _bookings.indexWhere((b) => b.id == bookingId);
    if (index != -1) {
      _bookings[index] = _bookings[index].copyWith(
        status: BookingStatus.inProgress,
      );
      return true;
    }
    return false;
  }
  
  @override
  Future<bool> stopCharging(String bookingId) async {
    await Future.delayed(const Duration(milliseconds: 800));
    final index = _bookings.indexWhere((b) => b.id == bookingId);
    if (index != -1) {
      _bookings[index] = _bookings[index].copyWith(
        status: BookingStatus.completed,
        endTime: DateTime.now(),
        actualDuration: DateTime.now().difference(_bookings[index].startTime).inMinutes,
      );
      return true;
    }
    return false;
  }
  
  @override
  Future<BookingModel?> getActiveSession() async {
    await Future.delayed(const Duration(milliseconds: 400));
    try {
      return _bookings.firstWhere((b) => b.status == BookingStatus.inProgress);
    } catch (e) {
      return null;
    }
  }
}

