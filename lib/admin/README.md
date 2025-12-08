# EV Charging Admin Panel

A comprehensive Flutter admin panel for managing the EV Charging platform.

## 🚀 Getting Started

### Run the Admin Panel

```bash
# Navigate to project directory
cd ev_charging_admin

# Install dependencies
flutter pub get

# Generate model serializers
flutter pub run build_runner build --delete-conflicting-outputs

# Run on Chrome (recommended for admin panel)
flutter run -d chrome --target=lib/admin/app_admin.dart
```

## 📁 Project Structure

```
lib/admin/
├── app_admin.dart           # Entry point for admin panel
├── admin.dart               # Barrel file for all exports
│
├── core/                    # Core utilities and components
│   ├── config/              # Configuration files
│   ├── constants/           # String, asset, API constants
│   ├── extensions/          # BuildContext extensions
│   ├── theme/               # Light/Dark themes
│   ├── utils/               # Validators, formatters, helpers
│   └── widgets/             # Reusable UI components
│
├── features/                # Feature modules
│   ├── dashboard/           # Dashboard feature
│   │   ├── bloc/            # BLoC files
│   │   ├── view/            # Pages
│   │   └── widgets/         # Feature-specific widgets
│   │
│   └── stations/            # Station management (fully implemented)
│       ├── bloc/            # BLoC files
│       ├── repository/      # Data repository
│       └── view/            # List, Detail, Edit pages
│
├── models/                  # Data models (json_serializable)
├── repositories/            # Repository barrel
├── services/                # Services (CSV export, etc.)
├── blocs/                   # BLoC barrel exports
├── viewmodels/              # ViewModel barrel exports
└── routes/                  # Admin routing configuration
```

## ✅ Implemented Features

### Core
- ✅ Admin Shell (Sidebar + Topbar layout)
- ✅ Responsive design (Desktop → Tablet → Mobile)
- ✅ Light/Dark theme support
- ✅ Theme extensions and color system
- ✅ Context extensions for theme, navigation, sizing
- ✅ Reusable widgets (DataTable, Cards, Buttons, etc.)
- ✅ Form validation utilities
- ✅ Date/Number formatters

### Dashboard
- ✅ Metric cards with change indicators
- ✅ Revenue chart (Line chart)
- ✅ Sessions distribution (Pie chart)
- ✅ Recent activity feed
- ✅ Quick actions panel

### Station Management (Complete Flow)
- ✅ Stations list with search & filters
- ✅ Station detail view
- ✅ Station create/edit form
- ✅ Status management
- ✅ Charger information display
- ✅ Manager assignment
- ✅ CSV export functionality
- ✅ BLoC state management
- ✅ Repository with dummy data

## 📋 Pending Features (Step-by-Step)

The following features have placeholder routes and will be implemented:

1. **Managers** - Station manager CRUD
2. **Users** - User management
3. **Sessions** - Charging session monitoring
4. **Payments** - Payment management
5. **Wallets** - User wallet management
6. **Offers** - Promotional offers CRUD
7. **Partners** - Partner management
8. **Reviews** - Review moderation
9. **Reports** - Analytics and reports
10. **Content** - CMS (Pages, FAQ, Banners)
11. **Media** - Media library
12. **Logs** - System logs viewer
13. **Settings** - App settings, RBAC

## 🎨 Design System

### Colors
The admin panel uses the same color system as the user app for consistency:
- Primary: Green (#34C759)
- Secondary: Amber (#F4B400)
- Tertiary: Purple (#7C4DFF)

### Typography
Uses ScreenUtil for responsive text sizing with Material 3 type scale.

### Breakpoints
- Mobile: < 768px
- Tablet: 768px - 1024px
- Desktop: ≥ 1024px
- Large Desktop: ≥ 1440px

## 📦 Data Layer

### Dummy Data
Static JSON files are located at:
```
assets/dummy_data/admin/
├── stations.json
├── users.json
├── managers.json
├── sessions.json
└── transactions.json
```

### Models
Models use `json_serializable` for JSON parsing:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## 🏗️ Architecture

The admin panel follows **MVVM + BLoC** pattern:

```
View (Widget) 
    ↓ dispatches events
BLoC (Business Logic)
    ↓ calls methods
Repository (Data Layer)
    ↓ reads/writes
Data Source (JSON/API)
```

### Key Principles
- Single state class with `copyWith()` and `Equatable`
- No business logic in UI
- Repository abstraction for data access
- Theming via extensions (no direct Theme.of())
- Responsive design via breakpoint extensions

## 🔧 Customization

### Adding a New Feature

1. Create feature folder: `lib/admin/features/[feature_name]/`
2. Add BLoC, Repository, Views
3. Register route in `admin_routes.dart`
4. Add sidebar item in `admin_sidebar.dart`
5. Export from barrel files

### Modifying Theme

Edit files in `lib/admin/core/theme/`:
- `admin_colors.dart` - Color palette
- `admin_light_theme.dart` - Light theme
- `admin_dark_theme.dart` - Dark theme

## 📄 License

This is a commercial template. See main project LICENSE for details.

