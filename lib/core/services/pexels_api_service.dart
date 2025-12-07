/// File: lib/core/services/pexels_api_service.dart
/// Purpose: Pexels API service using Dio
/// Belongs To: shared
/// Customization Guide:
///    - Configure API key in lib/core/constants/env.dart
///    - Adjust timeout values as needed
///    - Add retry logic if needed
library;

import 'package:dio/dio.dart';

import '../constants/app_constants.dart';
import '../constants/env.dart';
import '../data/models/pexels/pexels.dart';

/// Pexels API service.
/// Handles all communication with Pexels REST API.
class PexelsApiService {
  PexelsApiService() : _dio = _createDio();

  final Dio _dio;

  /// Base URL for Pexels API
  static const String _baseUrl = 'https://api.pexels.com/v1';

  /// Create Dio instance with configuration
  static Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: AppConstants.connectionTimeout,
        receiveTimeout: AppConstants.receiveTimeout,
        headers: {
          'Authorization': Env.pexelsKey.isNotEmpty
              ? 'Bearer ${Env.pexelsKey}'
              : '',
        },
      ),
    );

    // Add error interceptor
    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) {
          if (error.response?.statusCode == 401) {
            // Handle unauthorized (invalid API key)
            error = DioException(
              requestOptions: error.requestOptions,
              response: error.response,
              type: DioExceptionType.badResponse,
              error: 'Invalid Pexels API key. Please configure PEXELS_API_KEY.',
            );
          }
          return handler.next(error);
        },
      ),
    );

    return dio;
  }

  /// Get curated photos from Pexels.
  /// 
  /// [page] - Page number (default: 1)
  /// [perPage] - Results per page (default: 15, max: 80)
  /// 
  /// Returns list of curated photos.
  Future<List<PexelsPhoto>> curatedPhotos({
    int page = 1,
    int perPage = 15,
  }) async {
    try {
      if (!Env.hasPexelsKey) {
        throw Exception(
          'Pexels API key not configured. Add PEXELS_API_KEY to environment.',
        );
      }

      final response = await _dio.get<Map<String, dynamic>>(
        '/curated',
        queryParameters: {
          'page': page,
          'per_page': perPage.clamp(1, 80),
        },
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final pexelsResponse = PexelsResponse.fromJson(data);
        return pexelsResponse.photos;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        );
      }
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      throw Exception('Failed to fetch curated photos: $e');
    }
  }

  /// Search photos on Pexels.
  /// 
  /// [query] - Search query (e.g., "electric car", "charging station")
  /// [page] - Page number (default: 1)
  /// [perPage] - Results per page (default: 15, max: 80)
  /// 
  /// Returns list of matching photos.
  Future<List<PexelsPhoto>> searchPhotos(
    String query, {
    int page = 1,
    int perPage = 15,
  }) async {
    try {
      if (!Env.hasPexelsKey) {
        throw Exception(
          'Pexels API key not configured. Add PEXELS_API_KEY to environment.',
        );
      }

      if (query.isEmpty) {
        throw ArgumentError('Search query cannot be empty');
      }

      final response = await _dio.get<Map<String, dynamic>>(
        '/search',
        queryParameters: {
          'query': query,
          'page': page,
          'per_page': perPage.clamp(1, 80),
        },
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final pexelsResponse = PexelsResponse.fromJson(data);
        return pexelsResponse.photos;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        );
      }
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      throw Exception('Failed to search photos: $e');
    }
  }

  /// Handle Dio errors and convert to user-friendly exceptions
  Exception _handleError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('Connection timeout. Please check your internet.');
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        if (statusCode == 401) {
          return Exception('Invalid Pexels API key.');
        } else if (statusCode == 429) {
          return Exception('Rate limit exceeded. Please try again later.');
        } else {
          return Exception(
            'API error: ${e.response?.statusMessage ?? "Unknown error"}',
          );
        }
      case DioExceptionType.cancel:
        return Exception('Request cancelled.');
      case DioExceptionType.connectionError:
        return Exception('No internet connection.');
      default:
        return Exception('Failed to connect to Pexels API: ${e.message}');
    }
  }
}

