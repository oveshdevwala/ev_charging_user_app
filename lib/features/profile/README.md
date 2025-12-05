# Profile & Account Suite Feature

## 📋 Overview

Complete Profiles & Account Suite feature with all account management capabilities including profile editing, security, theme management, language selection, payment methods, help & support, and more.

## 🏗️ Architecture

This feature follows **MVVM architecture** with BLoC pattern:

```
lib/features/profile/
├── bloc/              # BLoC classes (state management)
├── models/            # Data models with json_serializable
├── repositories/      # Repository interface + dummy implementation
├── ui/                # Screen widgets
├── widgets/           # Reusable UI components
└── profile.dart       # Barrel file exports
```

## ✅ Completed Components

### 1. Models (with json_serializable)
- ✅ `UserProfileModel` - User profile data
- ✅ `UserPreferencesModel` - Theme, language, notifications preferences
- ✅ `PaymentMethodModel` - Payment method (card, wallet, etc.)
- ✅ `SupportTicketModel` - Support ticket data
- ✅ `WalletModel` - Wallet balance and transactions

### 2. Repository
- ✅ `ProfileRepository` interface
- ✅ `DummyProfileRepository` implementation (returns mock data)

### 3. BLoCs
- ✅ `ProfileBloc` - Profile loading and updates
- ✅ `AuthSecurityBloc` - Password change, 2FA, account deletion
- ✅ `ThemeBloc` - Theme mode management (system/light/dark)
- ✅ `LanguageBloc` - Language selection and persistence
- ✅ `PaymentBloc` - Payment methods and wallet management
- ✅ `SupportBloc` - FAQ, tickets, privacy policy, terms

### 4. UI Screens
- ✅ `ProfilePage` - Updated with BLoC integration
- ⏳ `EditProfilePage` - Needs BLoC integration
- ⏳ `ChangePasswordPage` - To be created
- ⏳ `PaymentMethodsPage` - To be created
- ⏳ `ThemeSettingsPage` - To be created
- ⏳ `LanguageSettingsPage` - To be created
- ⏳ `HelpSupportPage` - To be created
- ⏳ `ContactUsPage` - To be created
- ⏳ `PrivacyPolicyPage` - To be created
- ⏳ `TermsOfServicePage` - To be created

## 🔧 Setup Instructions

### 1. Generate JSON Serialization Code

Run build_runner to generate JSON serialization code for models:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 2. Register Dependencies in DI

Add to `lib/core/di/injection.dart`:

```dart
// Profile Repository
..registerLazySingleton<ProfileRepository>(DummyProfileRepository.new)

// Profile BLoCs (use registerFactory for BLoCs)
..registerFactory(
  () => ProfileBloc(repository: sl<ProfileRepository>()),
)
..registerFactory(
  () => AuthSecurityBloc(repository: sl<ProfileRepository>()),
)
..registerFactory(
  () => ThemeBloc(
    repository: sl<ProfileRepository>(),
    prefs: sl<SharedPreferences>(),
  ),
)
..registerFactory(
  () => LanguageBloc(
    repository: sl<ProfileRepository>(),
    prefs: sl<SharedPreferences>(),
  ),
)
..registerFactory(
  () => PaymentBloc(repository: sl<ProfileRepository>()),
)
..registerFactory(
  () => SupportBloc(repository: sl<ProfileRepository>()),
)
```

### 3. Add Routes

Add new routes to `lib/routes/app_routes.dart`:

```dart
enum AppRoutes {
  // ... existing routes ...
  changePassword,
  paymentMethods,
  themeSettings,
  languageSettings,
  helpSupport,
  contactUs,
  privacyPolicy,
  termsOfService,
  deleteAccount,
}
```

Add path mappings in `AppRoutePath` extension:

```dart
case AppRoutes.changePassword:
  return '/changePassword';
case AppRoutes.paymentMethods:
  return '/paymentMethods';
// ... etc
```

Add GoRoute definitions in `AppRouter.router`:

```dart
GoRoute(
  path: AppRoutes.changePassword.path,
  name: AppRoutes.changePassword.name,
  builder: (context, state) => const ChangePasswordPage(),
),
// ... etc
```

### 4. Add Localization Strings

Add strings to `lib/l10n/app_en.arb`:

```json
{
  "profileEditProfile": "Edit Profile",
  "profileChangePassword": "Change Password",
  "profilePaymentMethods": "Payment Methods",
  "profileTheme": "Theme",
  "profileLanguage": "Language",
  "profileHelpSupport": "Help & Support",
  "profileContactUs": "Contact Us",
  "profilePrivacyPolicy": "Privacy Policy",
  "profileTermsOfService": "Terms of Service",
  "profileDeleteAccount": "Delete Account",
  // ... more strings
}
```

## 📱 Usage Examples

### Using ProfileBloc

```dart
BlocProvider(
  create: (context) => ProfileBloc(
    repository: context.read<ProfileRepository>(),
  )..add(const LoadProfile()),
  child: BlocBuilder<ProfileBloc, ProfileState>(
    builder: (context, state) {
      if (state.isLoading) {
        return const CircularProgressIndicator();
      }
      final profile = state.profile;
      return Text(profile?.name ?? 'Loading...');
    },
  ),
)
```

### Using ThemeBloc

```dart
BlocProvider(
  create: (context) => ThemeBloc(
    repository: context.read<ProfileRepository>(),
    prefs: context.read<SharedPreferences>(),
  )..add(const LoadTheme()),
  child: BlocBuilder<ThemeBloc, ThemeState>(
    builder: (context, state) {
      return DropdownButton<ThemeModeOption>(
        value: state.themeMode,
        items: ThemeModeOption.values.map((mode) {
          return DropdownMenuItem(
            value: mode,
            child: Text(mode.name),
          );
        }).toList(),
        onChanged: (mode) {
          if (mode != null) {
            context.read<ThemeBloc>().add(SetThemeMode(mode));
          }
        },
      );
    },
  ),
)
```

## 🔐 Security Notes

- **Never store raw card data** - Only tokenized references (gatewayToken)
- **Re-authentication required** for sensitive operations (password change, account deletion)
- **Use flutter_secure_storage** for sensitive tokens (not implemented yet)
- **HTTPS everywhere** - All API calls should use HTTPS

## 🎨 UI Guidelines

- Use `ScreenUtil` for all sizing (`.sp`, `.h`, `.w`, `.r`)
- Use context extensions (`context.colors`, `context.text`, etc.)
- Follow Material Design 3 guidelines
- Support both light and dark themes
- Ensure accessibility (screen readers, large tap targets)

## 📝 TODO / Next Steps

1. **Create remaining UI screens:**
   - [ ] ChangePasswordPage
   - [ ] PaymentMethodsPage
   - [ ] ThemeSettingsPage
   - [ ] LanguageSettingsPage
   - [ ] HelpSupportPage
   - [ ] ContactUsPage
   - [ ] PrivacyPolicyPage
   - [ ] TermsOfServicePage
   - [ ] DeleteAccountPage

2. **Payment Gateway Integration:**
   - [ ] Create payment gateway adapter interface
   - [ ] Implement Stripe adapter (mock)
   - [ ] Implement Razorpay adapter (mock)
   - [ ] Add 3D Secure flow handling

3. **Image Upload:**
   - [ ] Implement avatar image picker
   - [ ] Add image compression
   - [ ] Add image cropping

4. **Localization:**
   - [ ] Add all strings to ARB files
   - [ ] Support multiple languages (en, hi, es, etc.)

5. **Testing:**
   - [ ] Unit tests for BLoCs
   - [ ] Widget tests for screens
   - [ ] Integration tests for flows

6. **Documentation:**
   - [ ] API integration guide
   - [ ] Payment gateway setup guide
   - [ ] Architecture diagrams

## 🔗 Related Files

- Models: `lib/features/profile/models/`
- BLoCs: `lib/features/profile/bloc/`
- Repository: `lib/features/profile/repositories/`
- Routes: `lib/routes/app_routes.dart`
- DI: `lib/core/di/injection.dart`
- Localization: `lib/l10n/app_en.arb`

## 📚 API Endpoints (To be implemented)

When replacing dummy repository with real API:

```
GET    /user/profile
PUT    /user/profile
POST   /user/profile/avatar
POST   /auth/change-password
POST   /auth/reauth
POST   /payments/methods
GET    /payments/methods
DELETE /payments/methods/{id}
POST   /payments/wallet/topup
GET    /user/billing/history
GET    /legal/privacy-policy
GET    /legal/terms
POST   /support/tickets
GET    /support/tickets
POST   /user/export-data
POST   /user/delete-account
```

## 🐛 Known Issues

- JSON serialization code needs to be generated (run build_runner)
- Some routes need to be added to app_routes.dart
- DI registration needs to be completed
- Localization strings need to be added

## 📞 Support

For questions or issues, refer to the main project documentation or contact the development team.

