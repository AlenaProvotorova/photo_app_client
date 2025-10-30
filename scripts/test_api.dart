import 'package:dio/dio.dart';

void main() async {
  print('🧪 Тестирование API подключения...\n');

  final dio = Dio();

  // Тестируем продакшн URL (обновите при необходимости)
  final productionUrl = 'https://api.fastselect.ru/api/';
  final productionBaseUrl = 'https://api.fastselect.ru/';

  try {
    print('📡 Тестируем подключение к продакшн серверу...');
    print('URL: $productionUrl');

    // Сначала проверим базовый URL
    print('🔍 Проверяем базовый URL: $productionBaseUrl');
    final baseResponse = await dio.get(
      productionBaseUrl,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
    print('✅ Базовый URL доступен! Статус: ${baseResponse.statusCode}');

    // Теперь проверим API эндпоинт
    final response = await dio.get(
      productionUrl,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    print('✅ Успешное подключение!');
    print('Статус: ${response.statusCode}');
    print('Заголовки: ${response.headers}');
    print('Данные: ${response.data}');
  } catch (e) {
    print('❌ Ошибка подключения:');
    if (e is DioException) {
      print('Тип ошибки: ${e.type}');
      print('Сообщение: ${e.message}');
      print('Статус код: ${e.response?.statusCode}');
      print('Ответ сервера: ${e.response?.data}');

      if (e.type == DioExceptionType.connectionError) {
        print('\n🔧 Возможные решения:');
        print('1. Проверьте интернет соединение');
        print('2. Убедитесь, что сервер запущен');
        print('3. Проверьте настройки CORS на сервере');
      }
    } else {
      print('Неожиданная ошибка: $e');
    }
  }

  // Тестируем локальный URL
  final localUrl = 'http://127.0.0.1:3000/api/';

  try {
    print('\n📡 Тестируем подключение к локальному серверу...');
    print('URL: $localUrl');

    final response = await dio.get(
      localUrl,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    print('✅ Локальный сервер доступен!');
    print('Статус: ${response.statusCode}');
  } catch (e) {
    print('❌ Локальный сервер недоступен: $e');
  }

  print('\n🏁 Тестирование завершено');
}
