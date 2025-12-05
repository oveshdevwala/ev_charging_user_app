/// File: lib/repositories/activity_repository.dart
/// Purpose: Activity repository for fetching user activity data
/// Belongs To: activity feature
/// Customization Guide:
///    - Replace DummyActivityRepository with real API implementation
///    - All methods return Future for async compatibility
library;

import 'dart:math';

import '../core/constants/home_images.dart';
import '../models/charging_session_model.dart';
import '../models/transaction_model.dart';
import '../models/user_activity_model.dart';

// ============================================================
// ACTIVITY REPOSITORY INTERFACE
// ============================================================

/// Abstract activity repository interface.
abstract class ActivityRepository {
  /// Fetch user activity summary.
  Future<UserActivitySummary> fetchActivitySummary();

  /// Fetch charging sessions history.
  Future<List<ChargingSessionModel>> fetchChargingSessions({
    int limit = 20,
    int offset = 0,
  });

  /// Fetch transactions history.
  Future<List<TransactionModel>> fetchTransactions({
    int limit = 20,
    int offset = 0,
  });

  /// Fetch weekly charging data for graphs.
  Future<List<DailyChargingSummary>> fetchWeeklyData();

  /// Fetch monthly charging data for graphs.
  Future<List<DailyChargingSummary>> fetchMonthlyData();

  /// Fetch monthly summaries for year comparison.
  Future<List<MonthlyChargingSummary>> fetchYearlyData();

  /// Fetch activity insights.
  Future<ActivityInsights> fetchInsights();
}

/// Activity insights model.
class ActivityInsights {
  const ActivityInsights({
    this.averageSessionsPerWeek = 0.0,
    this.averageEnergyPerSession = 0.0,
    this.averageCostPerSession = 0.0,
    this.peakChargingHour = 0,
    this.preferredChargerType,
    this.mostVisitedStation,
    this.totalTreesEquivalent = 0.0,
    this.monthOverMonthGrowth = 0.0,
    this.savingsVsGasoline = 0.0,
    this.carbonFootprintReduction = 0.0,
    this.chargingEfficiency = 0.0,
  });

  final double averageSessionsPerWeek;
  final double averageEnergyPerSession;
  final double averageCostPerSession;
  final int peakChargingHour;
  final String? preferredChargerType;
  final String? mostVisitedStation;
  final double totalTreesEquivalent;
  final double monthOverMonthGrowth;
  final double savingsVsGasoline;
  final double carbonFootprintReduction;
  final double chargingEfficiency;

  /// Get peak hour formatted.
  String get peakHourFormatted {
    final hour = peakChargingHour > 12 ? peakChargingHour - 12 : peakChargingHour;
    final period = peakChargingHour >= 12 ? 'PM' : 'AM';
    return '$hour:00 $period';
  }
}

// ============================================================
// DUMMY ACTIVITY REPOSITORY IMPLEMENTATION
// ============================================================

/// Dummy implementation of ActivityRepository for development.
class DummyActivityRepository implements ActivityRepository {
  final _random = Random(42); // Fixed seed for consistent data

  // Cached data for synchronous access
  static List<ChargingSessionModel>? _cachedSessions;
  static List<TransactionModel>? _cachedTransactions;

  /// Get sessions synchronously (for list pages).
  List<ChargingSessionModel> getSessions() {
    _cachedSessions ??= _generateSessions(30);
    return _cachedSessions!;
  }

  /// Get transactions synchronously (for list pages).
  List<TransactionModel> getTransactions() {
    _cachedTransactions ??= _generateTransactions(30);
    return _cachedTransactions!;
  }

  /// Get session by ID.
  ChargingSessionModel? getSessionById(String id) {
    return getSessions().where((s) => s.id == id).firstOrNull;
  }

  /// Get transaction by ID.
  TransactionModel? getTransactionById(String id) {
    return getTransactions().where((t) => t.id == id).firstOrNull;
  }

  List<ChargingSessionModel> _generateSessions(int count) {
    final random = Random(42);
    final now = DateTime.now();
    final stations = [
      ('GreenCharge Downtown', HomeImages.station1),
      ('PowerUp Station', HomeImages.station2),
      ('EcoCharge Hub', HomeImages.station3),
      ('QuickVolt Station', HomeImages.station4),
      ('ChargeMaster Pro', HomeImages.station5),
    ];
    final chargerTypes = ['CCS', 'CHAdeMO', 'Type 2', 'Tesla'];

    return List.generate(count, (index) {
      final stationIndex = random.nextInt(stations.length);
      final station = stations[stationIndex];
      final hoursAgo = (index * 8) + random.nextInt(6);
      final sessionTime = now.subtract(Duration(hours: hoursAgo));
      final energy = 15.0 + random.nextDouble() * 50;
      final duration = Duration(minutes: 20 + random.nextInt(60));
      final power = [50.0, 100.0, 150.0, 250.0, 350.0][random.nextInt(5)];

      return ChargingSessionModel(
        id: 'session_${1000 + index}',
        stationId: 'station_00${stationIndex + 1}',
        stationName: station.$1,
        chargerId: 'charger_${random.nextInt(5) + 1}',
        chargerName: '${chargerTypes[random.nextInt(chargerTypes.length)]} Charger',
        startTime: sessionTime,
        endTime: sessionTime.add(duration),
        energyKwh: energy,
        cost: energy * 0.35 + random.nextDouble() * 2,
        duration: duration,
        chargerType: chargerTypes[random.nextInt(chargerTypes.length)],
        powerKw: power,
        startBatteryPercent: 15 + random.nextInt(30),
        endBatteryPercent: 75 + random.nextInt(25),
        co2SavedKg: energy * 0.5,
        stationImageUrl: station.$2,
      );
    });
  }

  List<TransactionModel> _generateTransactions(int count) {
    final random = Random(42);
    final now = DateTime.now();
    final transactions = <TransactionModel>[];

    for (var i = 0; i < count; i++) {
      final hoursAgo = (i * 12) + random.nextInt(8);
      final txTime = now.subtract(Duration(hours: hoursAgo));

      final typeRoll = random.nextInt(10);
      TransactionType type;
      double amount;
      String? description;
      String? stationName;
      double? energyKwh;

      if (typeRoll < 6) {
        type = TransactionType.charging;
        amount = 8.0 + random.nextDouble() * 25;
        final stations = ['GreenCharge Downtown', 'PowerUp Station', 'EcoCharge Hub'];
        stationName = stations[random.nextInt(stations.length)];
        energyKwh = amount / 0.35;
        description = 'Charging session at $stationName';
      } else if (typeRoll < 7) {
        type = TransactionType.subscription;
        amount = [49.99, 99.99][random.nextInt(2)];
        description = 'Monthly Unlimited Plan';
      } else if (typeRoll < 8) {
        type = TransactionType.topUp;
        amount = [20.0, 50.0, 100.0][random.nextInt(3)];
        description = 'Wallet top-up';
      } else if (typeRoll < 9) {
        type = TransactionType.reward;
        amount = 2.0 + random.nextDouble() * 8;
        description = 'Charging reward bonus';
      } else {
        type = TransactionType.referral;
        amount = 10.0;
        description = 'Referral bonus';
      }

      transactions.add(TransactionModel(
        id: 'tx_${2000 + i}',
        type: type,
        amount: amount,
        createdAt: txTime,
        paymentMethod: PaymentMethod.values[random.nextInt(4)],
        description: description,
        referenceId: 'REF${100000 + i}',
        sessionId: type == TransactionType.charging ? 'session_${1000 + i}' : null,
        stationName: stationName,
        energyKwh: energyKwh,
        fee: type == TransactionType.charging ? 0.25 : 0.0,
      ));
    }

    return transactions;
  }

  @override
  Future<UserActivitySummary> fetchActivitySummary() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));

    return const UserActivitySummary(
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
      badges: ['early_adopter', 'eco_warrior', 'power_user', 'streak_master'],
    );
  }

  @override
  Future<List<ChargingSessionModel>> fetchChargingSessions({
    int limit = 20,
    int offset = 0,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));

    final now = DateTime.now();
    final stations = [
      ('GreenCharge Downtown', HomeImages.station1),
      ('PowerUp Station', HomeImages.station2),
      ('EcoCharge Hub', HomeImages.station3),
      ('QuickVolt Station', HomeImages.station4),
      ('ChargeMaster Pro', HomeImages.station5),
    ];

    final chargerTypes = ['CCS', 'CHAdeMO', 'Type 2', 'Tesla'];

    return List.generate(limit, (index) {
      final stationIndex = _random.nextInt(stations.length);
      final station = stations[stationIndex];
      final hoursAgo = (index * 8) + _random.nextInt(6);
      final sessionTime = now.subtract(Duration(hours: hoursAgo));
      final energy = 15.0 + _random.nextDouble() * 50;
      final duration = Duration(minutes: 20 + _random.nextInt(60));
      final power = [50.0, 100.0, 150.0, 250.0, 350.0][_random.nextInt(5)];

      return ChargingSessionModel(
        id: 'session_${1000 + index}',
        stationId: 'station_00${stationIndex + 1}',
        stationName: station.$1,
        chargerId: 'charger_${_random.nextInt(5) + 1}',
        chargerName: '${chargerTypes[_random.nextInt(chargerTypes.length)]} Charger',
        startTime: sessionTime,
        endTime: sessionTime.add(duration),
        energyKwh: energy,
        cost: energy * 0.35 + _random.nextDouble() * 2,
        duration: duration,
        chargerType: chargerTypes[_random.nextInt(chargerTypes.length)],
        powerKw: power,
        startBatteryPercent: 15 + _random.nextInt(30),
        endBatteryPercent: 75 + _random.nextInt(25),
        co2SavedKg: energy * 0.5,
        stationImageUrl: station.$2,
      );
    });
  }

  @override
  Future<List<TransactionModel>> fetchTransactions({
    int limit = 20,
    int offset = 0,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));

    final now = DateTime.now();
    final transactions = <TransactionModel>[];

    for (var i = 0; i < limit; i++) {
      final hoursAgo = (i * 12) + _random.nextInt(8);
      final txTime = now.subtract(Duration(hours: hoursAgo));

      // Mix of transaction types
      final typeRoll = _random.nextInt(10);
      TransactionType type;
      double amount;
      String? description;
      String? stationName;
      double? energyKwh;

      if (typeRoll < 6) {
        // 60% charging transactions
        type = TransactionType.charging;
        amount = 8.0 + _random.nextDouble() * 25;
        final stations = ['GreenCharge Downtown', 'PowerUp Station', 'EcoCharge Hub'];
        stationName = stations[_random.nextInt(stations.length)];
        energyKwh = amount / 0.35;
        description = 'Charging session at $stationName';
      } else if (typeRoll < 7) {
        // 10% subscriptions
        type = TransactionType.subscription;
        amount = [49.99, 99.99][_random.nextInt(2)];
        description = 'Monthly Unlimited Plan';
      } else if (typeRoll < 8) {
        // 10% top-ups
        type = TransactionType.topUp;
        amount = [20.0, 50.0, 100.0][_random.nextInt(3)];
        description = 'Wallet top-up';
      } else if (typeRoll < 9) {
        // 10% rewards
        type = TransactionType.reward;
        amount = 2.0 + _random.nextDouble() * 8;
        description = 'Charging reward bonus';
      } else {
        // 10% referrals
        type = TransactionType.referral;
        amount = 10.0;
        description = 'Referral bonus';
      }

      transactions.add(TransactionModel(
        id: 'tx_${2000 + i}',
        type: type,
        amount: amount,
        createdAt: txTime,
        paymentMethod: PaymentMethod.values[_random.nextInt(4)],
        description: description,
        referenceId: 'REF${100000 + i}',
        sessionId: type == TransactionType.charging ? 'session_${1000 + i}' : null,
        stationName: stationName,
        energyKwh: energyKwh,
        fee: type == TransactionType.charging ? 0.25 : 0.0,
      ));
    }

    return transactions;
  }

  @override
  Future<List<DailyChargingSummary>> fetchWeeklyData() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));

    final now = DateTime.now();
    return List.generate(7, (index) {
      final date = now.subtract(Duration(days: 6 - index));
      final sessions = _random.nextInt(4);
      final energy = sessions > 0 ? (15.0 + _random.nextDouble() * 35) * sessions : 0.0;

      return DailyChargingSummary(
        date: date,
        sessions: sessions,
        energyKwh: energy,
        cost: energy * 0.35,
        co2SavedKg: energy * 0.5,
        totalMinutes: sessions * (25 + _random.nextInt(35)),
      );
    });
  }

  @override
  Future<List<DailyChargingSummary>> fetchMonthlyData() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));

    final now = DateTime.now();
    return List.generate(30, (index) {
      final date = now.subtract(Duration(days: 29 - index));
      final sessions = _random.nextInt(5);
      final energy = sessions > 0 ? (12.0 + _random.nextDouble() * 40) * sessions : 0.0;

      return DailyChargingSummary(
        date: date,
        sessions: sessions,
        energyKwh: energy,
        cost: energy * 0.35,
        co2SavedKg: energy * 0.5,
        totalMinutes: sessions * (20 + _random.nextInt(40)),
      );
    });
  }

  @override
  Future<List<MonthlyChargingSummary>> fetchYearlyData() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));

    final now = DateTime.now();
    return List.generate(12, (index) {
      final month = ((now.month - 11 + index - 1) % 12) + 1;
      final year = now.year - (index < (12 - now.month + 1) ? 1 : 0);
      final sessions = 10 + _random.nextInt(20);
      final energy = sessions * (25.0 + _random.nextDouble() * 15);

      return MonthlyChargingSummary(
        month: month,
        year: year,
        totalSessions: sessions,
        totalEnergyKwh: energy,
        totalCost: energy * 0.35,
        totalCo2SavedKg: energy * 0.5,
        averageSessionDuration: Duration(minutes: 30 + _random.nextInt(20)),
        mostUsedStation: 'GreenCharge Downtown',
        peakChargingDay: ['Monday', 'Wednesday', 'Friday', 'Sunday'][_random.nextInt(4)],
      );
    });
  }

  @override
  Future<ActivityInsights> fetchInsights() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));

    return const ActivityInsights(
      averageSessionsPerWeek: 4.2,
      averageEnergyPerSession: 32.5,
      averageCostPerSession: 11.38,
      peakChargingHour: 18, // 6 PM
      preferredChargerType: 'CCS Fast Charging',
      mostVisitedStation: 'GreenCharge Downtown',
      totalTreesEquivalent: 104, // CO2 saved equivalent
      monthOverMonthGrowth: 15.5, // 15.5% increase
      savingsVsGasoline: 420, // $420 saved vs gasoline
      carbonFootprintReduction: 2260, // kg CO2
      chargingEfficiency: 92.5, // 92.5% efficiency
    );
  }
}

