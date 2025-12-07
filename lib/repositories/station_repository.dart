/// File: lib/repositories/station_repository.dart
/// Purpose: Station repository interface and dummy implementation
/// Belongs To: shared
/// Customization Guide:
///    - Implement the interface with actual backend API
///    - Replace DummyStationRepository with real implementation
library;

import '../core/di/injection.dart';
import '../core/services/station_image_service.dart';
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
  DummyStationRepository() : _imageService = sl<StationImageService>();

  final List<StationModel> _stations = _generateDummyStations();
  final Set<String> _favorites = {};
  final StationImageService _imageService;

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
        // imageUrl removed - using placeholder instead
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
        // imageUrl removed - using placeholder instead
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
        // imageUrl removed - using placeholder instead
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
        // imageUrl removed - using placeholder instead
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
        // imageUrl removed - using placeholder instead
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
      // ========== Trip Planner Charging Stations ==========
      const StationModel(
        id: 'cs_gilroy',
        name: 'Gilroy Supercharger',
        address: '681 Leavesley Rd, Gilroy, CA 95020',
        latitude: 37.0058,
        longitude: -121.5683,
        description: 'Tesla Supercharger with food nearby.',
        rating: 4.6,
        reviewCount: 89,
        pricePerKwh: 0.38,
        is24Hours: true,
        amenities: [Amenity.restroom, Amenity.cafe, Amenity.parking],
        chargers: [
          ChargerModel(
            id: 'cs_gilroy_1',
            stationId: 'cs_gilroy',
            name: 'V3-1',
            type: ChargerType.tesla,
            power: 250,
          ),
          ChargerModel(
            id: 'cs_gilroy_2',
            stationId: 'cs_gilroy',
            name: 'V3-2',
            type: ChargerType.tesla,
            power: 250,
          ),
          ChargerModel(
            id: 'cs_gilroy_3',
            stationId: 'cs_gilroy',
            name: 'V3-3',
            type: ChargerType.tesla,
            power: 250,
          ),
        ],
        distance: 125,
      ),
      const StationModel(
        id: 'cs_kettleman',
        name: 'Kettleman City Station',
        address: '33000 Bernard Dr, Kettleman City, CA 93239',
        latitude: 35.9894,
        longitude: -119.9616,
        description: 'Large charging station with restaurant.',
        rating: 4.4,
        reviewCount: 156,
        pricePerKwh: 0.35,
        is24Hours: true,
        amenities: [
          Amenity.restroom,
          Amenity.restaurant,
          Amenity.parking,
          Amenity.wifi,
        ],
        chargers: [
          ChargerModel(
            id: 'cs_kett_1',
            stationId: 'cs_kettleman',
            name: 'CCS-1',
            type: ChargerType.ccs,
            power: 150,
          ),
          ChargerModel(
            id: 'cs_kett_2',
            stationId: 'cs_kettleman',
            name: 'CCS-2',
            type: ChargerType.ccs,
            power: 150,
          ),
          ChargerModel(
            id: 'cs_kett_3',
            stationId: 'cs_kettleman',
            name: 'V3-1',
            type: ChargerType.tesla,
            power: 250,
          ),
        ],
        distance: 310,
      ),
      const StationModel(
        id: 'cs_tejon',
        name: 'Tejon Ranch Supercharger',
        address: '5701 Dennis McCarthy Dr, Lebec, CA 93243',
        latitude: 34.9872,
        longitude: -118.9486,
        description: 'Mountain pass charging station.',
        rating: 4.5,
        reviewCount: 112,
        pricePerKwh: 0.40,
        is24Hours: true,
        amenities: [Amenity.restroom, Amenity.cafe, Amenity.parking],
        chargers: [
          ChargerModel(
            id: 'cs_tejon_1',
            stationId: 'cs_tejon',
            name: 'V3-1',
            type: ChargerType.tesla,
            power: 250,
          ),
          ChargerModel(
            id: 'cs_tejon_2',
            stationId: 'cs_tejon',
            name: 'V3-2',
            type: ChargerType.tesla,
            power: 250,
          ),
        ],
        distance: 520,
      ),
      const StationModel(
        id: 'cs_sacramento',
        name: 'Sacramento Supercharger',
        address: '3560 N Freeway Blvd, Sacramento, CA 95834',
        latitude: 38.5816,
        longitude: -121.4944,
        description: 'Capital city charging hub.',
        rating: 4.7,
        reviewCount: 98,
        pricePerKwh: 0.36,
        is24Hours: true,
        amenities: [
          Amenity.restroom,
          Amenity.shopping,
          Amenity.parking,
          Amenity.cafe,
        ],
        chargers: [
          ChargerModel(
            id: 'cs_sac_1',
            stationId: 'cs_sacramento',
            name: 'V3-1',
            type: ChargerType.tesla,
            power: 250,
          ),
          ChargerModel(
            id: 'cs_sac_2',
            stationId: 'cs_sacramento',
            name: 'V3-2',
            type: ChargerType.tesla,
            power: 250,
          ),
          ChargerModel(
            id: 'cs_sac_3',
            stationId: 'cs_sacramento',
            name: 'CCS-1',
            type: ChargerType.ccs,
            power: 150,
          ),
        ],
        distance: 140,
      ),
      const StationModel(
        id: 'cs_barstow',
        name: 'Barstow Supercharger',
        address: '2812 Lenwood Rd, Barstow, CA 92311',
        latitude: 34.8983,
        longitude: -117.0225,
        description: 'Desert highway charging station.',
        rating: 4.3,
        reviewCount: 201,
        pricePerKwh: 0.38,
        is24Hours: true,
        amenities: [Amenity.restroom, Amenity.cafe, Amenity.parking],
        chargers: [
          ChargerModel(
            id: 'cs_bar_1',
            stationId: 'cs_barstow',
            name: 'V3-1',
            type: ChargerType.tesla,
            power: 250,
          ),
          ChargerModel(
            id: 'cs_bar_2',
            stationId: 'cs_barstow',
            name: 'V3-2',
            type: ChargerType.tesla,
            power: 250,
          ),
        ],
        distance: 180,
      ),
      const StationModel(
        id: 'cs_primm',
        name: 'Primm Outlet Mall Charger',
        address: '32100 S Las Vegas Blvd, Primm, NV 89019',
        latitude: 35.6106,
        longitude: -115.3889,
        description: 'Outlet mall charging with shopping.',
        rating: 4.2,
        reviewCount: 87,
        pricePerKwh: 0.42,
        is24Hours: true,
        amenities: [
          Amenity.restroom,
          Amenity.shopping,
          Amenity.restaurant,
          Amenity.parking,
        ],
        chargers: [
          ChargerModel(
            id: 'cs_pri_1',
            stationId: 'cs_primm',
            name: 'CCS-1',
            type: ChargerType.ccs,
            power: 150,
          ),
          ChargerModel(
            id: 'cs_pri_2',
            stationId: 'cs_primm',
            name: 'CCS-2',
            type: ChargerType.ccs,
            power: 150,
          ),
        ],
        distance: 360,
      ),
    ];
  }

  @override
  Future<List<StationModel>> getStations({int page = 1, int limit = 20}) async {
    await Future.delayed(const Duration(milliseconds: 800));
    final start = (page - 1) * limit;
    if (start >= _stations.length) {
      return [];
    }
    final end = (start + limit) > _stations.length
        ? _stations.length
        : start + limit;
    final stations = _stations.sublist(start, end);
    
    // Fetch Pexels images for stations
    final stationIds = stations.map((s) => s.id).toList();
    final stationNames = {for (final s in stations) s.id: s.name};
    final stationDescriptions = {
      for (final s in stations) s.id: s.description ?? '',
    };
    
    final imageUrls = await _imageService.getStationImageUrls(
      stationIds,
      stationNames: stationNames,
      stationDescriptions: stationDescriptions,
    );
    
    return stations
        .map((s) => s.copyWith(
              isFavorite: _favorites.contains(s.id),
              imageUrl: imageUrls[s.id] ?? s.imageUrl,
            ))
        .toList();
  }

  @override
  Future<StationModel?> getStationById(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      final station = _stations.firstWhere((s) => s.id == id);
      
      // Fetch Pexels image for this station
      final imageUrl = await _imageService.getStationImageUrl(
        id,
        stationName: station.name,
        stationDescription: station.description,
      );
      
      return station.copyWith(
        isFavorite: _favorites.contains(id),
        imageUrl: imageUrl ?? station.imageUrl,
      );
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
    final stations = List<StationModel>.from(_stations)
      ..sort((a, b) => (a.distance ?? 0).compareTo(b.distance ?? 0));
    
    // Fetch Pexels images for nearby stations
    final stationIds = stations.map((s) => s.id).toList();
    final stationNames = {for (final s in stations) s.id: s.name};
    final stationDescriptions = {
      for (final s in stations) s.id: s.description ?? '',
    };
    
    final imageUrls = await _imageService.getStationImageUrls(
      stationIds,
      stationNames: stationNames,
      stationDescriptions: stationDescriptions,
    );
    
    return stations
        .map((s) => s.copyWith(
              isFavorite: _favorites.contains(s.id),
              imageUrl: imageUrls[s.id] ?? s.imageUrl,
            ))
        .toList();
  }

  @override
  Future<List<StationModel>> searchStations(String query) async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (query.isEmpty) {
      return [];
    }
    final lowerQuery = query.toLowerCase();
    final stations = _stations
        .where(
          (s) =>
              s.name.toLowerCase().contains(lowerQuery) ||
              s.address.toLowerCase().contains(lowerQuery),
        )
        .toList();
    
    // Fetch Pexels images for search results
    final stationIds = stations.map((s) => s.id).toList();
    final stationNames = {for (final s in stations) s.id: s.name};
    final stationDescriptions = {
      for (final s in stations) s.id: s.description ?? '',
    };
    
    final imageUrls = await _imageService.getStationImageUrls(
      stationIds,
      stationNames: stationNames,
      stationDescriptions: stationDescriptions,
    );
    
    return stations
        .map((s) => s.copyWith(
              isFavorite: _favorites.contains(s.id),
              imageUrl: imageUrls[s.id] ?? s.imageUrl,
            ))
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
