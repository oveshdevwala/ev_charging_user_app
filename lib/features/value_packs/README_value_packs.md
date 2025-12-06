# Value Packs Feature - Documentation

## Overview

The Value Packs feature provides a complete subscription and one-time purchase system for EV charging services. Users can browse, compare, purchase, and review value packs that offer discounted rates and additional benefits.

## Architecture

This feature follows **Clean Architecture** with MVVM pattern using Cubits:

```
features/value_packs/
├── data/                    # Data layer
│   ├── datasources/        # Remote & local data sources
│   ├── models/             # Data models (Equatable + copyWith)
│   └── repositories/       # Repository implementations
├── domain/                  # Domain layer
│   ├── entities/           # Domain entities
│   ├── repositories/       # Repository interfaces
│   └── usecases/           # Business logic use cases
├── presentation/            # Presentation layer
│   ├── cubits/             # State management (Cubits)
│   ├── screens/            # UI screens
│   └── widgets/            # Reusable widgets
└── core/                   # Feature-specific utilities
    └── payment_adapter.dart # Payment gateway adapters
```

## Key Components

### Domain Layer

- **ValuePack**: Main entity representing a value pack
- **Review**: Review entity for pack reviews
- **PurchaseReceipt**: Purchase receipt entity
- **ValuePacksRepository**: Abstract repository interface
- **Use Cases**: GetValuePacks, GetValuePackDetail, PurchaseValuePack, GetReviews, SubmitReview

### Data Layer

- **ValuePackModel**: Data model with JSON serialization
- **ValuePacksRemoteDataSource**: API integration (currently mock)
- **ValuePacksLocalDataSource**: Hive caching
- **ValuePacksRepositoryImpl**: Repository with offline fallback

### Presentation Layer

- **ValuePacksListCubit**: Manages list state (filter, sort, pagination)
- **ValuePackDetailCubit**: Manages detail state
- **PurchaseCubit**: Handles purchase flow
- **ReviewsCubit**: Manages reviews

### Screens

1. **ValuePacksListScreen**: Browse all packs with filter/sort
2. **ValuePackDetailScreen**: View pack details, features, related packs
3. **ComparePacksScreen**: Side-by-side comparison
4. **PurchaseScreen**: Purchase flow with payment selection
5. **ReviewsScreen**: View and submit reviews

### Widgets

- **ValuePackCard**: Reusable pack card
- **ValuePackSliderEntry**: Compact slider entry
- **PriceBadge**: Price display with discount
- **TagBadge**: Tag display
- **FeatureChip**: Feature display

## Integration

### Dependency Injection

All dependencies are registered in `lib/core/di/injection.dart`:

```dart
// Datasources
..registerLazySingleton<ValuePacksRemoteDataSource>(ValuePacksRemoteDataSourceImpl.new)
..registerLazySingleton<ValuePacksLocalDataSource>(...)

// Repository
..registerLazySingleton<ValuePacksRepository>(...)

// Use Cases
..registerLazySingleton(() => GetValuePacks(sl()))
..registerLazySingleton(() => GetValuePackDetail(sl()))
// ... more use cases

// Cubits
..registerFactory(() => ValuePacksListCubit(sl<GetValuePacks>()))
// ... more cubits
```

### Routes

Routes are defined in `AppRoutes` enum:

- `valuePacksList`: `/valuePacks`
- `valuePackDetail`: `/valuePackDetail/:id`
- `comparePacks`: `/comparePacks?ids=pack1,pack2`
- `purchasePack`: `/purchasePack/:id`
- `packReviews`: `/packReviews/:id`

### Home Screen Integration

The bundles section in the home screen is connected to value packs:

```dart
void _onBundlesViewAll(BuildContext context) {
  context.push(AppRoutes.valuePacksList.path);
}
```

## Payment Adapters

The feature uses a payment adapter pattern for different payment gateways:

- **MockPaymentAdapter**: For development/testing
- **StripePaymentAdapter**: Stripe integration (placeholder)
- **RazorpayPaymentAdapter**: Razorpay integration (placeholder)

To use a payment adapter:

```dart
final adapter = MockPaymentAdapter();
await adapter.initialize();
final token = await adapter.processPayment(
  amount: 99.99,
  currency: 'USD',
  metadata: {'packId': 'pack_001'},
);
```

## API Integration

### Current State

The feature currently uses **mock data** from `ValuePacksRemoteDataSourceImpl`. To integrate with a real backend:

1. Replace `ValuePacksRemoteDataSourceImpl` with actual API calls
2. Update endpoints in the datasource
3. Handle authentication tokens
4. Implement error handling

### API Endpoints (Suggested)

```
GET    /value-packs?filter=&sort=&page=
GET    /value-packs/{id}
GET    /value-packs/{id}/reviews?page=
POST   /value-packs/{id}/purchase
GET    /user/purchases?packId?
POST   /value-packs/compare
GET    /value-packs/faq
POST   /value-packs/{id}/save
DELETE /value-packs/{id}/save
GET    /payments/invoice/{receiptId}
```

## Theming

All UI components use semantic theming via `context.appColors`:

```dart
final colors = context.appColors;
final textTheme = context.text;

// Use colors.primary, colors.surface, etc.
// Use textTheme.titleMedium, textTheme.bodySmall, etc.
```

## ScreenUtil Sizing

All sizing uses ScreenUtil:

```dart
width: 100.w      // Responsive width
height: 50.h      // Responsive height
fontSize: 14.sp   // Responsive font size
borderRadius: 16.r // Responsive radius
```

## Testing

### Unit Tests

Test use cases and cubits:

```dart
test('GetValuePacks should return list of packs', () async {
  final useCase = GetValuePacks(mockRepository);
  final packs = await useCase();
  expect(packs, isNotEmpty);
});
```

### Widget Tests

Test reusable widgets:

```dart
testWidgets('ValuePackCard displays pack info', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: ValuePackCard(
        pack: mockPack,
        onTap: () {},
      ),
    ),
  );
  expect(find.text(mockPack.title), findsOneWidget);
});
```

## Customization Guide

### Adding New Pack Types

1. Add new fields to `ValuePack` entity
2. Update `ValuePackModel` with JSON mapping
3. Update mock data in `ValuePacksRemoteDataSourceImpl`
4. Update UI widgets if needed

### Adding New Payment Gateway

1. Implement `PaymentAdapter` interface
2. Register in dependency injection
3. Update `PurchaseCubit` to use new adapter

### Customizing UI

- Modify widgets in `presentation/widgets/`
- Update screens in `presentation/screens/`
- All colors use `context.appColors` for theme support

## Troubleshooting

### Common Issues

1. **Cubit not found**: Ensure DI is properly set up
2. **Routes not working**: Check `AppRoutes` enum and GoRouter config
3. **Theme errors**: Ensure `context.appColors` extension is imported
4. **Null safety**: All models use nullable types where appropriate

## Future Enhancements

- [ ] Complete Hive caching implementation
- [ ] Add Stripe/Razorpay payment integration
- [ ] Implement image upload for reviews
- [ ] Add pack comparison analytics
- [ ] Add subscription management
- [ ] Add invoice PDF generation
- [ ] Add pack recommendations based on usage

## Support

For issues or questions, refer to the main project documentation or contact the development team.


