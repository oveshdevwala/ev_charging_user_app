/// File: lib/core/utils/debounce.dart
/// Purpose: Debounce utility for delaying function execution
/// Belongs To: shared
/// Customization Guide:
///    - Use for search input, map movements, etc.
library;

import 'dart:async';

/// Debounce utility class.
class Debouncer {
  Debouncer({this.duration = const Duration(milliseconds: 300)});

  final Duration duration;
  Timer? _timer;
  Completer<void>? _completer;

  /// Call the function after the debounce duration.
  /// Returns a Future that completes when the debounced action is executed.
  Future<void> call(Future<void> Function() action) async {
    _timer?.cancel();
    // Don't complete the old completer - just cancel it
    _completer = Completer<void>();
    
    final completer = _completer!;
    _timer = Timer(duration, () async {
      if (!completer.isCompleted) {
        await action();
        if (!completer.isCompleted) {
          completer.complete();
        }
      }
    });
    
    return completer.future;
  }

  /// Cancel the pending debounce.
  void cancel() {
    _timer?.cancel();
    _timer = null;
    // Don't complete the completer on cancel - let it remain incomplete
    _completer = null;
  }

  /// Dispose the debouncer.
  void dispose() {
    cancel();
  }
}

