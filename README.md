# EV Charging User App 🔋

A beautiful and feature-rich Flutter application for EV charging station discovery, booking, and management.

## ✨ Features

- **Find Nearby Stations** - Discover charging stations near you with real-time availability
- **Easy Booking** - Book your charging slot in advance
- **Station Details** - View charger types, amenities, reviews, and pricing
- **Favorites** - Save your preferred stations for quick access
- **Booking History** - Track all your past and upcoming charging sessions
- **User Profile** - Manage your account, vehicles, and payment methods
- **Dark Mode** - Beautiful UI in both light and dark themes

## 📁 Project Structure

```
lib/
├── core/
│   ├── constants/        # App strings, assets, API paths, constants
│   ├── di/               # Dependency injection (GetIt)
│   ├── extensions/       # Context, String, Date, Number extensions
│   ├── local_db/         # SQLite helper for caching
│   ├── theme/            # Light/Dark themes, colors, text styles
│   └── utils/            # Helpers, validators
├── features/
│   └── user_app/
│       └── ui/
│           └── pages/    # All user app screens
├── models/               # Data models (User, Station, Booking, etc.)
├── repositories/         # Data layer with dummy implementations
├── routes/               # GoRouter configuration
├── widgets/              # Reusable UI components
├── l10n/                 # Localization files
├── bootstrap.dart        # App initialization
└── main.dart             # Entry point
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.10.1 or higher
- Dart SDK 3.0.0 or higher

### Installation

1. Clone the repository
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Download [Urbanist font](https://fonts.google.com/specimen/Urbanist) and place in `assets/fonts/`
4. Run the app:
   ```bash
   flutter run
   ```

## 🎨 Theming

The app uses a comprehensive theming system:

- **`AppColors`** - Centralized color palette
- **`AppTextStyles`** - Typography system with ScreenUtil
- **`LightTheme`** / **`DarkTheme`** - Complete theme configurations
- **`ThemeManager`** - Theme switching with persistence

### Customizing Colors

Edit `lib/core/theme/app_colors.dart`:
```dart
static const Color primary = Color(0xFF00C853);  // Electric Green
static const Color secondary = Color(0xFF2196F3);  // Electric Blue
```

## 🛣️ Navigation

Using GoRouter with typed routes:

```dart
// Navigate using AppRoutes enum
context.go(AppRoutes.userHome.path);
context.push(AppRoutes.stationDetails.id(stationId));

// Using context extensions
context.goTo(AppRoutes.userHome);
context.pushToWithId(AppRoutes.stationDetails, stationId);
```

## 📱 Responsive Design

All UI uses `flutter_screenutil` for responsive sizing:

```dart
Container(
  width: 100.w,      // Responsive width
  height: 50.h,      // Responsive height
  padding: EdgeInsets.all(16.r),  // Responsive padding
  child: Text(
    'Hello',
    style: TextStyle(fontSize: 16.sp),  // Responsive font
  ),
)
```

## 🧩 Reusable Widgets

- `CommonButton` - Filled, outlined, text, tonal variants
- `CommonTextField` - With validation, password toggle
- `AppAppBar` - Customizable app bar
- `StationCard` - Station display card (full/compact)
- `BookingCard` - Booking display card
- `LoadingWrapper` - Loading, error, empty state handling

## 📦 Dependencies

| Package | Purpose |
|---------|---------|
| flutter_bloc | State management |
| go_router | Navigation |
| flutter_screenutil | Responsive UI |
| get_it | Dependency injection |
| sqflite | Local database |
| shared_preferences | Key-value storage |
| cached_network_image | Image caching |
| iconsax | Icon library |

## 🔧 Customization Guide

### Adding a New Screen

1. Create page in `lib/features/user_app/ui/pages/`
2. Add route to `AppRoutes` enum
3. Configure route in `AppRouter._router`
4. Export in `pages.dart` barrel file

### Adding Localization

1. Add strings to `lib/l10n/app_en.arb`
2. Add to `AppStrings` class for type-safe access

### Backend Integration

Replace dummy repositories with real implementations:

1. Create new repository class implementing the interface
2. Update registration in `lib/core/di/injection.dart`

## 📄 License

This is a commercial template. Please refer to the license included with your purchase.

---

Built with ❤️ using Flutter
# ev_charging_user_app
