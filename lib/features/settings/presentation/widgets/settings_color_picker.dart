/// File: lib/features/settings/presentation/widgets/settings_color_picker.dart
/// Purpose: Color picker widget for accent color selection
/// Belongs To: settings feature
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/core.dart';

/// Predefined accent colors.
final List<Color> accentColors = [
  Colors.blue,
  Colors.green,
  Colors.orange,
  Colors.purple,
  Colors.red,
  Colors.teal,
  Colors.pink,
  Colors.indigo,
  Colors.amber,
  Colors.cyan,
];

/// Color picker widget.
class SettingsColorPicker extends StatelessWidget {
  const SettingsColorPicker({
    required this.selectedColorHex,
    required this.onColorSelected,
    super.key,
  });

  final String? selectedColorHex;
  final ValueChanged<String> onColorSelected;

  Color? _parseColor(String? hex) {
    if (hex == null) return null;
    try {
      return Color(
        int.parse(hex.replaceFirst('#', ''), radix: 16) + 0xFF000000,
      );
    } catch (_) {
      return null;
    }
  }

  String _colorToHex(Color color) {
    return '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
  }

  @override
  Widget build(BuildContext context) {
    final selectedColor = _parseColor(selectedColorHex);

    /// make this wrap into grid view with 3 columns
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        mainAxisSpacing: 12.w,
        crossAxisSpacing: 12.w,
      ),
      itemCount: accentColors.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            onColorSelected(_colorToHex(accentColors[index]));
          },
          child: Container(
            width: 50.w,
            height: 50.h,
            decoration: BoxDecoration(
              color: accentColors[index],
              shape: BoxShape.circle,
              border: Border.all(
                color: accentColors[index] == selectedColor
                    ? context.colors.primary
                    : Colors.transparent,
                width: 3.w,
              ),
              boxShadow: accentColors[index] == selectedColor
                  ? [
                      BoxShadow(
                        color: context.colors.primary.withOpacity(0.3),
                        blurRadius: 8.r,
                        spreadRadius: 2.r,
                      ),
                    ]
                  : null,
            ),
            child: accentColors[index] == selectedColor
                ? Icon(Icons.check, color: Colors.white, size: 24.r)
                : null,
          ),
        );
      },
    );
  }
}
