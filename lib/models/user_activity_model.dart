/// File: lib/models/user_activity_model.dart
/// Purpose: User activity summary model for dashboard metrics
/// Belongs To: shared
/// Customization Guide:
///    - Add new metrics for enhanced gamification
///    - Update copyWith and JSON methods accordingly
library;

import 'package:equatable/equatable.dart';

/// User activity summary model for quick dashboard.
class UserActivitySummary extends Equatable {
  const UserActivitySummary({
    this.sessionsToday = 0,
    this.energyUsedKwh = 0.0,
    this.moneySpent = 0.0,
    this.co2SavedKg = 0.0,
    this.streaks = 0,
    this.totalSessions = 0,
    this.totalEnergyKwh = 0.0,
    this.totalSpent = 0.0,
    this.favoriteStationId,
    this.lastChargingDate,
    this.level = 1,
    this.xpPoints = 0,
    this.badges = const [],
  });

  /// Create from JSON map.
  factory UserActivitySummary.fromJson(Map<String, dynamic> json) {
    return UserActivitySummary(
      sessionsToday: json['sessionsToday'] as int? ?? 0,
      energyUsedKwh: (json['energyUsedKwh'] as num?)?.toDouble() ?? 0.0,
      moneySpent: (json['moneySpent'] as num?)?.toDouble() ?? 0.0,
      co2SavedKg: (json['co2SavedKg'] as num?)?.toDouble() ?? 0.0,
      streaks: json['streaks'] as int? ?? 0,
      totalSessions: json['totalSessions'] as int? ?? 0,
      totalEnergyKwh: (json['totalEnergyKwh'] as num?)?.toDouble() ?? 0.0,
      totalSpent: (json['totalSpent'] as num?)?.toDouble() ?? 0.0,
      favoriteStationId: json['favoriteStationId'] as String?,
      lastChargingDate: json['lastChargingDate'] != null
          ? DateTime.tryParse(json['lastChargingDate'] as String)
          : null,
      level: json['level'] as int? ?? 1,
      xpPoints: json['xpPoints'] as int? ?? 0,
      badges: (json['badges'] as List<dynamic>?)?.cast<String>() ?? [],
    );
  }

  final int sessionsToday;
  final double energyUsedKwh;
  final double moneySpent;
  final double co2SavedKg;
  final int streaks;
  final int totalSessions;
  final double totalEnergyKwh;
  final double totalSpent;
  final String? favoriteStationId;
  final DateTime? lastChargingDate;
  final int level;
  final int xpPoints;
  final List<String> badges;

  /// Calculate XP needed for next level.
  int get xpForNextLevel => level * 100;

  /// Progress to next level (0.0 - 1.0).
  double get levelProgress => (xpPoints % 100) / 100;

  /// Calculate trees equivalent of CO2 saved.
  double get treesEquivalent => co2SavedKg / 21.77; // avg kg CO2 per tree/year

  /// Check if user is on a streak.
  bool get hasStreak => streaks > 0;

  /// Get streak badge text.
  String get streakBadgeText {
    if (streaks >= 30) {
      return '🔥 30-day Streak!';
    }
    if (streaks >= 7) {
      return '⚡ Weekly Warrior';
    }
    if (streaks >= 3) {
      return '✨ Streak Started';
    }
    return '';
  }

  /// Convert to JSON map.
  Map<String, dynamic> toJson() {
    return {
      'sessionsToday': sessionsToday,
      'energyUsedKwh': energyUsedKwh,
      'moneySpent': moneySpent,
      'co2SavedKg': co2SavedKg,
      'streaks': streaks,
      'totalSessions': totalSessions,
      'totalEnergyKwh': totalEnergyKwh,
      'totalSpent': totalSpent,
      'favoriteStationId': favoriteStationId,
      'lastChargingDate': lastChargingDate?.toIso8601String(),
      'level': level,
      'xpPoints': xpPoints,
      'badges': badges,
    };
  }

  /// Copy with new values.
  UserActivitySummary copyWith({
    int? sessionsToday,
    double? energyUsedKwh,
    double? moneySpent,
    double? co2SavedKg,
    int? streaks,
    int? totalSessions,
    double? totalEnergyKwh,
    double? totalSpent,
    String? favoriteStationId,
    DateTime? lastChargingDate,
    int? level,
    int? xpPoints,
    List<String>? badges,
  }) {
    return UserActivitySummary(
      sessionsToday: sessionsToday ?? this.sessionsToday,
      energyUsedKwh: energyUsedKwh ?? this.energyUsedKwh,
      moneySpent: moneySpent ?? this.moneySpent,
      co2SavedKg: co2SavedKg ?? this.co2SavedKg,
      streaks: streaks ?? this.streaks,
      totalSessions: totalSessions ?? this.totalSessions,
      totalEnergyKwh: totalEnergyKwh ?? this.totalEnergyKwh,
      totalSpent: totalSpent ?? this.totalSpent,
      favoriteStationId: favoriteStationId ?? this.favoriteStationId,
      lastChargingDate: lastChargingDate ?? this.lastChargingDate,
      level: level ?? this.level,
      xpPoints: xpPoints ?? this.xpPoints,
      badges: badges ?? this.badges,
    );
  }

  @override
  List<Object?> get props => [
        sessionsToday,
        energyUsedKwh,
        moneySpent,
        co2SavedKg,
        streaks,
        totalSessions,
        totalEnergyKwh,
        totalSpent,
        favoriteStationId,
        lastChargingDate,
        level,
        xpPoints,
        badges,
      ];
}

