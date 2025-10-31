import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:photo_app/core/utils/token_storage.dart';

/// This interceptor is used to show request and response logs
class LoggerInterceptor extends Interceptor {
  Logger logger = Logger(
      printer: PrettyPrinter(methodCount: 0, colors: true, printEmojis: true));

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final options = err.requestOptions;
    final requestPath = '${options.baseUrl}${options.path}';
    logger.e('${options.method} request ==> $requestPath'); //Error log
    logger.d('Error type: ${err.error} \n '
        'Error message: ${err.message}'); //Debug log
    handler.next(err); //Continue with the Error
  }

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await TokenStorage.loadToken();
    // Устанавливаем токен только если он существует
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    final requestPath = '${options.baseUrl}${options.path}';

    logger.i('${options.method} request ==> $requestPath'); //Info log
    handler.next(options); // continue with the Request
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    logger.d('STATUSCODE: ${response.statusCode} \n '
        'STATUSMESSAGE: ${response.statusMessage} \n'
        'HEADERS: ${response.headers} \n'
        'Data: ${response.data}'); // Debug log
    handler.next(response); // continue with the Response
  }
}

/// CORS interceptor to handle cross-origin requests
class CorsInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Устанавливаем только безопасные заголовки
    // Origin устанавливается браузером автоматически и не может быть задан вручную
    options.headers['Content-Type'] = 'application/json';
    options.headers['Accept'] = 'application/json';

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Handle CORS preflight errors
    if (err.response?.statusCode == 405 &&
        err.requestOptions.method == 'OPTIONS') {
      // This is a CORS preflight request, return success
      final response = Response(
        requestOptions: err.requestOptions,
        statusCode: 200,
        statusMessage: 'OK',
        headers: Headers.fromMap({
          'Access-Control-Allow-Origin': ['*'],
          'Access-Control-Allow-Methods': ['GET, POST, PUT, DELETE, OPTIONS'],
          'Access-Control-Allow-Headers': [
            'Origin, Content-Type, Accept, Authorization, X-Request-With'
          ],
          'Access-Control-Allow-Credentials': ['true'],
        }),
      );
      handler.resolve(response);
      return;
    }

    handler.next(err);
  }
}

/// Error handling interceptor for better error management
class ErrorHandlingInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Логируем только в debug режиме
    if (kDebugMode) {
      print('ErrorHandlingInterceptor - Error type: ${err.type}');
      print('ErrorHandlingInterceptor - Status code: ${err.response?.statusCode}');
      print('ErrorHandlingInterceptor - Error message: ${err.message}');
      print('ErrorHandlingInterceptor - URL: ${err.requestOptions.baseUrl}${err.requestOptions.path}');
    }

    // Обработка 401 Unauthorized - очищаем токен
    if (err.response?.statusCode == 401) {
      if (kDebugMode) {
        print('401 Unauthorized detected - clearing token');
      }
      await TokenStorage.deleteToken();
      // Продолжаем обработку ошибки - UI слой обработает редирект через AuthGuard
      handler.next(err);
      return;
    }

    // Handle CORS errors specifically
    if (err.type == DioExceptionType.connectionError) {
      if (kDebugMode) {
        print('Connection error detected');
      }
      // Network error - could be CORS related
      final newError = DioException(
        requestOptions: err.requestOptions,
        error:
            'Network connection failed. Please check your internet connection and try again.',
        type: DioExceptionType.connectionError,
      );
      handler.next(newError);
      return;
    }

    if (err.response?.statusCode == 0) {
      if (kDebugMode) {
        print('CORS error detected (status code 0)');
      }
      // CORS error typically returns status code 0
      final newError = DioException(
        requestOptions: err.requestOptions,
        error:
            'CORS error: Unable to connect to the server. Please check if the server is running and CORS is properly configured.',
        type: DioExceptionType.connectionError,
      );
      handler.next(newError);
      return;
    }

    handler.next(err);
  }
}
