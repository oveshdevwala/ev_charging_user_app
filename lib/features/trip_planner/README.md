# Trip Planner Feature

A comprehensive EV trip planning feature for the EV Charging app. This feature allows users to plan trips with automatic charging stop optimization, energy calculations, and detailed trip insights.

## Features

- **Trip Planning**: Enter origin, destination, and optional waypoints
- **Vehicle Selection**: Support for multiple vehicles with different battery specs
- **Charging Stop Optimization**: Automatically plans optimal charging stops
- **Energy Calculations**: Accurate SOC predictions with explicit formulas
- **Trip Insights**: Battery graphs, cost breakdown, time distribution
- **Saved Trips**: Save and manage favorite trips
- **Offline Support**: Cached trip data for offline access

## Architecture

```
lib/features/trip_planner/
├── bloc/                    # State management
│   ├── trip_planner_cubit.dart
│   ├── trip_planner_state.dart
│   └── bloc.dart
├── models/                  # Domain models
│   ├── vehicle_profile_model.dart
│   ├── location_model.dart
│   ├── charging_stop_model.dart
│   ├── trip_model.dart
│   └── models.dart
├── repositories/            # Data layer
│   ├── trip_planner_repository.dart
│   └── repositories.dart
├── ui/                      # Presentation
│   ├── trip_planner_page.dart
│   ├── trip_planner_home_page.dart
│   ├── trip_create_page.dart
│   ├── trip_summary_page.dart
│   ├── charging_stops_page.dart
│   ├── insights_page.dart
│   ├── trip_detail_page.dart
│   └── ui.dart
├── utils/                   # Calculations
│   ├── trip_calculations.dart
│   └── utils.dart
├── widgets/                 # Reusable widgets
│   ├── battery_graph.dart
│   ├── cost_pie_chart.dart
│   ├── charging_stop_card.dart
│   ├── trip_stat_card.dart
│   ├── location_input.dart
│   ├── saved_trip_card.dart
│   └── widgets.dart
└── trip_planner.dart        # Feature barrel export
```

## Integration

### 1. Add to Routes

The trip planner route is already added to `lib/routes/app_routes.dart`:

```dart
enum AppRoutes {
  // ...
  tripPlanner,
}

// Route path
case AppRoutes.tripPlanner:
  return '/tripPlanner';

// GoRoute configuration
GoRoute(
  path: AppRoutes.tripPlanner.path,
  name: AppRoutes.tripPlanner.name,
  builder: (context, state) => const TripPlannerPage(),
),
```

### 2. Navigate to Trip Planner

```dart
// Using context extension
context.pushTo(AppRoutes.tripPlanner);

// Or using go_router directly
context.push(AppRoutes.tripPlanner.path);
```

### 3. Add Trip Planner Button to Home

The home page already has a Trip Planner section. To navigate:

```dart
onTap: () => context.pushTo(AppRoutes.tripPlanner),
```

## Calculation Formulas

All calculations are in `lib/features/trip_planner/utils/trip_calculations.dart`:

### Energy Consumption
```
energyWh = consumptionWhPerKm × distanceKm
energyKwh = energyWh / 1000
socUsedPercent = (energyKwh / batteryCapacityKwh) × 100
```

### SOC at Arrival
```
socAtArrival = startingSocPercent - socUsedPercent
needsCharging = socAtArrival < reserveSocPercent
```

### Range Calculation
```
currentEnergyKwh = batteryCapacity × (currentSoc / 100)
rangeKm = (energyKwh × 1000) / consumptionWhPerKm
```

### Charging Time
```
energyToCharge = batteryCapacity × ((targetSoc - currentSoc) / 100)
effectivePower = min(vehicleMaxPower, chargerPower)
rawTimeHours = energyToCharge / effectivePower
adjustedTime = rawTime × taperFactor (if charging above 80%)
```

## Configuration

### Environment Variables

For production, configure these in your environment:

```dart
// Route provider API key
ROUTE_PROVIDER_KEY=your_api_key

// Charging station API endpoint
CHARGING_STATION_API_URL=https://api.example.com/stations

// Google Maps API key (for map integration)
GOOGLE_MAPS_API_KEY=your_google_maps_key
```

### Vehicle Defaults

Customize default vehicle parameters in `VehicleProfileModel`:

```dart
const VehicleProfileModel(
  batteryCapacityKwh: 75,        // Usable capacity
  consumptionWhPerKm: 150,       // Energy efficiency
  maxChargePowerKw: 150,         // Max charge acceptance
  reserveSocPercent: 10,         // Safety reserve
);
```

## Customization

### Swapping Route Provider

Implement `IRouteService` interface:

```dart
abstract class IRouteService {
  Future<RouteResult> getRoute({
    required LocationModel origin,
    required LocationModel destination,
    List<LocationModel> waypoints,
  });
}
```

### Swapping Charging Station Provider

Implement custom station search:

```dart
Future<List<ChargingStationInfo>> findChargingStationsAlongRoute({
  required String routePolyline,
  double maxDistanceFromRouteKm,
  double minChargerPowerKw,
});
```

### Adding Map Integration

Replace the map placeholder in `trip_detail_page.dart`:

```dart
// For Google Maps
GoogleMap(
  initialCameraPosition: CameraPosition(...),
  polylines: {...},
  markers: {...},
)

// For flutter_map
FlutterMap(
  options: MapOptions(...),
  children: [
    PolylineLayer(...),
    MarkerLayer(...),
  ],
)
```

## Dependencies

This feature uses:
- `flutter_bloc` - State management
- `equatable` - Value equality
- `fl_chart` - Charts and graphs
- `flutter_screenutil` - Responsive sizing
- `iconsax` - Icons

For map integration, add one of:
- `google_maps_flutter` - Google Maps
- `flutter_map` - OpenStreetMap

## Sample Data

The `DummyTripPlannerRepository` provides sample data for development. Replace with real API implementation for production:

```dart
class RealTripPlannerRepository implements TripPlannerRepository {
  final ApiClient _client;
  
  @override
  Future<RouteResult> getRoute(...) async {
    final response = await _client.get('/route', params: {...});
    return RouteResult.fromJson(response.data);
  }
}
```

## License

Part of the EV Charging User App template.

