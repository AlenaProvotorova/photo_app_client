import 'package:dio/dio.dart';

class ErrorHandler {
  static String handleError(dynamic error) {
    if (error is DioException) {
      if (error.response != null) {
        return 'Ошибка: ${error.response?.data['message']}';
      } else {
        return 'Ошибка сети';
      }
    } else {
      return 'Неизвестная ошибка: $error';
    }
  }
}
