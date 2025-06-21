import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import '../constants/app_constants.dart';
import '../errors/exceptions.dart';

/// Dio client provider for dependency injection
final dioClientProvider = Provider<DioClient>((ref) => DioClient());

/// HTTP client wrapper using Dio
class DioClient {
  DioClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout: AppConstants.connectionTimeout,
        receiveTimeout: AppConstants.receiveTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _setupInterceptors();
  }
  late final Dio _dio;
  final Logger _logger = Logger();

  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          _logger
            ..d('REQUEST[${options.method}] => PATH: ${options.path}')
            ..d('Headers: ${options.headers}')
            ..d('Data: ${options.data}');
          handler.next(options);
        },
        onResponse: (response, handler) {
          _logger
            ..d(
              'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
            )
            ..d('Data: ${response.data}');
          handler.next(response);
        },
        onError: (error, handler) {
          _logger
            ..e(
              'ERROR[${error.response?.statusCode}] => PATH: ${error.requestOptions.path}',
            )
            ..e('Message: ${error.message}');
          handler.next(error);
        },
      ),
    );
  }

  /// GET request
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// POST request
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// PUT request
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// DELETE request
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Handle Dio errors and convert to custom exceptions
  AppException _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException(
          message: 'Connection timeout. Please check your internet connection.',
        );
      case DioExceptionType.badResponse:
        return ServerException(
          message:
              (error.response?.data as Map<String, dynamic>?)?['message']
                  as String? ??
              'Server error occurred',
          statusCode: error.response?.statusCode,
        );
      case DioExceptionType.cancel:
        return NetworkException(message: 'Request was cancelled');
      case DioExceptionType.connectionError:
        return NetworkException(
          message: 'No internet connection. Please check your network.',
        );
      case DioExceptionType.badCertificate:
        return NetworkException(message: 'Certificate verification failed');
      case DioExceptionType.unknown:
        return NetworkException(
          message: error.message ?? 'An unexpected error occurred',
        );
    }
  }
}
