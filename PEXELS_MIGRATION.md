# Pexels API Migration Summary

## ✅ Migration Complete

This document summarizes the complete migration from Unsplash to Pexels API across the entire Flutter app.

---

## 📦 What Was Changed

### 1. **Dependencies Added**
- ✅ Added `dio: ^5.4.0` to `pubspec.yaml` for API calls

### 2. **Environment Configuration**
- ✅ Created `lib/core/constants/env.dart` with `PEXELS_API_KEY` support
- ✅ Added to barrel export in `lib/core/constants/constants.dart`

### 3. **Pexels Models Created**
- ✅ `lib/core/data/models/pexels/pexels_src.dart` - Image source URLs model
- ✅ `lib/core/data/models/pexels/pexels_photo.dart` - Photo model
- ✅ `lib/core/data/models/pexels/pexels_response.dart` - API response wrapper
- ✅ `lib/core/data/models/pexels/pexels.dart` - Barrel export

All models include:
- `fromJson` factory constructors
- `toJson` methods
- `copyWith` methods

### 4. **Pexels API Service**
- ✅ Created `lib/core/services/pexels_api_service.dart`
- Features:
  - Base URL: `https://api.pexels.com/v1/`
  - Authorization header injection
  - `curatedPhotos()` method
  - `searchPhotos()` method
  - Comprehensive error handling
  - Timeout configuration

### 5. **Pexels Repository**
- ✅ Created `lib/core/repositories/pexels_repository.dart`
- Features:
  - `getDefaultImages()` - Returns curated photos
  - `searchImages(query)` - Search by query
  - In-memory caching (1 hour expiry)
  - Fallback to cached data on API failure

### 6. **Image Widget**
- ✅ Created `lib/widgets/pexels_image_widget.dart`
- Features:
  - `PexelsImageWidget` - For displaying PexelsPhoto models
  - `PexelsImageFromUrl` - For displaying images from URL strings
  - Cached network image loading
  - Shimmer placeholder
  - Error fallback
  - Customizable size and styling

### 7. **Utility**
- ✅ Created `lib/core/utils/image_url_resolver.dart`
- Features:
  - `ImageSize` enum (tiny, small, medium, large, large2x, original, portrait, landscape)
  - `getImageUrl()` - Get URL by size preference
  - `getBestImageUrl()` - Get best URL based on dimensions

### 8. **Dependency Injection**
- ✅ Registered `PexelsApiService` in `lib/core/di/injection.dart`
- ✅ Registered `PexelsRepository` in DI

### 9. **Barrel Exports**
- ✅ Updated `lib/widgets/widgets.dart` to export `pexels_image_widget.dart`
- ✅ Updated `lib/core/utils/utils.dart` to export `image_url_resolver.dart`

### 10. **URL Replacements**
- ✅ Replaced all Unsplash URLs in `lib/features/value_packs/data/datasources/value_packs_remote_datasource_impl.dart` (5 instances)
- ✅ Replaced Unsplash URL in `lib/repositories/user_repository.dart` (1 instance)
- ✅ Replaced Unsplash URLs in `lib/features/community/repositories/community_repository.dart` (3 instances)

All replaced with Pexels CDN URLs using the format:
```
https://images.pexels.com/photos/{photo_id}/pexels-photo-{photo_id}.jpeg?auto=compress&cs=tinysrgb&w={width}&h={height}&fit=crop
```

---

## 🔧 Setup Instructions

### 1. Get Pexels API Key

1. Visit https://www.pexels.com/api/
2. Sign up for a free account
3. Get your API key from the dashboard

### 2. Configure Environment Variable

**Option A: Using flutter_dotenv (Recommended for Production)**

1. Add `flutter_dotenv` to `pubspec.yaml`:
```yaml
dependencies:
  flutter_dotenv: ^5.1.0
```

2. Create `.env` file in project root:
```
PEXELS_API_KEY=your_api_key_here
```

3. Update `lib/core/constants/env.dart`:
```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract final class Env {
  static String get pexelsKey => dotenv.env['PEXELS_API_KEY'] ?? '';
  static bool get hasPexelsKey => pexelsKey.isNotEmpty;
}
```

4. Load `.env` in `main.dart`:
```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  bootstrap(() => const EVChargingApp());
}
```

**Option B: Using Compile-Time Constants (Current Implementation)**

Set the API key when running the app:
```bash
flutter run --dart-define=PEXELS_API_KEY=your_api_key_here
```

### 3. Add .env to .gitignore

Ensure `.env` is in `.gitignore` to avoid committing API keys:
```
.env
```

---

## 📱 Usage Examples

### Using Pexels Repository

```dart
import 'package:ev_charging_user_app/core/di/injection.dart';
import 'package:ev_charging_user_app/core/repositories/pexels_repository.dart';

// Get default/curated images
final pexelsRepo = sl<PexelsRepository>();
final photos = await pexelsRepo.getDefaultImages(page: 1, perPage: 15);

// Search images
final searchResults = await pexelsRepo.searchImages('electric car');
```

### Using Pexels Image Widget

```dart
import 'package:ev_charging_user_app/widgets/pexels_image_widget.dart';
import 'package:ev_charging_user_app/core/utils/image_url_resolver.dart';

// Display from PexelsPhoto model
PexelsImageWidget(
  photo: pexelsPhoto,
  width: 200.w,
  height: 200.h,
  borderRadius: 12.r,
  size: ImageSize.medium,
)

// Display from URL string
PexelsImageFromUrl(
  imageUrl: 'https://images.pexels.com/photos/...',
  width: 200.w,
  height: 200.h,
)
```

### Using Image URL Resolver

```dart
import 'package:ev_charging_user_app/core/utils/image_url_resolver.dart';

// Get URL by size
final url = ImageUrlResolver.getImageUrl(photo, size: ImageSize.large);

// Get best URL for dimensions
final url = ImageUrlResolver.getBestImageUrl(
  photo,
  width: 800,
  height: 600,
);
```

---

## 🎯 Architecture Compliance

✅ **Clean Architecture**: Models, services, repositories properly separated  
✅ **MVVM + BLoC**: Repository pattern maintained  
✅ **Dependency Injection**: All services registered in GetIt  
✅ **Barrel Exports**: All modules have proper exports  
✅ **Documentation**: All files include file-level documentation  
✅ **Type Safety**: All models are strictly typed  
✅ **Error Handling**: Comprehensive error handling in API service  

---

## 🔍 Verification Checklist

- [x] All Unsplash references removed
- [x] Pexels models created with fromJson/toJson/copyWith
- [x] Pexels API service created with error handling
- [x] Pexels repository created with caching
- [x] Pexels image widget created
- [x] All URLs replaced with Pexels CDN URLs
- [x] Dependency injection configured
- [x] Barrel exports updated
- [x] No linter errors
- [x] Dependencies installed

---

## 📝 Notes

- **API Rate Limits**: Pexels free tier allows 200 requests per hour. Consider implementing request throttling for production.
- **Caching**: Repository includes 1-hour in-memory cache. Consider adding persistent cache (sqflite) for offline support.
- **Image Sizes**: Pexels provides multiple image sizes. Use appropriate size based on use case to optimize bandwidth.
- **Attribution**: Pexels photos don't require attribution, but photographer names are available in the model.

---

## 🚀 Next Steps (Optional)

1. **Add Persistent Caching**: Store Pexels photos in sqflite for offline access
2. **Add Request Throttling**: Implement rate limiting to respect API limits
3. **Add Image Preloading**: Preload images for better UX
4. **Add Search History**: Store user search queries
5. **Add Favorites**: Allow users to favorite Pexels photos

---

## 📚 References

- Pexels API Documentation: https://www.pexels.com/api/documentation/
- Pexels API Endpoints: https://www.pexels.com/api/documentation/#photos
- Dio Package: https://pub.dev/packages/dio

---

**Migration completed on**: $(date)  
**All Unsplash references removed**: ✅  
**Pexels integration complete**: ✅

