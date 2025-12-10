/// File: lib/admin/features/sessions/util/sessions_util.dart
/// Purpose: Utility helpers for sessions feature (Pexels, CSV, playback)
/// Belongs To: admin/features/sessions
/// Customization Guide:
///    - Swap Pexels placeholder URLs as needed
///    - Replace CSV generation with server-side exports when ready
library;

import 'dart:convert';
import 'dart:typed_data';

import '../data/session_models.dart';

/// Pexels helper to provide consistent placeholder avatars and stations.
class SessionsPexelsHelper {
  static const String stationThumb =
      'https://images.pexels.com/photos/373543/pexels-photo-373543.jpeg?auto=compress&cs=tinysrgb&w=800';
  static const String userAvatar =
      'https://images.pexels.com/photos/91227/pexels-photo-91227.jpeg?auto=compress&cs=tinysrgb&w=800';
}

/// Lightweight CSV exporter for client-side fallback.
class SessionsCsvExporter {
  Uint8List export(List<AdminSessionSummaryDto> sessions) {
    final buffer = StringBuffer()
      ..writeln('id,station,user,start,end,energy_kwh,cost,status');
    for (final s in sessions) {
      buffer.writeln(
        '${s.id},${s.stationName},${s.userName},${s.startAt.toIso8601String()},${s.endAt?.toIso8601String() ?? ''},${s.energyKwh ?? 0},${s.cost ?? 0},${s.status.name}',
      );
    }
    return Uint8List.fromList(utf8.encode(buffer.toString()));
  }
}

/// Playback engine to manage scrubbing and speed for replay.
class TelemetryPlaybackEngine {
  TelemetryPlaybackEngine({this.speed = 1.0});

  double speed;
  Duration position = Duration.zero;

  Duration seek(Duration target) {
    position = target;
    return position;
  }

  Duration tick(Duration delta) {
    final adjusted = Duration(
      microseconds: (delta.inMicroseconds * speed).toInt(),
    );
    position += adjusted;
    return position;
  }
}

