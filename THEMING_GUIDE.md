# 🎨 Theming Guide - EV Charging User App

## Overview

This app uses a **design token system** with **ThemeExtension** to provide centralized, theme-aware colors that automatically adapt to light and dark modes. All hardcoded colors have been removed in favor of semantic color tokens.

---

## 📁 Architecture

### Core Theme Files

```
lib/core/theme/
├── design_tokens.dart          # Semantic token names (documentation)
├── app_theme_extensions.dart   # AppColors ThemeExtension class
├── color_schemes.dart          # Light & dark AppColors instances
├── app_colors.dart             # Static color palette (legacy, used by schemes)
├── light_theme.dart            # Light ThemeData with AppColors extension
├── dark_theme.dart             # Dark ThemeData with AppColors extension
├── theme_manager.dart          # Theme switching & persistence
└── theme.dart                  # Barrel exports
```

### Context Extension

```
lib/core/extensions/context_ext.dart
├── ContextThemeExt          # Theme, ColorScheme, TextTheme access
├── AppColorContextExt       # context.appColors → AppColors extension
└── ContextDarkModeExt       # isDark, isLight checks
```

---

## 🎯 Usage

### Accessing Theme Colors

**✅ DO: Use `context.appColors` for semantic colors**

```dart
Container(
  color: context.appColors.background,
  child: Text(
    'Hello',
    style: TextStyle(color: context.appColors.textPrimary),
  ),
)
```

**❌ DON'T: Use hardcoded colors**

```dart
// ❌ BAD - Breaks dark mode
Container(
  color: context.appColors.surface,
  child: Text('Hello', style: TextStyle(color: Colors.black)),
)

// ❌ BAD - Hardcoded hex
Container(color: Color(0xFF1A1A1A))
```

### Available Color Tokens

All colors are available via `context.appColors`:

```dart
// Backgrounds
context.appColors.background        // Scaffold background
context.appColors.surface           // Cards, dialogs, sheets
context.appColors.surfaceVariant    // Elevated surfaces, input fields

// Text
context.appColors.textPrimary       // Headings, important text
context.appColors.textSecondary     // Body text, descriptions
context.appColors.textTertiary      // Hints, placeholders
context.appColors.textDisabled      // Disabled text

// Brand
context.appColors.primary           // Main brand color
context.appColors.secondary         // Accent color

// Functional
context.appColors.success           // Success states
context.appColors.danger            // Error/danger states
context.appColors.warning           // Warning states
context.appColors.info              // Info states

// Outlines & Dividers
context.appColors.outline           // Borders, dividers
context.appColors.outlineVariant    // Subtle borders
context.appColors.divider           // Divider color
```

### Theme Mode Checks

```dart
if (context.isDark) {
  // Dark mode specific logic
}

if (context.isLight) {
  // Light mode specific logic
}
```

---

## 🔧 Customization

### Changing Color Values

1. **Edit `lib/core/theme/color_schemes.dart`**

   Modify the color values in `lightColorScheme` or `darkColorScheme`:

   ```dart
   final AppColors lightColorScheme = AppColors(
     background: Color(0xFFF8FAF9),  // Change this
     surface: Color(0xFFFFFFFF),      // Change this
     textPrimary: Color(0xFF1A1A1A), // Change this
     // ... etc
   );
   ```

2. **Edit `lib/core/theme/app_colors.dart`** (if using static colors)

   The static `AppColors` class contains the base color palette used by the schemes.

### Adding New Color Tokens

1. **Add property to `AppColors` ThemeExtension** (`app_theme_extensions.dart`):

   ```dart
   class AppColors extends ThemeExtension<AppColors> {
     // ... existing properties
     final Color newToken;  // Add this
     
     const AppColors({
       // ... existing parameters
       required this.newToken,  // Add this
     });
     
     // Update copyWith and lerp methods
   }
   ```

2. **Add to color schemes** (`color_schemes.dart`):

   ```dart
   final AppColors lightColorScheme = AppColors(
     // ... existing values
     newToken: Color(0xFF123456),  // Add this
   );
   
   final AppColors darkColorScheme = AppColors(
     // ... existing values
     newToken: Color(0xFFABCDEF),  // Add this
   );
   ```

3. **Use in widgets**:

   ```dart
   Container(color: context.appColors.newToken)
   ```

---

## 🎨 Theme Switching

The app uses `ThemeManager` for theme switching:

```dart
// Get ThemeManager from DI
final themeManager = sl<ThemeManager>();

// Switch themes
await themeManager.setLightMode();
await themeManager.setDarkMode();
await themeManager.setSystemMode();
await themeManager.toggleTheme();

// Check current mode
if (themeManager.isDarkMode) { ... }
```

The theme preference is automatically persisted to `SharedPreferences`.

---

## 📋 Migration Checklist

When adding new widgets or screens:

- [ ] ✅ Use `context.appColors.*` instead of `Colors.*`
- [ ] ✅ Use `context.appColors.*` instead of `Color(0xFF...)`
- [ ] ✅ Use `context.isDark` / `context.isLight` for theme checks
- [ ] ✅ Test in both light and dark modes
- [ ] ✅ Ensure proper contrast ratios (WCAG AA minimum)

---

## 🐛 Common Issues

### Issue: "AppColors extension not found"

**Solution**: Ensure `light_theme.dart` and `dark_theme.dart` include the extension:

```dart
ThemeData(
  // ...
  extensions: [
    lightColorScheme,  // or darkColorScheme
  ],
)
```

### Issue: Colors not updating when switching themes

**Solution**: Ensure widgets rebuild when theme changes. The app uses `ListenableBuilder` in `main.dart` to listen to `ThemeManager` changes.

### Issue: Name conflict with AppColors

**Solution**: The static `AppColors` class (in `app_colors.dart`) and the `AppColors` ThemeExtension (in `app_theme_extensions.dart`) have the same name. Use import prefixes if needed:

```dart
import 'app_colors.dart' as static_colors;
import 'app_theme_extensions.dart';
```

---

## 📚 Best Practices

1. **Always use semantic tokens**: Use `context.appColors.textPrimary` instead of `Colors.black`
2. **Test both themes**: Always verify your UI in both light and dark modes
3. **Maintain contrast**: Ensure text is readable on backgrounds (WCAG AA minimum)
4. **Use opacity carefully**: `context.appColors.textPrimary.withOpacity(0.7)` is fine, but prefer semantic tokens
5. **Avoid hardcoded colors**: Even in special cases (like card previews), prefer theme-aware colors

---

## 🔍 Examples

### Example 1: Card Widget

```dart
class MyCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.appColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: context.appColors.outline),
      ),
      child: Column(
        children: [
          Text(
            'Title',
            style: TextStyle(
              color: context.appColors.textPrimary,
              fontSize: 18.sp,
            ),
          ),
          Text(
            'Description',
            style: TextStyle(
              color: context.appColors.textSecondary,
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }
}
```

### Example 2: Button with Theme-Aware Colors

```dart
ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: context.appColors.primary,
    foregroundColor: context.appColors.surface,  // White text on primary
  ),
  onPressed: () {},
  child: Text('Click Me'),
)
```

### Example 3: Conditional Styling

```dart
Container(
  color: context.isDark
      ? context.appColors.surfaceVariant
      : context.appColors.surface,
  child: Text('Adaptive background'),
)
```

---

## 🎯 Summary

- ✅ **Use**: `context.appColors.*` for all colors
- ✅ **Test**: Both light and dark modes
- ✅ **Customize**: Edit `color_schemes.dart` to change values
- ❌ **Avoid**: `context.appColors.surface`, `Colors.black`, `Color(0xFF...)`
- ❌ **Avoid**: Hardcoded color values in widgets

---

**Last Updated**: 2024
**Maintained By**: Development Team

