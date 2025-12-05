/// File: lib/features/profile/bloc/language_event.dart
/// Purpose: Language BLoC events
/// Belongs To: profile feature
library;

/// Base class for language events.
abstract class LanguageEvent {
  const LanguageEvent();
}

/// Load language event.
class LoadLanguage extends LanguageEvent {
  const LoadLanguage();
}

/// Set language event.
class SetLanguage extends LanguageEvent {
  const SetLanguage(this.language);

  final String language;
}

