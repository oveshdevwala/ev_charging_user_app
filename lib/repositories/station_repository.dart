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
      // ========== Additional San Francisco Area Stations (30+ stations) ==========
      ..._generateSfAreaStations(),
    ];
  }

  /// Generate 30+ additional stations in San Francisco Bay Area
  static List<StationModel> _generateSfAreaStations() {
    return [
      const StationModel(
        id: 'sf_1',
        name: 'Marina District Charging',
        address: '2000 Fillmore St, San Francisco, CA 94115',
        latitude: 37.7899,
        longitude: -122.4344,
        description: 'Convenient charging in the heart of Marina District.',
        rating: 4.6,
        reviewCount: 92,
        pricePerKwh: 0.36,
        is24Hours: true,
        amenities: [Amenity.wifi, Amenity.cafe, Amenity.parking],
        chargers: [
          ChargerModel(
            id: 'sf_1_c1',
            stationId: 'sf_1',
            name: 'CCS-1',
            type: ChargerType.ccs,
            power: 150,
          ),
          ChargerModel(
            id: 'sf_1_c2',
            stationId: 'sf_1',
            name: 'CCS-2',
            type: ChargerType.ccs,
            power: 150,
          ),
        ],
        distance: 0.3,
      ),
      const StationModel(
        id: 'sf_2',
        name: "Fisherman's Wharf EV Station",
        address: '300 Jefferson St, San Francisco, CA 94133',
        latitude: 37.8080,
        longitude: -122.4177,
        description: "Tourist-friendly charging near Fisherman's Wharf.",
        rating: 4.4,
        reviewCount: 156,
        pricePerKwh: 0.42,
        is24Hours: true,
        amenities: [
          Amenity.restroom,
          Amenity.restaurant,
          Amenity.shopping,
          Amenity.parking,
        ],
        chargers: [
          ChargerModel(
            id: 'sf_2_c1',
            stationId: 'sf_2',
            name: 'Fast-1',
            type: ChargerType.ccs,
            power: 350,
          ),
          ChargerModel(
            id: 'sf_2_c2',
            stationId: 'sf_2',
            name: 'Fast-2',
            type: ChargerType.ccs,
            power: 350,
          ),
          ChargerModel(
            id: 'sf_2_c3',
            stationId: 'sf_2',
            name: 'Type2-1',
            type: ChargerType.type2,
            power: 22,
          ),
        ],
        distance: 1.2,
      ),
      const StationModel(
        id: 'sf_3',
        name: 'Golden Gate Park Charger',
        address: '1000 Great Highway, San Francisco, CA 94117',
        latitude: 37.7694,
        longitude: -122.4862,
        description: 'Scenic charging location in Golden Gate Park.',
        rating: 4.7,
        reviewCount: 203,
        pricePerKwh: 0.32,
        openTime: '06:00',
        closeTime: '22:00',
        amenities: [Amenity.restroom, Amenity.parking, Amenity.playground],
        chargers: [
          ChargerModel(
            id: 'sf_3_c1',
            stationId: 'sf_3',
            name: 'Park-1',
            type: ChargerType.type2,
            power: 22,
          ),
          ChargerModel(
            id: 'sf_3_c2',
            stationId: 'sf_3',
            name: 'Park-2',
            type: ChargerType.type2,
            power: 22,
          ),
        ],
        distance: 2.5,
      ),
      const StationModel(
        id: 'sf_4',
        name: 'Mission Bay Supercharger',
        address: '1855 3rd St, San Francisco, CA 94158',
        latitude: 37.7706,
        longitude: -122.3892,
        description: 'Modern charging hub in Mission Bay district.',
        rating: 4.8,
        reviewCount: 178,
        pricePerKwh: 0.38,
        is24Hours: true,
        amenities: [
          Amenity.wifi,
          Amenity.restroom,
          Amenity.cafe,
          Amenity.parking,
        ],
        chargers: [
          ChargerModel(
            id: 'sf_4_c1',
            stationId: 'sf_4',
            name: 'V3-1',
            type: ChargerType.tesla,
            power: 250,
          ),
          ChargerModel(
            id: 'sf_4_c2',
            stationId: 'sf_4',
            name: 'V3-2',
            type: ChargerType.tesla,
            power: 250,
          ),
          ChargerModel(
            id: 'sf_4_c3',
            stationId: 'sf_4',
            name: 'CCS-1',
            type: ChargerType.ccs,
            power: 150,
          ),
        ],
        distance: 1.8,
      ),
      const StationModel(
        id: 'sf_5',
        name: 'Castro District EV Hub',
        address: '400 Castro St, San Francisco, CA 94114',
        latitude: 37.7609,
        longitude: -122.4350,
        description: 'Vibrant neighborhood charging station.',
        rating: 4.5,
        reviewCount: 134,
        pricePerKwh: 0.35,
        is24Hours: true,
        amenities: [
          Amenity.wifi,
          Amenity.restroom,
          Amenity.cafe,
          Amenity.shopping,
        ],
        chargers: [
          ChargerModel(
            id: 'sf_5_c1',
            stationId: 'sf_5',
            name: 'Castro-1',
            type: ChargerType.ccs,
            power: 150,
          ),
          ChargerModel(
            id: 'sf_5_c2',
            stationId: 'sf_5',
            name: 'Castro-2',
            type: ChargerType.ccs,
            power: 150,
          ),
        ],
        distance: 1.5,
      ),
      const StationModel(
        id: 'sf_6',
        name: 'Union Square Charging',
        address: '333 Geary St, San Francisco, CA 94102',
        latitude: 37.7879,
        longitude: -122.4085,
        description: 'Premium location in Union Square shopping district.',
        rating: 4.6,
        reviewCount: 267,
        pricePerKwh: 0.45,
        is24Hours: true,
        amenities: [
          Amenity.wifi,
          Amenity.restroom,
          Amenity.restaurant,
          Amenity.shopping,
          Amenity.parking,
        ],
        chargers: [
          ChargerModel(
            id: 'sf_6_c1',
            stationId: 'sf_6',
            name: 'Premium-1',
            type: ChargerType.ccs,
            power: 350,
          ),
          ChargerModel(
            id: 'sf_6_c2',
            stationId: 'sf_6',
            name: 'Premium-2',
            type: ChargerType.ccs,
            power: 350,
          ),
          ChargerModel(
            id: 'sf_6_c3',
            stationId: 'sf_6',
            name: 'Standard-1',
            type: ChargerType.type2,
            power: 22,
          ),
        ],
        distance: 0.4,
      ),
      const StationModel(
        id: 'sf_7',
        name: 'Chinatown EV Station',
        address: '800 Grant Ave, San Francisco, CA 94108',
        latitude: 37.7941,
        longitude: -122.4078,
        description: 'Cultural district charging with great food nearby.',
        rating: 4.3,
        reviewCount: 98,
        pricePerKwh: 0.34,
        is24Hours: true,
        amenities: [Amenity.restroom, Amenity.restaurant, Amenity.shopping],
        chargers: [
          ChargerModel(
            id: 'sf_7_c1',
            stationId: 'sf_7',
            name: 'Chinatown-1',
            type: ChargerType.ccs,
            power: 150,
          ),
          ChargerModel(
            id: 'sf_7_c2',
            stationId: 'sf_7',
            name: 'Chinatown-2',
            type: ChargerType.type2,
            power: 22,
          ),
        ],
        distance: 0.6,
      ),
      const StationModel(
        id: 'sf_8',
        name: 'SOMA Fast Charge',
        address: '1500 Mission St, San Francisco, CA 94103',
        latitude: 37.7749,
        longitude: -122.4194,
        description: 'Fast charging in South of Market area.',
        rating: 4.7,
        reviewCount: 189,
        pricePerKwh: 0.37,
        is24Hours: true,
        amenities: [
          Amenity.wifi,
          Amenity.restroom,
          Amenity.cafe,
          Amenity.parking,
        ],
        chargers: [
          ChargerModel(
            id: 'sf_8_c1',
            stationId: 'sf_8',
            name: 'SOMA-1',
            type: ChargerType.ccs,
            power: 350,
          ),
          ChargerModel(
            id: 'sf_8_c2',
            stationId: 'sf_8',
            name: 'SOMA-2',
            type: ChargerType.ccs,
            power: 350,
          ),
          ChargerModel(
            id: 'sf_8_c3',
            stationId: 'sf_8',
            name: 'SOMA-3',
            type: ChargerType.ccs,
            power: 150,
          ),
        ],
        distance: 0.2,
      ),
      const StationModel(
        id: 'sf_9',
        name: 'Presidio Heights Charging',
        address: '3500 Sacramento St, San Francisco, CA 94118',
        latitude: 37.7881,
        longitude: -122.4461,
        description: 'Upscale neighborhood charging station.',
        rating: 4.8,
        reviewCount: 112,
        pricePerKwh: 0.40,
        is24Hours: true,
        amenities: [
          Amenity.wifi,
          Amenity.restroom,
          Amenity.cafe,
          Amenity.parking,
        ],
        chargers: [
          ChargerModel(
            id: 'sf_9_c1',
            stationId: 'sf_9',
            name: 'Presidio-1',
            type: ChargerType.ccs,
            power: 150,
          ),
          ChargerModel(
            id: 'sf_9_c2',
            stationId: 'sf_9',
            name: 'Presidio-2',
            type: ChargerType.ccs,
            power: 150,
          ),
        ],
        distance: 1.8,
      ),
      const StationModel(
        id: 'sf_10',
        name: 'Embarcadero Center EV',
        address: '275 Battery St, San Francisco, CA 94111',
        latitude: 37.7955,
        longitude: -122.4008,
        description: 'Downtown financial district charging.',
        rating: 4.5,
        reviewCount: 245,
        pricePerKwh: 0.43,
        is24Hours: true,
        amenities: [
          Amenity.wifi,
          Amenity.restroom,
          Amenity.restaurant,
          Amenity.parking,
        ],
        chargers: [
          ChargerModel(
            id: 'sf_10_c1',
            stationId: 'sf_10',
            name: 'Emb-1',
            type: ChargerType.ccs,
            power: 350,
          ),
          ChargerModel(
            id: 'sf_10_c2',
            stationId: 'sf_10',
            name: 'Emb-2',
            type: ChargerType.ccs,
            power: 350,
          ),
        ],
        distance: 0.7,
      ),
      const StationModel(
        id: 'sf_11',
        name: 'Haight-Ashbury Charger',
        address: '1500 Haight St, San Francisco, CA 94117',
        latitude: 37.7699,
        longitude: -122.4469,
        description: 'Historic neighborhood charging point.',
        rating: 4.4,
        reviewCount: 87,
        pricePerKwh: 0.33,
        is24Hours: true,
        amenities: [Amenity.wifi, Amenity.cafe, Amenity.shopping],
        chargers: [
          ChargerModel(
            id: 'sf_11_c1',
            stationId: 'sf_11',
            name: 'Haight-1',
            type: ChargerType.type2,
            power: 22,
          ),
          ChargerModel(
            id: 'sf_11_c2',
            stationId: 'sf_11',
            name: 'Haight-2',
            type: ChargerType.type2,
            power: 22,
          ),
        ],
        distance: 2.1,
      ),
      const StationModel(
        id: 'sf_12',
        name: 'Pacific Heights EV Hub',
        address: '2500 Fillmore St, San Francisco, CA 94115',
        latitude: 37.7925,
        longitude: -122.4344,
        description: 'Elegant neighborhood charging station.',
        rating: 4.7,
        reviewCount: 156,
        pricePerKwh: 0.39,
        is24Hours: true,
        amenities: [
          Amenity.wifi,
          Amenity.restroom,
          Amenity.cafe,
          Amenity.parking,
        ],
        chargers: [
          ChargerModel(
            id: 'sf_12_c1',
            stationId: 'sf_12',
            name: 'Pacific-1',
            type: ChargerType.ccs,
            power: 150,
          ),
          ChargerModel(
            id: 'sf_12_c2',
            stationId: 'sf_12',
            name: 'Pacific-2',
            type: ChargerType.ccs,
            power: 150,
          ),
        ],
        distance: 0.8,
      ),
      const StationModel(
        id: 'sf_13',
        name: 'North Beach Charging',
        address: '1500 Grant Ave, San Francisco, CA 94133',
        latitude: 37.8014,
        longitude: -122.4106,
        description: 'Italian district charging with great restaurants.',
        rating: 4.5,
        reviewCount: 123,
        pricePerKwh: 0.36,
        is24Hours: true,
        amenities: [Amenity.restroom, Amenity.restaurant, Amenity.parking],
        chargers: [
          ChargerModel(
            id: 'sf_13_c1',
            stationId: 'sf_13',
            name: 'Beach-1',
            type: ChargerType.ccs,
            power: 150,
          ),
          ChargerModel(
            id: 'sf_13_c2',
            stationId: 'sf_13',
            name: 'Beach-2',
            type: ChargerType.type2,
            power: 22,
          ),
        ],
        distance: 1,
      ),
      const StationModel(
        id: 'sf_14',
        name: 'Mission District EV',
        address: '2800 Mission St, San Francisco, CA 94110',
        latitude: 37.7514,
        longitude: -122.4194,
        description: 'Vibrant Mission District charging station.',
        rating: 4.4,
        reviewCount: 178,
        pricePerKwh: 0.32,
        is24Hours: true,
        amenities: [
          Amenity.wifi,
          Amenity.restroom,
          Amenity.restaurant,
          Amenity.shopping,
        ],
        chargers: [
          ChargerModel(
            id: 'sf_14_c1',
            stationId: 'sf_14',
            name: 'Mission-1',
            type: ChargerType.ccs,
            power: 150,
          ),
          ChargerModel(
            id: 'sf_14_c2',
            stationId: 'sf_14',
            name: 'Mission-2',
            type: ChargerType.ccs,
            power: 150,
          ),
          ChargerModel(
            id: 'sf_14_c3',
            stationId: 'sf_14',
            name: 'Mission-3',
            type: ChargerType.type2,
            power: 22,
          ),
        ],
        distance: 1.9,
      ),
      const StationModel(
        id: 'sf_15',
        name: 'Richmond District Charger',
        address: '3500 Geary Blvd, San Francisco, CA 94118',
        latitude: 37.7844,
        longitude: -122.4642,
        description: 'Residential area charging station.',
        rating: 4.3,
        reviewCount: 95,
        pricePerKwh: 0.34,
        is24Hours: true,
        amenities: [Amenity.restroom, Amenity.cafe, Amenity.parking],
        chargers: [
          ChargerModel(
            id: 'sf_15_c1',
            stationId: 'sf_15',
            name: 'Richmond-1',
            type: ChargerType.type2,
            power: 22,
          ),
          ChargerModel(
            id: 'sf_15_c2',
            stationId: 'sf_15',
            name: 'Richmond-2',
            type: ChargerType.type2,
            power: 22,
          ),
        ],
        distance: 2.8,
      ),
      const StationModel(
        id: 'sf_16',
        name: 'Potrero Hill Supercharger',
        address: '1800 18th St, San Francisco, CA 94107',
        latitude: 37.7644,
        longitude: -122.4014,
        description: 'Hilltop charging with city views.',
        rating: 4.6,
        reviewCount: 134,
        pricePerKwh: 0.38,
        is24Hours: true,
        amenities: [
          Amenity.wifi,
          Amenity.restroom,
          Amenity.cafe,
          Amenity.parking,
        ],
        chargers: [
          ChargerModel(
            id: 'sf_16_c1',
            stationId: 'sf_16',
            name: 'V3-1',
            type: ChargerType.tesla,
            power: 250,
          ),
          ChargerModel(
            id: 'sf_16_c2',
            stationId: 'sf_16',
            name: 'V3-2',
            type: ChargerType.tesla,
            power: 250,
          ),
          ChargerModel(
            id: 'sf_16_c3',
            stationId: 'sf_16',
            name: 'CCS-1',
            type: ChargerType.ccs,
            power: 150,
          ),
        ],
        distance: 1.4,
      ),
      const StationModel(
        id: 'sf_17',
        name: 'Bernal Heights EV',
        address: '300 Cortland Ave, San Francisco, CA 94110',
        latitude: 37.7444,
        longitude: -122.4144,
        description: 'Neighborhood charging in Bernal Heights.',
        rating: 4.5,
        reviewCount: 102,
        pricePerKwh: 0.33,
        is24Hours: true,
        amenities: [Amenity.wifi, Amenity.restroom, Amenity.cafe],
        chargers: [
          ChargerModel(
            id: 'sf_17_c1',
            stationId: 'sf_17',
            name: 'Bernal-1',
            type: ChargerType.ccs,
            power: 150,
          ),
          ChargerModel(
            id: 'sf_17_c2',
            stationId: 'sf_17',
            name: 'Bernal-2',
            type: ChargerType.type2,
            power: 22,
          ),
        ],
        distance: 2.3,
      ),
      const StationModel(
        id: 'sf_18',
        name: 'Sunset District Charging',
        address: '2500 Irving St, San Francisco, CA 94122',
        latitude: 37.7644,
        longitude: -122.4744,
        description: 'Family-friendly charging in Sunset District.',
        rating: 4.4,
        reviewCount: 118,
        pricePerKwh: 0.31,
        is24Hours: true,
        amenities: [Amenity.restroom, Amenity.parking, Amenity.playground],
        chargers: [
          ChargerModel(
            id: 'sf_18_c1',
            stationId: 'sf_18',
            name: 'Sunset-1',
            type: ChargerType.type2,
            power: 22,
          ),
          ChargerModel(
            id: 'sf_18_c2',
            stationId: 'sf_18',
            name: 'Sunset-2',
            type: ChargerType.type2,
            power: 22,
          ),
        ],
        distance: 3.2,
      ),
      const StationModel(
        id: 'sf_19',
        name: 'Financial District Fast Charge',
        address: '200 California St, San Francisco, CA 94111',
        latitude: 37.7944,
        longitude: -122.3994,
        description: 'Business district ultra-fast charging.',
        rating: 4.7,
        reviewCount: 298,
        pricePerKwh: 0.44,
        is24Hours: true,
        amenities: [
          Amenity.wifi,
          Amenity.restroom,
          Amenity.restaurant,
          Amenity.parking,
        ],
        chargers: [
          ChargerModel(
            id: 'sf_19_c1',
            stationId: 'sf_19',
            name: 'Fast-1',
            type: ChargerType.ccs,
            power: 350,
          ),
          ChargerModel(
            id: 'sf_19_c2',
            stationId: 'sf_19',
            name: 'Fast-2',
            type: ChargerType.ccs,
            power: 350,
          ),
          ChargerModel(
            id: 'sf_19_c3',
            stationId: 'sf_19',
            name: 'Fast-3',
            type: ChargerType.ccs,
            power: 350,
          ),
        ],
        distance: 0.5,
      ),
      const StationModel(
        id: 'sf_20',
        name: 'Nob Hill Charging',
        address: '1000 California St, San Francisco, CA 94108',
        latitude: 37.7925,
        longitude: -122.4106,
        description: 'Upscale Nob Hill charging station.',
        rating: 4.8,
        reviewCount: 167,
        pricePerKwh: 0.41,
        is24Hours: true,
        amenities: [
          Amenity.wifi,
          Amenity.restroom,
          Amenity.restaurant,
          Amenity.parking,
        ],
        chargers: [
          ChargerModel(
            id: 'sf_20_c1',
            stationId: 'sf_20',
            name: 'Nob-1',
            type: ChargerType.ccs,
            power: 150,
          ),
          ChargerModel(
            id: 'sf_20_c2',
            stationId: 'sf_20',
            name: 'Nob-2',
            type: ChargerType.ccs,
            power: 150,
          ),
        ],
        distance: 0.6,
      ),
      const StationModel(
        id: 'sf_21',
        name: 'Russian Hill EV Station',
        address: '1500 Hyde St, San Francisco, CA 94109',
        latitude: 37.8006,
        longitude: -122.4177,
        description: 'Historic neighborhood charging point.',
        rating: 4.5,
        reviewCount: 109,
        pricePerKwh: 0.37,
        is24Hours: true,
        amenities: [Amenity.wifi, Amenity.restroom, Amenity.cafe],
        chargers: [
          ChargerModel(
            id: 'sf_21_c1',
            stationId: 'sf_21',
            name: 'Russian-1',
            type: ChargerType.ccs,
            power: 150,
          ),
          ChargerModel(
            id: 'sf_21_c2',
            stationId: 'sf_21',
            name: 'Russian-2',
            type: ChargerType.type2,
            power: 22,
          ),
        ],
        distance: 0.9,
      ),
      const StationModel(
        id: 'sf_22',
        name: 'Tenderloin Charging Hub',
        address: '800 Market St, San Francisco, CA 94102',
        latitude: 37.7849,
        longitude: -122.4094,
        description: 'Central location charging station.',
        rating: 4.2,
        reviewCount: 145,
        pricePerKwh: 0.30,
        is24Hours: true,
        amenities: [Amenity.restroom, Amenity.parking],
        chargers: [
          ChargerModel(
            id: 'sf_22_c1',
            stationId: 'sf_22',
            name: 'TL-1',
            type: ChargerType.ccs,
            power: 150,
          ),
          ChargerModel(
            id: 'sf_22_c2',
            stationId: 'sf_22',
            name: 'TL-2',
            type: ChargerType.ccs,
            power: 150,
          ),
        ],
        distance: 0.1,
      ),
      const StationModel(
        id: 'sf_23',
        name: 'Bayview Charging Station',
        address: '500 3rd St, San Francisco, CA 94107',
        latitude: 37.7744,
        longitude: -122.3894,
        description: 'Waterfront charging with bay views.',
        rating: 4.4,
        reviewCount: 112,
        pricePerKwh: 0.35,
        is24Hours: true,
        amenities: [Amenity.wifi, Amenity.restroom, Amenity.parking],
        chargers: [
          ChargerModel(
            id: 'sf_23_c1',
            stationId: 'sf_23',
            name: 'Bay-1',
            type: ChargerType.ccs,
            power: 150,
          ),
          ChargerModel(
            id: 'sf_23_c2',
            stationId: 'sf_23',
            name: 'Bay-2',
            type: ChargerType.ccs,
            power: 150,
          ),
        ],
        distance: 1.6,
      ),
      const StationModel(
        id: 'sf_24',
        name: 'Glen Park EV Charger',
        address: '2800 Diamond St, San Francisco, CA 94131',
        latitude: 37.7344,
        longitude: -122.4344,
        description: 'Quiet neighborhood charging point.',
        rating: 4.3,
        reviewCount: 78,
        pricePerKwh: 0.32,
        is24Hours: true,
        amenities: [Amenity.restroom, Amenity.parking],
        chargers: [
          ChargerModel(
            id: 'sf_24_c1',
            stationId: 'sf_24',
            name: 'Glen-1',
            type: ChargerType.type2,
            power: 22,
          ),
          ChargerModel(
            id: 'sf_24_c2',
            stationId: 'sf_24',
            name: 'Glen-2',
            type: ChargerType.type2,
            power: 22,
          ),
        ],
        distance: 2.8,
      ),
      const StationModel(
        id: 'sf_25',
        name: 'Noe Valley Charging',
        address: '4000 24th St, San Francisco, CA 94114',
        latitude: 37.7514,
        longitude: -122.4294,
        description: 'Family-friendly neighborhood charging.',
        rating: 4.6,
        reviewCount: 134,
        pricePerKwh: 0.34,
        is24Hours: true,
        amenities: [
          Amenity.wifi,
          Amenity.restroom,
          Amenity.cafe,
          Amenity.parking,
        ],
        chargers: [
          ChargerModel(
            id: 'sf_25_c1',
            stationId: 'sf_25',
            name: 'Noe-1',
            type: ChargerType.ccs,
            power: 150,
          ),
          ChargerModel(
            id: 'sf_25_c2',
            stationId: 'sf_25',
            name: 'Noe-2',
            type: ChargerType.ccs,
            power: 150,
          ),
        ],
        distance: 2,
      ),
      const StationModel(
        id: 'sf_26',
        name: 'Diamond Heights EV',
        address: '5000 Diamond Heights Blvd, San Francisco, CA 94131',
        latitude: 37.7444,
        longitude: -122.4444,
        description: 'Hilltop charging with panoramic views.',
        rating: 4.5,
        reviewCount: 96,
        pricePerKwh: 0.36,
        is24Hours: true,
        amenities: [Amenity.wifi, Amenity.restroom, Amenity.parking],
        chargers: [
          ChargerModel(
            id: 'sf_26_c1',
            stationId: 'sf_26',
            name: 'Diamond-1',
            type: ChargerType.ccs,
            power: 150,
          ),
          ChargerModel(
            id: 'sf_26_c2',
            stationId: 'sf_26',
            name: 'Diamond-2',
            type: ChargerType.type2,
            power: 22,
          ),
        ],
        distance: 2.5,
      ),
      const StationModel(
        id: 'sf_27',
        name: 'Excelsior District Charger',
        address: '4500 Mission St, San Francisco, CA 94112',
        latitude: 37.7244,
        longitude: -122.4244,
        description: 'Diverse neighborhood charging station.',
        rating: 4.3,
        reviewCount: 89,
        pricePerKwh: 0.31,
        is24Hours: true,
        amenities: [Amenity.restroom, Amenity.parking],
        chargers: [
          ChargerModel(
            id: 'sf_27_c1',
            stationId: 'sf_27',
            name: 'Excel-1',
            type: ChargerType.type2,
            power: 22,
          ),
          ChargerModel(
            id: 'sf_27_c2',
            stationId: 'sf_27',
            name: 'Excel-2',
            type: ChargerType.type2,
            power: 22,
          ),
        ],
        distance: 3.1,
      ),
      const StationModel(
        id: 'sf_28',
        name: 'Ocean Beach Charging',
        address: '1000 Great Highway, San Francisco, CA 94121',
        latitude: 37.7544,
        longitude: -122.5094,
        description: 'Beachside charging with ocean views.',
        rating: 4.6,
        reviewCount: 156,
        pricePerKwh: 0.33,
        is24Hours: true,
        amenities: [Amenity.restroom, Amenity.parking],
        chargers: [
          ChargerModel(
            id: 'sf_28_c1',
            stationId: 'sf_28',
            name: 'Ocean-1',
            type: ChargerType.ccs,
            power: 150,
          ),
          ChargerModel(
            id: 'sf_28_c2',
            stationId: 'sf_28',
            name: 'Ocean-2',
            type: ChargerType.type2,
            power: 22,
          ),
        ],
        distance: 3.5,
      ),
      const StationModel(
        id: 'sf_29',
        name: 'Lakeshore Charging',
        address: '200 Sloat Blvd, San Francisco, CA 94132',
        latitude: 37.7344,
        longitude: -122.4894,
        description: 'Near Lake Merced charging point.',
        rating: 4.4,
        reviewCount: 102,
        pricePerKwh: 0.32,
        is24Hours: true,
        amenities: [Amenity.restroom, Amenity.parking],
        chargers: [
          ChargerModel(
            id: 'sf_29_c1',
            stationId: 'sf_29',
            name: 'Lake-1',
            type: ChargerType.type2,
            power: 22,
          ),
          ChargerModel(
            id: 'sf_29_c2',
            stationId: 'sf_29',
            name: 'Lake-2',
            type: ChargerType.type2,
            power: 22,
          ),
        ],
        distance: 4.2,
      ),
      const StationModel(
        id: 'sf_30',
        name: 'Portola District EV',
        address: '3000 San Bruno Ave, San Francisco, CA 94134',
        latitude: 37.7144,
        longitude: -122.4044,
        description: 'Residential area charging station.',
        rating: 4.2,
        reviewCount: 87,
        pricePerKwh: 0.30,
        is24Hours: true,
        amenities: [Amenity.restroom, Amenity.parking],
        chargers: [
          ChargerModel(
            id: 'sf_30_c1',
            stationId: 'sf_30',
            name: 'Portola-1',
            type: ChargerType.type2,
            power: 22,
          ),
          ChargerModel(
            id: 'sf_30_c2',
            stationId: 'sf_30',
            name: 'Portola-2',
            type: ChargerType.type2,
            power: 22,
          ),
        ],
        distance: 3.8,
      ),
      const StationModel(
        id: 'sf_31',
        name: 'Visitacion Valley Charger',
        address: '400 Leland Ave, San Francisco, CA 94134',
        latitude: 37.7144,
        longitude: -122.4094,
        description: 'Community charging in Visitacion Valley.',
        rating: 4.3,
        reviewCount: 76,
        pricePerKwh: 0.29,
        is24Hours: true,
        amenities: [Amenity.restroom, Amenity.parking],
        chargers: [
          ChargerModel(
            id: 'sf_31_c1',
            stationId: 'sf_31',
            name: 'Visit-1',
            type: ChargerType.type2,
            power: 22,
          ),
          ChargerModel(
            id: 'sf_31_c2',
            stationId: 'sf_31',
            name: 'Visit-2',
            type: ChargerType.type2,
            power: 22,
          ),
        ],
        distance: 4,
      ),
      const StationModel(
        id: 'sf_32',
        name: 'Treasure Island Supercharger',
        address: '1 Avenue of the Palms, San Francisco, CA 94130',
        latitude: 37.8244,
        longitude: -122.3694,
        description: 'Island charging with bay bridge views.',
        rating: 4.7,
        reviewCount: 145,
        pricePerKwh: 0.39,
        is24Hours: true,
        amenities: [Amenity.wifi, Amenity.restroom, Amenity.parking],
        chargers: [
          ChargerModel(
            id: 'sf_32_c1',
            stationId: 'sf_32',
            name: 'V3-1',
            type: ChargerType.tesla,
            power: 250,
          ),
          ChargerModel(
            id: 'sf_32_c2',
            stationId: 'sf_32',
            name: 'V3-2',
            type: ChargerType.tesla,
            power: 250,
          ),
          ChargerModel(
            id: 'sf_32_c3',
            stationId: 'sf_32',
            name: 'CCS-1',
            type: ChargerType.ccs,
            power: 150,
          ),
        ],
        distance: 2.2,
      ),
      const StationModel(
        id: 'sf_33',
        name: 'Alamo Square EV Hub',
        address: '600 Hayes St, San Francisco, CA 94117',
        latitude: 37.7761,
        longitude: -122.4344,
        description: 'Iconic Painted Ladies neighborhood charging.',
        rating: 4.6,
        reviewCount: 178,
        pricePerKwh: 0.36,
        is24Hours: true,
        amenities: [
          Amenity.wifi,
          Amenity.restroom,
          Amenity.cafe,
          Amenity.parking,
        ],
        chargers: [
          ChargerModel(
            id: 'sf_33_c1',
            stationId: 'sf_33',
            name: 'Alamo-1',
            type: ChargerType.ccs,
            power: 150,
          ),
          ChargerModel(
            id: 'sf_33_c2',
            stationId: 'sf_33',
            name: 'Alamo-2',
            type: ChargerType.ccs,
            power: 150,
          ),
        ],
        distance: 1.1,
      ),
      const StationModel(
        id: 'sf_34',
        name: 'Duboce Triangle Charging',
        address: '500 Duboce Ave, San Francisco, CA 94117',
        latitude: 37.7699,
        longitude: -122.4294,
        description: 'Central location near public transit.',
        rating: 4.5,
        reviewCount: 123,
        pricePerKwh: 0.35,
        is24Hours: true,
        amenities: [Amenity.wifi, Amenity.restroom, Amenity.cafe],
        chargers: [
          ChargerModel(
            id: 'sf_34_c1',
            stationId: 'sf_34',
            name: 'Duboce-1',
            type: ChargerType.ccs,
            power: 150,
          ),
          ChargerModel(
            id: 'sf_34_c2',
            stationId: 'sf_34',
            name: 'Duboce-2',
            type: ChargerType.type2,
            power: 22,
          ),
        ],
        distance: 1.7,
      ),
      const StationModel(
        id: 'sf_35',
        name: 'Dogpatch Charging Station',
        address: '2500 3rd St, San Francisco, CA 94107',
        latitude: 37.7644,
        longitude: -122.3894,
        description: 'Industrial district charging hub.',
        rating: 4.4,
        reviewCount: 98,
        pricePerKwh: 0.34,
        is24Hours: true,
        amenities: [Amenity.wifi, Amenity.restroom, Amenity.parking],
        chargers: [
          ChargerModel(
            id: 'sf_35_c1',
            stationId: 'sf_35',
            name: 'Dogpatch-1',
            type: ChargerType.ccs,
            power: 150,
          ),
          ChargerModel(
            id: 'sf_35_c2',
            stationId: 'sf_35',
            name: 'Dogpatch-2',
            type: ChargerType.ccs,
            power: 150,
          ),
        ],
        distance: 1.5,
      ),
    ];
  }

  @override
  Future<List<StationModel>> getStations({int page = 1, int limit = 20}) async {
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
        .map(
          (s) => s.copyWith(
            isFavorite: _favorites.contains(s.id),
            imageUrl: imageUrls[s.id] ?? s.imageUrl,
          ),
        )
        .toList();
  }

  @override
  Future<StationModel?> getStationById(String id) async {
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
        .map(
          (s) => s.copyWith(
            isFavorite: _favorites.contains(s.id),
            imageUrl: imageUrls[s.id] ?? s.imageUrl,
          ),
        )
        .toList();
  }

  @override
  Future<List<StationModel>> searchStations(String query) async {
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
        .map(
          (s) => s.copyWith(
            isFavorite: _favorites.contains(s.id),
            imageUrl: imageUrls[s.id] ?? s.imageUrl,
          ),
        )
        .toList();
  }

  @override
  Future<List<StationModel>> getFavoriteStations() async {
    final favorites = _stations
        .where((s) => _favorites.contains(s.id))
        .map((s) => s.copyWith(isFavorite: true))
        .toList();

    // For UI template: if no favorites, return dummy favorites
    if (favorites.isEmpty) {
      return _stations
          .take(4)
          .map((s) => s.copyWith(isFavorite: true))
          .toList();
    }

    return favorites;
  }

  @override
  Future<bool> toggleFavorite(String stationId) async {
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
    return true;
  }

  @override
  Future<List<ChargerModel>> getStationChargers(String stationId) async {
    final station = await getStationById(stationId);
    return station?.chargers ?? [];
  }
}
