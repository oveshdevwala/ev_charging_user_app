# Trip History Feature - BLoC Event → State Flow Diagram

## Architecture Overview

```
┌─────────────┐
│    User     │
│ Interaction │
└──────┬──────┘
       │
       ▼
┌─────────────────┐
│  UI (Screen)    │
│  Dispatches     │──────────────┐
│  BLoC Events    │              │
└─────────────────┘              │
                                 ▼
                        ┌─────────────────┐
                        │  TripHistoryBloc│
                        │                 │
                        │  Event Handler  │
                        └────────┬────────┘
                                 │
                                 ▼
                        ┌─────────────────┐
                        │   Use Cases     │
                        │                 │
                        │ - GetTripHistory│
                        │ - GetAnalytics  │
                        │ - ExportReport  │
                        └────────┬────────┘
                                 │
                                 ▼
                        ┌─────────────────┐
                        │   Repository    │
                        │                 │
                        │ TripRepository  │
                        └────────┬────────┘
                                 │
                    ┌────────────┴────────────┐
                    ▼                         ▼
           ┌─────────────────┐      ┌─────────────────┐
           │ Remote DataSource│      │ Local DataSource│
           │                 │      │                 │
           │  (API/Mock)     │      │    (Hive)      │
           └─────────────────┘      └─────────────────┘
```

---

## Event → State Flow Diagrams

### 1. FetchTripHistory Event

```
User Opens Screen
       │
       ▼
┌──────────────────────┐
│ FetchTripHistory     │ ◄──── Event Dispatched
└──────────┬───────────┘
           │
           ▼
┌──────────────────────┐
│ TripHistoryLoading   │ ◄──── State Emitted (shows loading spinner)
└──────────┬───────────┘
           │
           ▼
┌──────────────────────────────────┐
│ getTripHistory() UseCase Called  │
└──────────┬───────────────────────┘
           │
           ▼
┌──────────────────────────────────┐
│ Repository.getTripHistory()      │
└──────────┬───────────────────────┘
           │
           ├──────► Try Remote DataSource
           │        │
           │        ├─ Success → Cache Locally → Return Data
           │        │
           │        └─ Failure → Fallback to Local Cache
           │
           ▼
┌──────────────────────────────────┐
│ Also Fetch Current Month         │
│ Analytics (optional)             │
└──────────┬───────────────────────┘
           │
           ▼
┌──────────────────────┐
│ TripHistoryLoaded    │ ◄──── State Emitted
│                      │       - trips: [...]
│                      │       - analytics: {...} (if available)
└──────────────────────┘

OR (on error)
           │
           ▼
┌──────────────────────┐
│ TripHistoryError     │ ◄──── State Emitted
│                      │       - message: "Error description"
└──────────────────────┘
```

---

### 2. FetchMonthlyAnalytics Event

```
User Selects Different Month
       │
       ▼
┌──────────────────────────────┐
│ FetchMonthlyAnalytics(month) │ ◄──── Event Dispatched (e.g., "2025-11")
└──────────┬───────────────────┘
           │
           │ (No loading state, keeps current data visible)
           │
           ▼
┌──────────────────────────────────────┐
│ getMonthlyAnalytics(month) Called    │
└──────────┬─────────────────────────┘
           │
           ▼
┌──────────────────────────────────────┐
│ Repository.getMonthlyAnalytics()     │
└──────────┬─────────────────────────┘
           │
           ├──────► Try Remote DataSource
           │        │
           │        ├─ Success → Cache Locally → Return Data
           │        │
           │        └─ Failure → Fallback to Local Cache
           │
           ▼
┌──────────────────────┐
│ TripHistoryLoaded    │ ◄──── State Emitted (updated)
│                      │       - trips: [...] (same)
│                      │       - analytics: {...} (new month data)
└──────────────────────┘

OR (on error)
           │
           ▼
┌──────────────────────┐
│ TripHistoryError     │ ◄──── State Emitted
└──────────────────────┘
```

---

### 3. ExportReportPDF Event

```
User Clicks "Download PDF Report"
       │
       ▼
┌──────────────────────────┐
│ ExportReportPDF(month)   │ ◄──── Event Dispatched
└──────────┬───────────────┘
           │
           ▼
┌──────────────────────┐
│ TripHistoryExporting │ ◄──── State Emitted (shows loading indicator on button)
└──────────┬───────────┘
           │
           ▼
┌──────────────────────────────────┐
│ exportTripReport(month) Called   │
└──────────┬─────────────────────┘
           │
           ▼
┌──────────────────────────────────┐
│ Repository.exportTripReport()    │
└──────────┬─────────────────────┘
           │
           ▼
┌──────────────────────────────────┐
│ Remote DataSource Returns Bytes  │
└──────────┬─────────────────────┘
           │
           ▼
┌──────────────────────────────────┐
│ Save to Local File System        │
│ (using path_provider)            │
└──────────┬─────────────────────┘
           │
           ▼
┌──────────────────────┐
│ TripHistoryExported  │ ◄──── State Emitted
│                      │       - file: File("/path/to/report.pdf")
└──────────┬───────────┘
           │
           ▼
┌──────────────────────────────────┐
│ UI Shows SnackBar with Success   │
│ + "Open" Action Button           │
└──────────────────────────────────┘

OR (on error)
           │
           ▼
┌──────────────────────┐
│ TripHistoryError     │ ◄──── State Emitted
│                      │       - message: "Export failed"
└──────────────────────┘
           │
           ▼
┌──────────────────────────────────┐
│ UI Shows Error SnackBar          │
│ + Retry Option (Optional)        │
└──────────────────────────────────┘
```

---

## State Transition Table

| Current State          | Event                    | Next State           | Side Effects                          |
|------------------------|--------------------------|----------------------|---------------------------------------|
| Initial                | FetchTripHistory         | Loading              | Start data fetch                      |
| Loading                | (Success)                | Loaded               | Display trips & analytics             |
| Loading                | (Error)                  | Error                | Show error message                    |
| Loaded                 | FetchMonthlyAnalytics    | Loaded (updated)     | Update analytics data                 |
| Loaded                 | ExportReportPDF          | Exporting            | Start PDF generation                  |
| Exporting              | (Success)                | Exported             | Show success snackbar                 |
| Exporting              | (Error)                  | Error                | Show error snackbar                   |
| Error                  | FetchTripHistory         | Loading              | Retry data fetch                      |
| Any                    | Any Error                | Error                | Show error message                    |

---

## BLoC Internal Logic

### _onFetchTripHistory

```dart
Future<void> _onFetchTripHistory(
  FetchTripHistory event,
  Emitter<TripHistoryState> emit,
) async {
  // 1. Emit loading state
  emit(TripHistoryLoading());
  
  try {
    // 2. Fetch trips
    final trips = await getTripHistory();
    
    // 3. Also fetch current month analytics
    final currentMonth = getCurrentMonth(); // "YYYY-MM"
    
    try {
      final analytics = await getMonthlyAnalytics(currentMonth);
      // 4. Emit loaded state with both trips and analytics
      emit(TripHistoryLoaded(trips: trips, analytics: analytics));
    } catch (analyticsError) {
      // 5. If analytics fail, still show trips
      emit(TripHistoryLoaded(trips: trips));
    }
  } catch (e) {
    // 6. Emit error state
    emit(TripHistoryError(e.toString()));
  }
}
```

### _onFetchMonthlyAnalytics

```dart
Future<void> _onFetchMonthlyAnalytics(
  FetchMonthlyAnalytics event,
  Emitter<TripHistoryState> emit,
) async {
  // 1. Keep existing data visible (no loading state)
  final currentState = state;
  
  if (currentState is TripHistoryLoaded) {
    try {
      // 2. Fetch new analytics
      final analytics = await getMonthlyAnalytics(event.month);
      
      // 3. Update state with new analytics
      emit(currentState.copyWith(analytics: analytics));
    } catch (e) {
      // 4. Emit error
      emit(TripHistoryError(e.toString()));
    }
  }
}
```

### _onExportReportPDF

```dart
Future<void> _onExportReportPDF(
  ExportReportPDF event,
  Emitter<TripHistoryState> emit,
) async {
  // 1. Emit exporting state
  emit(TripHistoryExporting());
  
  try {
    // 2. Export PDF
    final file = await exportTripReport(event.month);
    
    // 3. Emit exported state
    emit(TripHistoryExported(file));
  } catch (e) {
    // 4. Emit error
    emit(TripHistoryError(e.toString()));
  }
}
```

---

## Error Handling Strategy

### Network Errors
- **Strategy:** Fallback to local cache
- **User Experience:** Data shown from cache, subtle indicator for offline mode
- **Implementation:** Try-catch in repository with local fallback

### Cache Miss
- **Strategy:** Show empty state or error
- **User Experience:** "No data available. Pull to refresh."
- **Implementation:** Throw exception from local datasource

### Export Failure
- **Strategy:** Show error with retry option
- **User Experience:** Error SnackBar with "Retry" button
- **Implementation:** Error state with retry logic in UI

### Partial Data
- **Strategy:** Show what's available
- **User Experience:** Trips shown even if analytics fail
- **Implementation:** Nested try-catch in _onFetchTripHistory

---

## UI Integration Example

```dart
BlocConsumer<TripHistoryBloc, TripHistoryState>(
  listener: (context, state) {
    // Handle side effects
    if (state is TripHistoryExported) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Report exported!')),
      );
    } else if (state is TripHistoryError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message)),
      );
    }
  },
  builder: (context, state) {
    // Build UI based on state
    if (state is TripHistoryLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (state is TripHistoryLoaded) {
      return _buildContent(state.trips, state.analytics);
    } else if (state is TripHistoryError) {
      return _buildError(state.message);
    }
    return SizedBox.shrink();
  },
)
```

---

**Last Updated:** December 4, 2025
