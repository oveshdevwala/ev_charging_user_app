# Trip History & Cost Analytics Feature

## Overview
The Trip History & Cost Analytics Dashboard provides users with complete insight into their EV charging usage, cost trends, and efficiency metrics.

---

## 📁 Architecture

This feature follows **Clean Architecture** principles with a feature-first folder structure:

```
features/trip_history/
├── data/
│   ├── datasources/
│   │   ├── trip_remote_datasource.dart    # API integration
│   │   ├── trip_local_datasource.dart     # Hive cache
│   │   └── datasources.dart               # Barrel export
│   ├── models/
│   │   ├── trip_record_model.dart         # Freezed model
│   │   ├── monthly_analytics_model.dart   # Freezed model
│   │   └── models.dart                    # Barrel export
│   └── repositories/
│       └── trip_repository_impl.dart      # Repository implementation
├── domain/
│   ├── entities/
│   │   ├── trip_record.dart               # Domain entity
│   │   └── monthly_analytics.dart         # Domain entity
│   ├── repositories/
│   │   └── trip_repository.dart           # Abstract repository
│   └── usecases/
│       ├── get_trip_history.dart          # Fetch trips usecase
│       ├── get_monthly_analytics.dart     # Fetch analytics usecase
│       └── export_trip_report.dart        # Export PDF usecase
├── presentation/
│   ├── bloc/
│   │   ├── trip_history_bloc.dart         # Main BLoC
│   │   ├── trip_history_event.dart        # Events
│   │   ├── trip_history_state.dart        # States
│   │   └── bloc.dart                      # Barrel export
│   ├── screens/
│   │   └── trip_history_screen.dart       # Main screen
│   └── widgets/
│       ├── monthly_summary_card.dart      # Summary card widget
│       ├── cost_trend_chart.dart          # Line chart widget
│       ├── energy_bar_chart.dart          # Bar chart widget
│       ├── trip_list_item.dart            # List item widget
│       └── widgets.dart                   # Barrel export
└── utils/
    ├── trip_calculator.dart               # Calculation utilities
    ├── trip_formatter.dart                # Formatting utilities
    └── utils.dart                         # Barrel export
```

---

## 🧾 Data Models

### 1. TripRecord (Domain Entity)
Represents a single charging trip/session.

**Fields:**
- `id` (String) - Unique identifier
- `stationName` (String) - Name of charging station
- `startTime` (DateTime) - Session start time
- `endTime` (DateTime) - Session end time
- `energyConsumedKWh` (double) - Energy consumed in kWh
- `cost` (double) - Total cost in ₹
- `vehicle` (String) - Vehicle name
- `efficiencyScore` (double) - Calculated efficiency

### 2. MonthlyAnalytics (Domain Entity)
Aggregated monthly statistics.

**Fields:**
- `month` (String) - Format: YYYY-MM
- `totalCost` (double) - Total spending
- `totalEnergy` (double) - Total kWh consumed
- `avgEfficiency` (double) - Average efficiency score
- `comparisonPercentage` (double) - % change from previous month
- `trendData` (List<DailyBreakdown>) - Daily breakdown

### 3. DailyBreakdown
Daily cost and energy data.

**Fields:**
- `date` (DateTime) - Date
- `cost` (double) - Daily cost
- `energy` (double) - Daily energy

---

## 🔌 API Contracts

### GET /user/trips
**Description:** Fetch all trip records for the user.

**Response:**
```json
[
  {
    "id": "trip_123",
    "stationName": "Station A",
    "startTime": "2025-12-04T10:00:00Z",
    "endTime": "2025-12-04T12:00:00Z",
    "energyConsumedKWh": 15.5,
    "cost": 250.0,
    "vehicle": "Tesla Model 3",
    "efficiencyScore": 4.5
  }
]
```

### GET /user/trip-analytics?month=YYYY-MM
**Description:** Fetch month-wise analytics.

**Parameters:**
- `month` (String) - Format: YYYY-MM

**Response:**
```json
{
  "month": "2025-12",
  "totalCost": 1500.0,
  "totalEnergy": 300.5,
  "avgEfficiency": 4.2,
  "comparisonPercentage": 12.5,
  "trendData": [...]
}
```

### GET /user/export/trip-report?month=YYYY-MM
**Description:** Export trip report as PDF.

**Parameters:**
- `month` (String) - Format: YYYY-MM

**Response:** Binary PDF file

---

## 🧠 BLoC Architecture

### Events
1. **FetchTripHistory** - Load all trips
2. **FetchMonthlyAnalytics(month)** - Load analytics for a specific month
3. **ExportReportPDF(month)** - Export PDF report

### States
1. **TripHistoryInitial** - Initial state
2. **TripHistoryLoading** - Loading data
3. **TripHistoryLoaded** - Data loaded successfully
   - `trips: List<TripRecord>`
   - `analytics: MonthlyAnalytics?`
4. **TripHistoryExporting** - Exporting PDF
5. **TripHistoryExported** - PDF exported
   - `file: File`
6. **TripHistoryError** - Error occurred
   - `message: String`

### State Flow
```
Initial → FetchTripHistory → Loading → Loaded
Loaded → FetchMonthlyAnalytics → Loaded (updated analytics)
Loaded → ExportReportPDF → Exporting → Exported
Any → Error
```

---

## 🧮 Core Calculations

### Efficiency Score
```dart
efficiencyScore = kmDriven / energyConsumedKWh
```

### Month Comparison
```dart
percentage = ((current - previous) / previous) * 100
```

### Trend Generation
- Group trips by day
- Compute sum of cost and energy per day
- Generate DailyBreakdown list

---

## 📱 UI Components

### 1. MonthlySummaryCard
Displays key monthly metrics:
- Total Cost (₹)
- Total Energy (kWh)
- Efficiency Score (km/kWh)
- Comparison badge (↑ 12% or ↓ 4%)

### 2. CostTrendChart
Smooth line chart showing cost trend over days using `fl_chart`.

**Features:**
- Curved line
- Gradient fill below line
- X-axis: dates
- Y-axis: cost
- Empty state handling

### 3. EnergyBarChart
Bar chart showing energy consumption per day using `fl_chart`.

**Features:**
- Vertical bars
- Color-coded by value
- Tap interaction support

### 4. TripListItem
Individual trip record card.

**Shows:**
- Station name
- Date & duration
- Energy consumed
- Cost
- Icons for visual appeal

---

## 🛠️ Dependencies

### Required Packages
```yaml
dependencies:
  flutter_bloc: ^8.1.6
  freezed_annotation: ^3.1.0
  json_annotation: ^4.9.0
  equatable: ^2.0.5
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  get_it: ^8.0.2
  fl_chart: ^1.1.1
  printing: ^5.14.2
  pdf: ^3.11.3
  path_provider: ^2.1.4
  intl: ^0.20.2

dev_dependencies:
  freezed: ^3.2.3
  json_serializable: ^6.11.2
  build_runner: ^2.4.13
```

---

## 🚀 Setup & Usage

### 1. Generate Code
Run build_runner to generate freezed and json_serializable code:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 2. Dependency Injection
All dependencies are automatically registered in `lib/core/di/injection.dart`.

### 3. Navigation
Add route to your router configuration:
```dart
GoRoute(
  path: '/trip-history',
  builder: (context, state) => const TripHistoryScreen(),
)
```

### 4. Usage Example
```dart
// Navigate to trip history screen
context.go('/trip-history');
```

---

## 🔄 Offline Support

The feature includes offline-first architecture:
- Remote data is cached locally using Hive
- On network failure, local cache is used as fallback
- Automatic retry on network restoration

---

## 🧪 Testing Considerations

### Unit Tests
- Test BLoC events and state transitions
- Test repository implementations
- Test calculation utilities
- Test formatters

### Widget Tests
- Test UI components render correctly
- Test chart data visualization
- Test empty states
- Test error states

### Integration Tests
- Test full user flow
- Test offline behavior
- Test PDF export

---

## 📝 Customization Guide

### Change Mock Data
Edit `TripRemoteDataSourceImpl` in `trip_remote_datasource.dart`.

### Add New Analytics
1. Update `MonthlyAnalytics` entity
2. Update `MonthlyAnalyticsModel`
3. Update API contract
4. Update UI to display new data

### Custom Chart Styling
Modify `fl_chart` configuration in:
- `cost_trend_chart.dart`
- `energy_bar_chart.dart`

### PDF Report Template
TODO: Implement PDF generation using `printing` and `pdf` packages in `ExportTripReport` use case.

---

## 🐛 Edge Cases Handled

1. **No trips found** - Shows empty state message
2. **Negative comparison** - Shows downward arrow (green)
3. **Missing analytics data** - Gracefully degrades, shows only trips
4. **User offline** - Loads from local cache
5. **Export failure** - Shows error message with retry option
6. **Zero energy consumption** - Returns 0 efficiency to avoid division by zero

---

## 📚 Additional Resources

- [BLoC Pattern Documentation](https://bloclibrary.dev)
- [Freezed Package](https://pub.dev/packages/freezed)
- [FL Chart Documentation](https://pub.dev/packages/fl_chart)
- [Clean Architecture Guide](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)

---

## 🎯 Future Enhancements

1. Real-time sync with backend
2. Advanced filtering (by date range, vehicle, station)
3. Export to CSV/Excel
4. Comparison with community averages
5. Predictive analytics & insights
6. Integration with vehicle telematics
7. Gamification & achievements

---

## ✅ Checklist for Integration

- [x] Domain entities created
- [x] Data models with Freezed
- [x] Remote & local datasources
- [x] Repository implementation
- [x] Use cases
- [x] BLoC implementation
- [x] UI widgets
- [x] Main screen
- [x] Dependency injection setup
- [x] Utility functions
- [ ] Generate freezed code (run build_runner)
- [ ] Add route to app router
- [ ] PDF export implementation (template needed)
- [ ] Write unit tests
- [ ] Write widget tests

---

**Version:** 1.0.0  
**Last Updated:** December 4, 2025  
**Maintainer:** EV Charging App Team
