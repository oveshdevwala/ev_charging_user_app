/// File: lib/repositories/station_repository.dart
/// Purpose: Station repository interface and dummy implementation
/// Belongs To: shared
/// Customization Guide:
///    - Implement the interface with actual backend API
///    - Replace DummyStationRepository with real implementation
library;

import '../models/models.dart';

/// Station repository interface.
/// Implement this for actual backend integration.
abstract class StationRepository {
  /// Get all stations.
  Future<List<StationModel>> getStations({int page = 1, int limit = 20});

  /// Get station by ID.
  Future<StationModel?> getStationById(String id);

  /// Get nearby stations.
  Future<List<StationModel>> getNearbyStations({
    required double latitude,
    required double longitude,
    double radius = 10.0,
  });

  /// Search stations.
  Future<List<StationModel>> searchStations(String query);

  /// Get favorite stations.
  Future<List<StationModel>> getFavoriteStations();

  /// Toggle station favorite.
  Future<bool> toggleFavorite(String stationId);

  /// Get station reviews.
  Future<List<ReviewModel>> getStationReviews(String stationId);

  /// Add station review.
  Future<bool> addReview({
    required String stationId,
    required double rating,
    String? comment,
  });

  /// Get station chargers.
  Future<List<ChargerModel>> getStationChargers(String stationId);
}

/// Dummy station repository for development/testing.
class DummyStationRepository implements StationRepository {
  final List<StationModel> _stations = _generateDummyStations();
  final Set<String> _favorites = {};

  static List<StationModel> _generateDummyStations() {
    return [
      const StationModel(
        id: 'station_1',
        name: 'Downtown EV Hub',
        address: '123 Main Street, San Francisco, CA 94102',
        latitude: 37.7849,
        longitude: -122.4094,
        description:
            'Fast charging station in the heart of downtown. Open 24/7 with excellent amenities.',
        imageUrl:
            'https://images.unsplash.com/photo-1593941707882-a5bba14938c7',
        rating: 4.8,
        reviewCount: 124,
        pricePerKwh: 0.35,
        is24Hours: true,
        amenities: [
          Amenity.wifi,
          Amenity.restroom,
          Amenity.cafe,
          Amenity.parking,
        ],
        chargers: [
          ChargerModel(
            id: 'charger_1_1',
            stationId: 'station_1',
            name: 'Charger 1',
            type: ChargerType.ccs,
            power: 150,
          ),
          ChargerModel(
            id: 'charger_1_2',
            stationId: 'station_1',
            name: 'Charger 2',
            type: ChargerType.ccs,
            power: 150,
            status: ChargerStatus.charging,
          ),
          ChargerModel(
            id: 'charger_1_3',
            stationId: 'station_1',
            name: 'Charger 3',
            type: ChargerType.type2,
            power: 22,
          ),
        ],
        distance: 0.5,
      ),
      const StationModel(
        id: 'station_2',
        name: 'Green Valley Charge Point',
        address: '456 Oak Avenue, San Francisco, CA 94103',
        latitude: 37.7749,
        longitude: -122.4194,
        description: 'Eco-friendly charging station powered by solar energy.',
        imageUrl: 'https://images.unsplash.com/photo-1558346648-9757f2fa4474',
        rating: 4.5,
        reviewCount: 89,
        pricePerKwh: 0.30,
        openTime: '06:00',
        closeTime: '22:00',
        amenities: [Amenity.wifi, Amenity.parking, Amenity.shopping],
        chargers: [
          ChargerModel(
            id: 'charger_2_1',
            stationId: 'station_2',
            name: 'Solar 1',
            type: ChargerType.type2,
            power: 22,
          ),
          ChargerModel(
            id: 'charger_2_2',
            stationId: 'station_2',
            name: 'Solar 2',
            type: ChargerType.type2,
            power: 22,
          ),
        ],
        distance: 1.2,
      ),
      const StationModel(
        id: 'station_3',
        name: 'Tesla Supercharger - Mall',
        address: '789 Market Street, San Francisco, CA 94104',
        latitude: 37.7859,
        longitude: -122.4084,
        description:
            'Tesla Supercharger with V3 technology for fastest charging speeds.',
        imageUrl:
            'https://images.unsplash.com/photo-1647166545674-ce28ce93bdca',
        rating: 4.9,
        reviewCount: 256,
        pricePerKwh: 0.40,
        is24Hours: true,
        amenities: [
          Amenity.wifi,
          Amenity.restroom,
          Amenity.cafe,
          Amenity.restaurant,
          Amenity.shopping,
          Amenity.parking,
        ],
        chargers: [
          ChargerModel(
            id: 'charger_3_1',
            stationId: 'station_3',
            name: 'V3-1',
            type: ChargerType.tesla,
            power: 250,
          ),
          ChargerModel(
            id: 'charger_3_2',
            stationId: 'station_3',
            name: 'V3-2',
            type: ChargerType.tesla,
            power: 250,
            status: ChargerStatus.occupied,
          ),
          ChargerModel(
            id: 'charger_3_3',
            stationId: 'station_3',
            name: 'V3-3',
            type: ChargerType.tesla,
            power: 250,
          ),
          ChargerModel(
            id: 'charger_3_4',
            stationId: 'station_3',
            name: 'V3-4',
            type: ChargerType.tesla,
            power: 250,
            status: ChargerStatus.charging,
          ),
        ],
        distance: 0.8,
      ),
      const StationModel(
        id: 'station_4',
        name: 'City Park Charging',
        address: '321 Park Boulevard, San Francisco, CA 94105',
        latitude: 37.7699,
        longitude: -122.4094,
        description:
            'Scenic charging location in the city park with beautiful views.',
        imageUrl:
            'https://images.unsplash.com/photo-1621004316532-9d3f5d2b2ad7',
        rating: 4.3,
        reviewCount: 67,
        pricePerKwh: 0.28,
        openTime: '05:00',
        closeTime: '23:00',
        amenities: [Amenity.restroom, Amenity.parking, Amenity.playground],
        chargers: [
          ChargerModel(
            id: 'charger_4_1',
            stationId: 'station_4',
            name: 'Park 1',
            type: ChargerType.chademo,
            power: 50,
          ),
          ChargerModel(
            id: 'charger_4_2',
            stationId: 'station_4',
            name: 'Park 2',
            type: ChargerType.ccs,
            power: 50,
            status: ChargerStatus.offline,
          ),
        ],
        distance: 2.1,
      ),
      const StationModel(
        id: 'station_5',
        name: 'Highway Rest Stop',
        address: '555 Interstate Drive, San Francisco, CA 94106',
        latitude: 37.7599,
        longitude: -122.3994,
        description:
            'Convenient highway rest stop with multiple fast chargers.',
        imageUrl:
            'https://images.unsplash.com/photo-1617788138017-80ad40651399',
        rating: 4.1,
        reviewCount: 203,
        pricePerKwh: 0.45,
        is24Hours: true,
        amenities: [
          Amenity.restroom,
          Amenity.cafe,
          Amenity.parking,
          Amenity.restaurant,
        ],
        chargers: [
          ChargerModel(
            id: 'charger_5_1',
            stationId: 'station_5',
            name: 'Express 1',
            type: ChargerType.ccs,
            power: 350,
          ),
          ChargerModel(
            id: 'charger_5_2',
            stationId: 'station_5',
            name: 'Express 2',
            type: ChargerType.ccs,
            power: 350,
          ),
          ChargerModel(
            id: 'charger_5_3',
            stationId: 'station_5',
            name: 'Standard 1',
            type: ChargerType.chademo,
            power: 50,
            status: ChargerStatus.charging,
          ),
        ],
        distance: 5.3,
      ),
    ];
  }

  @override
  Future<List<StationModel>> getStations({int page = 1, int limit = 20}) async {
    await Future.delayed(const Duration(milliseconds: 800));
    final start = (page - 1) * limit;
    if (start >= _stations.length) return [];
    final end = (start + limit) > _stations.length
        ? _stations.length
        : start + limit;
    return _stations
        .sublist(start, end)
        .map((s) => s.copyWith(isFavorite: _favorites.contains(s.id)))
        .toList();
  }

  @override
  Future<StationModel?> getStationById(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      final station = _stations.firstWhere((s) => s.id == id);
      return station.copyWith(isFavorite: _favorites.contains(id));
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<StationModel>> getNearbyStations({
    required double latitude,
    required double longitude,
    double radius = 10.0,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));
    // In dummy, return all stations sorted by distance
    final stations = List<StationModel>.from(_stations);
    stations.sort((a, b) => (a.distance ?? 0).compareTo(b.distance ?? 0));
    return stations
        .map((s) => s.copyWith(isFavorite: _favorites.contains(s.id)))
        .toList();
  }

  @override
  Future<List<StationModel>> searchStations(String query) async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (query.isEmpty) return [];
    final lowerQuery = query.toLowerCase();
    return _stations
        .where(
          (s) =>
              s.name.toLowerCase().contains(lowerQuery) ||
              s.address.toLowerCase().contains(lowerQuery),
        )
        .map((s) => s.copyWith(isFavorite: _favorites.contains(s.id)))
        .toList();
  }

  @override
  Future<List<StationModel>> getFavoriteStations() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _stations
        .where((s) => _favorites.contains(s.id))
        .map((s) => s.copyWith(isFavorite: true))
        .toList();
  }

  @override
  Future<bool> toggleFavorite(String stationId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (_favorites.contains(stationId)) {
      _favorites.remove(stationId);
      return false;
    } else {
      _favorites.add(stationId);
      return true;
    }
  }

  @override
  Future<List<ReviewModel>> getStationReviews(String stationId) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return [
      ReviewModel(
        id: 'review_1',
        userId: 'user_1',
        stationId: stationId,
        rating: 5,
        userName: 'Sarah M.',
        comment:
            'Excellent charging station! Fast and reliable. The cafe nearby is a nice bonus.',
        isVerified: true,
        helpfulCount: 12,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      ReviewModel(
        id: 'review_2',
        userId: 'user_2',
        stationId: stationId,
        rating: 4,
        userName: 'Mike R.',
        comment: 'Good location, but sometimes crowded during peak hours.',
        isVerified: true,
        helpfulCount: 8,
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
      ReviewModel(
        id: 'review_3',
        userId: 'user_3',
        stationId: stationId,
        rating: 4.5,
        userName: 'Emily K.',
        comment:
            'Clean facilities and fast charging. Will definitely come back!',
        helpfulCount: 5,
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
      ),
    ];
  }

  @override
  Future<bool> addReview({
    required String stationId,
    required double rating,
    String? comment,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return true;
  }

  @override
  Future<List<ChargerModel>> getStationChargers(String stationId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final station = await getStationById(stationId);
    return station?.chargers ?? [];
  }
}
