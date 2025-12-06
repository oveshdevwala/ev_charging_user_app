/// Follow-up script to add `final colors = context.appColors;` where needed
/// 
/// Usage: dart fix_missing_colors_context.dart
/// 
/// This script ensures that methods using `colors.` have access to the colors variable.
library;

import 'dart:io';

void main() async {
  print('🔍 Scanning for methods using colors without context...\n');

  final libDir = Directory('lib');
  if (!await libDir.exists()) {
    print('❌ lib directory not found!');
    exit(1);
  }

  final files = await _findDartFiles(libDir);
  
  // Exclude core theme files
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

  print('🎯 Processing ${filesToFix.length} files\n');

  var filesModified = 0;

  for (final file in filesToFix) {
    var content = await file.readAsString();
    final originalContent = content;

    // Check if file uses colors. but doesn't have colors defined in build methods
    if (!content.contains('colors.')) {
      continue;
    }

    // Fix build methods that use colors but don't define it
    content = _fixBuildMethods(content);
    
    // Fix other widget methods that use colors
    content = _fixWidgetMethods(content);

    if (content != originalContent) {
      await file.writeAsString(content);
      filesModified++;
      print('✅ Fixed: ${file.path}');
    }
  }

  print('\n✨ Done!');
  print('📊 Modified $filesModified files');
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

String _fixBuildMethods(String content) {
  // Pattern: Widget build(BuildContext context) { ... colors. ... }
  // Need to add: final colors = context.appColors; after the opening brace
  
  final buildPattern = RegExp(
    r'(Widget\s+build\s*\([^)]*BuildContext\s+context[^)]*\)\s*\{)',
    multiLine: true,
  );

  return content.replaceAllMapped(buildPattern, (match) {
    final buildStart = match.group(0)!;
    final startPos = match.end;
    
    // Check if colors is already defined in this method
    final methodEnd = _findMethodEnd(content, startPos);
    final methodBody = content.substring(startPos, methodEnd);
    
    if (methodBody.contains(RegExp(r'\bfinal\s+colors\s*=\s*context\.appColors'))) {
      return buildStart; // Already has colors defined
    }
    
    // Check if method uses colors.
    if (!methodBody.contains(RegExp(r'\bcolors\.'))) {
      return buildStart; // Doesn't use colors
    }
    
    // Add colors definition
    return '$buildStart\n    final colors = context.appColors;';
  });
}

String _fixWidgetMethods(String content) {
  // Fix other widget methods (like _buildSomething) that use colors
  final widgetMethodPattern = RegExp(
    r'(Widget\s+(_\w+|build\w*)\s*\([^)]*BuildContext\s+context[^)]*\)\s*\{)',
    multiLine: true,
  );

  return content.replaceAllMapped(widgetMethodPattern, (match) {
    final methodStart = match.group(0)!;
    final startPos = match.end;
    
    // Check if colors is already defined in this method
    final methodEnd = _findMethodEnd(content, startPos);
    final methodBody = content.substring(startPos, methodEnd);
    
    if (methodBody.contains(RegExp(r'\bfinal\s+colors\s*=\s*context\.appColors'))) {
      return methodStart; // Already has colors defined
    }
    
    // Check if method uses colors.
    if (!methodBody.contains(RegExp(r'\bcolors\.'))) {
      return methodStart; // Doesn't use colors
    }
    
    // Add colors definition
    return '$methodStart\n    final colors = context.appColors;';
  });
}

int _findMethodEnd(String content, int startPos) {
  var braceCount = 1;
  var pos = startPos;
  
  while (pos < content.length && braceCount > 0) {
    final char = content[pos];
    if (char == '{') {
      braceCount++;
    } else if (char == '}') {
      braceCount--;
    }
    pos++;
  }
  
  return pos;
}

