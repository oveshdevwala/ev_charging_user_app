# API Integration Guide - Trip History Feature

This guide explains how to integrate the Trip History feature with your real backend API.

---

## Current Implementation Status

✅ **Mock Data Source** - Currently using `TripRemoteDataSourceImpl` with hardcoded mock data  
⏳ **Real API Integration** - Ready to be implemented

---

## Step-by-Step Integration

### Step 1: Add HTTP Client

If not already added, include Dio or http package in `pubspec.yaml`:

```yaml
dependencies:
  dio: ^5.4.0  # Recommended
  # OR
  http: ^1.1.0
```

### Step 2: Create API Service

Create a new file: `lib/core/network/api_service.dart`

```dart
import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio;
  
  ApiService({required String baseUrl}) 
    : _dio = Dio(BaseOptions(baseUrl: baseUrl));
  
  Future<Response> get(String path, {Map<String, dynamic>? queryParams}) async {
    return await _dio.get(path, queryParameters: queryParams);
  }
  
  Future<List<int>> getBytes(String path, {Map<String, dynamic>? queryParams}) async {
    final response = await _dio.get<List<int>>(
      path,
      queryParameters: queryParams,
      options: Options(responseType: ResponseType.bytes),
    );
    return response.data!;
  }
}
```

### Step 3: Update Remote DataSource

Replace the mock implementation in `trip_remote_datasource.dart`:

```dart
import 'package:dio/dio.dart';
import '../../../../core/network/api_service.dart';
import '../models/models.dart';

abstract class TripRemoteDataSource {
  Future<List<TripRecordModel>> getTripHistory();
  Future<MonthlyAnalyticsModel> getMonthlyAnalytics(String month);
  Future<List<int>> exportTripReport(String month);
}

class TripRemoteDataSourceImpl implements TripRemoteDataSource {
  final ApiService apiService;

  TripRemoteDataSourceImpl({required this.apiService});

  @override
  Future<List<TripRecordModel>> getTripHistory() async {
    try {
      final response = await apiService.get('/user/trips');
      
      final List<dynamic> data = response.data as List<dynamic>;
      return data
          .map((json) => TripRecordModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<MonthlyAnalyticsModel> getMonthlyAnalytics(String month) async {
    try {
      final response = await apiService.get(
        '/user/trip-analytics',
        queryParams: {'month': month},
      );
      
      return MonthlyAnalyticsModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<List<int>> exportTripReport(String month) async {
    try {
      return await apiService.getBytes(
        '/user/export/trip-report',
        queryParams: {'month': month},
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('Connection timeout. Please check your internet.');
      case DioExceptionType.badResponse:
        return Exception('Server error: ${e.response?.statusCode}');
      case DioExceptionType.cancel:
        return Exception('Request cancelled');
      default:
        return Exception('Network error: ${e.message}');
    }
  }
}
```

### Step 4: Update Dependency Injection

Update `lib/core/di/injection.dart`:

```dart
// Add import
import '../../core/network/api_service.dart';

// In initializeDependencies(), add:
sl
  // API Service
  ..registerLazySingleton<ApiService>(
    () => ApiService(baseUrl: 'https://your-api-base-url.com/api/v1'),
  )
  
  // Update Trip Remote DataSource
  ..registerLazySingleton<TripRemoteDataSource>(
    () => TripRemoteDataSourceImpl(apiService: sl()),
  );
```

---

## API Endpoint Specification

### 1. GET /user/trips

**Description:** Fetch all trip records for authenticated user

**Headers:**
```
Authorization: Bearer {token}
Content-Type: application/json
```

**Response (200 OK):**
```json
[
  {
    "id": "trip_abc123",
    "stationName": "EV Station Downtown",
    "startTime": "2025-12-04T10:00:00Z",
    "endTime": "2025-12-04T12:30:00Z",
    "energyConsumedKWh": 25.5,
    "cost": 450.75,
    "vehicle": "Tesla Model 3",
    "efficiencyScore": 4.8
  },
  // ... more trips
]
```

**Error Responses:**
- `401 Unauthorized` - Invalid or missing token
- `500 Internal Server Error` - Server error

---

### 2. GET /user/trip-analytics

**Description:** Fetch monthly analytics

**Query Parameters:**
- `month` (required) - Format: YYYY-MM (e.g., "2025-12")

**Headers:**
```
Authorization: Bearer {token}
Content-Type: application/json
```

**Response (200 OK):**
```json
{
  "month": "2025-12",
  "totalCost": 2500.50,
  "totalEnergy": 450.25,
  "avgEfficiency": 4.5,
  "comparisonPercentage": 12.3,
  "trendData": [
    {
      "date": "2025-12-01T00:00:00Z",
      "cost": 85.50,
      "energy": 15.2
    },
    {
      "date": "2025-12-02T00:00:00Z",
      "cost": 120.00,
      "energy": 22.5
    }
    // ... daily data for the month
  ]
}
```

**Notes:**
- `comparisonPercentage`: Positive = increase from previous month, Negative = decrease
- `trendData`: Should contain daily breakdown for visualization

**Error Responses:**
- `400 Bad Request` - Invalid month format
- `401 Unauthorized` - Invalid or missing token
- `404 Not Found` - No data for specified month
- `500 Internal Server Error` - Server error

---

### 3. GET /user/export/trip-report

**Description:** Export trip report as PDF

**Query Parameters:**
- `month` (required) - Format: YYYY-MM

**Headers:**
```
Authorization: Bearer {token}
```

**Response (200 OK):**
```
Content-Type: application/pdf
Content-Disposition: attachment; filename="trip_report_2025-12.pdf"

[Binary PDF data]
```

**Error Responses:**
- `400 Bad Request` - Invalid month format
- `401 Unauthorized` - Invalid or missing token
- `404 Not Found` - No trips for specified month
- `500 Internal Server Error` - PDF generation failed

---

## Authentication

### Adding Bearer Token

If your API requires authentication, update the `ApiService`:

```dart
class ApiService {
  final Dio _dio;
  final String Function() getToken;
  
  ApiService({
    required String baseUrl,
    required this.getToken,
  }) : _dio = Dio(BaseOptions(baseUrl: baseUrl)) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = getToken();
          if (token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ),
    );
  }
}
```

Then in DI:

```dart
sl.registerLazySingleton<ApiService>(
  () => ApiService(
    baseUrl: 'https://your-api.com/api/v1',
    getToken: () {
      // Get token from your auth service
      final authRepo = sl<AuthRepository>();
      return authRepo.getToken() ?? '';
    },
  ),
);
```

---

## Testing the Integration

### 1. Test with Postman/cURL

Before integrating, test your API endpoints:

```bash
# Get trips
curl -H "Authorization: Bearer YOUR_TOKEN" \
  https://your-api.com/api/v1/user/trips

# Get analytics
curl -H "Authorization: Bearer YOUR_TOKEN" \
  "https://your-api.com/api/v1/user/trip-analytics?month=2025-12"

# Export report
curl -H "Authorization: Bearer YOUR_TOKEN" \
  "https://your-api.com/api/v1/user/export/trip-report?month=2025-12" \
  --output report.pdf
```

### 2. Update Model Mapping

If your backend uses different field names, update the models:

```dart
@freezed
class TripRecordModel with _$TripRecordModel {
  const factory TripRecordModel({
    @JsonKey(name: 'trip_id') required String id,  // Backend uses 'trip_id'
    @JsonKey(name: 'station') required String stationName, // Backend uses 'station'
    // ... other fields with @JsonKey if needed
  }) = _TripRecordModel;
}
```

### 3. Enable Logging

Add Dio logger for debugging:

```yaml
dependencies:
  pretty_dio_logger: ^1.3.1
```

```dart
_dio.interceptors.add(
  PrettyDioLogger(
    requestHeader: true,
    requestBody: true,
    responseBody: true,
    responseHeader: false,
    error: true,
    compact: true,
  ),
);
```

---

## Error Handling

### Network Error Handling

The repository automatically handles network errors with fallback to cache:

```dart
try {
  final remoteTrips = await remoteDataSource.getTripHistory();
  await localDataSource.cacheTripHistory(remoteTrips);
  return remoteTrips.map((e) => e.toEntity()).toList();
} catch (e) {
  // Fallback to local cache
  final localTrips = await localDataSource.getLastTripHistory();
  return localTrips.map((e) => e.toEntity()).toList();
}
```

### Custom Error Messages

For user-friendly error messages, create an error mapper:

```dart
String getErrorMessage(Exception e) {
  final message = e.toString();
  if (message.contains('timeout')) {
    return 'Connection timeout. Please check your internet.';
  } else if (message.contains('401')) {
    return 'Session expired. Please login again.';
  } else if (message.contains('500')) {
    return 'Server error. Please try again later.';
  }
  return 'Something went wrong. Please try again.';
}
```

---

## Migration Checklist

- [ ] Add Dio/HTTP package
- [ ] Create ApiService
- [ ] Update TripRemoteDataSourceImpl
- [ ] Update dependency injection
- [ ] Add authentication headers
- [ ] Test endpoints with Postman
- [ ] Verify model mapping
- [ ] Test error scenarios
- [ ] Test offline behavior
- [ ] Update error messages
- [ ] Remove mock data

---

## Troubleshooting

### Issue: "Connection refused"
- **Cause:** Base URL is incorrect or server is down
- **Solution:** Verify base URL and server status

### Issue: "401 Unauthorized"
- **Cause:** Missing or invalid token
- **Solution:** Check token retrieval logic in ApiService

### Issue: "Model parsing error"
- **Cause:** API response doesn't match model
- **Solution:** Compare JSON response with model fields, add @JsonKey if needed

### Issue: "No internet connection"
- **Cause:** Device offline
- **Solution:** Feature automatically falls back to cache (already implemented)

---

## Support

For backend API questions, contact your backend team.

For feature-related issues, refer to:
- `README_trip_history.md` - General documentation
- `BLOC_DOCUMENTATION.md` - BLoC architecture

---

**Version:** 1.0.0  
**Last Updated:** December 4, 2025
