import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:photo_app/core/constants/api_url.dart';
import 'package:photo_app/core/constants/environment.dart';

import 'interceptors.dart';

class DioClient {
  late final Dio _dio;

  DioClient()
      : _dio = Dio(
          BaseOptions(
            baseUrl: ApiUrl.baseURL,
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
              'Accept': 'application/json',
              ...EnvironmentConfig.requestHeaders,
            },
            responseType: ResponseType.json,
            connectTimeout:
                const Duration(minutes: 5), // Увеличено для batch загрузок
            receiveTimeout:
                const Duration(minutes: 5), // Увеличено для batch загрузок
            sendTimeout:
                const Duration(minutes: 5), // Увеличено для batch загрузок
            maxRedirects: 5,
          ),
        )..interceptors.addAll([
            LoggerInterceptor(), // Всегда добавляем для установки токена, логи контролируются внутри
            if (kIsWeb) CorsInterceptor(),
            ErrorHandlingInterceptor(),
          ]);

  Options get _sendTimeoutOption => Options(
        sendTimeout: const Duration(minutes: 5), // Увеличено для batch загрузок
      );

  // GET METHOD
  Future<Response> get(
    String url, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response response = await _dio.get(
        url,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on DioException {
      rethrow;
    }
  }

  // POST METHOD
  Future<Response> post(
    String url, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      // Используем переданные options или объединяем с таймаутами по умолчанию
      final finalOptions = options?.copyWith(
            sendTimeout: options.sendTimeout ?? _sendTimeoutOption.sendTimeout,
            receiveTimeout:
                options.receiveTimeout ?? _sendTimeoutOption.sendTimeout,
          ) ??
          _sendTimeoutOption;

      final Response response = await _dio.post(
        url,
        data: data,
        options: finalOptions,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // PUT METHOD
  Future<Response> put(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response response = await _dio.put(
        url,
        data: data,
        queryParameters: queryParameters,
        options:
            options?.copyWith(sendTimeout: _sendTimeoutOption.sendTimeout) ??
                _sendTimeoutOption,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // PATCH METHOD
  Future<Response> patch(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response response = await _dio.patch(
        url,
        data: data,
        queryParameters: queryParameters,
        options:
            options?.copyWith(sendTimeout: _sendTimeoutOption.sendTimeout) ??
                _sendTimeoutOption,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // DELETE METHOD
  Future<Response> delete(
    String url, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final Response response = await _dio.delete(
        url,
        data: data,
        queryParameters: queryParameters,
        options:
            options?.copyWith(sendTimeout: _sendTimeoutOption.sendTimeout) ??
                _sendTimeoutOption,
        cancelToken: cancelToken,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
