# Vehicle Add Feature - Documentation

## Overview

The Vehicle Add feature provides a complete vehicle management system for EV Charging app users. Users can add, edit, delete, and manage their electric vehicles with comprehensive validation, offline support, and a clean MVVM + BLoC architecture.

## Architecture

This feature follows **Clean Architecture** with MVVM pattern using BLoC:

```
features/vehicle_add/
├── data/                    # Data layer
│   ├── datasources/        # Remote & local data sources
│   ├── models/             # Data models (json_serializable)
│   └── repositories/       # Repository implementations
├── domain/                  # Domain layer
│   ├── entities/           # Domain entities
│   ├── repositories/       # Repository interfaces
│   └── usecases/           # Business logic use cases
├── presentation/            # Presentation layer
│   ├── bloc/               # BLoC (events, states, bloc)
│   ├── view/               # UI screens
│   ├── viewmodel/          # ViewModels
│   └── widgets/            # Reusable widgets
├── utils/                   # Utilities (validators)
└── core/                    # Feature-specific config
    ├── config/             # Configuration (mock mode)
    └── services/           # Service re-exports
```

## Key Components

### Domain Layer

- **Vehicle**: Main entity representing a vehicle
- **VehicleType**: Enum (BEV, PHEV, HEV)
- **VehicleRepository**: Abstract repository interface
- **Use Cases**: AddVehicle, GetUserVehicles, UpdateVehicle, DeleteVehicle, SetDefaultVehicle

### Data Layer

- **VehicleModel**: Data model with JSON serialization (json_serializable)
- **VehicleRemoteDataSource**: API integration (currently mock)
- **VehicleLocalDataSource**: SharedPreferences caching with dummy data
- **VehicleRepositoryImpl**: Repository with offline fallback

### Presentation Layer

- **VehicleAddBloc**: Manages add/edit state and form validation
- **VehicleAddViewModel**: Presentation logic helpers
- **VehicleAddScreen**: Add/Edit vehicle form screen
- **VehicleListScreen**: List of user's vehicles
- **VehicleFormField**: Reusable form field wrapper
- **VehicleImagePicker**: Image picker widget

### Utils

- **VehicleValidator**: Comprehensive form validation

## Features

- ✅ Add new vehicles with full validation
- ✅ Edit existing vehicles
- ✅ Delete vehicles with confirmation
- ✅ Set default vehicle
- ✅ View vehicle list with pull-to-refresh
- ✅ Image upload support (camera/gallery)
- ✅ Offline-first with local caching
- ✅ Dummy data for development/demo
- ✅ Comprehensive form validation
- ✅ Analytics tracking hooks

## Configuration

### Mock Mode Toggle

The feature uses a config flag to toggle between mock (local) and real (remote) data sources:

```dart
// lib/features/vehicle_add/core/config/config.dart
class Config {
  static const bool useMock = true; // Set to false when backend is ready
}
```

When `useMock = true`:
- Uses `VehicleLocalDataSource` with dummy data
- Data persists in SharedPreferences
- No network calls

When `useMock = false`:
- Uses `VehicleRemoteDataSource` for API calls
- Falls back to local cache on network errors
- Syncs data to local cache

## Dummy Data

The feature includes 4 pre-seeded vehicles:
1. Daily Bolt (Chevrolet Bolt EV, 2021, 66 kWh, BEV)
2. Family Model (Toyota Prius Prime, 2019, 8.8 kWh, PHEV)
3. Long Trip (Hyundai Ioniq 5, 2023, 77.4 kWh, BEV)
4. Work Runabout (Honda Civic Hybrid, 2018, 1.3 kWh, HEV)

## Validation Rules

- **Nickname**: Optional, max 40 characters
- **Make**: Required
- **Model**: Required
- **Year**: Required, between 1990 and currentYear+1
- **Battery Capacity**: Required, >0 and <=300 kWh
- **License Plate**: Optional, regex: `^[A-Z0-9\- ]{2,12}$`
- **Image**: Optional, max 10MB, types: jpg/png/webp

## Routes

- `AppRoutes.vehicleList` → `/vehicles` - Vehicle list screen
- `AppRoutes.addVehicle` → `/vehicles/add` - Add vehicle screen
- `AppRoutes.editVehicle` → `/vehicles/edit/:id` - Edit vehicle screen

## Usage Examples

### Navigate to Vehicle List

```dart
context.push(
  AppRoutes.vehicleList.path,
  extra: userId,
);
```

### Navigate to Add Vehicle

```dart
context.push(
  AppRoutes.addVehicle.path,
  extra: userId,
);
```

### Navigate to Edit Vehicle

```dart
context.push(
  AppRoutes.editVehicle.id(vehicleId),
  extra: userId,
);
```

### Use BLoC in Screen

```dart
BlocProvider(
  create: (context) => sl<VehicleAddBloc>(),
  child: VehicleAddScreen(userId: userId),
)
```

## API Integration

When backend is ready, update:

1. **VehicleRemoteDataSourceImpl**: Replace mock methods with actual HTTP calls
2. **Config.useMock**: Set to `false`
3. **API Base URL**: Update in `config.dart`

### API Endpoints (Expected)

- `POST /v1/users/{userId}/vehicles` - Add vehicle
- `GET /v1/users/{userId}/vehicles` - Get vehicles
- `PUT /v1/users/{userId}/vehicles/{vehicleId}` - Update vehicle
- `DELETE /v1/users/{userId}/vehicles/{vehicleId}` - Delete vehicle
- `PUT /v1/users/{userId}/vehicles/{vehicleId}/set-default` - Set default

## Migration & Versioning

The local data source includes versioning support:
- Cache version stored in SharedPreferences
- Version changes trigger cache clear
- Migration helpers can be added in `VehicleLocalDataSource`

## Analytics Events

The feature tracks the following events:
- `vehicle_add_started` - User opened add/edit screen
- `vehicle_add_success` - Vehicle saved successfully
- `vehicle_add_failure` - Vehicle save failed
- `vehicle_set_default` - Default vehicle changed

## Dependencies

- `flutter_bloc` - State management
- `equatable` - Value equality
- `json_annotation` - JSON serialization
- `shared_preferences` - Local storage
- `image_picker` - Image selection
- `go_router` - Navigation
- `flutter_screenutil` - Responsive UI

## Code Generation

After adding new fields to `VehicleModel`, run:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## Testing

The feature is designed for easy testing:
- Repository interfaces allow easy mocking
- Use cases are pure functions
- BLoC can be tested with `bloc_test`

## Customization Guide

### Add New Vehicle Fields

1. Update `Vehicle` entity
2. Update `VehicleModel` with JSON annotations
3. Run code generation
4. Update `VehicleForm` state
5. Update validation in `VehicleValidator`
6. Update UI form fields

### Change Validation Rules

Edit `VehicleValidator` class methods.

### Customize UI

- Modify `VehicleAddScreen` for form layout
- Modify `VehicleListScreen` for list display
- Create new widgets in `presentation/view/widgets/`

## Troubleshooting

### Images not uploading
- Check `image_picker` permissions
- Verify file size limits
- Check image format support

### Dummy data not showing
- Ensure `Config.useMock = true`
- Check SharedPreferences initialization
- Verify userId matches dummy data

### Validation errors not showing
- Check BLoC state updates
- Verify error keys match i18n
- Check form field error bindings

## Future Enhancements

- [ ] Vehicle image upload to cloud storage
- [ ] Vehicle sharing between users
- [ ] Vehicle statistics and usage tracking
- [ ] Integration with trip planner
- [ ] Vehicle recommendations based on usage
- [ ] Bulk vehicle import/export

