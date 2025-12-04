/// File: lib/repositories/home_repository.dart
/// Purpose: Home repository for fetching home screen data
/// Belongs To: home feature
/// Customization Guide:
///    - Replace DummyHomeRepository with real API implementation
///    - All methods return Future for async compatibility
library;

import '../core/constants/home_images.dart';
import '../models/bundle_model.dart';
import '../models/charger_model.dart';
import '../models/offer_model.dart';
import '../models/station_model.dart';
import '../models/trip_route_model.dart';
import '../models/user_activity_model.dart';

// ============================================================
// HOME REPOSITORY INTERFACE
// ============================================================

/// Abstract home repository interface.
abstract class HomeRepository {
  /// Fetch nearby stations with smart ranking.
  Future<List<StationModel>> fetchNearbyStations({
    double? latitude,
    double? longitude,
    int limit = 10,
  });

  /// Fetch saved trip routes.
  Future<List<TripRouteModel>> fetchSavedRoutes();

  /// Fetch promotional offers.
  Future<List<OfferModel>> fetchOffers();

  /// Fetch recommended bundles.
  Future<List<BundleModel>> fetchBundles();

  /// Fetch user activity summary.
  Future<UserActivitySummary> fetchActivitySummary();
}

// ============================================================
// DUMMY HOME REPOSITORY IMPLEMENTATION
// ============================================================

/// Dummy implementation of HomeRepository for development.
class DummyHomeRepository implements HomeRepository {
  @override
  Future<List<StationModel>> fetchNearbyStations({
    double? latitude,
    double? longitude,
    int limit = 10,
  }) async {
    // Simulate network delay
    await Future<void>.delayed(const Duration(milliseconds: 500));

    // Use consistent station IDs that match station_repository.dart
    return [
      const StationModel(
        id: 'station_1',
        name: 'Downtown EV Hub',
        address: '123 Main Street, San Francisco, CA 94102',
        latitude: 37.7849,
        longitude: -122.4094,
        imageUrl: HomeImages.station1,
        rating: 4.8,
        reviewCount: 124,
        pricePerKwh: 0.35,
        distance: 0.5,
        is24Hours: true,
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
        ],
        amenities: [Amenity.wifi, Amenity.cafe, Amenity.restroom, Amenity.parking],
      ),
      const StationModel(
        id: 'station_2',
        name: 'Green Valley Charge Point',
        address: '456 Oak Avenue, San Francisco, CA 94103',
        latitude: 37.7749,
        longitude: -122.4194,
        imageUrl: HomeImages.station2,
        rating: 4.5,
        reviewCount: 89,
        pricePerKwh: 0.30,
        distance: 1.2,
        openTime: '06:00',
        closeTime: '22:00',
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
        amenities: [Amenity.wifi, Amenity.parking, Amenity.shopping],
      ),
      const StationModel(
        id: 'station_3',
        name: 'Tesla Supercharger - Mall',
        address: '789 Market Street, San Francisco, CA 94104',
        latitude: 37.7859,
        longitude: -122.4084,
        imageUrl: HomeImages.station3,
        rating: 4.9,
        reviewCount: 256,
        pricePerKwh: 0.40,
        distance: 0.8,
        is24Hours: true,
        isFavorite: true,
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
        ],
        amenities: [Amenity.wifi, Amenity.restroom, Amenity.cafe, Amenity.restaurant, Amenity.shopping, Amenity.parking],
      ),
      const StationModel(
        id: 'station_4',
        name: 'City Park Charging',
        address: '321 Park Boulevard, San Francisco, CA 94105',
        latitude: 37.7699,
        longitude: -122.4094,
        imageUrl: HomeImages.station4,
        rating: 4.3,
        reviewCount: 67,
        pricePerKwh: 0.28,
        distance: 2.1,
        openTime: '05:00',
        closeTime: '23:00',
        chargers: [
          ChargerModel(
            id: 'charger_4_1',
            stationId: 'station_4',
            name: 'Park 1',
            type: ChargerType.chademo,
            power: 50,
          ),
        ],
        amenities: [Amenity.restroom, Amenity.parking, Amenity.playground],
      ),
      const StationModel(
        id: 'station_5',
        name: 'Highway Rest Stop',
        address: '555 Interstate Drive, San Francisco, CA 94106',
        latitude: 37.7599,
        longitude: -122.3994,
        imageUrl: HomeImages.station5,
        rating: 4.1,
        reviewCount: 203,
        pricePerKwh: 0.45,
        distance: 5.3,
        is24Hours: true,
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
        ],
        amenities: [Amenity.restroom, Amenity.cafe, Amenity.parking, Amenity.restaurant],
      ),
    ];
  }

  @override
  Future<List<TripRouteModel>> fetchSavedRoutes() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));

    // IDs match trip_planner repository for seamless navigation
    return [
      TripRouteModel(
        id: 'trip_sf_la', // Matches trip planner's trip ID
        from: 'San Francisco',
        to: 'Los Angeles',
        fromAddress: 'San Francisco, CA',
        toAddress: 'Los Angeles, CA',
        distance: 615,
        name: 'Weekend Trip to LA',
        isFavorite: true,
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
        stops: const [
          TripStop(
            id: 'stop_001',
            stationId: 'station_101',
            stationName: 'Gilroy Supercharger',
            address: 'Gilroy, CA',
            latitude: 37.0058,
            longitude: -121.5683,
            estimatedChargeTimeMin: 20,
            estimatedCost: 6.56,
            distanceFromPrevious: 125,
            chargerPowerKw: 250,
          ),
          TripStop(
            id: 'stop_002',
            stationId: 'station_102',
            stationName: 'Kettleman City Station',
            address: 'Kettleman City, CA',
            latitude: 35.9894,
            longitude: -119.9616,
            estimatedChargeTimeMin: 25,
            estimatedCost: 10.08,
            distanceFromPrevious: 185,
            chargerPowerKw: 350,
          ),
        ],
        estimation: const TripEnergyEstimation(
          totalDistanceKm: 615,
          estimatedEnergyKwh: 92.25,
          estimatedCost: 16.64,
          estimatedTimeMin: 415,
          requiredStops: 2,
        ),
      ),
      TripRouteModel(
        id: 'trip_sf_napa', // Matches trip planner's trip ID
        from: 'San Francisco',
        to: 'Napa',
        fromAddress: 'San Francisco, CA',
        toAddress: 'Napa, CA',
        distance: 95,
        name: 'Wine Country Day Trip',
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        estimation: const TripEnergyEstimation(
          totalDistanceKm: 95,
          estimatedEnergyKwh: 14.25,
          estimatedCost: 0,
          estimatedTimeMin: 70,
        ),
      ),
      TripRouteModel(
        id: 'trip_sf_tahoe', // Matches trip planner's trip ID
        from: 'San Francisco',
        to: 'Lake Tahoe',
        fromAddress: 'San Francisco, CA',
        toAddress: 'South Lake Tahoe, CA',
        distance: 320,
        name: 'Ski Trip to Tahoe',
        isFavorite: true,
        createdAt: DateTime.now().subtract(const Duration(days: 21)),
        stops: const [
          TripStop(
            id: 'stop_003',
            stationId: 'station_103',
            stationName: 'Sacramento Supercharger',
            address: 'Sacramento, CA',
            latitude: 38.5816,
            longitude: -121.4944,
            estimatedChargeTimeMin: 18,
            estimatedCost: 7.35,
            distanceFromPrevious: 140,
            chargerPowerKw: 250,
          ),
        ],
        estimation: const TripEnergyEstimation(
          totalDistanceKm: 320,
          estimatedEnergyKwh: 48,
          estimatedCost: 7.35,
          estimatedTimeMin: 218,
          requiredStops: 1,
        ),
      ),
      TripRouteModel(
        id: 'trip_sj_sac', // Matches trip planner's trip ID
        from: 'San Jose',
        to: 'Sacramento',
        fromAddress: 'San Jose, CA',
        toAddress: 'Sacramento, CA',
        distance: 180,
        name: 'Sacramento Day Trip',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        estimation: const TripEnergyEstimation(
          totalDistanceKm: 180,
          estimatedEnergyKwh: 27,
          estimatedCost: 0,
          estimatedTimeMin: 110,
        ),
      ),
    ];
  }

  @override
  Future<List<OfferModel>> fetchOffers() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));

    return [
      OfferModel(
        id: 'offer_001',
        titleKey: 'offer_flash_sale_title',
        descKey: 'offer_flash_sale_desc',
        bannerUrl: HomeImages.offerBanner1,
        discountPercent: 25,
        validUntil: DateTime.now().add(const Duration(hours: 12)),
      ),
      OfferModel(
        id: 'offer_002',
        titleKey: 'offer_cashback_title',
        descKey: 'offer_cashback_desc',
        bannerUrl: HomeImages.offerBanner2,
        type: OfferType.cashback,
        discountPercent: 10,
        validUntil: DateTime.now().add(const Duration(days: 7)),
      ),
      OfferModel(
        id: 'offer_003',
        titleKey: 'offer_partner_title',
        descKey: 'offer_partner_desc',
        bannerUrl: HomeImages.offerBanner3,
        type: OfferType.partner,
        validUntil: DateTime.now().add(const Duration(days: 30)),
      ),
      OfferModel(
        id: 'offer_004',
        titleKey: 'offer_seasonal_title',
        descKey: 'offer_seasonal_desc',
        bannerUrl: HomeImages.offerBanner4,
        type: OfferType.seasonal,
        discountPercent: 15,
        validUntil: DateTime.now().add(const Duration(days: 14)),
      ),
    ];
  }

  @override
  Future<List<BundleModel>> fetchBundles() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));

    return [
      const BundleModel(
        id: 'bundle_001',
        titleKey: 'bundle_unlimited_title',
        benefitKey: 'bundle_unlimited_desc',
        iconUrl: HomeImages.bundleUnlimited,
        type: BundleType.unlimited,
        price: 99.99,
        originalPrice: 149.99,
        isPopular: true,
        features: ['Unlimited charging', 'Priority access', '24/7 support'],
        color: '#00C853',
      ),
      const BundleModel(
        id: 'bundle_002',
        titleKey: 'bundle_saver_title',
        benefitKey: 'bundle_saver_desc',
        iconUrl: HomeImages.bundleSaver,
        price: 49.99,
        originalPrice: 59.99,
        features: ['200 kWh included', 'Discounted rates', 'App benefits'],
        color: '#2196F3',
      ),
      const BundleModel(
        id: 'bundle_003',
        titleKey: 'bundle_home_title',
        benefitKey: 'bundle_home_desc',
        iconUrl: HomeImages.bundleHome,
        type: BundleType.homeCharging,
        price: 299,
        features: ['Home charger install', 'Smart scheduling', 'Energy tracking'],
        isBestValue: true,
        badgeKey: 'bundle_badge_best_value',
        color: '#7C4DFF',
      ),
      const BundleModel(
        id: 'bundle_004',
        titleKey: 'bundle_business_title',
        benefitKey: 'bundle_business_desc',
        iconUrl: HomeImages.bundleBusiness,
        type: BundleType.business,
        price: 199.99,
        features: ['Fleet management', 'Bulk discounts', 'Analytics dashboard'],
        color: '#FF9800',
      ),
    ];
  }

  @override
  Future<UserActivitySummary> fetchActivitySummary() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));

    return UserActivitySummary(
      sessionsToday: 2,
      energyUsedKwh: 45.5,
      moneySpent: 18.20,
      co2SavedKg: 22.75,
      streaks: 7,
      totalSessions: 156,
      totalEnergyKwh: 4520,
      totalSpent: 1580,
      level: 5,
      xpPoints: 450,
      lastChargingDate: DateTime.now().subtract(const Duration(hours: 3)),
      badges: const ['early_adopter', 'eco_warrior', 'power_user'],
    );
  }
}

