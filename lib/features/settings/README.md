# Settings Feature

## Overview

A production-grade Settings feature for the EV Charging app with full persistence, JSON export/import, theme management, and comprehensive user preferences.

## Architecture

- **Clean Architecture**: Data → Domain → Presentation layers
- **State Management**: BLoC pattern (SettingsBloc, AppearanceBloc, SecurityBloc)
- **Persistence**: SharedPreferences with JSON serialization
- **Models**: json_serializable for type-safe serialization

## Structure

```
lib/features/settings/
├── data/
│   ├── models/
│   │   └── settings_model.dart          # Main settings model with nested DTOs
│   └── repositories/
│       └── settings_repository.dart     # SharedPreferences wrapper + JSON export/import
├── presentation/
│   ├── blocs/
│   │   ├── settings_bloc.dart           # Main settings BLoC
│   │   ├── appearance_bloc.dart         # Theme & appearance BLoC
│   │   └── security_bloc.dart          # PIN & biometrics BLoC
│   ├── viewmodels/
│   │   └── settings_viewmodel.dart      # Presentation logic helpers
│   ├── ui/
│   │   └── screens/
│   │       ├── settings_home_screen.dart # Main settings screen
│   │       ├── appearance_screen.dart    # Theme & appearance
│   │       ├── notifications_screen.dart # Notification preferences
│   │       ├── privacy_screen.dart      # Privacy & security
│   │       └── data_backup_screen.dart   # Export/import/reset
│   └── widgets/
│       ├── settings_section_card.dart    # Reusable section card
│       ├── settings_toggle_tile.dart     # Toggle switch tile
│       ├── settings_select_tile.dart     # Selectable tile
│       ├── settings_color_picker.dart    # Color picker
│       ├── profile_avatar.dart           # Avatar widget
│       ├── app_bottom_sheet.dart         # Standardized bottom sheet
│       └── safe_scroll_area.dart         # Safe scroll wrapper
└── settings.dart                         # Barrel export

```

## Usage

### 1. Generate JSON Serialization Code

Run build_runner to generate JSON serialization code:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 2. Access Settings

```dart
// Get settings repository from DI
final repository = sl<SettingsRepository>();

// Load settings
final settings = await repository.load();

// Save settings
await repository.save(settings);

// Export as JSON
final json = await repository.exportJson();

// Import from JSON
await repository.importJson(jsonString, replace: true);
```

### 3. Use BLoC in Screens

```dart
MultiBlocProvider(
  providers: [
    BlocProvider(
      create: (context) => SettingsBloc(
        repository: sl<SettingsRepository>(),
      )..add(const LoadSettings()),
    ),
  ],
  child: YourSettingsScreen(),
)
```

### 4. Navigation

```dart
// Navigate to settings
context.pushTo(AppRoutes.userSettings);

// Navigate to appearance
context.pushTo(AppRoutes.settingsAppearance);

// Navigate to notifications
context.pushTo(AppRoutes.settingsNotifications);

// Navigate to privacy
context.pushTo(AppRoutes.settingsPrivacy);

// Navigate to data backup
context.pushTo(AppRoutes.settingsDataBackup);
```

## Settings Categories

### 1. Appearance
- Theme mode (System/Light/Dark)
- Accent color picker
- Font size (Small/Medium/Large)

### 2. Notifications
- Global toggle
- Charging alerts
- Trip reminders
- Promotions
- Quiet hours
- Sound toggle

### 3. Privacy & Security
- Analytics opt-in
- Location services
- Biometric lock
- PIN lock
- Session timeout

### 4. Data & Backup
- Export settings to JSON
- Import settings from JSON
- Reset to defaults
- Clear cache

### 5. Account & Profile
- Display name
- Email
- Connected apps

### 6. Language & Locale
- App language selection

### 7. Accessibility
- Larger text
- High contrast
- Screen reader hints

## Security Notes

- **PIN Storage**: PINs are hashed using SHA-256 before storage. Never store plain text PINs.
- **Biometrics**: Only stores a flag; actual biometric prompt happens at unlock time.
- **Data Export**: Warn users that exported JSON may contain settings (no sensitive data like PINs).

## Customization

### Adding New Settings

1. Add new fields to the appropriate settings model (e.g., `AppearanceSettings`)
2. Update `SettingsModel.defaults()` if needed
3. Run `build_runner` to regenerate JSON code
4. Add UI controls in the appropriate screen
5. Update ViewModel if needed for presentation logic

### Theming

The `AppearanceBloc` integrates with `ThemeManager` to switch themes at runtime. Theme changes are persisted automatically.

## Testing

### Unit Tests

```dart
// Test repository
test('load returns default settings when none exist', () async {
  final repository = SettingsRepositoryImpl(prefs: mockPrefs);
  final settings = await repository.load();
  expect(settings, isA<SettingsModel>());
});

// Test BLoC
test('LoadSettings emits SettingsLoadSuccess', () async {
  final bloc = SettingsBloc(repository: mockRepository);
  bloc.add(const LoadSettings());
  await expectLater(
    bloc.stream,
    emits(isA<SettingsLoadSuccess>()),
  );
});
```

## Future Enhancements

- [ ] PIN setup/change flow with confirmation
- [ ] Quiet hours time picker
- [ ] File picker for JSON import
- [ ] Share sheet for JSON export
- [ ] Connected apps management
- [ ] Profile photo upload
- [ ] Language selection UI
- [ ] Integration with local_auth for biometrics

## Notes

- All settings are persisted locally using SharedPreferences
- JSON export/import validates schema before applying
- Settings are versioned (currently v1) for future migrations
- All UI uses ScreenUtil for responsive sizing
- All text uses AppStrings constants (no hardcoded strings)

