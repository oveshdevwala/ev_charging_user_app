/// File: lib/repositories/home_repository.dart
/// Purpose: Home repository for fetching home screen data
/// Belongs To: home feature
/// Customization Guide:
///    - Replace DummyHomeRepository with real API implementation
///    - All methods return Future for async compatibility

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

    return [
      StationModel(
        id: 'station_001',
        name: 'GreenCharge Downtown',
        address: '123 Main Street, San Francisco, CA',
        latitude: 37.7749,
        longitude: -122.4194,
        imageUrl: HomeImages.station1,
        rating: 4.8,
        reviewCount: 245,
        pricePerKwh: 0.35,
        distance: 0.8,
        is24Hours: true,
        chargers: [
          const ChargerModel(
            id: 'c1',
            stationId: 'station_001',
            name: 'CCS Fast Charger',
            type: ChargerType.ccs,
            power: 150,
            status: ChargerStatus.available,
          ),
          const ChargerModel(
            id: 'c2',
            stationId: 'station_001',
            name: 'CHAdeMO Charger',
            type: ChargerType.chademo,
            power: 50,
            status: ChargerStatus.available,
          ),
        ],
        amenities: [Amenity.wifi, Amenity.cafe, Amenity.restroom],
      ),
      StationModel(
        id: 'station_002',
        name: 'PowerUp Station',
        address: '456 Market Street, San Francisco, CA',
        latitude: 37.7899,
        longitude: -122.4010,
        imageUrl: HomeImages.station2,
        rating: 4.6,
        reviewCount: 189,
        pricePerKwh: 0.40,
        distance: 1.2,
        is24Hours: false,
        openTime: '06:00',
        closeTime: '22:00',
        chargers: [
          const ChargerModel(
            id: 'c3',
            stationId: 'station_002',
            name: 'Type 2 AC Charger',
            type: ChargerType.type2,
            power: 22,
            status: ChargerStatus.available,
          ),
          const ChargerModel(
            id: 'c4',
            stationId: 'station_002',
            name: 'CCS DC Fast',
            type: ChargerType.ccs,
            power: 100,
            status: ChargerStatus.charging,
          ),
        ],
        amenities: [Amenity.parking, Amenity.shopping],
      ),
      StationModel(
        id: 'station_003',
        name: 'EcoCharge Hub',
        address: '789 Valencia Street, San Francisco, CA',
        latitude: 37.7649,
        longitude: -122.4224,
        imageUrl: HomeImages.station3,
        rating: 4.9,
        reviewCount: 312,
        pricePerKwh: 0.32,
        distance: 1.5,
        is24Hours: true,
        isFavorite: true,
        chargers: [
          const ChargerModel(
            id: 'c5',
            stationId: 'station_003',
            name: 'CCS Ultra Fast',
            type: ChargerType.ccs,
            power: 350,
            status: ChargerStatus.available,
          ),
          const ChargerModel(
            id: 'c6',
            stationId: 'station_003',
            name: 'Tesla Supercharger',
            type: ChargerType.tesla,
            power: 250,
            status: ChargerStatus.available,
          ),
        ],
        amenities: [Amenity.lounge, Amenity.wifi, Amenity.cafe, Amenity.restroom],
      ),
      StationModel(
        id: 'station_004',
        name: 'QuickVolt Station',
        address: '321 Hayes Street, San Francisco, CA',
        latitude: 37.7769,
        longitude: -122.4294,
        imageUrl: HomeImages.station4,
        rating: 4.4,
        reviewCount: 156,
        pricePerKwh: 0.38,
        distance: 2.1,
        is24Hours: true,
        chargers: [
          const ChargerModel(
            id: 'c7',
            stationId: 'station_004',
            name: 'CCS Fast Charger',
            type: ChargerType.ccs,
            power: 150,
            status: ChargerStatus.available,
          ),
        ],
        amenities: [Amenity.parking],
      ),
      StationModel(
        id: 'station_005',
        name: 'ChargeMaster Pro',
        address: '555 Howard Street, San Francisco, CA',
        latitude: 37.7879,
        longitude: -122.3964,
        imageUrl: HomeImages.station5,
        rating: 4.7,
        reviewCount: 278,
        pricePerKwh: 0.42,
        distance: 2.8,
        is24Hours: true,
        chargers: [
          const ChargerModel(
            id: 'c8',
            stationId: 'station_005',
            name: 'CCS Ultra Fast 1',
            type: ChargerType.ccs,
            power: 350,
            status: ChargerStatus.available,
          ),
          const ChargerModel(
            id: 'c9',
            stationId: 'station_005',
            name: 'CCS Ultra Fast 2',
            type: ChargerType.ccs,
            power: 350,
            status: ChargerStatus.available,
          ),
          const ChargerModel(
            id: 'c10',
            stationId: 'station_005',
            name: 'Type 2 AC Charger',
            type: ChargerType.type2,
            power: 22,
            status: ChargerStatus.occupied,
          ),
        ],
        amenities: [Amenity.wifi, Amenity.restaurant, Amenity.shopping],
      ),
    ];
  }

  @override
  Future<List<TripRouteModel>> fetchSavedRoutes() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));

    return [
      TripRouteModel(
        id: 'route_001',
        from: 'San Francisco',
        to: 'Los Angeles',
        fromAddress: 'San Francisco, CA',
        toAddress: 'Los Angeles, CA',
        distance: 615.0,
        name: 'Weekend Trip to LA',
        isFavorite: true,
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
        stops: [
          const TripStop(
            id: 'stop_001',
            stationId: 'station_101',
            stationName: 'Gilroy Supercharger',
            address: 'Gilroy, CA',
            latitude: 37.0058,
            longitude: -121.5683,
            estimatedChargeTimeMin: 25,
            estimatedCost: 12.50,
            distanceFromPrevious: 125.0,
            chargerPowerKw: 250,
          ),
          const TripStop(
            id: 'stop_002',
            stationId: 'station_102',
            stationName: 'Kettleman City Station',
            address: 'Kettleman City, CA',
            latitude: 35.9894,
            longitude: -119.9616,
            estimatedChargeTimeMin: 30,
            estimatedCost: 15.00,
            distanceFromPrevious: 180.0,
            chargerPowerKw: 150,
          ),
        ],
        estimation: const TripEnergyEstimation(
          totalDistanceKm: 615.0,
          estimatedEnergyKwh: 185.0,
          estimatedCost: 65.00,
          estimatedTimeMin: 420,
          requiredStops: 2,
        ),
      ),
      TripRouteModel(
        id: 'route_002',
        from: 'San Francisco',
        to: 'Napa Valley',
        fromAddress: 'San Francisco, CA',
        toAddress: 'Napa, CA',
        distance: 95.0,
        createdAt: DateTime.now().subtract(const Duration(days: 14)),
        stops: [],
        estimation: const TripEnergyEstimation(
          totalDistanceKm: 95.0,
          estimatedEnergyKwh: 28.0,
          estimatedCost: 10.00,
          estimatedTimeMin: 75,
          requiredStops: 0,
        ),
      ),
      TripRouteModel(
        id: 'route_003',
        from: 'San Francisco',
        to: 'Lake Tahoe',
        fromAddress: 'San Francisco, CA',
        toAddress: 'South Lake Tahoe, CA',
        distance: 310.0,
        name: 'Ski Trip',
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        stops: [
          const TripStop(
            id: 'stop_003',
            stationId: 'station_103',
            stationName: 'Sacramento Supercharger',
            address: 'Sacramento, CA',
            latitude: 38.5816,
            longitude: -121.4944,
            estimatedChargeTimeMin: 20,
            estimatedCost: 10.00,
            distanceFromPrevious: 145.0,
            chargerPowerKw: 250,
          ),
        ],
        estimation: const TripEnergyEstimation(
          totalDistanceKm: 310.0,
          estimatedEnergyKwh: 95.0,
          estimatedCost: 35.00,
          estimatedTimeMin: 240,
          requiredStops: 1,
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
        type: OfferType.dailyDeal,
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
      BundleModel(
        id: 'bundle_001',
        titleKey: 'bundle_unlimited_title',
        benefitKey: 'bundle_unlimited_desc',
        iconUrl: HomeImages.bundleUnlimited,
        type: BundleType.unlimited,
        price: 99.99,
        originalPrice: 149.99,
        duration: 30,
        isPopular: true,
        features: ['Unlimited charging', 'Priority access', '24/7 support'],
        color: '#00C853',
      ),
      BundleModel(
        id: 'bundle_002',
        titleKey: 'bundle_saver_title',
        benefitKey: 'bundle_saver_desc',
        iconUrl: HomeImages.bundleSaver,
        type: BundleType.monthly,
        price: 49.99,
        originalPrice: 59.99,
        duration: 30,
        features: ['200 kWh included', 'Discounted rates', 'App benefits'],
        color: '#2196F3',
      ),
      BundleModel(
        id: 'bundle_003',
        titleKey: 'bundle_home_title',
        benefitKey: 'bundle_home_desc',
        iconUrl: HomeImages.bundleHome,
        type: BundleType.homeCharging,
        price: 299.00,
        features: ['Home charger install', 'Smart scheduling', 'Energy tracking'],
        isBestValue: true,
        badgeKey: 'bundle_badge_best_value',
        color: '#7C4DFF',
      ),
      BundleModel(
        id: 'bundle_004',
        titleKey: 'bundle_business_title',
        benefitKey: 'bundle_business_desc',
        iconUrl: HomeImages.bundleBusiness,
        type: BundleType.business,
        price: 199.99,
        duration: 30,
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
      totalEnergyKwh: 4520.0,
      totalSpent: 1580.00,
      level: 5,
      xpPoints: 450,
      lastChargingDate: DateTime.now().subtract(const Duration(hours: 3)),
      badges: ['early_adopter', 'eco_warrior', 'power_user'],
    );
  }
}

