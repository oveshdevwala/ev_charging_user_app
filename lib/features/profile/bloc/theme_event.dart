/// File: lib/features/profile/bloc/theme_event.dart
/// Purpose: Theme BLoC events
/// Belongs To: profile feature
library;

import '../models/models.dart';

/// Base class for theme events.
abstract class ThemeEvent {
  const ThemeEvent();
}

/// Load theme event.
class LoadTheme extends ThemeEvent {
  const LoadTheme();
}

/// Set theme mode event.
class SetThemeMode extends ThemeEvent {
  const SetThemeMode(this.themeMode);

  final ThemeModeOption themeMode;
}

