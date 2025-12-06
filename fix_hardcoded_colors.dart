/// Script to batch-fix hard-coded AppColors references
/// 
/// Usage: dart fix_hardcoded_colors.dart
/// 
/// This script replaces hard-coded AppColors static properties with
/// semantic context.appColors tokens throughout the codebase.
library;

import 'dart:io';

void main() async {
  print('🔍 Scanning for hard-coded AppColors references...\n');

  final libDir = Directory('lib');
  if (!await libDir.exists()) {
    print('❌ lib directory not found!');
    exit(1);
  }

  final files = await _findDartFiles(libDir);
  print('📁 Found ${files.length} Dart files\n');

  // Exclude core theme files (they intentionally use AppColors static)
  final excludedPaths = [
    'lib/core/theme/color_schemes.dart',
    'lib/core/theme/light_theme.dart',
    'lib/core/theme/dark_theme.dart',
    'lib/core/theme/app_text_styles.dart',
    'lib/core/theme/app_colors.dart',
    'lib/bootstrap.dart',
  ];

  final filesToFix = files.where((file) {
    final path = file.path;
    return !excludedPaths.any(path.contains);
  }).toList();

  print('🎯 Processing ${filesToFix.length} files (excluding core theme files)\n');

  var totalReplacements = 0;
  var filesModified = 0;

  for (final file in filesToFix) {
    var content = await file.readAsString();
    final originalContent = content;
    
    // Skip if file doesn't have hard-coded AppColors
    if (!content.contains('AppColors.')) {
      continue;
    }

    // Check if file already imports context_ext
    final hasContextExt = content.contains("import 'package:ev_charging_user_app/core/extensions/context_ext.dart'") ||
                          content.contains('import "package:ev_charging_user_app/core/extensions/context_ext.dart"') ||
                          content.contains("import '../../../core/extensions/context_ext.dart'") ||
                          content.contains('import "../../../core/extensions/context_ext.dart"') ||
                          content.contains("import '../../../../core/extensions/context_ext.dart'") ||
                          content.contains('import "../../../../core/extensions/context_ext.dart"');

    // Replace common patterns
    content = _replacePatterns(content);

    // Add context_ext import if needed and file was modified
    if (content != originalContent && !hasContextExt) {
      content = _addContextExtImport(content, file.path);
    }

    if (content != originalContent) {
      await file.writeAsString(content);
      final replacements = _countReplacements(originalContent, content);
      totalReplacements += replacements;
      filesModified++;
      print('✅ Fixed: ${file.path} ($replacements replacements)');
    }
  }

  print('\n✨ Done!');
  print('📊 Modified $filesModified files');
  print('🔄 Total replacements: $totalReplacements');
}

Future<List<File>> _findDartFiles(Directory dir) async {
  final files = <File>[];
  await for (final entity in dir.list(recursive: true)) {
    if (entity is File && entity.path.endsWith('.dart')) {
      files.add(entity);
    }
  }
  return files;
}

String _replacePatterns(String content) {
  // Map of AppColors static properties to semantic tokens
  final replacements = {
    'AppColors.textPrimaryDark': 'colors.textPrimary',
    'AppColors.textPrimaryLight': 'colors.textPrimary',
    'AppColors.textSecondaryDark': 'colors.textSecondary',
    'AppColors.textSecondaryLight': 'colors.textSecondary',
    'AppColors.textTertiaryDark': 'colors.textTertiary',
    'AppColors.textTertiaryLight': 'colors.textTertiary',
    'AppColors.textDisabledLight': 'colors.textDisabled',
    'AppColors.textDisabledDark': 'colors.textDisabled',
    'AppColors.surfaceVariantDark': 'colors.surfaceVariant',
    'AppColors.surfaceVariantLight': 'colors.surfaceVariant',
    'AppColors.surfaceDark': 'colors.surface',
    'AppColors.surfaceLight': 'colors.surface',
    'AppColors.backgroundDark': 'colors.background',
    'AppColors.backgroundLight': 'colors.background',
    'AppColors.outlineDark': 'colors.outline',
    'AppColors.outlineLight': 'colors.outline',
    'AppColors.primaryDark': 'colors.primaryContainer',
    'AppColors.primaryLight': 'colors.primary',
    'AppColors.secondaryDark': 'colors.secondaryContainer',
    'AppColors.secondaryLight': 'colors.secondary',
    'AppColors.tertiaryDark': 'colors.tertiaryContainer',
    'AppColors.tertiaryLight': 'colors.tertiary',
    'AppColors.successDark': 'colors.successContainer',
    'AppColors.successLight': 'colors.success',
    'AppColors.errorDark': 'colors.dangerContainer',
    'AppColors.errorLight': 'colors.danger',
    'AppColors.error': 'colors.danger',
    'AppColors.warningDark': 'colors.warningContainer',
    'AppColors.warningLight': 'colors.warning',
    'AppColors.infoDark': 'colors.infoContainer',
    'AppColors.infoLight': 'colors.info',
    'AppColors.ratingActive': 'colors.warning',
    'AppColors.ratingInactive': 'colors.textTertiary',
    'AppColors.available': 'colors.success',
    'AppColors.occupied': 'colors.warning',
    'AppColors.offline': 'colors.textTertiary',
    'AppColors.charging': 'colors.info',
    'AppColors.faulted': 'colors.danger',
    'AppColors.scrim': 'colors.scrim',
    'AppColors.shadowDark': 'colors.shadow',
    'AppColors.shadowLight': 'colors.shadow',
    'AppColors.shadowMedium': 'colors.shadow',
    'AppColors.shadowDarkMode': 'colors.shadow',
    'AppColors.dividerDark': 'colors.divider',
    'AppColors.dividerLight': 'colors.divider',
    'AppColors.primaryContainer': 'colors.primaryContainer',
    'AppColors.secondaryContainer': 'colors.secondaryContainer',
    'AppColors.tertiaryContainer': 'colors.tertiaryContainer',
    'AppColors.successContainer': 'colors.successContainer',
    'AppColors.errorContainer': 'colors.dangerContainer',
    'AppColors.warningContainer': 'colors.warningContainer',
    'AppColors.infoContainer': 'colors.infoContainer',
    'AppColors.primaryContainerDark': 'colors.primaryContainer',
    'AppColors.secondaryContainerDark': 'colors.secondaryContainer',
    'AppColors.tertiaryContainerDark': 'colors.tertiaryContainer',
    'AppColors.successContainerDark': 'colors.successContainer',
    'AppColors.errorContainerDark': 'colors.dangerContainer',
    'AppColors.warningContainerDark': 'colors.warningContainer',
    'AppColors.infoContainerDark': 'colors.infoContainer',
    'AppColors.platinumBadge': 'colors.tertiary',
    'AppColors.goldBadge': 'colors.secondary',
    'AppColors.silverBadge': 'colors.textTertiary',
    'AppColors.bronzeBadge': 'colors.warning',
  };

  // Apply replacements
  for (final entry in replacements.entries) {
    // Replace standalone references (not part of other identifiers)
    final pattern = RegExp(r'\b' + RegExp.escape(entry.key) + r'\b');
    content = content.replaceAll(pattern, entry.value);
  }

  // Fix common patterns that need context
  content = _fixCommonPatterns(content);

  return content;
}

String _fixCommonPatterns(String content) {
  // Fix patterns like AppColors.primary.withValues(alpha: ...)
  // These should become colors.primary.withValues(alpha: ...)
  // But we need to ensure colors is available in the scope
  
  // Fix const TextStyle with AppColors (should remove const)
  content = content.replaceAllMapped(
    RegExp(r'const\s+TextStyle\s*\([^)]*color:\s*AppColors\.\w+'),
    (match) => match.group(0)!.replaceFirst('const ', ''),
  );

  // Fix const BoxDecoration with AppColors
  content = content.replaceAllMapped(
    RegExp(r'const\s+BoxDecoration\s*\([^)]*color:\s*AppColors\.\w+'),
    (match) => match.group(0)!.replaceFirst('const ', ''),
  );

  // Fix const LinearGradient with AppColors
  content = content.replaceAllMapped(
    RegExp(r'const\s+LinearGradient\s*\([^)]*colors:\s*\[[^\]]*AppColors\.\w+'),
    (match) => match.group(0)!.replaceFirst('const ', ''),
  );

  return content;
}

String _addContextExtImport(String content, String filePath) {
  // Determine relative path depth
  final depth = filePath.split('/').length - 2; // -2 for lib/ and filename
  final relativePath = '../' * depth + 'core/extensions/context_ext.dart';
  
  // Find the last import statement
  final importPattern = RegExp(r'import\s+[^\s]+\s*;', multiLine: true);
  final imports = importPattern.allMatches(content).toList();
  
  if (imports.isEmpty) {
    // No imports found, add at the beginning after library directive
    if (content.contains('library;')) {
      return content.replaceFirst(
        'library;',
        "library;\n\nimport '$relativePath';",
      );
    }
    return "import '$relativePath';\n\n$content";
  }

  // Add after the last import
  final lastImport = imports.last;
  final insertPosition = lastImport.end;
  final before = content.substring(0, insertPosition);
  final after = content.substring(insertPosition);
  
  // Check if already imported
  if (content.contains('context_ext.dart')) {
    return content;
  }

  return "$before\nimport '$relativePath';$after";
}

int _countReplacements(String original, String modified) {
  // Simple count of AppColors references removed
  final originalCount = RegExp(r'\bAppColors\.\w+').allMatches(original).length;
  final modifiedCount = RegExp(r'\bAppColors\.\w+').allMatches(modified).length;
  return originalCount - modifiedCount;
}

