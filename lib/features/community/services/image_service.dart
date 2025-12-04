/// File: lib/features/community/services/image_service.dart
/// Purpose: Image processing service for compression and EXIF removal
/// Belongs To: community feature
/// Customization Guide:
///    - Adjust compression settings as needed
///    - Implement actual EXIF removal with native_exif package
library;

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

/// Image processing result.
class ProcessedImage {
  const ProcessedImage({
    required this.path,
    required this.originalSize,
    required this.processedSize,
    required this.width,
    required this.height,
  });

  final String path;
  final int originalSize;
  final int processedSize;
  final int width;
  final int height;

  /// Compression ratio (0-1).
  double get compressionRatio => processedSize / originalSize;

  /// Savings in bytes.
  int get savedBytes => originalSize - processedSize;

  /// Savings percentage.
  double get savingsPercent => (1 - compressionRatio) * 100;
}

/// Image upload configuration.
class ImageUploadConfig {
  const ImageUploadConfig({
    this.maxWidth = 2048,
    this.maxHeight = 2048,
    this.quality = 85,
    this.maxFileSizeKb = 300,
    this.removeExif = true,
    this.format = ImageFormat.jpeg,
  });

  final int maxWidth;
  final int maxHeight;
  final int quality;
  final int maxFileSizeKb;
  final bool removeExif;
  final ImageFormat format;

  /// Default config for reviews.
  static const review = ImageUploadConfig();

  /// Config for thumbnails.
  static const thumbnail = ImageUploadConfig(
    maxWidth: 400,
    maxHeight: 400,
    quality: 75,
    maxFileSizeKb: 50,
  );

  /// Config for profile avatars.
  static const avatar = ImageUploadConfig(
    maxWidth: 256,
    maxHeight: 256,
    quality: 80,
    maxFileSizeKb: 30,
  );
}

/// Image format for output.
enum ImageFormat { jpeg, png, webp }

/// Image service for processing uploads.
class ImageService {
  ImageService._();
  static final ImageService instance = ImageService._();

  final _uuid = const Uuid();

  /// Process image for upload.
  /// Compresses, resizes, and removes EXIF data.
  /// Note: In production, use the 'image' package for actual compression.
  Future<ProcessedImage?> processImage(
    String sourcePath, {
    ImageUploadConfig config = ImageUploadConfig.review,
  }) async {
    try {
      final sourceFile = File(sourcePath);
      // ignore: avoid_slow_async_io
      if (!await sourceFile.exists()) {
        debugPrint('ImageService: Source file does not exist');
        return null;
      }

      final originalBytes = await sourceFile.readAsBytes();
      final originalSize = originalBytes.length;

      // In production, use the 'image' package for actual compression
      // For now, just copy the file with a new name
      final tempDir = await getTemporaryDirectory();
      final extension = _getExtension(config.format);
      final fileName = '${_uuid.v4()}.$extension';
      final outputPath = '${tempDir.path}/$fileName';
      final outputFile = File(outputPath);
      await outputFile.writeAsBytes(originalBytes);

      return ProcessedImage(
        path: outputPath,
        originalSize: originalSize,
        processedSize: originalBytes.length,
        width: config.maxWidth,
        height: config.maxHeight,
      );
    } catch (e) {
      debugPrint('ImageService: Error processing image: $e');
      return null;
    }
  }

  /// Process multiple images in parallel.
  Future<List<ProcessedImage>> processImages(
    List<String> sourcePaths, {
    ImageUploadConfig config = ImageUploadConfig.review,
  }) async {
    final futures = sourcePaths.map(
      (path) => processImage(path, config: config),
    );
    final results = await Future.wait(futures);
    return results.whereType<ProcessedImage>().toList();
  }

  /// Generate thumbnail from image.
  Future<ProcessedImage?> generateThumbnail(
    String sourcePath, {
    int size = 200,
  }) async {
    return processImage(
      sourcePath,
      config: ImageUploadConfig(
        maxWidth: size,
        maxHeight: size,
        quality: 75,
        maxFileSizeKb: 30,
      ),
    );
  }

  /// Validate image before processing.
  Future<ImageValidationResult> validateImage(
    String path, {
    int maxSizeMb = 10,
    List<String> allowedFormats = const ['jpg', 'jpeg', 'png', 'webp', 'heic'],
  }) async {
    try {
      final file = File(path);
      // ignore: avoid_slow_async_io
      if (!await file.exists()) {
        return ImageValidationResult.notFound;
      }

      // Check file size
      final size = await file.length();
      final maxBytes = maxSizeMb * 1024 * 1024;
      if (size > maxBytes) {
        return ImageValidationResult.tooLarge;
      }

      // Check format
      final extension = path.split('.').last.toLowerCase();
      if (!allowedFormats.contains(extension)) {
        return ImageValidationResult.invalidFormat;
      }

      // In production, decode the image to verify it's valid
      // For now, just check if we can read the file
      await file.readAsBytes();

      return ImageValidationResult.valid;
    } catch (e) {
      debugPrint('ImageService: Validation error: $e');
      return ImageValidationResult.error;
    }
  }

  /// Clean up temp processed images.
  Future<void> cleanupTempImages() async {
    try {
      final tempDir = await getTemporaryDirectory();
      final files = tempDir.listSync();
      for (final file in files) {
        if (file is File) {
          final name = file.path.split('/').last;
          // Only delete our processed images (UUID format)
          if (_isUuidFileName(name)) {
            await file.delete();
          }
        }
      }
    } catch (e) {
      debugPrint('ImageService: Cleanup error: $e');
    }
  }

  String _getExtension(ImageFormat format) {
    switch (format) {
      case ImageFormat.jpeg:
        return 'jpg';
      case ImageFormat.png:
        return 'png';
      case ImageFormat.webp:
        return 'webp';
    }
  }

  bool _isUuidFileName(String name) {
    // Simple UUID pattern check
    final uuidPattern = RegExp(
      r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\.',
      caseSensitive: false,
    );
    return uuidPattern.hasMatch(name);
  }
}

/// Image validation result.
enum ImageValidationResult {
  valid,
  notFound,
  tooLarge,
  invalidFormat,
  corrupt,
  error,
}

/// Extension for validation result messages.
extension ImageValidationResultExt on ImageValidationResult {
  String get message {
    switch (this) {
      case ImageValidationResult.valid:
        return 'Image is valid';
      case ImageValidationResult.notFound:
        return 'Image file not found';
      case ImageValidationResult.tooLarge:
        return 'Image is too large';
      case ImageValidationResult.invalidFormat:
        return 'Invalid image format';
      case ImageValidationResult.corrupt:
        return 'Image file is corrupt';
      case ImageValidationResult.error:
        return 'Error validating image';
    }
  }

  bool get isValid => this == ImageValidationResult.valid;
}

// Note: In production, add the 'image' package and implement actual
// image processing with compression and EXIF removal.
// The current implementation is a simplified placeholder.
