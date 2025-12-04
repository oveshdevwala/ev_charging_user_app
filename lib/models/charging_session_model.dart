/// File: lib/models/charging_session_model.dart
/// Purpose: Charging session data model for activity tracking
/// Belongs To: shared
/// Customization Guide:
///    - Add new fields for additional session metrics
///    - Update copyWith and JSON methods accordingly
library;

import 'package:equatable/equatable.dart';

/// Charging session status.
enum SessionStatus {
  completed,
  inProgress,
  cancelled,
  failed,
}

/// Payment status for a session.
enum PaymentStatus {
  paid,
  pending,
  failed,
  refunded,
}

/// Charging session model for tracking user charging history.
class ChargingSessionModel extends Equatable {
  const ChargingSessionModel({
    required this.id,
    required this.stationId,
    required this.stationName,
    required this.chargerId,
    required this.chargerName,
    required this.startTime,
    this.endTime,
    this.energyKwh = 0.0,
    this.cost = 0.0,
    this.duration = Duration.zero,
    this.status = SessionStatus.completed,
    this.paymentStatus = PaymentStatus.paid,
    this.chargerType,
    this.powerKw = 0.0,
    this.startBatteryPercent,
    this.endBatteryPercent,
    this.co2SavedKg = 0.0,
    this.stationImageUrl,
  });

  /// Create from JSON map.
  factory ChargingSessionModel.fromJson(Map<String, dynamic> json) {
    return ChargingSessionModel(
      id: json['id'] as String? ?? '',
      stationId: json['stationId'] as String? ?? '',
      stationName: json['stationName'] as String? ?? '',
      chargerId: json['chargerId'] as String? ?? '',
      chargerName: json['chargerName'] as String? ?? '',
      startTime: json['startTime'] != null
          ? DateTime.parse(json['startTime'] as String)
          : DateTime.now(),
      endTime: json['endTime'] != null
          ? DateTime.parse(json['endTime'] as String)
          : null,
      energyKwh: (json['energyKwh'] as num?)?.toDouble() ?? 0.0,
      cost: (json['cost'] as num?)?.toDouble() ?? 0.0,
      duration: json['durationMinutes'] != null
          ? Duration(minutes: json['durationMinutes'] as int)
          : Duration.zero,
      status: SessionStatus.values.firstWhere(
        (s) => s.name == (json['status'] as String?),
        orElse: () => SessionStatus.completed,
      ),
      paymentStatus: PaymentStatus.values.firstWhere(
        (s) => s.name == (json['paymentStatus'] as String?),
        orElse: () => PaymentStatus.paid,
      ),
      chargerType: json['chargerType'] as String?,
      powerKw: (json['powerKw'] as num?)?.toDouble() ?? 0.0,
      startBatteryPercent: json['startBatteryPercent'] as int?,
      endBatteryPercent: json['endBatteryPercent'] as int?,
      co2SavedKg: (json['co2SavedKg'] as num?)?.toDouble() ?? 0.0,
      stationImageUrl: json['stationImageUrl'] as String?,
    );
  }

  final String id;
  final String stationId;
  final String stationName;
  final String chargerId;
  final String chargerName;
  final DateTime startTime;
  final DateTime? endTime;
  final double energyKwh;
  final double cost;
  final Duration duration;
  final SessionStatus status;
  final PaymentStatus paymentStatus;
  final String? chargerType;
  final double powerKw;
  final int? startBatteryPercent;
  final int? endBatteryPercent;
  final double co2SavedKg;
  final String? stationImageUrl;

  /// Get formatted duration string.
  String get formattedDuration {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  /// Get formatted date.
  String get formattedDate {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final sessionDate = DateTime(startTime.year, startTime.month, startTime.day);
    
    if (sessionDate == today) {
      return 'Today';
    } else if (sessionDate == today.subtract(const Duration(days: 1))) {
      return 'Yesterday';
    }
    return '${startTime.day}/${startTime.month}/${startTime.year}';
  }

  /// Get formatted time.
  String get formattedTime {
    final hour = startTime.hour.toString().padLeft(2, '0');
    final minute = startTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  /// Battery charged percentage.
  int? get batteryCharged {
    if (startBatteryPercent != null && endBatteryPercent != null) {
      return endBatteryPercent! - startBatteryPercent!;
    }
    return null;
  }

  /// Convert to JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'stationId': stationId,
      'stationName': stationName,
      'chargerId': chargerId,
      'chargerName': chargerName,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'energyKwh': energyKwh,
      'cost': cost,
      'durationMinutes': duration.inMinutes,
      'status': status.name,
      'paymentStatus': paymentStatus.name,
      'chargerType': chargerType,
      'powerKw': powerKw,
      'startBatteryPercent': startBatteryPercent,
      'endBatteryPercent': endBatteryPercent,
      'co2SavedKg': co2SavedKg,
      'stationImageUrl': stationImageUrl,
    };
  }

  /// Copy with new values.
  ChargingSessionModel copyWith({
    String? id,
    String? stationId,
    String? stationName,
    String? chargerId,
    String? chargerName,
    DateTime? startTime,
    DateTime? endTime,
    double? energyKwh,
    double? cost,
    Duration? duration,
    SessionStatus? status,
    PaymentStatus? paymentStatus,
    String? chargerType,
    double? powerKw,
    int? startBatteryPercent,
    int? endBatteryPercent,
    double? co2SavedKg,
    String? stationImageUrl,
  }) {
    return ChargingSessionModel(
      id: id ?? this.id,
      stationId: stationId ?? this.stationId,
      stationName: stationName ?? this.stationName,
      chargerId: chargerId ?? this.chargerId,
      chargerName: chargerName ?? this.chargerName,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      energyKwh: energyKwh ?? this.energyKwh,
      cost: cost ?? this.cost,
      duration: duration ?? this.duration,
      status: status ?? this.status,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      chargerType: chargerType ?? this.chargerType,
      powerKw: powerKw ?? this.powerKw,
      startBatteryPercent: startBatteryPercent ?? this.startBatteryPercent,
      endBatteryPercent: endBatteryPercent ?? this.endBatteryPercent,
      co2SavedKg: co2SavedKg ?? this.co2SavedKg,
      stationImageUrl: stationImageUrl ?? this.stationImageUrl,
    );
  }

  @override
  List<Object?> get props => [
        id,
        stationId,
        stationName,
        chargerId,
        chargerName,
        startTime,
        endTime,
        energyKwh,
        cost,
        duration,
        status,
        paymentStatus,
        chargerType,
        powerKw,
        startBatteryPercent,
        endBatteryPercent,
        co2SavedKg,
        stationImageUrl,
      ];
}

/// Daily charging summary for graphs.
class DailyChargingSummary extends Equatable {
  const DailyChargingSummary({
    required this.date,
    this.sessions = 0,
    this.energyKwh = 0.0,
    this.cost = 0.0,
    this.co2SavedKg = 0.0,
    this.totalMinutes = 0,
  });

  final DateTime date;
  final int sessions;
  final double energyKwh;
  final double cost;
  final double co2SavedKg;
  final int totalMinutes;

  /// Get day of week abbreviation.
  String get dayAbbrev {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[date.weekday - 1];
  }

  /// Get short date format.
  String get shortDate => '${date.day}/${date.month}';

  @override
  List<Object?> get props => [date, sessions, energyKwh, cost, co2SavedKg, totalMinutes];
}

/// Monthly charging summary for insights.
class MonthlyChargingSummary extends Equatable {
  const MonthlyChargingSummary({
    required this.month,
    required this.year,
    this.totalSessions = 0,
    this.totalEnergyKwh = 0.0,
    this.totalCost = 0.0,
    this.totalCo2SavedKg = 0.0,
    this.averageSessionDuration = Duration.zero,
    this.mostUsedStation,
    this.peakChargingDay,
  });

  final int month;
  final int year;
  final int totalSessions;
  final double totalEnergyKwh;
  final double totalCost;
  final double totalCo2SavedKg;
  final Duration averageSessionDuration;
  final String? mostUsedStation;
  final String? peakChargingDay;

  /// Get month name.
  String get monthName {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }

  /// Get full month name.
  String get fullMonthName {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }

  @override
  List<Object?> get props => [
        month,
        year,
        totalSessions,
        totalEnergyKwh,
        totalCost,
        totalCo2SavedKg,
        averageSessionDuration,
        mostUsedStation,
        peakChargingDay,
      ];
}

